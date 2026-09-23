```bash
#!/bin/bash

# ==========================================
# Highly Available 3-Tier AWS Application
# EC2 User Data Script
# ==========================================

# Update package repositories
apt-get update -y

# Install Apache Web Server
apt-get install -y apache2

# Enable Apache to start automatically
systemctl enable apache2

# Start Apache
systemctl start apache2

# Create application web page
cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Three-Tier AWS Application</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f4f7fb;
            color: #1f2937;
        }

        .container {
            max-width: 900px;
            margin: 80px auto;
            padding: 20px;
        }

        .card {
            background: #ffffff;
            padding: 45px;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
        }

        h1 {
            margin-bottom: 15px;
            font-size: 36px;
        }

        .subtitle {
            color: #6b7280;
            margin-bottom: 30px;
            font-size: 18px;
        }

        .architecture {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-top: 30px;
        }

        .tier {
            padding: 20px;
            border-radius: 10px;
            background: #f8fafc;
            border: 1px solid #e5e7eb;
        }

        .tier h3 {
            margin-bottom: 8px;
        }

        .footer {
            margin-top: 30px;
            color: #6b7280;
            font-size: 14px;
        }

        @media (max-width: 700px) {
            .architecture {
                grid-template-columns: 1fr;
            }

            .card {
                padding: 30px 20px;
            }

            h1 {
                font-size: 28px;
            }
        }
    </style>
</head>

<body>

    <div class="container">

        <div class="card">

            <h1>Three-Tier AWS Application</h1>

            <p class="subtitle">
                Highly Available Cloud Architecture
            </p>

            <div class="architecture">

                <div class="tier">
                    <h3>Presentation Tier</h3>
                    <p>CloudFront</p>
                    <p>Application Load Balancer</p>
                </div>

                <div class="tier">
                    <h3>Application Tier</h3>
                    <p>Amazon EC2</p>
                    <p>Auto Scaling</p>
                </div>

                <div class="tier">
                    <h3>Database Tier</h3>
                    <p>Amazon RDS</p>
                    <p>MySQL</p>
                </div>

            </div>

            <div class="footer">
                AWS Cloud Architecture Solution
            </div>

        </div>

    </div>

</body>
</html>
EOF

# Set correct ownership
chown -R www-data:www-data /var/www/html

# Set directory permissions
chmod -R 755 /var/www/html

# Restart Apache to apply configuration
systemctl restart apache2

# Verify Apache status
systemctl is-active --quiet apache2

if [ $? -eq 0 ]; then
    echo "Apache Web Server is running successfully."
else
    echo "Apache Web Server failed to start."
fi
```
