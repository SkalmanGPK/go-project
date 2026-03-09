# Lightweight Network Monitor (K8s + Go)

A minimalist network probing tool built in Go, designed for monitoring microservices within a Kubernetes cluster. This project demonstrates low-level systems programming combined with modern cloud-native infrastructure.

---

# Overview

This project explores network latency and performance in containerized environments. By utilizing a sidecar container pattern (Nginx + PHP-FPM) and a dedicated Go-based monitoring agent, we measure Round-Trip Time (RTT) and service availability.

---

# Key Features

- **Go Monitoring Agent**  
  A compiled binary for high-precision HTTP latency measurement.

- **Kubernetes Native**  
  Fully declarative configuration using YAML manifests.

- **Optimized Docker Image**  
  Multi-stage build process resulting in a footprint under 15MB.

- **Sidecar Pattern**  
  Nginx and PHP-FPM co-scheduled in a single Pod for minimal internal overhead.

---

# Tech Stack

- **Language:** Go (Golang)  
- **Orchestration:** MicroK8s (Kubernetes)  
- **Web Stack:** Nginx & PHP-FPM  
- **Containerization:** Docker (Multi-stage)

---

# Architecture

The system consists of four main components running in a local cluster. The Go-monitor acts as a decoupled service, observing the application pod via a Kubernetes Service.

    mermaid
    graph TD;

        subgraph "Kubernetes Cluster (MicroK8s)"

            Monitor[Go Monitor Deployment] -->|HTTP GET| Service[Probe Service]
            Service -->|ClusterIP| Pod[App Pod]

            subgraph "App Pod (Sidecar)"
                Nginx[Nginx Container] <-->|FastCGI| PHP[PHP-FPM Container]
            end

        end

        PHP -->|External API| WeatherAPI[Open-Meteo API]

---

# Installation and Deployment

Initialize the Go module:

    go mod init network-probe

Build the Docker image:

    docker build -t network-probe:v1 .

Import the image to MicroK8s:

    docker save network-probe:v1 | microk8s ctr image import -

Apply the manifests:

    microk8s kubectl apply -f .

---

# Results and Lessons Learned

During evaluation, a consistent latency of **1–2 seconds** was observed. Analysis confirmed that this was not caused by network congestion, but rather **application-layer latency** from the PHP backend fetching data from external APIs.

**Key Takeaway**

In a **single-node Kubernetes environment**, internal networking is highly efficient. To observe significant differences in network drivers (Bridge vs Host), artificial latency injection or a **multi-node distributed setup** is required.

---

# Future Work

- **Concurrency**  
  Implementing goroutines for parallel monitoring of multiple endpoints.

- **Visualization**  
  Integration with **Prometheus** and **Grafana** for time-series analysis.

- **Chaos Engineering**  
  Utilizing **Chaos Mesh** to inject network failures and test agent resilience.

---

# Contact

**Robin Lust**  
Pineappel92@gmail.com  
Västerås, Sweden
