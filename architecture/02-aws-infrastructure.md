                   Internet
                       │
                       ▼
                Internet Gateway
                       │
                       ▼
                    AWS VPC
                       │
                       ▼
                 Public Subnet
                       │
                       ▼
               EC2 Security Group
            ┌─────────────────────┐
            │ Allow SSH (22)      │
            │ Allow HTTP (80)     │
            └─────────────────────┘
                       │
                       ▼
                  EC2 Instance
                (Ubuntu Server)


| AWS Component    | Purpose                       |
| ---------------- | ----------------------------- |
| VPC              | Isolated network              |
| Public Subnet    | Internet-accessible subnet    |
| Internet Gateway | Enables internet connectivity |
| Security Group   | Firewall rules                |
| EC2              | Runs containers               |
