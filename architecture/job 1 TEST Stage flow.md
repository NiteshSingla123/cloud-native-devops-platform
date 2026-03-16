
###Job 1 — TEST STAGE

Each job runs on a temporary runner VM.

GitHub Actions
      │
      ▼
Create Temporary Runner
(OS: Ubuntu)

Runner purpose:
1. Execute pipeline scripts
2. Run tests
3. Build images

Create Ubuntu Runner
        │
        ▼
Checkout Repository
(actions/checkout)
        │
        ▼
Repository Cloned Into Runner
        │
        ▼
Setup Python Runtime
(actions/setup-python)
        │
        ▼
Install Dependencies
pip install -r requirements.txt
        │
        ▼
Run Tests
pytest
        │
        ▼
API Tests + Unit Tests
        │
        ▼
Test Success



If tests fail:

Pipeline stops
Build never happens