##Job 2 — BUILD STAGE

After tests pass:

Test Job Success
       │
       ▼
Build Job Triggered

New runner created:

GitHub Actions
      │
      ▼
New Ubuntu Runner Created


Important concept:
Each job uses a new VM
Previous VM is destroyed


Build Stage Flow:
Checkout Repository
       │
       ▼
Clone Repo Into Runner
       │
       ▼
Login to DockerHub
(using GitHub Secrets)
       │
       ▼
Docker Authentication Success


Registry used:
Docker

Docker Image Build

Docker Build Command
       │
       ▼
Read Dockerfile
(location: backend/Dockerfile)
       │
       ▼
Build Image


Image contains:
Python
FastAPI
Application code
Dependencies


Image tagging:
devops-api:latest
devops-api:sha-commit


Purpose of SHA tag:
Versioned image tracking


Push Image to DockerHub
Docker Push
      │
      ▼
Image Uploaded to DockerHub Registry

Now image is stored remotely.