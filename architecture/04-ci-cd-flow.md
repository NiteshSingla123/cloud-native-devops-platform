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
