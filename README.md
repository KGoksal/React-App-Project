# React DevOps Case Study

This project demonstrates the complete DevOps lifecycle of a simple React.js application, from development to deployment, utilizing Docker, GitLab CI/CD pipelines, AWS ECS Fargate with Terraform, and Kubernetes. The goal is to establish a secure and scalable cloud infrastructure and automate the deployment process following DevOps best practices.

## Table of Contents

1. [Overview](#overview)
2. [Technologies Used](#technologies-used)
3. [Dockerfile](#dockerfile)
4. [GitLab CI/CD Pipeline](#gitlab-cicd-pipeline)
5. [AWS ECS Fargate Deployment](#aws-ecs-fargate-deployment)
6. [Kubernetes Deployment](#kubernetes-deployment)
7. [Infrastructure Provisioning with Terraform](#infrastructure-provisioning-with-terraform)
8. [Project Setup](#project-setup)
9. [Security Considerations](#security-considerations)
10. [Conclusion](#conclusion)

## Overview

This case study covers the entire DevOps pipeline for deploying a simple React.js application. The process starts by building a Docker container, setting up continuous integration and deployment using GitLab CI/CD, and deploying the application to AWS ECS Fargate using Terraform for infrastructure automation. Additionally, the app is deployed to a Kubernetes cluster using manifests and necessary resources for external access.

## Technologies Used

- **React.js** (Frontend)
- **Docker** (Containerization)
- **GitLab CI/CD** (Pipeline automation)
- **AWS ECS Fargate** (Container orchestration)
- **Terraform** (Infrastructure as Code)
- **Kubernetes** (Cluster orchestration)
- **AWS ALB** (Application Load Balancer for traffic management)

## Dockerfile

The `Dockerfile` is written to ensure minimal image size and security.

```
Dockerfile
# Use official lightweight Node.js base image
FROM node:16-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy app files
COPY . .

# Build the app
RUN yarn build

# Serve the app using a lightweight web server
FROM nginx:stable-alpine

# Copy the build files from the previous stage
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 to access the app
EXPOSE 80

# Start the server
CMD ["nginx", "-g", "daemon off;"]
```

- Multi-stage build is used to keep the final image size small.
- Dependencies are installed in the first stage, and the app is built in a secure, isolated environment.
- The final image only contains the build files and Nginx for serving, reducing attack surface and ensuring a small, efficient production image.

## Key Stages:
- Build Stage: Builds the Docker image.
- Test Stage: Runs basic tests to ensure the app is functional.
- Deploy to AWS: Deploys the Docker container to AWS ECS Fargate.
- Deploy to Kubernetes: Deploys the containerized app to a Kubernetes cluster.
