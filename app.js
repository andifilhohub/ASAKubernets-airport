const express = require('express');
const jwt = require('jsonwebtoken');
const dotenv = require('dotenv');
const { Pool } = require('pg');



dotenv.config();


const app = express();
const PORT = process.env.PORT || 3000;


app.use(express.json());
const pool = new Pool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    port: process.env.DB_PORT || 5432,
});




const authenticateToken = (req, res, next) => {
    const token = req.header('Authorization')?.replace('Bearer ', '');

    if (!token) return res.status(401).json({ message: 'Token não fornecido' });

    jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
        if (err) return res.status(403).json({ message: 'Token inválido' });
        req.user = user;
        next();
    });
};


app.post('/api/login', (req, res) => {
    const { email, password } = req.body;


    pool.query('SELECT * FROM "Users" WHERE email = $1', [email], (err, results) => {
        if (err) {
            return res.status(500).json({ message: 'Erro ao consultar o banco de dados' });
        }

        if (results.rows.length === 0) {
            return res.status(401).json({ message: 'Credenciais incorretas' });
        }

        const userFromDb = results.rows[0];

        if (password === userFromDb.password) {

            const token = jwt.sign(
                { id: userFromDb.id, email: userFromDb.email },
                process.env.JWT_SECRET,
                //               { expiresIn: '30' }
            );

            return res.json({ message: 'Login bem-sucedido', token });
        } else {
            return res.status(401).json({ message: 'Credenciais incorretas' });
        }
    });
});

app.post('/api/logout', authenticateToken, (req, res) => {
    const authHeader = req.header('Authorization');
    const token = authHeader?.replace('Bearer ', '');

    if (!token) {
        return res.status(400).json({ message: 'Token não fornecido' });
    }

    pool.query(
        'INSERT INTO "TokenBlacklists" (token, "createdAt", "updatedAt") VALUES ($1, NOW(), NOW())',
        [token],
        (err, results) => {
            if (err) {
                console.error('Erro ao inserir na blacklist:', err);
                return res.status(500).json({ message: 'Erro ao realizar logout' });
            }

            res.json({ message: 'Logout bem-sucedido' });
        }
    );

});


app.get('/api/dashboard', authenticateToken, (req, res) => {
    res.json({ message: 'painel protegido', user: req.user });
});

app.get('/api/aeroportos', (req, res) => {
    pool.query('SELECT * FROM "Airports" ORDER BY code', (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).json({ message: 'Erro ao buscar aeroportos' });
        }
        res.json(results.rows);
    });
});


app.get('/api/aeroportos/origem/:origem', (req, res) => {
    const origem = req.params.origem.toUpperCase();

    pool.query(
        `SELECT DISTINCT destination FROM "Routes" 
        WHERE origin = $1 
        ORDER BY destination`,
        [origem],
        (err, results) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ message: 'Erro na consulta de rotas' });
            }
            res.json(results.rows.map(row => row.destination));
        }
    );
});


app.get('/api/voos', (req, res) => {
    const data = req.query.data;

    if (!data || !/^\d{4}-\d{2}-\d{2}$/.test(data)) {
        return res.status(400).json({ message: 'Formato de data inválido. Use YYYY-MM-DD' });
    }

    pool.query(
        `SELECT * FROM "Flights" 
        WHERE departure_time::date = $1 
        ORDER BY departure_time`,
        [data],
        (err, results) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ message: 'Erro ao buscar voos' });
            }
            res.json(results.rows);
        }
    );
});


app.post('/api/voos/pesquisar', authenticateToken, (req, res) => {
    const { origem, destino, data, passageiros } = req.body;


    if (!origem || !destino || !data || !passageiros) {
        return res.status(400).json({ message: 'Parâmetros incompletos' });
    }

    pool.query(
        `SELECT f.*, MIN(t.price) as preco 
        FROM "Flights" f
        JOIN "Tickets" t ON f.id = t.flight_id
        WHERE f.origin = $1 
        AND f.destination = $2 
        AND f.departure_time::date = $3
        AND t.available_seats >= $4
        GROUP BY f.id
        ORDER BY preco ASC`,
        [origem, destino, data, passageiros],
        (err, results) => {
            if (err) {
                console.error(err);
                return res.status(500).json({ message: 'Erro na pesquisa de voos' });
            }
            res.json(results.rows);
        }
    );
});


app.post('/api/compras', authenticateToken, async (req, res) => {
    const { voos_ids, tarifa_ids, passageiros } = req.body;
    const userId = req.user.id;


    if (!voos_ids?.length || !tarifa_ids?.length || !passageiros) {
        return res.status(400).json({ message: 'Dados de compra inválidos' });
    }

    const client = await pool.connect();

    try {
        await client.query('BEGIN');


        for (const tarifaId of tarifa_ids) {
            const tarifa = await client.query(
                `SELECT available_seats FROM "Tickets" 
                 WHERE id = $1 FOR UPDATE`,
                [tarifaId]
            );

            if (tarifa.rows.length === 0 || tarifa.rows[0].available_seats < passageiros) {
                throw new Error(`Assentos insuficientes ou tarifa ${tarifaId} não encontrada`);
            }
        }


        const localizador = Math.random().toString(36).substr(2, 8).toUpperCase();
        const reservaResult = await client.query(
            `INSERT INTO "Bookings" 
             (user_id, locator, status, created_at)
             VALUES ($1, $2, 'Confirmada', NOW())
             RETURNING id`,
            [userId, localizador]
        );


        for (const [i, tarifaId] of tarifa_ids.entries()) {
            await client.query(
                `UPDATE "Tickets" 
                 SET available_seats = available_seats - $1,
                     booking_id = $2,
                     status = 'RESERVED'
                 WHERE id = $3`,
                [passageiros, reservaResult.rows[0].id, tarifaId]
            );
        }

        await client.query('COMMIT');

        res.json({
            success: true,
            message: 'Compra efetuada com sucesso',
            localizador,
            booking_id: reservaResult.rows[0].id
        });

    } catch (error) {
        await client.query('ROLLBACK');
        console.error('Erro na compra:', error);
        res.status(400).json({
            success: false,
            message: error.message,
            details: 'Verifique a disponibilidade dos voos'
        });
    } finally {
        client.release();
    }
});


app.listen(PORT, () => {
    console.log(`Servidor rodando na porta ${PORT}`);
});
