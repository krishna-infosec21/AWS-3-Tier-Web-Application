# ☁️ Highly Available 3-Tier Web Application on AWS

## AWS Cloud Architecture Solution

A highly available and scalable **3-Tier Web Application deployed on Amazon Web Services (AWS)** using AWS networking, compute, database, storage, security, DNS, CDN, monitoring, and automation services.

This project demonstrates the practical implementation of a secure, scalable, and highly available cloud architecture using multiple AWS services.

---

## 📌 Project Overview

The project implements a **3-Tier AWS Web Application Architecture** with the following layers:

* **Presentation Layer** – Route 53, CloudFront and Application Load Balancer
* **Application Layer** – Amazon EC2 and Auto Scaling
* **Database Layer** – Amazon RDS MySQL
* **Storage** – Amazon S3
* **Security** – IAM, Security Groups and Secrets Manager
* **Management** – AWS Systems Manager
* **HTTPS** – AWS Certificate Manager
* **Monitoring** – Amazon CloudWatch
* **Notifications** – Amazon SNS
* **Networking** – Amazon VPC, Internet Gateway, NAT Gateway and Route Tables

---

# 🏗️ Architecture Diagram

![AWS 3-Tier Architecture](architecture/architecture-diagram.png)

---

# 🌐 Architecture Flow

```text
                         Internet
                            |
                        Route 53
                            |
                       CloudFront
                            |
                          HTTPS
                            |
             Application Load Balancer
                            |
                      Target Group
                       /         \
                      /           \
             EC2 Instance     EC2 Instance
                AZ-1              AZ-2
                    \             /
                     \           /
                    Auto Scaling
                         |
                 Application Tier
                         |
                    RDS MySQL
```

### Supporting Services

```text
EC2
 |
 +---- IAM Role
 |
 +---- Secrets Manager
 |
 +---- Amazon S3
 |
 +---- AWS Systems Manager

CloudWatch
 |
SNS
 |
Email Notifications
```

---

# 🌐 Network Architecture

```text
                         Internet
                            |
                  Internet Gateway
                            |
              +-------------+-------------+
              |                           |
        Public Subnet AZ1           Public Subnet AZ2
              |                           |
        NAT Gateway                 NAT Gateway
              |                           |
              +-------------+-------------+
                            |
                 Private Application Subnets
                      /               \
                     /                 \
                EC2 AZ1             EC2 AZ2
                     \                 /
                      \               /
                       Private DB Subnets
                              |
                          RDS MySQL
```

---

# ☁️ AWS Services Used

| AWS Service               | Purpose                                        |
| ------------------------- | ---------------------------------------------- |
| Amazon VPC                | Isolated cloud network                         |
| Subnets                   | Network segmentation                           |
| Internet Gateway          | Internet connectivity                          |
| NAT Gateway               | Outbound internet access for private resources |
| Route Tables              | Network traffic routing                        |
| Security Groups           | Network-level access control                   |
| Amazon EC2                | Application servers                            |
| Application Load Balancer | Distributes application traffic                |
| Auto Scaling              | Maintains application capacity                 |
| Amazon RDS MySQL          | Managed relational database                    |
| Amazon S3                 | Object and application storage                 |
| Amazon CloudFront         | CDN and content delivery                       |
| Amazon Route 53           | DNS management                                 |
| AWS Certificate Manager   | SSL/TLS certificates                           |
| AWS Secrets Manager       | Secure secret storage                          |
| AWS IAM                   | Identity and access management                 |
| AWS Systems Manager       | Secure EC2 management                          |
| Amazon CloudWatch         | Monitoring and alarms                          |
| Amazon SNS                | Notifications                                  |

---

# 🧩 3-Tier Architecture

## 1️⃣ Presentation Tier

The presentation layer handles incoming user requests.

Components:

* Amazon Route 53
* Amazon CloudFront
* Application Load Balancer
* HTTPS

```text
User
 |
Route 53
 |
CloudFront
 |
HTTPS
 |
Application Load Balancer
```

---

## 2️⃣ Application Tier

The application layer processes user requests.

Components:

* Amazon EC2
* Apache Web Server
* Auto Scaling Group
* Target Group
* Private Application Subnets

```text
                 Application Load Balancer
                           |
                     Target Group
                       /       \
                      /         \
                   EC2         EC2
                  AZ-1        AZ-2
```

---

## 3️⃣ Database Tier

The database layer stores application data.

Component:

* Amazon RDS MySQL

The database is deployed in private subnets and is not directly exposed to the public internet.

```text
EC2 Application Tier
        |
        |
    RDS MySQL
```

---

# 🌐 VPC and Networking

The application is deployed inside a dedicated Amazon VPC.

### VPC CIDR

```text
10.0.0.0/16
```

The network is separated into:

* Public subnets
* Private application subnets
* Private database subnets

This segmentation helps control network access between the different application tiers.

---

# 🌍 Internet Gateway

The Internet Gateway provides internet connectivity for resources that require public network access.

```text
Internet
   |
Internet Gateway
   |
Public Subnet
```

The Internet Gateway is attached to the VPC.

---

# 🔄 NAT Gateway

The NAT Gateway provides outbound internet access for resources deployed in private subnets.

```text
Private EC2
    |
NAT Gateway
    |
Internet Gateway
    |
Internet
```

Private application servers can access required external resources without being directly exposed to inbound internet traffic.

---

# 🛣️ Route Tables

Route Tables control network traffic within the VPC.

### Public Route

```text
0.0.0.0/0 → Internet Gateway
```

### Private Route

```text
0.0.0.0/0 → NAT Gateway
```

Local VPC traffic uses the VPC local route.

---

# 🔐 Security Groups

Security Groups are used as virtual firewalls.

The application follows controlled communication between the tiers.

```text
Internet
   |
   | HTTPS : 443
   ↓
ALB Security Group
   |
   | HTTP : 80
   ↓
EC2 Security Group
   |
   | MySQL : 3306
   ↓
RDS Security Group
```

The database is not directly exposed to the public internet.

---

# ⚖️ Application Load Balancer

The Application Load Balancer distributes incoming application traffic across healthy EC2 instances.

### Load Balancer

```text
three-tier-alb
```

### Target Group

```text
three-tier-targets
```

### Health Check

```text
Protocol: HTTP
Port: 80
Path: /
```

The ALB uses target health checks to determine which application instances can receive traffic.

---

# 🎯 Target Group

The Target Group contains the EC2 instances registered with the Application Load Balancer.

The health check verifies the application server status.

```text
ALB
 |
Target Group
 |
 +---- EC2 AZ1
 |
 +---- EC2 AZ2
```

Unhealthy instances can be removed from traffic routing until they become healthy again.

---

# 📈 Auto Scaling

The application tier is managed using an Auto Scaling Group.

```text
Auto Scaling Group: three-tier-asg

Minimum Capacity: 2
Desired Capacity: 2
Maximum Capacity: 4
Target CPU: 60%
```

Auto Scaling provides:

* Automatic scaling
* Instance replacement
* Improved availability
* Better resource management
* Multi-AZ application deployment

---

# 🖥️ Amazon EC2

Amazon EC2 provides compute resources for the application tier.

The EC2 instances:

* Run in private application subnets
* Run Apache Web Server
* Receive traffic through the ALB
* Are managed by Auto Scaling
* Use IAM roles
* Can be managed through AWS Systems Manager

---

# 🗄️ Amazon RDS MySQL

Amazon RDS MySQL is used as the managed database layer.

The database is deployed in private subnets.

```text
EC2 Application
       |
       | MySQL : 3306
       ↓
RDS MySQL
```

Database access is controlled using Security Groups.

---

# 🪣 Amazon S3

Amazon S3 is used for object and application-related storage.

Possible use cases include:

* Static files
* Application uploads
* Object storage
* Backup-related storage

Access can be controlled using IAM permissions.

---

# 🔑 AWS Secrets Manager

AWS Secrets Manager is used to securely store sensitive information.

Examples:

* Database credentials
* Passwords
* Application secrets

Application access can be controlled using IAM permissions.

```text
EC2
 |
IAM Role
 |
Secrets Manager
 |
Application Secrets
```

Sensitive values are not stored directly inside application source code.

---

# 👤 AWS IAM

AWS IAM is used to manage identities and permissions.

IAM provides:

* Users
* Roles
* Policies
* Permissions

EC2 instances use IAM roles to access required AWS services securely.

---

# 🛠️ AWS Systems Manager

AWS Systems Manager is used for secure EC2 management.

It can provide:

* Session Manager
* Secure instance access
* Remote administration
* Instance management
* Operational management

This reduces the need to expose SSH access directly to the internet.

---

# 🔒 HTTPS and AWS Certificate Manager

AWS Certificate Manager is used to provide SSL/TLS certificates.

Project domain:

```text
krishnakumarcloud.online
```

HTTPS provides encrypted communication between users and the application delivery layer.

```text
User
 |
HTTPS
 |
CloudFront / ALB
 |
EC2
```

---

# 🌎 Amazon CloudFront

Amazon CloudFront is used as the CDN layer.

```text
User
 |
CloudFront
 |
Application Load Balancer
 |
EC2
```

CloudFront helps deliver application content through AWS edge locations.

### Route 53 vs CloudFront

| Service    | Purpose                          |
| ---------- | -------------------------------- |
| Route 53   | DNS management                   |
| CloudFront | CDN and content delivery         |
| ALB        | Application traffic distribution |

---

# 🌐 Amazon Route 53

Amazon Route 53 is used for DNS management.

### Domain

```text
krishnakumarcloud.online
```

Request flow:

```text
User
 |
Route 53
 |
CloudFront
 |
ALB
 |
EC2
```

Route 53 resolves the domain and directs users to the configured application delivery endpoint.

---

# 📊 Amazon CloudWatch

Amazon CloudWatch is used to monitor AWS infrastructure.

Monitoring includes:

* EC2 CPU utilization
* ALB metrics
* Auto Scaling metrics
* Instance health

Example alarm condition:

```text
CPU Utilization > 70%
for 5 minutes
```

---

# 🔔 Amazon SNS

Amazon SNS is used for sending monitoring notifications.

### SNS Topic

```text
three-tier-alerts
```

Notification flow:

```text
CloudWatch Alarm
       |
       ↓
      SNS
       |
       ↓
     Email
```

---

# 🔄 Application Request Flow

The complete application request flow is:

```text
User
  |
  ↓
Route 53
  |
  ↓
CloudFront
  |
  ↓
HTTPS
  |
  ↓
Application Load Balancer
  |
  ↓
Target Group
  |
  ↓
EC2 Auto Scaling Group
  |
  ↓
Application Server
  |
  +------→ RDS MySQL
  |
  +------→ Amazon S3
  |
  +------→ Secrets Manager
```

---

# 🔐 Security Architecture

The project uses multiple layers of security.

### Network Security

* VPC isolation
* Public and private subnet separation
* Security Groups
* Controlled route tables
* Private database layer

### Identity Security

* IAM roles
* IAM policies
* Controlled permissions

### Data Security

* Private RDS deployment
* Secrets Manager
* HTTPS
* Controlled S3 access

### Server Management

* Private EC2 instances
* AWS Systems Manager
* Restricted inbound access

---

# 🧠 Key AWS Concepts Demonstrated

This project demonstrates practical knowledge of:

* AWS VPC
* Public and private subnets
* Internet Gateway
* NAT Gateway
* Route Tables
* Security Groups
* Multi-AZ architecture
* Amazon EC2
* Application Load Balancer
* Target Groups
* Auto Scaling
* Amazon RDS MySQL
* Amazon S3
* CloudFront
* Route 53
* AWS Certificate Manager
* AWS Secrets Manager
* AWS IAM
* AWS Systems Manager
* Amazon CloudWatch
* Amazon SNS
* HTTPS
* DNS
* High Availability
* Scalability
* Fault Tolerance
* Network Security

---

# 🚀 Deployment Process

## Step 1 — Create VPC

Created the VPC using:

```text
10.0.0.0/16
```

## Step 2 — Create Subnets

Created public, private application and private database subnet architecture.

## Step 3 — Configure Internet Gateway

Attached the Internet Gateway to the VPC.

## Step 4 — Configure NAT Gateway

Configured NAT Gateway access for private subnet outbound connectivity.

## Step 5 — Configure Route Tables

Configured public and private routing.

## Step 6 — Configure Security Groups

Configured controlled communication between:

```text
Internet → ALB
ALB → EC2
EC2 → RDS
```

## Step 7 — Launch EC2

Created application servers inside private application subnets.

## Step 8 — Configure Apache

Installed and configured Apache Web Server.

## Step 9 — Create Target Group

Created the target group and configured health checks.

## Step 10 — Create Application Load Balancer

Created the internet-facing ALB.

## Step 11 — Configure Auto Scaling

Created the Launch Template and Auto Scaling Group.

## Step 12 — Create RDS

Created the private MySQL database.

## Step 13 — Configure S3

Configured Amazon S3 for object storage.

## Step 14 — Configure Secrets Manager

Configured secure storage for sensitive application information.

## Step 15 — Configure IAM

Configured IAM roles and permissions.

## Step 16 — Configure Systems Manager

Configured secure EC2 management.

## Step 17 — Configure ACM

Configured SSL/TLS certificates.

## Step 18 — Configure CloudFront

Configured CloudFront as the CDN layer.

## Step 19 — Configure Route 53

Configured DNS for the project domain.

## Step 20 — Configure CloudWatch

Configured infrastructure monitoring and alarms.

## Step 21 — Configure SNS

Configured email notifications for monitoring alerts.

## Step 22 — Validate Application

Validated the application, load balancer, target health, Auto Scaling, DNS, HTTPS and supporting AWS services.

---

# 🧪 Testing and Validation

The following components were validated during implementation:

* VPC configuration
* Subnet configuration
* Internet Gateway
* NAT Gateway
* Route Tables
* Security Groups
* EC2 instances
* Apache Web Server
* Application Load Balancer
* Target Group health checks
* Auto Scaling
* RDS MySQL
* Amazon S3
* Secrets Manager
* IAM
* Systems Manager
* ACM
* CloudFront
* Route 53
* CloudWatch
* SNS
* Final application output

---

# 📸 AWS Implementation Screenshots

> **Important:** All screenshot paths below are relative to the root `README.md`.
> The filenames must exactly match the files inside the `screenshots` folder.

## 🌐 Networking

### VPC

![VPC Configuration](./screenshots/01-vpc.png)

### Subnets

![Subnet Configuration](./screenshots/02-subnets.png)

### Internet Gateway

![Internet Gateway](./screenshots/03-internet-gateway.png)

### NAT Gateway

![NAT Gateway](./screenshots/04-nat-gateway.png)

### Route Tables

![Route Tables](./screenshots/05-route-tables.png)

### Security Groups

![Security Groups](./screenshots/06-security-groups.png)

---

## 🖥️ Compute and Load Balancing

### EC2 Instances

![EC2 Instances](./screenshots/07-ec2.png)

### Application Load Balancer

![Application Load Balancer](./screenshots/08-alb.png)

### Target Groups

![Target Groups](./screenshots/09-target-groups.png)

### Auto Scaling

![Auto Scaling](./screenshots/10-auto-scaling.png)

---

## 🗄️ Storage and Database

### Amazon RDS MySQL

![RDS MySQL](./screenshots/11-rds.png)

### Amazon S3

![Amazon S3](./screenshots/12-s3.png)

---

## 🌍 DNS, CDN and HTTPS

### CloudFront

![CloudFront](./screenshots/13-cloudfront.png)

### Route 53

![Route 53](./screenshots/14-route53.png)

### AWS Certificate Manager

![AWS Certificate Manager](./screenshots/15-acm.png)

---

## 🔐 Security and Access Management

### AWS Secrets Manager

![Secrets Manager](./screenshots/16-secrets-manager.png)

### Amazon CloudWatch

![CloudWatch](./screenshots/17-cloudwatch.png)

### Amazon SNS

![Amazon SNS](./screenshots/18-sns.png)

### AWS IAM

![AWS IAM](./screenshots/19-iam.png)

---

# 🚀 Final Application Output

The following screenshot shows the final application output after deployment.

![Final Application Output](./screenshots/20-final-application.png)

---

# 📁 Project Structure

```text
AWS-3-Tier-Web-Application/
│
├── app.py
├── requirements.txt
├── README.md
├── .gitignore
│
├── architecture/
│   └── architecture-diagram.png
│
├── scripts/
│   ├── deployment-notes.md
│   └── user-data.sh
│
├── screenshots/
│   ├── 01-vpc.png
│   ├── 02-subnets.png
│   ├── 03-internet-gateway.png
│   ├── 04-nat-gateway.png
│   ├── 05-route-tables.png
│   ├── 06-security-groups.png
│   ├── 07-ec2.png
│   ├── 08-alb.png
│   ├── 09-target-groups.png
│   ├── 10-auto-scaling.png
│   ├── 11-rds.png
│   ├── 12-s3.png
│   ├── 13-cloudfront.png
│   ├── 14-route53.png
│   ├── 15-acm.png
│   ├── 16-secrets-manager.png
│   ├── 17-cloudwatch.png
│   ├── 18-sns.png
│   ├── 19-iam.png
│   └── 20-final-application.png
│
└── docs/
    ├── architecture.md
    ├── deployment.md
    ├── security.md
    └── troubleshooting.md
```

---

# 🎯 Project Objectives

* Build a highly available AWS architecture
* Implement a 3-Tier application architecture
* Deploy application servers across multiple Availability Zones
* Implement Application Load Balancing
* Configure Auto Scaling
* Deploy a private RDS MySQL database
* Implement secure network segmentation
* Configure DNS using Route 53
* Implement CDN using CloudFront
* Enable HTTPS using ACM
* Secure application secrets using Secrets Manager
* Implement IAM-based access control
* Manage EC2 using Systems Manager
* Monitor infrastructure using CloudWatch
* Configure notifications using SNS

---

# ⭐ Project Highlights

* ☁️ AWS Cloud Architecture
* 🏗️ 3-Tier Architecture
* 🌐 Amazon Route 53
* 🚀 Amazon CloudFront
* ⚖️ Application Load Balancer
* 🖥️ Amazon EC2
* 📈 Auto Scaling
* 🗄️ Amazon RDS MySQL
* 🪣 Amazon S3
* 🔐 AWS Secrets Manager
* 👤 AWS IAM
* 🛠️ AWS Systems Manager
* 🔒 HTTPS with ACM
* 📊 Amazon CloudWatch
* 🔔 Amazon SNS
* 🌍 Multi-AZ Architecture
* 🔒 Private Subnet Architecture
* 📡 Secure Network Segmentation

---

# 🧩 Key Challenges Solved

During implementation, practical AWS infrastructure challenges were addressed, including:

* Private EC2 connectivity
* Systems Manager connectivity
* Security Group configuration
* Route Table configuration
* NAT Gateway connectivity
* ALB target health checks
* Apache Web Server configuration
* Auto Scaling configuration
* Private RDS connectivity
* DNS configuration
* HTTPS certificate validation
* CloudFront configuration
* CloudWatch monitoring
* SNS notification configuration

---

# 📚 Key Learning Outcomes

Through this project, I gained practical experience with:

### AWS Networking

* VPC
* Subnets
* Route Tables
* Internet Gateway
* NAT Gateway
* Security Groups

### AWS Compute

* EC2
* Launch Templates
* Auto Scaling
* Application Load Balancer
* Target Groups

### AWS Storage and Database

* Amazon S3
* Amazon RDS MySQL

### AWS Security

* IAM
* Secrets Manager
* Security Groups
* ACM
* HTTPS

### AWS Management

* Systems Manager
* CloudWatch
* SNS

### Application Delivery

* Route 53
* CloudFront
* Application Load Balancer

---

# 🔮 Future Improvements

Possible future enhancements include:

* Infrastructure as Code using Terraform
* CI/CD using GitHub Actions
* Docker containerization
* Amazon ECS / Fargate deployment
* AWS WAF integration
* Centralized logging
* Enhanced CloudWatch dashboards
* Automated backup and recovery
* Disaster recovery strategy
* Cost optimization

---

# 🏆 Future Architecture Enhancements

The architecture can be extended with CI/CD and containerization.

```text
GitHub
   |
CI/CD Pipeline
   |
Docker
   |
Amazon ECR
   |
Amazon ECS / Fargate
```

Additional security can be introduced using AWS WAF.

```text
CloudFront
    |
AWS WAF
    |
ALB
    |
Application
```

Monitoring can be expanded using:

```text
CloudWatch
    |
Metrics + Logs + Alarms
    |
SNS
    |
Email
```

---

# 📌 Project Summary

This project demonstrates the design and implementation of a **Highly Available 3-Tier Web Application on AWS**.

The architecture combines AWS networking, compute, database, storage, DNS, CDN, security and monitoring services to create a scalable and secure cloud environment.

The project demonstrates practical knowledge of:

```text
AWS Networking
       +
High Availability
       +
Load Balancing
       +
Auto Scaling
       +
Database
       +
Storage
       +
Security
       +
DNS
       +
CDN
       +
Monitoring
```

---

# ☁️ AWS Cloud Architecture Solution

**Highly Available 3-Tier Web Application on AWS**

Designed and implemented using AWS cloud architecture principles with a focus on:

* High Availability
* Scalability
* Security
* Fault Tolerance
* Monitoring
* Secure Access
* Reliable Application Delivery

---

# 👨‍💻 Author

**Krishna Kumar**

**AWS Cloud Architecture | Cloud Enthusiast**

GitHub: https://github.com/krishna-infosec21

---

# 📄 License

This project is created for learning, portfolio development and demonstrating practical AWS Cloud Architecture skills.
