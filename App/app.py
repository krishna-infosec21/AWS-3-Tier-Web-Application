from flask import Flask, render_template, jsonify

app = Flask(__name__)


@app.route("/")
def home():
    return render_template("index.html")


@app.route("/health")
def health():
    return jsonify({
        "status": "healthy",
        "application": "Three-Tier AWS Application"
    })


@app.route("/api/info")
def info():
    return jsonify({
        "application": "Three-Tier AWS Application",
        "application_tier": "Amazon EC2",
        "database_tier": "Amazon RDS",
        "storage_tier": "Amazon S3",
        "status": "Running"
    })


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)