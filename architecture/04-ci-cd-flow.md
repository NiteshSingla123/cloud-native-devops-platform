Developer
   │
   │ git push
   ▼
GitHub
   │
   ▼
GitHub Actions
   │
   ├── Run Unit Tests
   ├── Build Docker Image
   ├── Tag Image
   └── Push → DockerHub
           │
           ▼
      DockerHub
           │
           ▼
        EC2 Server
           │
           ▼
 docker-compose pull
 docker-compose up -d



 | Step  | Purpose                 |
| ----- | ----------------------- |
| Tests | Prevent broken code     |
| Build | Create container image  |
| Push  | Store image in registry |
| Pull  | Deploy new version      |



After Automation our CICD looks like this 

workflow
│
├── on
│     ├── push
│     └── pull_request
│
└── jobs
      │
      ├── test
      │      run pytest
      │
      ├── build
      │      build docker image
      │      push to dockerhub
      │
      └── deploy
             ssh to EC2
             docker-compose pull
             docker-compose up -d


Our CICD what we want as final  

Developer Push
      ↓
GitHub Actions
      ↓
Run Tests
      ↓
Build Docker Image
      ↓
Push Image → DockerHub
      ↓
Terraform Apply
      ↓
Create / Update AWS Infrastructure
      ↓
EC2 Bootstraps Itself
      ↓
Install Docker + Docker Compose
      ↓
Pull Image
      ↓
Run Containers