# Online Shop DevOps Deployment

## Project overview
Deploy a prebuilt React shopping application on AWS EC2 using Docker,
Docker Compose, Jenkins, and Docker Hub.

## Links
- GitHub: https://github.com/arasantam786-wq/online-shop-devops
- Application: http://3.110.50.130
- Original application: https://github.com/sriram-R-krishnan/devops-build

## Infrastructure
- AWS region: ap-south-1 (Mumbai)
- Instance: devops-jenkins-server
- Instance type: t2.micro
- OS: Ubuntu Server 24.04 LTS
- Storage: 30 GB
- Swap: 2 GB configured in /etc/fstab

## Network access
- Port 80: public application access
- Port 22: SSH restricted to my IP
- Port 8080: Jenkins restricted to my IP
- Port 3001: monitoring dashboard restricted to my IP

## Project files
- build/: prebuilt React application
- Dockerfile: packages the website with Nginx
- nginx.conf: serves the application and supports client-side routes
- compose.yaml: defines the application container
- build.sh: builds a Docker image
- deploy.sh: deploys the specified image through Compose
- Jenkinsfile: defines the automated pipeline
- .dockerignore and .gitignore: exclude unnecessary and sensitive files

## Setup
1. Launch an Ubuntu EC2 instance and configure its security group.
2. Install Git, Docker Engine, and the Docker Compose plugin.
3. Install Java 21 and Jenkins LTS.
4. Allow the Jenkins user to run Docker commands.
5. Create Docker Hub repositories:
   - desing96/dev: public
   - desing96/prod: private
6. Store Docker Hub credentials in Jenkins as dockerhub-creds.
7. Configure a Multibranch Pipeline for this GitHub repository.
8. Use Jenkinsfile as the script path and discover dev and master.
9. Configure periodic repository scans at a one-minute interval.
10. Configure GitHub credentials for authenticated repository scans.

## Local build and deployment
Run from the repository root:

    sudo bash build.sh
    sudo bash deploy.sh

Verify:

    sudo docker compose -p devops-build ps
    curl -I http://localhost

## Automated pipeline
GitHub -> Jenkins -> Docker Hub -> Docker Compose on EC2

- Push to dev: build and push an image to desing96/dev.
- Merge dev into master and push: build and push to desing96/prod,
  deploy the image, and check the HTTP response.
- Image tags combine the Jenkins build number and short commit hash.
- Production deployment is skipped for dev builds.
- Credentials are stored in Jenkins, not in the repository.

## Verified production image
desing96/prod:2-af4c9be

Later successful builds will use a new tag.

## Monitoring
Uptime Kuma monitors http://3.110.50.130 every 60 seconds.
The monitor is named Online Shop Production.
Uptime Kuma runs in Docker with a persistent uptime-kuma volume.

Monitoring dashboard: http://3.110.50.130:3001

The monitor runs on the application server, so it cannot independently
report a complete failure of that server. Notifications are not yet configured.

## Verification
- Jenkins dev and master builds succeeded.
- Automatic builds were verified by pushing a test commit.
- Production container uses an image from desing96/prod.
- Application returns HTTP 200.
- Uptime Kuma reports the website as Up.

## Screenshots
Evidence will be added in the screenshots directory:
- Jenkins pipeline configuration and successful builds
- AWS EC2 instance and security group rules
- Docker Hub repositories and image tags
- Deployed application
- Uptime Kuma health status

## Notes
The public IP may change after stopping and starting the EC2 instance.
Update application and monitoring URLs if that happens.

## Submission evidence
[View all deployment and monitoring screenshots](screenshots/)

The folder includes Jenkins builds, Docker images, the EC2 instance,
the deployed application, and Uptime Kuma monitoring evidence.
