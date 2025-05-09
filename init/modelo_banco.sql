--
-- PostgreSQL database dump
--

-- Dumped from database version 16.8 (Ubuntu 16.8-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.8 (Ubuntu 16.8-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Airports; Type: TABLE; Schema: public; Owner: postgres
--
-- Criar o usuário 'asa' com senha
CREATE USER asa WITH PASSWORD 'asa';

-- Conceder privilégios máximos ao usuário
ALTER USER asa WITH SUPERUSER;

-- Conceder privilégios completos no banco de dados 'asaproject'
GRANT ALL PRIVILEGES ON DATABASE airline TO asa;

-- Conceder privilégios em todas as tabelas
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO asa;

-- Conceder privilégios em todas as sequências
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO asa;

-- Conceder privilégios em todas as funções
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO asa;


CREATE TABLE public."Airports" (
    code character varying(3) NOT NULL,
    name character varying(100) NOT NULL,
    city character varying(50) NOT NULL,
    country character varying(50) NOT NULL
);


ALTER TABLE public."Airports" OWNER TO postgres;

--
-- Name: Bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Bookings" (
    id integer NOT NULL,
    user_id integer NOT NULL,
    locator character varying(8) NOT NULL,
    status character varying(20) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT "Bookings_status_check" CHECK (((status)::text = ANY ((ARRAY['Confirmada'::character varying, 'Cancelada'::character varying, 'Pendente'::character varying])::text[])))
);


ALTER TABLE public."Bookings" OWNER TO postgres;

--
-- Name: Bookings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Bookings_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Bookings_id_seq" OWNER TO postgres;

--
-- Name: Bookings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Bookings_id_seq" OWNED BY public."Bookings".id;


--
-- Name: Flights; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Flights" (
    id integer NOT NULL,
    origin character varying(3) NOT NULL,
    destination character varying(3) NOT NULL,
    departure_time timestamp without time zone NOT NULL,
    duration integer NOT NULL,
    aircraft character varying(50) NOT NULL
);


ALTER TABLE public."Flights" OWNER TO postgres;

--
-- Name: Flights_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Flights_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Flights_id_seq" OWNER TO postgres;

--
-- Name: Flights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Flights_id_seq" OWNED BY public."Flights".id;


--
-- Name: Routes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Routes" (
    origin character varying(3) NOT NULL,
    destination character varying(3) NOT NULL
);


ALTER TABLE public."Routes" OWNER TO postgres;

--
-- Name: SequelizeMeta; Type: TABLE; Schema: public; Owner: asa
--

CREATE TABLE public."SequelizeMeta" (
    name character varying(255) NOT NULL
);


ALTER TABLE public."SequelizeMeta" OWNER TO asa;

--
-- Name: Tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Tickets" (
    id integer NOT NULL,
    flight_id integer NOT NULL,
    booking_id integer,
    ticket_number character varying(20) NOT NULL,
    price numeric(10,2) NOT NULL,
    available_seats integer NOT NULL,
    class character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'AVAILABLE'::character varying,
    CONSTRAINT "Tickets_class_check" CHECK (((class)::text = ANY ((ARRAY['Economica'::character varying, 'Executiva'::character varying, 'Primeira'::character varying])::text[])))
);


ALTER TABLE public."Tickets" OWNER TO postgres;

--
-- Name: Tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Tickets_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Tickets_id_seq" OWNER TO postgres;

--
-- Name: Tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Tickets_id_seq" OWNED BY public."Tickets".id;


--
-- Name: TokenBlacklists; Type: TABLE; Schema: public; Owner: asa
--

CREATE TABLE public."TokenBlacklists" (
    id integer NOT NULL,
    token character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."TokenBlacklists" OWNER TO asa;

--
-- Name: TokenBlacklists_id_seq; Type: SEQUENCE; Schema: public; Owner: asa
--

CREATE SEQUENCE public."TokenBlacklists_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."TokenBlacklists_id_seq" OWNER TO asa;

--
-- Name: TokenBlacklists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: asa
--

ALTER SEQUENCE public."TokenBlacklists_id_seq" OWNED BY public."TokenBlacklists".id;


--
-- Name: Users; Type: TABLE; Schema: public; Owner: asa
--

CREATE TABLE public."Users" (
    id integer NOT NULL,
    email character varying(255),
    password character varying(255),
    "createdAt" timestamp with time zone NOT NULL,
    "updatedAt" timestamp with time zone NOT NULL
);


ALTER TABLE public."Users" OWNER TO asa;

--
-- Name: Users_id_seq; Type: SEQUENCE; Schema: public; Owner: asa
--

CREATE SEQUENCE public."Users_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Users_id_seq" OWNER TO asa;

--
-- Name: Users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: asa
--

ALTER SEQUENCE public."Users_id_seq" OWNED BY public."Users".id;


--
-- Name: Bookings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bookings" ALTER COLUMN id SET DEFAULT nextval('public."Bookings_id_seq"'::regclass);


--
-- Name: Flights id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Flights" ALTER COLUMN id SET DEFAULT nextval('public."Flights_id_seq"'::regclass);


--
-- Name: Tickets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tickets" ALTER COLUMN id SET DEFAULT nextval('public."Tickets_id_seq"'::regclass);


--
-- Name: TokenBlacklists id; Type: DEFAULT; Schema: public; Owner: asa
--

ALTER TABLE ONLY public."TokenBlacklists" ALTER COLUMN id SET DEFAULT nextval('public."TokenBlacklists_id_seq"'::regclass);


--
-- Name: Users id; Type: DEFAULT; Schema: public; Owner: asa
--

ALTER TABLE ONLY public."Users" ALTER COLUMN id SET DEFAULT nextval('public."Users_id_seq"'::regclass);


--
-- Name: Airports Airports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Airports"
    ADD CONSTRAINT "Airports_pkey" PRIMARY KEY (code);


--
-- Name: Bookings Bookings_locator_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bookings"
    ADD CONSTRAINT "Bookings_locator_key" UNIQUE (locator);


--
-- Name: Bookings Bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Bookings"
    ADD CONSTRAINT "Bookings_pkey" PRIMARY KEY (id);


--
-- Name: Flights Flights_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Flights"
    ADD CONSTRAINT "Flights_pkey" PRIMARY KEY (id);


--
-- Name: Routes Routes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Routes"
    ADD CONSTRAINT "Routes_pkey" PRIMARY KEY (origin, destination);


--
-- Name: SequelizeMeta SequelizeMeta_pkey; Type: CONSTRAINT; Schema: public; Owner: asa
--

ALTER TABLE ONLY public."SequelizeMeta"
    ADD CONSTRAINT "SequelizeMeta_pkey" PRIMARY KEY (name);


--
-- Name: Tickets Tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_pkey" PRIMARY KEY (id);


--
-- Name: Tickets Tickets_ticket_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_ticket_number_key" UNIQUE (ticket_number);


--
-- Name: TokenBlacklists TokenBlacklists_pkey; Type: CONSTRAINT; Schema: public; Owner: asa
--

ALTER TABLE ONLY public."TokenBlacklists"
    ADD CONSTRAINT "TokenBlacklists_pkey" PRIMARY KEY (id);


--
-- Name: Users Users_pkey; Type: CONSTRAINT; Schema: public; Owner: asa
--

ALTER TABLE ONLY public."Users"
    ADD CONSTRAINT "Users_pkey" PRIMARY KEY (id);


--
-- Name: Flights Flights_destination_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Flights"
    ADD CONSTRAINT "Flights_destination_fkey" FOREIGN KEY (destination) REFERENCES public."Airports"(code);


--
-- Name: Flights Flights_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Flights"
    ADD CONSTRAINT "Flights_origin_fkey" FOREIGN KEY (origin) REFERENCES public."Airports"(code);


--
-- Name: Routes Routes_destination_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Routes"
    ADD CONSTRAINT "Routes_destination_fkey" FOREIGN KEY (destination) REFERENCES public."Airports"(code);


--
-- Name: Routes Routes_origin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Routes"
    ADD CONSTRAINT "Routes_origin_fkey" FOREIGN KEY (origin) REFERENCES public."Airports"(code);


--
-- Name: Tickets Tickets_booking_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_booking_id_fkey" FOREIGN KEY (booking_id) REFERENCES public."Bookings"(id);


--
-- Name: Tickets Tickets_flight_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Tickets"
    ADD CONSTRAINT "Tickets_flight_id_fkey" FOREIGN KEY (flight_id) REFERENCES public."Flights"(id);


--
-- PostgreSQL database dump complete
--

-- Seed para a tabela Airports
-- Seed para a tabela Airports
-- Inserir aeroportos
INSERT INTO public."Airports" (code, name, city, country) VALUES
  ('JFK', 'John F. Kennedy International Airport', 'New York', 'USA'),
  ('LHR', 'London Heathrow Airport', 'London', 'UK'),
  ('HND', 'Tokyo Haneda Airport', 'Tokyo', 'Japan'),
  ('GRU', 'São Paulo–Guarulhos International Airport', 'São Paulo', 'Brazil'),
  ('GIG', 'Rio de Janeiro–Galeão International Airport', 'Rio de Janeiro', 'Brazil'),
  ('MIA', 'Miami International Airport', 'Miami', 'USA'),
  ('LAX', 'Los Angeles International Airport', 'Los Angeles', 'USA'),
  ('MCO', 'Orlando International Airport', 'Orlando', 'USA');


INSERT INTO public."Flights" (id, origin, destination, departure_time, duration, aircraft) VALUES
  (1, 'JFK', 'LHR', '2025-06-01 10:00:00', 420, 'Boeing 777'),
  (2, 'LHR', 'HND', '2025-06-02 13:00:00', 720, 'Airbus A350'),
  (3, 'HND', 'JFK', '2025-06-03 15:00:00', 600, 'Boeing 787');


INSERT INTO public."Users" (id, email, password, "createdAt", "updatedAt") VALUES
  (1, 'user1@example.com', 'password123', '2025-01-01 10:00:00', '2025-01-01 10:00:00'),
  (2, 'user2@example.com', 'password456', '2025-01-02 11:00:00', '2025-01-02 11:00:00'),
  (3, 'user3@example.com', 'password789', '2025-01-03 12:00:00', '2025-01-03 12:00:00');



INSERT INTO public."Bookings" (id, user_id, locator, status, created_at) VALUES
  (1, 1, 'A1B2C3', 'Confirmada', '2025-05-01 12:00:00'),
  (2, 2, 'D4E5F6', 'Pendente', '2025-05-02 14:00:00'),
  (3, 3, 'G7H8I9', 'Cancelada', '2025-05-03 16:00:00');

INSERT INTO public."Tickets" (id, flight_id, booking_id, ticket_number, price, available_seats, class, status) VALUES
  (1, 1, 1, 'TK1234', 500.00, 100, 'Economica', 'AVAILABLE'),
  (2, 2, 2, 'TK5678', 750.00, 50, 'Executiva', 'AVAILABLE'),
  (3, 3, 3, 'TK91011', 1200.00, 20, 'Primeira', 'AVAILABLE');

INSERT INTO public."Routes" (origin, destination) VALUES
  ('GRU', 'GIG'),
  ('GRU', 'JFK'),
  ('GRU', 'MIA'),
  ('GIG', 'GRU'),
  ('GIG', 'JFK'),
  ('JFK', 'GRU'),
  ('JFK', 'LAX'),
  ('MIA', 'MCO');
