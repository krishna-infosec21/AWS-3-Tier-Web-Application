# 🔐 AWS 3-Tier Application Security

> Security design and best practices implemented for the AWS application.

---

## 🛡️ Security Architecture

The application follows a **defense-in-depth** approach.

```text
🌍 Internet
     │
     ▼
⚖️ ALB
     │
     ▼
🔒 Private EC2
     │
     ▼
🔒 Private RDS
```

---

## 🔐 1. Network Security

The application uses an Amazon VPC with public and private subnets.

### Public Layer

Contains:

* ⚖️ Application Load Balancer

### Private Layer

Contains:

* 🖥️ EC2 application servers
* 🗄️ RDS database

Private resources are not directly exposed to the internet.

---

## 🧱 2. Security Groups

Security Groups act as virtual firewalls.

### ALB

```text
Internet
   ↓
HTTP 80
HTTPS 443
```

### EC2

```text
ALB Security Group
       ↓
     HTTP 80
```

### RDS

```text
EC2 Security Group
       ↓
    MySQL 3306
```

This limits communication between application layers.

---

## 🔑 3. IAM Security

Use IAM roles instead of storing AWS access keys directly on EC2 instances.

### Recommended Principles

* 🔒 Least privilege
* 👤 Use IAM roles
* 🚫 Avoid hard-coded credentials
* 🔄 Rotate credentials when required
* 📋 Review permissions regularly

---

## 🔐 4. Database Security

RDS should be configured as a private database.

Recommended settings:

```text
Public Access: Disabled
Port: 3306
Encryption: Enabled
```

Only authorized application servers should be able to connect to the database.

---

## 🌐 5. HTTPS / TLS

Use AWS Certificate Manager to provide an SSL/TLS certificate.

Traffic flow:

```text
👤 User
   │
   │ HTTPS
   ▼
⚖️ Application Load Balancer
   │
   │ HTTP / HTTPS
   ▼
🖥️ EC2
```

HTTPS protects data transmitted between the client and load balancer.

---

## 📦 6. S3 Security

S3 bucket access should follow least-privilege principles.

Recommended:

```text
🚫 Public access disabled
🔐 IAM-based access
📋 Bucket policies reviewed
🔒 Encryption enabled
```

Only required application components should have access to the bucket.

---

## 📊 7. Monitoring & Logging

Use Amazon CloudWatch to monitor infrastructure activity.

Monitor:

* EC2 CPU utilization
* ALB requests
* Target health
* Auto Scaling events
* Application logs

Monitoring helps identify unusual activity and infrastructure problems.

---

## 🔄 8. Backup & Recovery

Use AWS backup capabilities where appropriate.

### Database

* Automated backups
* Snapshots
* Point-in-time recovery

### Application

* AMI / Launch Template
* Version-controlled source code
* S3 object protection where required

---

## 🚨 9. Security Best Practices

```text
✅ Keep EC2 instances private
✅ Restrict Security Group rules
✅ Keep RDS private
✅ Use HTTPS
✅ Use IAM roles
✅ Enable encryption
✅ Monitor CloudWatch metrics
✅ Keep operating systems updated
✅ Avoid hard-coded credentials
✅ Follow least-privilege access
```

---

## 🎯 Security Goal

The objective is to reduce unnecessary public exposure while allowing only the required communication between the application layers.

---

## 🏁 Summary

Security is implemented at multiple levels including network isolation, Security Groups, IAM, HTTPS, private database access, S3 controls, encryption, monitoring, and backup mechanisms.
