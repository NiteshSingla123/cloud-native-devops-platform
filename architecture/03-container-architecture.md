                EC2 Instance
                     │
                     ▼
                Docker Engine
                     │
          ┌──────────┼──────────┐
          ▼          ▼          ▼
        Nginx      FastAPI     PostgreSQL
      Container   Container     Container
         │            │             │
         │            │             │
         ▼            ▼             ▼
     Port 80      Port 8000      Port 5432
   (Public)       (Internal)     (Internal)



REQUEST FLOW

User Browser
     │
     ▼
http://EC2-IP
     │
     ▼
Nginx Reverse Proxy
     │
     ▼
FastAPI Application
     │
     ▼
PostgreSQL Database