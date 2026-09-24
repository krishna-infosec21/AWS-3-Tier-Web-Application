<h1 align="center">☁️ Highly Available 3-Tier Web Application on AWS</h1> <p align="center"> <b>A secure, scalable and fault-tolerant 3-Tier architecture built on Amazon Web Services</b> </p> <p align="center"> <img src="https://img.shields.io/badge/AWS-Cloud%20Architecture-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white" alt="AWS"> <img src="https://img.shields.io/badge/Architecture-3--Tier-232F3E?style=for-the-badge" alt="3-Tier"> <img src="https://img.shields.io/badge/Availability-Multi--AZ-2E7D32?style=for-the-badge" alt="Multi-AZ"> <img src="https://img.shields.io/badge/HTTPS-ACM-1565C0?style=for-the-badge" alt="HTTPS"> </p> <p align="center"> <a href="https://krishnakumarcloud.online"><b>🌐 krishnakumarcloud.online</b></a> </p>
📌 Project Overview

This project demonstrates the practical implementation of a secure, scalable and highly available 3-Tier Web Application on AWS, using networking, compute, database, storage, security, DNS, CDN and monitoring services.

Layer	AWS Services
Presentation	Route 53, CloudFront, Application Load Balancer
Application	Amazon EC2, Auto Scaling
Database	Amazon RDS MySQL
Storage	Amazon S3
Security	IAM, Security Groups, Secrets Manager
Management	AWS Systems Manager
HTTPS	AWS Certificate Manager
Monitoring	Amazon CloudWatch
Notifications	Amazon SNS
Networking	VPC, Internet Gateway, NAT Gateway, Route Tables
🚀 Final Application Output
<p align="center"> <a href="https://krishnakumarcloud.online"> <img src="screenshots/20-final-application.png" alt="Final application output served through Route 53, CloudFront, ALB and EC2" width="90%"> </a> </p> <p align="center"> <em>Live application served over HTTPS through Route 53 → CloudFront → ALB → EC2 (Auto Scaling, Multi-AZ)</em> </p>
✅ Verified	Status
HTTPS with ACM certificate	Working
DNS resolution via Route 53	Working
CDN delivery via CloudFront	Working
ALB target health checks	Healthy
EC2 instances across 2 AZs	Running
Private RDS MySQL connectivity	Working
CloudWatch alarms + SNS email alerts	Configured
🏗️ Architecture Diagram
<p align="center"> <img src="architecture/architecture-diagram.png" alt="AWS 3-Tier Architecture" width="90%"> </p>
🌐 Architecture Flow
text
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
   /       \
  /         \
EC2        EC2
AZ-1       AZ-2
   \         /
    \       /
   Auto Scaling
        |
 Application Tier
        |
   RDS MySQL
Supporting Services
text
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
🌐 Network Architecture
text
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
                      /              \
                     /                \
                EC2 AZ1            EC2 AZ2
                     \                /
                      \              /
                       Private DB Subnets
                              |
                          RDS MySQL
☁️ AWS Services Used
AWS Service	Purpose
Amazon VPC	Isolated cloud network
Subnets	Network segmentation
Internet Gateway	Internet connectivity
NAT Gateway	Outbound internet access for private resources
Route Tables	Network traffic routing
Security Groups	Network-level access control
Amazon EC2	Application servers
Application Load Balancer	Distributes application traffic
Auto Scaling	Maintains application capacity
Amazon RDS MySQL	Managed relational database
Amazon S3	Object and application storage
Amazon CloudFront	CDN and content delivery
Amazon Route 53	DNS management
AWS Certificate Manager	SSL/TLS certificates
AWS Secrets Manager	Secure secret storage
AWS IAM	Identity and access management
AWS Systems Manager	Secure EC2 management
Amazon CloudWatch	Monitoring and alarms
Amazon SNS	Notifications
🧩 3-Tier Architecture
1️⃣ Presentation Tier

Handles incoming user requests.

Amazon Route 53
Amazon CloudFront
Application Load Balancer
HTTPS
text
User
 |
Route 53
 |
CloudFront
 |
HTTPS
 |
Application Load Balancer
2️⃣ Application Tier

Processes user requests.

Amazon EC2
Apache Web Server
Auto Scaling Group
Target Group
Private Application Subnets
text
Application Load Balancer
          |
     Target Group
       /       \
      /         \
    EC2         EC2
   AZ-1        AZ-2
3️⃣ Database Tier

Stores application data.

Amazon RDS MySQL

The database is deployed in private subnets and is not directly exposed to the public internet.

text
EC2 Application Tier
        |
        |
    RDS MySQL
🌐 VPC and Networking

The application is deployed inside a dedicated Amazon VPC.

text
VPC CIDR: 10.0.0.0/16

The network is separated into:

Public subnets
Private application subnets
Private database subnets

This segmentation controls network access between the application tiers.

🌍 Internet Gateway
text
Internet
   |
Internet Gateway
   |
Public Subnet

The Internet Gateway is attached to the VPC and provides connectivity for public resources.

🔄 NAT Gateway
text
Private EC2
    |
NAT Gateway
    |
Internet Gateway
    |
Internet

Private application servers can reach required external resources without being exposed to inbound internet traffic.

🛣️ Route Tables
Route Table	Route
Public	0.0.0.0/0 → Internet Gateway
Private	0.0.0.0/0 → NAT Gateway

Local VPC traffic uses the VPC local route.

🔐 Security Groups

Security Groups act as virtual firewalls and enforce controlled communication between tiers.

text
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

The database is never directly exposed to the public internet.

⚖️ Application Load Balancer & Target Group

The Application Load Balancer distributes incoming traffic across healthy EC2 instances.

Setting	Value
Load Balancer	three-tier-alb
Target Group	three-tier-targets
Health Check Protocol	HTTP
Health Check Port	80
Health Check Path	/
text
ALB
 |
Target Group
 |
 +---- EC2 AZ1
 |
 +---- EC2 AZ2

Unhealthy instances are removed from traffic routing until they become healthy again.

📈 Auto Scaling

The application tier is managed by an Auto Scaling Group.

Setting	Value
Auto Scaling Group	three-tier-asg
Minimum Capacity	2
Desired Capacity	2
Maximum Capacity	4
Target CPU	60%

Auto Scaling provides automatic scaling, instance replacement, improved availability, better resource management and multi-AZ deployment.

🖥️ Amazon EC2

EC2 instances provide compute for the application tier. They:

Run in private application subnets
Run Apache Web Server
Receive traffic through the ALB
Are managed by Auto Scaling
Use IAM roles
Can be managed through AWS Systems Manager
🗄️ Amazon RDS MySQL

Amazon RDS MySQL is the managed database layer, deployed in private subnets. Access is controlled using Security Groups.

text
EC2 Application
       |
       | MySQL : 3306
       ↓
RDS MySQL
🪣 Amazon S3

Amazon S3 is used for object and application-related storage.

Static files
Application uploads
Object storage
Backup-related storage

Access is controlled using IAM permissions.

🔑 AWS Secrets Manager

Secrets Manager securely stores sensitive information such as database credentials, passwords and application secrets.

text
EC2
 |
IAM Role
 |
Secrets Manager
 |
Application Secrets

Sensitive values are never stored inside application source code.

👤 AWS IAM

IAM manages identities and permissions (users, roles, policies). EC2 instances use IAM roles to access AWS services securely.

🛠️ AWS Systems Manager

Systems Manager provides Session Manager, secure instance access, remote administration and operational management. This removes the need to expose SSH to the internet.

🔒 HTTPS and AWS Certificate Manager

AWS Certificate Manager provides the SSL/TLS certificates.

text
Project Domain: krishnakumarcloud.online
text
User
 |
HTTPS
 |
CloudFront / ALB
 |
EC2
🌎 Amazon CloudFront

CloudFront is used as the CDN layer and delivers content through AWS edge locations.

text
User
 |
CloudFront
 |
Application Load Balancer
 |
EC2
Service	Purpose
Route 53	DNS management
CloudFront	CDN and content delivery
ALB	Application traffic distribution
🌐 Amazon Route 53

Route 53 manages DNS for krishnakumarcloud.online and directs users to the application delivery endpoint.

text
User
 |
Route 53
 |
CloudFront
 |
ALB
 |
EC2
📊 Amazon CloudWatch

CloudWatch monitors EC2 CPU utilization, ALB metrics, Auto Scaling metrics and instance health.

text
Example alarm: CPU Utilization > 70% for 5 minutes
🔔 Amazon SNS
text
SNS Topic: three-tier-alerts
text
CloudWatch Alarm
       |
       ↓
      SNS
       |
       ↓
     Email
🔄 Application Request Flow
text
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
🔐 Security Architecture
Area	Controls
Network	VPC isolation, public/private subnet separation, Security Groups, controlled route tables, private database layer
Identity	IAM roles, IAM policies, controlled permissions
Data	Private RDS, Secrets Manager, HTTPS, controlled S3 access
Server Management	Private EC2, Systems Manager, restricted inbound access
🚀 Deployment Process
Create VPC – 10.0.0.0/16
Create Subnets – public, private application and private database subnets
Configure Internet Gateway – attached to the VPC
Configure NAT Gateway – outbound access for private subnets
Configure Route Tables – public and private routing
Configure Security Groups – Internet → ALB → EC2 → RDS
Launch EC2 – application servers in private application subnets
Configure Apache – install and configure Apache Web Server
Create Target Group – with health checks
Create Application Load Balancer – internet-facing ALB
Configure Auto Scaling – Launch Template and Auto Scaling Group
Create RDS – private MySQL database
Configure S3 – object storage
Configure Secrets Manager – secure application secrets
Configure IAM – roles and permissions
Configure Systems Manager – secure EC2 management
Configure ACM – SSL/TLS certificates
Configure CloudFront – CDN layer
Configure Route 53 – DNS for the project domain
Configure CloudWatch – monitoring and alarms
Configure SNS – email notifications
Validate Application – ALB, target health, Auto Scaling, DNS, HTTPS and supporting services
🧪 Testing and Validation

VPC · Subnets · Internet Gateway · NAT Gateway · Route Tables · Security Groups · EC2 · Apache · ALB · Target Group health checks · Auto Scaling · RDS MySQL · S3 · Secrets Manager · IAM · Systems Manager · ACM · CloudFront · Route 53 · CloudWatch · SNS · Final application output

📸 AWS Implementation Screenshots
🌐 Networking

VPC

Show Image

Subnets

Show Image

Internet Gateway

Show Image

NAT Gateway

Show Image

Route Tables

Show Image

Security Groups

Show Image

🖥️ Compute and Load Balancing

EC2 Instances

Show Image

Application Load Balancer

Show Image

Target Groups

Show Image

Auto Scaling

Show Image

🗄️ Storage and Database

Amazon RDS MySQL

Show Image

Amazon S3

Show Image

🌍 DNS, CDN and HTTPS

CloudFront

Show Image

Route 53

Show Image

AWS Certificate Manager

Show Image

🔐 Security, Monitoring and Access Management

AWS Secrets Manager

Show Image

Amazon CloudWatch

Show Image

Amazon SNS

Show Image

AWS IAM

Show Image

📁 Project Structure
text
Highly-Available-3-Tier-AWS/
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
🎯 Project Objectives
Build a highly available AWS architecture
Implement a 3-Tier application architecture across multiple Availability Zones
Implement Application Load Balancing and Auto Scaling
Deploy a private RDS MySQL database
Implement secure network segmentation
Configure DNS (Route 53), CDN (CloudFront) and HTTPS (ACM)
Secure secrets with Secrets Manager and control access with IAM
Manage EC2 using Systems Manager
Monitor with CloudWatch and notify with SNS
🧩 Key Challenges Solved

Private EC2 connectivity · Systems Manager connectivity · Security Group configuration · Route Table configuration · NAT Gateway connectivity · ALB target health checks · Apache configuration · Auto Scaling configuration · Private RDS connectivity · DNS configuration · HTTPS certificate validation · CloudFront configuration · CloudWatch monitoring · SNS notifications

📚 Key Learning Outcomes
Area	Skills
Networking	VPC, Subnets, Route Tables, Internet Gateway, NAT Gateway, Security Groups
Compute	EC2, Launch Templates, Auto Scaling, ALB, Target Groups
Storage & Database	Amazon S3, Amazon RDS MySQL
Security	IAM, Secrets Manager, Security Groups, ACM, HTTPS
Management	Systems Manager, CloudWatch, SNS
Application Delivery	Route 53, CloudFront, ALB
🔮 Future Improvements
Infrastructure as Code using Terraform
CI/CD using GitHub Actions
Docker containerization
Amazon ECS / Fargate deployment
AWS WAF integration
Centralized logging
Enhanced CloudWatch dashboards
Automated backup and recovery
Disaster recovery strategy
Cost optimization
text
GitHub → CI/CD Pipeline → Docker → Amazon ECR → Amazon ECS / Fargate
text
CloudFront → AWS WAF → ALB → Application
📌 Project Summary

This project demonstrates the design and implementation of a Highly Available 3-Tier Web Application on AWS, combining networking, compute, database, storage, DNS, CDN, security and monitoring services into a scalable and secure cloud environment.

Focus areas: High Availability · Scalability · Security · Fault Tolerance · Monitoring · Secure Access · Reliable Application Delivery

👨‍💻 Author

Krishna Kumar — AWS Cloud Architecture | Cloud Enthusiast

GitHub

📄 License

This project is created for learning, portfolio development, and demonstrating practical AWS Cloud Architecture skills.