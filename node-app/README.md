# Cloud & IaaS Basics – Node.js Application Deployment on DigitalOcean

## Project Overview

This project demonstrates how a DevOps Engineer packages, deploys, and runs a Node.js application on a cloud server using DigitalOcean Infrastructure as a Service (IaaS).

The application displays a list of team members and the projects they are currently working on. The goal of this exercise is to make the application accessible online so developers, testers, and project managers can view it through a web browser.

This project follows a professional DevOps workflow including:

- Git version control
- Feature branch workflow
- Artifact packaging
- Cloud server provisioning
- Application deployment
- Remote server administration
- Firewall configuration
- Process management
- Documentation

---

# Project Architecture

```text
┌─────────────────────┐
│ Developer Workstation│
│      (MacBook)       │
└──────────┬───────────┘
           │
           │ npm pack
           ▼
┌─────────────────────┐
│ NodeJS Artifact     │
│      .tgz File      │
└──────────┬───────────┘
           │
           │ SCP
           ▼
┌────────────────────────────────────┐
│ DigitalOcean Ubuntu Droplet        │
│                                    │
│  Node.js Runtime                   │
│  npm                               │
│  server.js                         │
│                                    │
│  Port 3000                         │
└──────────┬─────────────────────────┘
           │
           │ Firewall Rule
           ▼
┌─────────────────────┐
│      Browser        │
│ http://SERVER_IP    │
└─────────────────────┘
```

---

# Technologies Used

- Git
- GitHub
- GitLab
- Linux
- Ubuntu Server
- Node.js
- npm
- SCP
- SSH
- DigitalOcean
- Cloud Firewall

---

# Repository Workflow

This project follows a professional Git workflow.

```text
main
│
├── develop
│
├── feature/package-node-app
│
├── feature/droplet-setup
│
└── feature/deployment
```

Merge strategy:

```bash
git merge --no-ff
```

This preserves feature branch history and creates a professional commit graph.

---

# Step 1 – Clone Repository

```bash
git clone https://gitlab.com/twn-devops-bootcamp/latest/05-cloud/cloud-basics-exercises.git

cd cloud-basics-exercises
```

---

# Step 2 – Initialize Personal Repository

```bash
rm -rf .git

git init

git branch -M main

git add .

git commit -m "chore: initial project setup"
```

Create:

```text
GitLab Repository
GitHub Repository
```

Add remotes:

```bash
git remote add origin git@gitlab.com:younghadiz/younghadiz-cloud-iaas-nodejs-digitalocean.git

git remote add github git@github.com:younghadiz/younghadiz-cloud-iaas-nodejs-digitalocean.git
```

Push:

```bash
git push -u origin main

git push -u github main
```

---

# Step 3 – Create Develop Branch

```bash
git checkout -b develop

git push -u origin develop

git push -u github develop
```

---

# Step 4 – Package Application

Create deployment artifact.

```bash
npm pack
```

Output:

```text
bootcamp-node-project-1.0.0.tgz
```

Verify:

```bash
ls
```

Expected:

```text
bootcamp-node-project-1.0.0.tgz
```

---

# Step 5 – Create DigitalOcean Droplet

Create:

```text
Ubuntu 24.04 LTS
1 vCPU
2 GB RAM
```

Authentication:

```text
SSH Key
```

Recommended:

```text
Monitoring Enabled
Backups Optional
Firewall Enabled
```

---

# Step 6 – Connect to Server

```bash
ssh root@SERVER_IP
```

Example:

```bash
ssh root@158.190.240.271
```

---

# Step 7 – Install Node.js and npm

Update packages:

```bash
apt update
```

Install Node.js:

```bash
apt install nodejs npm -y
```

Verify:

```bash
node -v

npm -v
```

Expected:

```text
v22.x.x
10.x.x
```

---

# Step 8 – Upload Application

From local machine:

```bash
scp bootcamp-node-project-1.0.0.tgz root@SERVER_IP:/root
```

Example:

```bash
scp bootcamp-node-project-1.0.0.tgz root@YOUR_SERVER_IP:/root
```

---

# Step 9 – Extract Application

SSH into server:

```bash
cd /root

tar -zxvf bootcamp-node-project-1.0.0.tgz
```

Expected:

```text
package/
```

---

# Step 10 – Install Dependencies

```bash
cd package

npm install
```

Expected:

```text
added packages
```

---

# Step 11 – Run Application

Run application in detached mode.

```bash
nohup node server.js > app.log 2>&1 &
```

Verify process:

```bash
ps aux | grep node
```

Example output:

```text
node server.js
```

Check logs:

```bash
tail -f app.log
```

Expected:

```text
app listening on port 3000!
```

---

# Step 12 – Configure Firewall

DigitalOcean Firewall

Add inbound rule:

```text
TCP
Port 3000
Source: All IPv4
```

Keep:

```text
SSH 22
```

---

# Step 13 – Access Application

Open browser:

```text
http://SERVER_IP:3000
```

Example:

```text
http://152.290.240.141:3000
```

Application loads successfully.

---

# Validation Commands

Verify Node process:

```bash
ps aux | grep node
```

Verify listening port:

```bash
ss -tulpn | grep node
```

Verify logs:

```bash
tail -f app.log
```

---

# Troubleshooting

## Application not loading

Verify process:

```bash
ps aux | grep node
```

Restart:

```bash
pkill node

nohup node server.js > app.log 2>&1 &
```

---

## Port not accessible

Verify firewall:

```text
DigitalOcean
→ Networking
→ Firewall
```

Ensure:

```text
TCP 3000
```

is allowed.

---

## Application crashes

Check logs:

```bash
tail -100 app.log
```

---

## npm not found

Install:

```bash
apt install npm -y
```

---

# Security Considerations

For this exercise root user was used for simplicity.

Production environments should use:

- Dedicated Linux user
- Reverse proxy (Nginx)
- HTTPS
- Domain name
- Process manager (PM2 or systemd)
- Secrets management
- Monitoring
- Logging

---

# Screenshots

Recommended screenshots:

## Infrastructure

- DigitalOcean Droplet
- Firewall Configuration

## Deployment

- Node.js Installation
- npm Installation
- SCP Upload
- Application Extraction
- npm install

## Runtime

- nohup execution
- Process verification
- Application logs

## Browser

- Application accessible from browser

Store screenshots:

```text
docs/screenshots/
```

---

# Skills Demonstrated

- Linux Administration
- SSH
- SCP
- Cloud Infrastructure
- DigitalOcean
- Node.js Deployment
- npm Packaging
- Firewall Management
- Git Workflow
- Troubleshooting
- Application Hosting

---

# Future Improvements

- Dockerize application
- Deploy using Docker Compose
- Configure Nginx reverse proxy
- Add HTTPS
- Deploy with CI/CD pipeline
- Use GitLab CI
- Use GitHub Actions
- Add Monitoring
- Add Automated Deployment

---

# Author

Gafari Salaudeen

DevOps Engineer Portfolio Project

GitHub:
https://github.com/younghadiz

GitLab:
https://gitlab.com/younghadiz
