# Kong Gateway with Keycloak, Spring Boot Services, Redis, Kafka, Docker

## Overview

This repository contains a setup for a microservices architecture utilizing several modern technologies. The
architecture consists of Kong Gateway as the API Gateway, Keycloak for authentication and authorization, Spring Boot
services for backend functionality, Redis for caching, Kafka for messaging, and Docker for containerization.

## Technologies Used

### Kong Gateway

[Kong Gateway](https://konghq.com/kong/) is an open-source API Gateway and Microservices Management Layer, delivering
high performance and reliability. It provides various features such as API authentication, rate limiting, logging, and
more.

### Keycloak

[Keycloak](https://www.keycloak.org/) is an open-source identity and access management solution. It provides features
like single sign-on (SSO), OAuth, and OpenID Connect for securing applications and services.

### Spring Boot

[Spring Boot](https://spring.io/projects/spring-boot) is a popular Java framework for building microservices. It
simplifies the development process by providing out-of-the-box solutions for dependency management, configuration, and
more.

### Redis

[Redis](https://redis.io/) is an in-memory data structure store used as a database, cache, and message broker. In this
setup, Redis is utilized for caching data, improving the performance of the application.

### Kafka

[Apache Kafka](https://kafka.apache.org/) is a distributed event streaming platform used for building real-time data
pipelines and streaming applications. It provides features like high-throughput, fault-tolerance, and scalability,
making it suitable for event-driven architectures.

### Docker

[Docker](https://www.docker.com/) is a platform for developing, shipping, and running applications in containers. It
allows for easy deployment and scaling of applications by encapsulating them in containers, ensuring consistency across
different environments.

---