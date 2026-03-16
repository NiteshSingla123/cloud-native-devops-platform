                Developer
                    │
                    │ Push Code
                    ▼
             GitHub Repository
                    │
                    │ Trigger CI Pipeline
                    ▼
             GitHub Actions (CI)
            ┌───────────────────────┐
            │ Run Tests (pytest)    │
            │ Build Docker Image    │
            │ Tag Image (latest)    │
            │ Push → DockerHub      │
            └───────────────────────┘
                    │
                    ▼
              DockerHub Registry
                    │
                    │ Pull Image
                    ▼
               AWS EC2 Instance
                    │
                    ▼
              Docker Compose
          ┌──────────┼──────────┐
          ▼          ▼          ▼
       Nginx      FastAPI     PostgreSQL
    (Reverse Proxy) (API)     (Database)



Explanation
Component	            Responsibility
GitHub	                Stores source code
GitHub Actions	        CI pipeline
DockerHub	            Container registry
EC2	                    Runtime server
Docker	                Container runtime
Docker Compose	        Service orchestration
Nginx	                Reverse proxy
FastAPI	                Backend application
PostgreSQL	            Database

example



## The final architecture of the pipeline

Developer writes code
        │
        ▼
Push to GitHub
        │
        ▼
GitHub Actions CI Pipeline
        │
        ▼
Run Tests
        │
        ▼
Build Docker Image
        │
        ▼
Push Image to DockerHub
        │
        ▼
Deploy Pipeline
        │
        ▼
SSH into EC2
        │
        ▼
docker-compose pull
        │
        ▼
docker-compose up -d
        │
        ▼
Containers Running
        │
        ▼
Application Live