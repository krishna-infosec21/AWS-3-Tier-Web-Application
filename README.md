# ☁️ Highly Available 3-Tier Web Application on AWS

## AWS Cloud Architecture Solution

A highly available and scalable **3-Tier Web Application deployed on Amazon Web Services (AWS)** using multiple AWS services for networking, compute, database, storage, security, DNS, CDN, monitoring, and automation.

The project demonstrates how a web application can be designed using AWS cloud architecture principles with **high availability, scalability, security, centralized access control, monitoring, and reliable application delivery**.

---

## 📌 Project Overview

This project implements a **3-Tier Web Application Architecture on AWS** consisting of:

* **Presentation / Web Layer** – Application Load Balancer and CloudFront
* **Application Layer** – EC2 instances running Apache with Auto Scaling
* **Database Layer** – Amazon RDS MySQL
* **Storage** – Amazon S3
* **DNS** – Amazon Route 53
* **HTTPS** – AWS Certificate Manager
* **Secrets Management** – AWS Secrets Manager
* **Monitoring** – Amazon CloudWatch
* **Notifications** – Amazon SNS
* **Identity and Access Management** – AWS IAM
* **Server Management** – AWS Systems Manager
* **Networking** – Amazon VPC, Internet Gateway, NAT Gateway, Route Tables and Security Groups

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
             EC2 Instance       EC2 Instance
               AZ-1                AZ-2
                  \                 /
                   \               /
                    Auto Scaling
                          |
                    Application Tier
                          |
                    RDS MySQL
                  Private Database
                          
        Supporting AWS Services
        ├── Amazon S3
        ├── AWS Secrets Manager
        ├── AWS IAM
        ├── AWS Systems Manager
        ├── Amazon CloudWatch
        └── Amazon SNS
```

---

# 🌐 Network Architecture

```text
                         Internet
                            |
                     Internet Gateway
                            |
                +-----------+-----------+
                |                       |
          Public Subnet AZ1       Public Subnet AZ2
                |                       |
          NAT Gateway              NAT Gateway
                |                       |
                +-----------+-----------+
                            |
                 Private Application Subnets
                     /              \
                    /                \
              EC2 Instance        EC2 Instance
                    \                /
                     \              /
                      Private DB Subnets
                             |
                         RDS MySQL
```

The application servers are placed in private subnets while the required public-facing components are placed in public subnets.

---

# ☁️ AWS Services Used

| AWS Service               | Purpose                                        |
| ------------------------- | ---------------------------------------------- |
| Amazon VPC                | Isolated cloud network                         |
| Subnets                   | Network segmentation                           |
| Internet Gateway          | Internet connectivity                          |
| NAT Gateway               | Outbound internet access for private resources |
| Route Tables              | Network traffic routing                        |
| Security Groups           | Instance and service-level firewall rules      |
| Amazon EC2                | Application servers                            |
| Application Load Balancer | Distributes incoming application traffic       |
| Auto Scaling              | Maintains application capacity                 |
| Amazon RDS MySQL          | Managed relational database                    |
| Amazon S3                 | Object and static storage                      |
| Amazon CloudFront         | CDN and content delivery                       |
| Amazon Route 53           | DNS management                                 |
| AWS Certificate Manager   | SSL/TLS certificates                           |
| AWS Secrets Manager       | Secure secret storage                          |
| AWS IAM                   | Identity and access management                 |
| AWS Systems Manager       | Secure EC2 management                          |
| Amazon CloudWatch         | Monitoring and alarms                          |
| Amazon SNS                | Email notifications                            |

---

# 🧩 3-Tier Architecture

## 1️⃣ Presentation Tier

The presentation layer handles incoming user requests.

Components:

* Amazon Route 53
* Amazon CloudFront
* Application Load Balancer
* HTTPS / SSL

Request flow:

```text
User
 ↓
Route 53
 ↓
CloudFront
 ↓
Application Load Balancer
```

---

## 2️⃣ Application Tier

The application tier processes user requests.

Components:

* Amazon EC2
* Apache Web Server
* Auto Scaling Group
* Target Group
* Private Application Subnets

Multiple EC2 instances are distributed across Availability Zones to improve application availability.

```text
ALB
 |
 +---- EC2 AZ1
 |
 +---- EC2 AZ2
```

---

## 3️⃣ Database Tier

The database tier stores application data.

Component:

* Amazon RDS MySQL

The database is placed inside private subnets and is not directly exposed to the public internet.

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

The VPC provides an isolated network environment for the application infrastructure.

The network is divided into:

* Public Subnets
* Private Application Subnets
* Private Database Subnets

---

# 🌍 Internet Gateway

The **Internet Gateway (IGW)** provides internet connectivity for resources that require public internet access.

The Internet Gateway is attached to the VPC and is associated with public subnet routing.

```text
Internet
   |
Internet Gateway
   |
Public Subnet
```

---

# 🔄 NAT Gateway

The NAT Gateway allows resources in private subnets to access the internet for outbound communication without exposing private resources directly to inbound internet traffic.

Example:

```text
Private EC2
    |
NAT Gateway
    |
Internet Gateway
    |
Internet
```

This design allows private application servers to download updates and packages while remaining in private subnets.

---

# 🛣️ Route Tables

Route tables control traffic flow between subnets and network components.

Typical routing:

### Public Route Table

```text
0.0.0.0/0 → Internet Gateway
```

### Private Route Table

```text
0.0.0.0/0 → NAT Gateway
```

Local VPC traffic remains available through the VPC's local route.

---

# 🔐 Security Groups

Security Groups are used as virtual firewalls to control inbound and outbound traffic.

Example architecture:

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

The database security group allows database access only from the required application tier rather than directly from the internet.

---

# ⚖️ Application Load Balancer

An **Application Load Balancer (ALB)** distributes incoming application traffic across multiple EC2 instances.

Benefits:

* High availability
* Traffic distribution
* Health checks
* Automatic removal of unhealthy targets
* Integration with Auto Scaling
* HTTPS support

Architecture:

```text
Users
  |
 ALB
  |
Target Group
 /       \
EC2      EC2
AZ1      AZ2
```

---

# 🎯 Target Group

The Target Group contains the EC2 instances that receive traffic from the Application Load Balancer.

Health checks are used to verify whether application instances are healthy.

Example:

```text
Protocol: HTTP
Port: 80
Health Check Path: /
```

If an instance becomes unhealthy, the ALB can stop routing traffic to that instance.

---

# 📈 Auto Scaling

The Auto Scaling Group automatically manages EC2 application instances according to the configured capacity and scaling policy.

Configuration used in the project:

```text
Auto Scaling Group: three-tier-asg

Minimum Capacity: 2
Desired Capacity: 2
Maximum Capacity: 4
Target CPU: 60%
```

The application servers are distributed across multiple private subnets / Availability Zones.

### Benefits

* Automatic scaling
* High availability
* Fault tolerance
* Reduced manual management
* Automatic replacement of unhealthy instances

---

# 🖥️ Amazon EC2

Amazon EC2 provides the compute resources for the application tier.

The EC2 instances:

* Run inside private application subnets
* Run the Apache web server
* Receive traffic through the ALB
* Are managed through Auto Scaling
* Use IAM roles for AWS access
* Can be managed through AWS Systems Manager

---

# 🗄️ Amazon RDS MySQL

Amazon RDS is used as the managed relational database layer.

Database characteristics:

* MySQL
* Private subnet deployment
* Not directly exposed to the internet
* Access controlled through Security Groups
* Used by the application tier

Database flow:

```text
EC2 Application
       |
       | MySQL : 3306
       ↓
RDS MySQL
```

---

# 🪣 Amazon S3

Amazon S3 is used for object and application storage.

Possible use cases include:

* Static assets
* Application files
* Uploads
* Backup objects
* Project-related storage

Application access can be controlled using IAM permissions rather than exposing storage unnecessarily.

---

# 🔑 AWS Secrets Manager

AWS Secrets Manager is used to securely store sensitive information such as:

* Database credentials
* Passwords
* API secrets
* Other application secrets

Instead of hardcoding sensitive values inside application code, the application can retrieve them securely using IAM permissions.

```text
EC2
 |
IAM Role
 |
Secrets Manager
 |
Application Secrets
```

---

# 👤 AWS IAM

AWS IAM controls access to AWS resources.

IAM is used for:

* Users
* Roles
* Policies
* Permissions
* EC2 service access

The EC2 instances use an IAM role to securely access required AWS services without storing long-term access keys on the server.

---

# 🛠️ AWS Systems Manager

AWS Systems Manager is used for secure EC2 management.

It can provide:

* Secure server access
* Session Manager
* Instance management
* Remote command execution
* Operational management

This reduces the need to expose SSH access directly to the internet.

---

# 🔒 HTTPS and AWS Certificate Manager

AWS Certificate Manager (ACM) is used to provide SSL/TLS certificates for secure HTTPS communication.

HTTPS provides:

* Encrypted communication
* Data protection in transit
* Secure browser connections
* Certificate-based authentication

Traffic flow:

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

Amazon CloudFront is used as the Content Delivery Network (CDN) layer.

CloudFront helps deliver content through AWS edge locations and can improve application delivery performance.

Architecture:

```text
User
 |
CloudFront
 |
Application Load Balancer
 |
EC2
```

CloudFront and Route 53 have different responsibilities:

* **Route 53** → DNS management
* **CloudFront** → Content delivery and CDN
* **ALB** → Application traffic distribution

---

# 🌐 Amazon Route 53

Amazon Route 53 is used for DNS management for the project domain.

Domain used:

```text
krishnakumarcloud.online
```

Route 53 provides DNS resolution and directs users toward the configured application delivery endpoint.

Example flow:

```text
User
 |
krishnakumarcloud.online
 |
Route 53
 |
CloudFront
 |
ALB
 |
EC2
```

---

# 📊 Amazon CloudWatch

Amazon CloudWatch is used for infrastructure monitoring.

Monitoring can include:

* EC2 CPU utilization
* Instance health
* ALB metrics
* Application performance metrics
* Auto Scaling metrics

Example scaling/monitoring condition:

```text
CPU Utilization > 70%
for 5 minutes
```

CloudWatch can trigger an alarm when the configured threshold is reached.

---

# 🔔 Amazon SNS

Amazon SNS is used for notifications and alert delivery.

Example:

```text
CloudWatch Alarm
       |
       ↓
      SNS
       |
       ↓
    Email
```

SNS topic used:

```text
three-tier-alerts
```

This allows important infrastructure alerts to be delivered through email notifications.

---

# 🔄 Application Request Flow

The complete application request flow is:

```text
1. User opens the application domain
             ↓
2. Route 53 resolves the domain
             ↓
3. Request reaches CloudFront
             ↓
4. HTTPS secures the communication
             ↓
5. Request reaches Application Load Balancer
             ↓
6. ALB checks Target Group health
             ↓
7. ALB forwards request to a healthy EC2 instance
             ↓
8. EC2 processes the application request
             ↓
9. EC2 communicates with RDS when database data is required
             ↓
10. EC2 can access S3 for object storage
             ↓
11. Response returns to the user
```

---

# 🔐 Security Architecture

The project follows multiple security layers.

### Network Security

* VPC isolation
* Private application subnets
* Private database subnets
* Security Groups
* Controlled route tables

### Identity Security

* IAM roles
* Least-privilege permissions
* No unnecessary long-term credentials

### Data Security

* Private RDS deployment
* Secrets Manager for sensitive values
* HTTPS encryption
* Controlled S3 access

### Server Security

* Private EC2 instances
* Systems Manager for management
* Restricted security group rules

---

# 🧠 Key AWS Concepts Demonstrated

This project demonstrates practical knowledge of:

* AWS VPC architecture
* Public and private subnet design
* Internet Gateway
* NAT Gateway
* Route Tables
* Security Groups
* Multi-AZ architecture
* Application Load Balancer
* Target Groups
* EC2
* Auto Scaling
* Amazon RDS
* Amazon S3
* CloudFront
* Route 53
* AWS Certificate Manager
* AWS Secrets Manager
* IAM
* Systems Manager
* CloudWatch
* SNS
* HTTPS
* DNS
* High availability
* Scalability
* Fault tolerance
* Infrastructure security

---

# 🚀 Deployment Process

The project was implemented through the following major stages:

### Step 1 – Create VPC

Created a dedicated VPC using:

```text
CIDR: 10.0.0.0/16
```

### Step 2 – Create Subnets

Created public and private subnets across Availability Zones.

### Step 3 – Configure Internet Gateway

Attached an Internet Gateway to the VPC for public internet connectivity.

### Step 4 – Configure NAT Gateway

Configured NAT Gateway access for private subnet outbound connectivity.

### Step 5 – Configure Route Tables

Configured public and private routing.

### Step 6 – Configure Security Groups

Created controlled security rules between:

```text
Internet → ALB
ALB → EC2
EC2 → RDS
```

### Step 7 – Launch EC2

Created application servers inside private application subnets.

### Step 8 – Configure Apache

Installed and configured Apache as the web server.

### Step 9 – Create Target Group

Created a target group and configured health checks.

### Step 10 – Create Application Load Balancer

Created an internet-facing Application Load Balancer.

### Step 11 – Configure Auto Scaling

Created:

```text
Launch Template
       ↓
Auto Scaling Group
       ↓
EC2 Instances
```

### Step 12 – Create RDS

Created a private MySQL database for the database tier.

### Step 13 – Configure S3

Created an S3 bucket for object/static storage.

### Step 14 – Configure Secrets Manager

Stored sensitive application/database information securely.

### Step 15 – Configure IAM

Created appropriate IAM roles and permissions.

### Step 16 – Configure Systems Manager

Configured secure management of EC2 instances.

### Step 17 – Configure ACM

Configured SSL/TLS certificates for HTTPS.

### Step 18 – Configure CloudFront

Configured CloudFront for content delivery.

### Step 19 – Configure Route 53

Configured DNS for:

```text
krishnakumarcloud.online
```

### Step 20 – Configure CloudWatch and SNS

Configured monitoring, alarms and email notifications.

### Step 21 – Test Application

Validated:

* Application accessibility
* ALB health checks
* EC2 availability
* Auto Scaling
* Database connectivity
* DNS resolution
* HTTPS
* Monitoring and notifications

---

# 🧪 Testing and Validation

The following components were validated during the project:

### VPC

```text
VPC created successfully
```

### EC2

```text
Application instances launched successfully
```

### Apache

```text
Apache Web Server → Running
```

### ALB

```text
Application Load Balancer → Configured
```

### Target Group

```text
Health Check → /
```

### Auto Scaling

```text
Minimum → 2
Desired → 2
Maximum → 4
```

### RDS

```text
MySQL Database → Private
```

### S3

```text
Object Storage → Configured
```

### DNS

```text
Route 53 → Domain Resolution
```

### HTTPS

```text
ACM → SSL/TLS Certificate
```

### Monitoring

```text
CloudWatch → Metrics and Alarms
```

### Notifications

```text
SNS → Email Alerts
```

---

# 📸 AWS Implementation Screenshots

## Networking

### VPC

![VPC Configuration](screenshots/01-vpc.png)

### Subnets

![Subnet Configuration](screenshots/02-subnets.png)

### Internet Gateway

![Internet Gateway](screenshots/03-internet-gateway.png)

### NAT Gateway

![NAT Gateway](screenshots/04-nat-gateway.png)

### Route Tables

![Route Tables](screenshots/05-route-tables.png)

### Security Groups

![Security Groups](screenshots/06-security-groups.png)

---

## Compute and Load Balancing

### EC2 Instances

![EC2 Instances](screenshots/07-ec2.png)

### Application Load Balancer

![Application Load Balancer](screenshots/08-alb.png)

### Target Groups

![Target Groups](screenshots/09-target-groups.png)

### Auto Scaling

![Auto Scaling](screenshots/10-auto-scaling.png)

---

## Storage and Database

### Amazon RDS MySQL

![RDS MySQL](screenshots/11-rds.png)

### Amazon S3

![Amazon S3](screenshots/12-s3.png)

---

## DNS, CDN and HTTPS

### CloudFront

![CloudFront](screenshots/13-cloudfront.png)

### Route 53

![Route 53](screenshots/14-route53.png)

### AWS Certificate Manager

![AWS Certificate Manager](screenshots/15-acm.png)

---

## Security and Access Management

### AWS Secrets Manager

![Secrets Manager](screenshots/16-secrets-manager.png)

### Amazon CloudWatch

![CloudWatch](screenshots/17-cloudwatch.png)

### Amazon SNS

![Amazon SNS](screenshots/18-sns.png)

### AWS IAM

![AWS IAM](screenshots/19-iam.png)

---

# 🚀 Final Application Output

The following screenshot shows the final deployed application output.

![Final Application Output](screenshots/20-final-application.png)

---

# 📁 Project Structure

```text
AWS-3-Tier-Web-Application/
│
├── app.py
├── requirements.txt
├── README.md
│
├── architecture/
│   └── architecture-diagram.png
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

The main objectives of this project are:

* Build a highly available AWS architecture
* Implement a 3-Tier application design
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
* Manage EC2 instances using Systems Manager
* Monitor infrastructure using CloudWatch
* Configure notifications using SNS
* Gain practical AWS cloud architecture experience

---

# ⭐ Project Highlights

* ☁️ AWS Cloud Architecture
* 🏗️ 3-Tier Architecture
* 🌐 Route 53 DNS
* 🚀 CloudFront CDN
* ⚖️ Application Load Balancer
* 🖥️ EC2 Application Servers
* 📈 Auto Scaling
* 🗄️ RDS MySQL
* 🪣 Amazon S3
* 🔐 AWS Secrets Manager
* 👤 AWS IAM
* 🛠️ AWS Systems Manager
* 🔒 HTTPS with ACM
* 📊 CloudWatch Monitoring
* 🔔 SNS Notifications
* 🌍 Multi-AZ Design
* 🔒 Private Subnet Architecture
* 📡 Secure Network Segmentation
* ♻️ Scalable Infrastructure

---

# 🧩 Key Challenges Solved

During implementation, several practical AWS infrastructure challenges were addressed, including:

* Private EC2 connectivity
* Systems Manager connectivity
* Security Group configuration
* Route table configuration
* NAT Gateway connectivity
* ALB target health checks
* Apache web server configuration
* Auto Scaling configuration
* RDS private connectivity
* DNS configuration
* HTTPS certificate validation
* CloudFront configuration
* Monitoring and notification setup

These troubleshooting activities provided practical experience in diagnosing AWS networking, compute, security and application availability issues.

---

# 📚 Key Learning Outcomes

Through this project, I gained hands-on experience with:

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
* HTTPS
* ACM

### AWS Management

* Systems Manager
* CloudWatch
* SNS

### AWS Application Delivery

* Route 53
* CloudFront
* ALB

---

# 🔮 Future Improvements

Possible future enhancements include:

* Infrastructure as Code using Terraform
* CI/CD pipeline using AWS CodePipeline / GitHub Actions
* Containerization using Docker
* Container deployment using Amazon ECS
* Centralized logging
* AWS WAF integration
* Database backup and recovery automation
* CloudWatch dashboard improvements
* Disaster recovery strategy
* Cost optimization
* Enhanced application monitoring

---

# 🏆 Future Architecture Enhancements

The architecture can be extended with additional AWS services to improve automation, security, observability and deployment efficiency.

Possible improvements:

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

Security can be enhanced with:

```text
CloudFront
    |
AWS WAF
    |
ALB
    |
Application
```

Monitoring can be expanded with:

```text
CloudWatch
    |
Logs + Metrics + Alarms
    |
SNS
    |
Email Notifications
```

---

# 📌 Project Summary

This project demonstrates the design and implementation of a **Highly Available 3-Tier Web Application on AWS**.

The architecture combines AWS networking, compute, database, storage, DNS, CDN, security and monitoring services to create a scalable and secure cloud environment.

The project provides practical hands-on experience with:

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

**AWS Cloud Architect solution**

GitHub: https://github.com/krishna-infosec21

---

# 📄 License

This project is created for **learning, portfolio development and demonstrating practical AWS Cloud Architecture skills**.
