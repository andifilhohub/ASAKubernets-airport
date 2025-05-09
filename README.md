# Airline Ticket Sales Backend

This project implements the backend system for an airline ticket sales platform. It was developed as part of a backend team assignment, featuring a containerized architecture with microservices and a custom database model.

## 📦 Project Structure

- **Microservices**: RESTful services built with Node.js, responsible for business logic and communication with the database.
- **Database**: Custom schema designed to support ticket sales, integrated into the container environment.
- **Containerization**: Docker containers running Ubuntu and exposing services via port `3000`.
- **Orchestration**: Kubernetes configuration to manage the development environment and service deployment.

## 🚀 Features

- RESTful API endpoints handling JSON requests/responses.
- Fully containerized setup using Docker and Docker Compose.
- Kubernetes manifests to simulate a production-like environment.
- Custom database structure (PostgreSQL or other) defined by the development team.

## 🛠️ Technologies Used

- Node.js
- Express.js
- PostgreSQL (or your chosen DB)
- Docker
- Kubernetes
- Ubuntu Linux

## ⚙️ How to Run

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/airline-backend.git
   cd airline-backend
   docker-compose up --build
   kubectl apply -f k8s/

