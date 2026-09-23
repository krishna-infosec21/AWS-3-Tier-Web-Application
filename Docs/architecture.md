# 🏗️ AWS 3-Tier Web Application Architecture

> A highly available and scalable three-tier web application architecture built using AWS services.

---

## 📌 Architecture Overview

This project follows a **three-tier architecture** consisting of:

* 🌐 **Presentation / Web Layer** — Application Load Balancer
* ⚙️ **Application Layer** — EC2 instances running the web application
* 🗄️ **Database Layer** — Amazon RDS MySQL

Additional AWS services are used for DNS, storage, monitoring, and scalability.

---

## 🔄 Request Flow

```text
👤 User
   │
   ▼
🌍 Route 53
   │
   ▼
⚖️ Application Load Balancer
   │
   ├───────────────┐
   ▼               ▼
🖥️ EC2 AZ-1     🖥️ EC2 AZ-2
   │               │
   └───────┬───────┘
           │
           ▼
      🗄️ RDS MySQL
           
📦 Amazon S3
   └── Static files / Uploads
```

---

## 🌐 1. DNS Layer — Amazon Route 53

**Amazon Route 53** is used to provide DNS resolution for the application domain.

### Responsibilities

* 🌍 Domain name resolution
* 🔗 Routes users to the Application Load Balancer
* ❤️ Supports health-based routing when configured

---

## ⚖️ 2. Load Balancing Layer — Application Load Balancer

The Application Load Balancer is deployed in **public subnets**.

### Responsibilities

* 🔀 Distributes incoming requests
* ❤️ Performs health checks on EC2 instances
* 🔐 Handles HTTP/HTTPS traffic
* 🚀 Improves application availability

---

## 🖥️ 3. Application Layer — Amazon EC2

The application layer contains EC2 instances distributed across multiple Availability Zones.

### Configuration

| Component      | Configuration             |
| -------------- | ------------------------- |
| Compute        | Amazon EC2                |
| Availability   | Multiple AZs              |
| Web Server     | Apache                    |
| Load Balancing | Application Load Balancer |
| Scaling        | Auto Scaling Group        |
| Network        | Private Subnets           |

Using multiple EC2 instances helps the application continue serving requests if one instance becomes unavailable.

---

## 🗄️ 4. Database Layer — Amazon RDS

Amazon RDS for MySQL is used as the database layer.

### Responsibilities

* 🗃️ Store application data
* 🔒 Keep database inside private networking
* 💾 Manage database backups
* 📈 Support database scalability

The database should not be directly accessible from the public internet.

---

## 📦 5. Storage Layer — Amazon S3

Amazon S3 is used for storing application-related objects.

### Example Usage

* 🖼️ Images
* 📄 Static files
* 📁 User uploads
* 💾 Application objects

---

## 📈 6. Auto Scaling

The EC2 instances are managed using an **Auto Scaling Group**.

### Benefits

* ➕ Adds instances when demand increases
* ➖ Removes unnecessary instances when demand decreases
* ❤️ Replaces unhealthy instances
* ⚡ Improves application availability

---

## 📊 7. Monitoring

**Amazon CloudWatch** can be used to monitor the infrastructure.

### Metrics

* CPU utilization
* EC2 instance health
* Application Load Balancer health
* Request count
* Target health

---

## 🔐 Network Design

The application uses a VPC with separate subnet layers.

```text
                 🌐 Internet
                      │
                      ▼
              🌐 Public Subnets
                      │
                      ▼
              ⚖️ Application LB
                      │
          ┌───────────┴───────────┐
          ▼                       ▼
     🔒 Private App          🔒 Private App
       Subnet AZ-1             Subnet AZ-2
          │                       │
          └───────────┬───────────┘
                      ▼
               🗄️ Private RDS
```

---

## 🎯 Architecture Goals

* 🔄 High availability
* 📈 Scalability
* 🔐 Network isolation
* ⚖️ Load balancing
* 💾 Reliable storage
* 📊 Infrastructure monitoring

---

## 🏁 Summary

This architecture separates the web, application, and database responsibilities into different layers. Using multiple Availability Zones, an Application Load Balancer, Auto Scaling, and private database networking provides a foundation for a highly available AWS application.
