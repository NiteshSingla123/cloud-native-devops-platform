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