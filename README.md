Assignment 3 — CI/CD with GitHub Actions
Project Overview
This project implements a local CI pipeline for a Bash-based DevOps utility. It validates Bash syntax, runs automated tests, and builds and smoke-tests a Docker image.

No cloud deployment is performed.

Project Structure
assignment-3/
├── README.md
├── app/
│   └── app.sh
├── scripts/
│   ├── lint.sh
│   └── build.sh
├── tests/
│   └── test.sh
├── .github/
│   └── workflows/
│       └── ci.yml
├── Dockerfile
├── compose.yaml
├── .dockerignore
└── grade.sh
Requirements
Git
Bash
Docker
GitHub account
Application Commands
Display system information:

./app/app.sh system-info
Check whether a hostname resolves:

./app/app.sh check-host localhost
Check TCP connectivity:

./app/app.sh check-port localhost 80
Display usage instructions:

./app/app.sh help
Invalid arguments return exit code 2. A failed hostname lookup or TCP connection returns a nonzero exit code.

Local Validation and Tests
Run the linter:

bash scripts/lint.sh
Run automated tests:

bash tests/test.sh
Run all local CI stages:

bash grade.sh
The test suite covers help, system information, invalid commands, missing input, hostname resolution, and invalid ports.

Docker
Build the image:

docker build -t devops-tool .
Run the application:

docker run --rm devops-tool help
docker run --rm devops-tool system-info
Run Docker smoke tests:

bash scripts/build.sh
Docker Compose is also supported:

docker compose build
docker compose run --rm devops-tool help
GitHub Actions CI Pipeline
The workflow is located at .github/workflows/ci.yml.

It runs on every push and pull request and contains three ordered jobs:

validate: checks required files and Bash syntax.
test: runs after validation succeeds and executes the automated tests.
docker: runs after the tests succeed, builds the Docker image, and executes smoke tests.
The needs dependency ensures that later jobs do not run when an earlier required job fails.

CI Failure Demonstration
To demonstrate CI failure, create a temporary branch, introduce a Bash syntax error or a deliberately failing test, commit the change, and push the branch. Open the repository's GitHub Actions tab and record the failed workflow run.

Then fix the issue, commit the correction, and push again. Verify that the final workflow passes all three jobs.

Evidence to record after performing the demonstration:

Failed workflow run: [add run URL]
Fixed workflow run: [add run URL]
Final status: [record the actual result]
Conclusion
This project demonstrates automated Bash validation, repeatable testing, Docker image building, smoke testing, and sequential CI execution using GitHub Actions. All builds and tests run locally or on GitHub-hosted CI runners; no cloud deployment is required.
