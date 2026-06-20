# Artifact Repository Manager with Nexus

## Project Overview

This project demonstrates how to build and manage a centralized artifact repository using Nexus Repository Manager.

The goal is to provide a secure location where multiple development teams can store, version, share, and retrieve application artifacts.

The project includes:

* Nexus Repository Manager installation on DigitalOcean
* npm hosted repository for Node.js applications 
* Maven hosted repository for Java applications
* Role-based access control for different teams
* Artifact publishing from Node.js and Java projects
* Nexus REST API integration
* Automated artifact retrieval and deployment
* Deployment of application artifacts on a Linux server

This project simulates a real-world DevOps workflow where development teams publish build artifacts to a central repository and deployment servers retrieve approved artifacts for execution.

---

# Architecture

```text
                     ┌─────────────────────┐
                     │     Developers      │
                     └──────────┬──────────┘
                                │
                                │ Publish Artifacts
                                ▼
                 ┌────────────────────────────┐
                 │ Nexus Repository Manager   │
                 │                            │
                 │ project1-npm-hosted        │
                 │ project2-maven-hosted      │
                 └──────────┬─────────────────┘
                            │
                            │ REST API
                            ▼
              ┌──────────────────────────────┐
              │ Deployment Droplet           │
              │                              │
              │ Fetch Latest Artifact        │
              │ Download Artifact            │
              │ Extract Artifact             │
              │ Start Application            │
              └──────────┬───────────────────┘
                         │
                         ▼
              ┌──────────────────────────────┐
              │ Running Application          │
              │ Node.js Service              │
              └──────────────────────────────┘
```

---

# Technologies Used

## Cloud

* DigitalOcean Droplets

## Artifact Management

* Nexus Repository Manager OSS

## Programming Languages

* JavaScript
* Java

## Build Tools

* npm
* Gradle

## Linux

* Ubuntu Server

## DevOps Tools

* Git
* GitHub
* GitLab
* Bash
* curl
* jq

---

# Repository Structure

```text
artifact_repository_manager_with_nexus/
│
├── docs/
│
├── java-app/
│   ├── build.gradle
│   ├── gradlew
│   ├── gradlew.bat
│   ├── settings.gradle
│   └── src/
│
├── node-app/
│   └── app/
│
├── scripts/
│   ├── fetch-latest-node-artifact.sh
│   ├── run-node-artifact.sh
│   └── fetch-latest-java-artifact.sh
│
└── README.md
```

---

# Nexus Repositories

## Project 1 Repository

Repository Type:

```text
npm (hosted)
```

Repository Name:

```text
project1-npm-hosted
```

Blob Store:

```text
project1-npm-blob
```

Purpose:

Store Node.js application packages generated with:

```bash
npm pack
```

---

## Project 2 Repository

Repository Type:

```text
maven2 (hosted)
```

Repository Name:

```text
project2-maven-hosted
```

Purpose:

Store Java application JAR files built with Gradle.

---

# User Management

## Team 1 User

Access:

```text
project1-npm-hosted
```

Permissions:

```text
browse
read
add
edit
```

---

## Team 2 User

Access:

```text
project2-maven-hosted
```

Permissions:

```text
browse
read
add
edit
```

---

## Deployment User

Purpose:

Deployment server access.

Permissions:

```text
Read npm artifacts
Read Maven artifacts
Browse repositories
Use Nexus REST API
```

---

# Publishing Node.js Artifact

Generate package:

```bash
npm pack
```

Login:

```bash
npm login --registry=http://NEXUS_SERVER:8081/repository/project1-npm-hosted/
```

Publish:

```bash
npm publish \
--registry=http://NEXUS_SERVER:8081/repository/project1-npm-hosted/ \
bootcamp-node-project-1.0.0.tgz
```

---

# Publishing Java Artifact

Build:

```bash
./gradlew clean build
```

Publish:

```bash
./gradlew publish \
-PrepoUser=project2-user \
-PrepoPassword=YOUR_PASSWORD
```

---

# Deployment Automation

The deployment server uses Nexus REST API to:

1. Query latest artifact metadata
2. Retrieve download URL
3. Download latest artifact
4. Extract package
5. Start application

Example API call:

```bash
curl -u USER:PASSWORD \
"http://NEXUS_SERVER:8081/service/rest/v1/components?repository=project1-npm-hosted"
```

---

# Security Practices

Implemented practices:

* Dedicated Nexus users per team
* Role-based repository access
* Separate repositories for different projects
* Deployment user with read-only access
* No credentials stored in Git
* Passwords injected through environment variables
* Principle of least privilege

---

# Troubleshooting Log

## Issue 1

Problem:

```text
npm publish returned 401 Unauthorized
```

Cause:

```text
Incorrect Nexus permissions.
```

Resolution:

```text
Assigned required npm repository privileges.
```

---

## Issue 2

Problem:

```text
Nexus REST API returned 403 Forbidden
```

Cause:

```text
Deployment user lacked browse/read permissions.
```

Resolution:

```text
Added browse and read privileges to deployment role.
```

---

## Issue 3

Problem:

```text
Node application failed with MODULE_NOT_FOUND
```

Cause:

```text
Application extracted into package/ directory after untar.
```

Resolution:

```text
Updated deployment path to:

/opt/artifact-apps/node-app/package
```

---

# Validation

Verify Node artifact exists:

```bash
curl -u USER:PASSWORD \
"http://NEXUS_SERVER:8081/service/rest/v1/components?repository=project1-npm-hosted"
```

Verify process:

```bash
ps aux | grep node
```

Verify logs:

```bash
tail -f /opt/artifact-apps/node-app/app.log
```

---

# Key DevOps Skills Demonstrated

* Artifact Repository Management
* Nexus Administration
* Role-Based Access Control
* npm Package Publishing
* Maven Artifact Publishing
* REST API Integration
* Linux Server Administration
* Deployment Automation
* Bash Scripting
* DigitalOcean Infrastructure
* GitHub and GitLab Workflow
* Production Troubleshooting

---

# Future Improvements

* Nexus Backup Automation
* HTTPS with Reverse Proxy
* Dockerized Nexus Deployment
* Jenkins Integration
* Automated CI/CD Pipeline
* Artifact Promotion Strategy
* Vulnerability Scanning
* High Availability Repository Architecture

---

## Author

Younghadiz

Artifact Repository Manager with Nexus
