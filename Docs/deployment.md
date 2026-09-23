# 🚀 AWS 3-Tier Application Deployment

> Step-by-step deployment process for the highly available AWS web application.

---

## 🎯 Deployment Overview

The application is deployed using the following AWS components:

```text
👤 User
   ↓
🌍 Route 53
   ↓
⚖️ Application Load Balancer
   ↓
🖥️ EC2 Auto Scaling Group
   ↓
🗄️ Amazon RDS MySQL

📦 Amazon S3
   └── Application Storage
```

---

## 1️⃣ Create the VPC

Create a dedicated VPC for the application.

### Example

```text
VPC CIDR: 10.0.0.0/16
```

Create subnets across at least two Availability Zones.

### Subnet Design

| Subnet          | Type    | Purpose |
| --------------- | ------- | ------- |
| Public Subnet 1 | Public  | ALB     |
| Public Subnet 2 | Public  | ALB     |
| Private App 1   | Private | EC2     |
| Private App 2   | Private | EC2     |
| Private DB      | Private | RDS     |

---

## 2️⃣ Configure Security Groups

Create separate security groups for each layer.

### ⚖️ ALB Security Group

Allow:

```text
HTTP   80
HTTPS  443
```

Source:

```text
0.0.0.0/0
```

### 🖥️ EC2 Security Group

Allow:

```text
HTTP 80
```

Source:

```text
Application Load Balancer Security Group
```

### 🗄️ RDS Security Group

Allow:

```text
MySQL 3306
```

Source:

```text
EC2 Security Group
```

---

## 3️⃣ Launch EC2 Instances

Launch Ubuntu EC2 instances inside the private application subnets.

Install the web server:

```bash
sudo apt update
sudo apt install apache2 -y
```

Start Apache:

```bash
sudo systemctl enable apache2
sudo systemctl start apache2
```

Verify:

```bash
sudo systemctl status apache2
```

---

## 4️⃣ Configure the Application

Place the application files on the EC2 instance.

Example:

```text
/var/www/html/
├── index.html
├── css/
├── images/
└── application files
```

Test locally:

```bash
curl http://localhost
```

---

## 5️⃣ Create Target Group

Create an Application Load Balancer target group.

### Example

```text
Target Type: Instances
Protocol: HTTP
Port: 80
Health Check Path: /
```

Register the EC2 instances with the target group.

---

## 6️⃣ Create Application Load Balancer

Configure:

```text
Load Balancer Type: Application Load Balancer
Scheme: Internet-facing
IP Address Type: IPv4
```

Select the two public subnets.

Attach the target group to the listener.

---

## 7️⃣ Configure Auto Scaling

Create a Launch Template containing:

* 🖥️ AMI
* 💻 Instance type
* 🔐 IAM role
* 🛡️ Security group
* ⚙️ User data

Create the Auto Scaling Group.

### Example

```text
Minimum: 2
Desired: 2
Maximum: 4
```

Use the private application subnets.

---

## 8️⃣ Create Amazon RDS

Create an RDS MySQL database in the private database subnet.

Example:

```text
Engine: MySQL
Port: 3306
Public Access: No
```

Configure the RDS security group to allow MySQL traffic only from the EC2 security group.

---

## 9️⃣ Configure Amazon S3

Create an S3 bucket for application storage.

Example:

```text
Bucket
├── images/
├── uploads/
└── static/
```

Configure IAM permissions according to the application requirement.

---

## 🔟 Configure Route 53

Create a DNS record pointing the application domain to the Application Load Balancer.

Example:

```text
Domain
   ↓
Route 53
   ↓
Application Load Balancer
```

---

## 🔐 1️⃣1️⃣ Configure HTTPS

Use **AWS Certificate Manager (ACM)** to request an SSL/TLS certificate.

Configure:

```text
HTTPS : 443
       ↓
Application Load Balancer
```

Redirect HTTP traffic to HTTPS if required.

---

## 📊 1️⃣2️⃣ Configure Monitoring

Use Amazon CloudWatch to monitor:

* CPU utilization
* EC2 health
* ALB requests
* Target health
* Auto Scaling activity

---

## ✅ Deployment Verification

Test the following:

```text
☑ Domain resolves correctly
☑ ALB is reachable
☑ EC2 targets are healthy
☑ Application loads successfully
☑ RDS connection works
☑ S3 storage works
☑ Auto Scaling is configured
☑ HTTPS certificate is valid
```

---

## 🏁 Deployment Result

The final deployment provides a scalable AWS environment where traffic is distributed across multiple EC2 instances and application data is stored in private database infrastructure.
