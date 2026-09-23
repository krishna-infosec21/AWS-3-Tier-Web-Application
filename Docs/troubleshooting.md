# 🛠️ AWS 3-Tier Application Troubleshooting

> Common issues and solutions encountered while deploying the AWS 3-tier application.

---

## 🔍 Troubleshooting Flow

When the application is not working, check the infrastructure from top to bottom:

```text
🌍 DNS
 ↓
⚖️ ALB
 ↓
🎯 Target Group
 ↓
🖥️ EC2
 ↓
🌐 Web Server
 ↓
🗄️ RDS
 ↓
📦 S3
```

---

## ❌ 1. ALB Returns 503 Error

### Possible Causes

* EC2 target is unhealthy
* Apache is not running
* Security Group blocks traffic
* Application is not listening on port 80
* Health check path is incorrect

### Check Apache

```bash
sudo systemctl status apache2
```

Start Apache:

```bash
sudo systemctl start apache2
```

Test locally:

```bash
curl http://localhost
```

---

## ❌ 2. Target Group Shows Unhealthy

Check:

```text
Target Group
→ Targets
→ Health Status
→ Health Check Details
```

Verify:

```text
Protocol: HTTP
Port: 80
Path: /
```

Also verify that EC2 Security Group allows HTTP traffic from the ALB Security Group.

---

## ❌ 3. Website Does Not Open

Check the following:

```text
☑ ALB is active
☑ Target is healthy
☑ Listener is configured
☑ Security Group allows traffic
☑ Apache is running
☑ DNS record is correct
```

Test from the EC2 instance:

```bash
curl http://localhost
```

---

## ❌ 4. HTTPS Not Working

Check:

### ACM Certificate

```text
Certificate Status: Issued
```

### ALB Listener

```text
HTTPS : 443
```

The HTTPS listener must have the correct ACM certificate attached.

Also verify that the DNS record points to the correct Application Load Balancer.

---

## ❌ 5. Route 53 Domain Not Working

Check:

```text
Domain
   ↓
Route 53 Hosted Zone
   ↓
A / Alias Record
   ↓
Application Load Balancer
```

Verify that the domain's nameservers are correctly delegated to Route 53.

---

## ❌ 6. EC2 Cannot Connect to RDS

Check the RDS Security Group.

Required rule:

```text
Type: MySQL/Aurora
Port: 3306
Source: EC2 Security Group
```

Do not use:

```text
0.0.0.0/0
```

for database access unless there is a specific justified requirement.

---

## ❌ 7. SSM Agent Not Connected

Check the SSM Agent:

```bash
sudo systemctl status amazon-ssm-agent
```

Verify:

* IAM role is attached
* SSM permissions are available
* Network connectivity exists
* Required VPC endpoints or outbound connectivity are configured

---

## ❌ 8. Auto Scaling Not Launching Instances

Check:

```text
Auto Scaling Group
→ Activity
→ Instances
```

Review:

* Launch Template
* AMI
* Instance type
* Subnets
* Security Group
* IAM role
* Health checks

---

## ❌ 9. EC2 Health Check Fails

Check the application server:

```bash
sudo systemctl status apache2
```

Check port 80:

```bash
sudo ss -tulpn | grep :80
```

Test:

```bash
curl http://localhost
```

If localhost works but the ALB health check fails, investigate the Security Group and target-group configuration.

---

## ❌ 1️⃣0️⃣ Application Loads Slowly

Check CloudWatch metrics for:

* CPU utilization
* Network traffic
* ALB request count
* Target response time

Also check application and web-server logs.

---

## 📝 Useful Commands

### Apache Status

```bash
sudo systemctl status apache2
```

### Restart Apache

```bash
sudo systemctl restart apache2
```

### Test Local Application

```bash
curl http://localhost
```

### Check Listening Ports

```bash
sudo ss -tulpn
```

### Check Server Logs

```bash
sudo journalctl -u apache2
```

---

## 🚦 Troubleshooting Checklist

```text
☐ DNS record is correct
☐ ALB is active
☐ Listener is configured
☐ Target group exists
☐ Targets are healthy
☐ EC2 is running
☐ Apache is running
☐ Port 80 is allowed
☐ RDS port 3306 is allowed
☐ IAM role is attached
☐ SSM connectivity is available
☐ CloudWatch metrics are checked
```

---

## 🏁 Conclusion

A systematic troubleshooting approach helps identify whether the problem is related to DNS, load balancing, networking, EC2, the web server, database connectivity, or AWS permissions.

Always troubleshoot **layer by layer** instead of changing multiple configurations at the same time.
