# Deployment Notes

## Project

**Highly Available 3-Tier Web Application on AWS**

## AWS Region

```text
ap-southeast-1 (Singapore)
```

## VPC Configuration

```text
VPC CIDR: 10.0.0.0/16
```

The application infrastructure is deployed inside a dedicated Amazon VPC.

---

## 1. Network Configuration

The VPC is divided into public and private network segments.

### Public Layer

The public layer contains the components that require internet-facing connectivity.

* Internet Gateway
* Application Load Balancer
* NAT Gateway

### Private Application Layer

The application servers are deployed in private subnets.

* Amazon EC2
* Apache Web Server
* Auto Scaling Group

### Private Database Layer

The database is deployed in private subnets.

* Amazon RDS MySQL

---

## 2. Internet Gateway

An Internet Gateway is attached to the VPC to provide internet connectivity for public resources.

```text
Internet
   |
Internet Gateway
   |
Public Subnet
```

---

## 3. NAT Gateway

The NAT Gateway provides outbound internet connectivity for resources deployed in private subnets.

```text
Private EC2
    |
NAT Gateway
    |
Internet Gateway
    |
Internet
```

This allows private EC2 instances to download packages and updates without requiring direct inbound internet access.

---

## 4. Route Tables

Route tables are configured to control traffic between public and private subnets.

### Public Route

```text
0.0.0.0/0 → Internet Gateway
```

### Private Route

```text
0.0.0.0/0 → NAT Gateway
```

VPC local traffic remains available through the local route.

---

## 5. Security Groups

Security Groups are configured to control communication between the different application layers.

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

## 6. EC2 Application Layer

Amazon EC2 instances are used as application servers.

The EC2 instances:

* Run in private application subnets
* Run Apache Web Server
* Receive traffic through the Application Load Balancer
* Are managed through Auto Scaling
* Use IAM roles
* Can be managed using AWS Systems Manager

---

## 7. Apache Web Server

Apache is installed and configured on the EC2 application servers.

Basic validation:

```bash
sudo systemctl status apache2
```

Local application testing:

```bash
curl http://localhost
```

---

## 8. Application Load Balancer

An internet-facing Application Load Balancer is configured to distribute incoming application traffic across the EC2 instances.

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

Only healthy targets should receive application traffic.

---

## 9. Auto Scaling

The application tier is managed using an Auto Scaling Group.

```text
Auto Scaling Group: three-tier-asg

Minimum Capacity: 2
Desired Capacity: 2
Maximum Capacity: 4
Target CPU: 60%
```

The Auto Scaling Group uses the configured Launch Template to launch application instances.

---

## 10. Amazon RDS MySQL

Amazon RDS MySQL is used as the database tier.

The database is deployed in private subnets and is accessed by the application tier through controlled Security Group rules.

```text
EC2 Application Tier
        |
        | MySQL : 3306
        ↓
RDS MySQL
```

---

## 11. Amazon S3

Amazon S3 is used for object and application-related storage.

Typical use cases include:

* Static files
* Application uploads
* Objects
* Backup-related storage

Access is controlled using AWS IAM permissions.

---

## 12. AWS Secrets Manager

AWS Secrets Manager is used to securely store sensitive application information.

Examples include:

* Database credentials
* Passwords
* Application secrets

The application can access required secrets through IAM permissions instead of storing sensitive values directly in source code.

---

## 13. AWS IAM

IAM is used to manage permissions for AWS resources.

The EC2 application servers use an IAM role to access the required AWS services securely.

No long-term AWS access keys are required on the EC2 servers for normal AWS service access.

---

## 14. AWS Systems Manager

AWS Systems Manager is used for secure EC2 management.

The project uses Systems Manager capabilities for:

* Secure instance access
* Session management
* Remote administration
* Instance management

This reduces the need to expose SSH access publicly.

---

## 15. AWS Certificate Manager

AWS Certificate Manager is used to provide SSL/TLS certificates for HTTPS.

The project domain is:

```text
krishnakumarcloud.online
```

HTTPS provides encrypted communication between users and the application delivery layer.

---

## 16. Amazon CloudFront

Amazon CloudFront is used as the CDN layer.

The request flow is:

```text
User
 |
CloudFront
 |
Application Load Balancer
 |
EC2
```

CloudFront improves content delivery by using AWS edge locations.

---

## 17. Amazon Route 53

Amazon Route 53 is used for DNS management.

Domain:

```text
krishnakumarcloud.online
```

The DNS request flow is:

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

---

## 18. Amazon CloudWatch

Amazon CloudWatch is used to monitor AWS resources.

The project monitors metrics such as:

* EC2 CPU utilization
* Application Load Balancer metrics
* Auto Scaling metrics
* Instance health

Example monitoring condition:

```text
CPU Utilization > 70%
for 5 minutes
```

---

## 19. Amazon SNS

Amazon SNS is used for sending monitoring notifications.

SNS Topic:

```text
three-tier-alerts
```

Example notification flow:

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

## 20. Application Request Flow

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

## 21. Deployment Validation

The following components were validated during deployment:

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
* Auto Scaling Group
* RDS MySQL
* Amazon S3
* AWS Secrets Manager
* IAM roles
* AWS Systems Manager
* ACM certificate
* CloudFront
* Route 53
* CloudWatch
* SNS notifications
* Final application output

---

## 22. Final Application

The final application is accessed through the configured domain and AWS application delivery architecture.

```text
Route 53
   ↓
CloudFront
   ↓
ALB
   ↓
EC2
   ↓
RDS / S3
```

The final application output is documented in:

```text
screenshots/20-final-application.png
```

---

## Deployment Summary

This deployment demonstrates a highly available AWS 3-Tier architecture using separate presentation, application and database layers.

The architecture combines:

```text
Networking
+
Compute
+
Load Balancing
+
Auto Scaling
+
Database
+
Storage
+
DNS
+
CDN
+
HTTPS
+
Security
+
Monitoring
+
Notifications
```
