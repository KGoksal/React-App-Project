

# React DevOps Case Study

This project demonstrates the full DevOps cycle for a simple React.js application, including CI/CD pipeline, Dockerization, deployment to AWS ECS Fargate, and Kubernetes using Terraform.

## Key Stages:
1. **Build Stage:** Builds the Docker image for the React.js app.
2. **Test Stage:** Runs basic tests to ensure the app is functional.
3. **Deploy to AWS ECS Fargate:** Deploys the Docker container to AWS ECS Fargate using Terraform.
4. **Deploy to Kubernetes:** Deploys the containerized app to a Kubernetes cluster using Helm.

---

## 1. Create a Basic React.js App

We will create a simple React.js application using Facebook's Create React App tool.

### Steps:
1. Create a new React.js app:
   ```bash
   npx create-react-app my-app
   cd my-app
   npm start
   ```
   This will create a new directory `my-app` with the necessary files and dependencies for a basic React.js app.

---

## 2. Create a Dockerfile

We will create a multi-stage Dockerfile to build the React app and serve it using Nginx.

### Dockerfile:
```dockerfile
# Stage 1: Build the React app
FROM node:alpine AS build
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Serve the app using Nginx
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Explanation:
- **Stage 1:** Builds the React app using a small Node.js Alpine image.
- **Stage 2:** Copies the built files and serves them with Nginx.

### Build the Docker Image:
```bash
docker build -t my-react-app .
```

### Run the Docker Container:
```bash
docker run -p 80:80 my-react-app
```

---

## 3. Set Up GitLab CI/CD Pipeline

Next, we set up a CI/CD pipeline to automate building, testing, and deploying the app using GitLab CI/CD.

### `.gitlab-ci.yml`:
```yaml
stages:
  - build
  - test
  - deploy

build:
  stage: build
  script:
    - docker build -t $CI_REGISTRY/my-react-app .
  only:
    - master

test:
  stage: test
  script:
    - docker run my-react-app npm test
  only:
    - master

deploy:
  stage: deploy
  script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
    - docker push $CI_REGISTRY/my-react-app
    - aws ecs update-service --cluster my-cluster --service my-service --force-new-deployment
  only:
    - master
```

### Explanation:
- **Build Stage:** Builds the Docker image for the app.
- **Test Stage:** Runs tests inside a Docker container to verify app functionality.
- **Deploy Stage:** Pushes the image to a Docker registry and deploys it to AWS ECS using the `aws ecs` CLI command.

---

## 4. Deploy to AWS ECS Fargate

We will deploy the Docker container to AWS ECS Fargate using Terraform for infrastructure as code.

### Steps to Deploy:
1. **Create a VPC and Security Group** using Terraform:
    ```hcl
    resource "aws_vpc" "main" {
      cidr_block = "10.0.0.0/16"
    }

    resource "aws_security_group" "web_sg" {
      vpc_id = aws_vpc.main.id
      ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    }
    ```

2. **Define ECS Cluster and Fargate Service:**
    ```hcl
    resource "aws_ecs_cluster" "my-cluster" {}

    resource "aws_ecs_service" "my-service" {
      cluster        = aws_ecs_cluster.my-cluster.id
      task_definition = aws_ecs_task_definition.my-task.arn
      launch_type    = "FARGATE"
      desired_count  = 1
      network_configuration {
        subnets         = [aws_subnet.main.id]
        security_groups = [aws_security_group.web_sg.id]
      }
    }
    ```

3. **Create an Application Load Balancer:**
    ```hcl
    resource "aws_lb" "app_lb" {
      name               = "my-app-lb"
      internal           = false
      load_balancer_type = "application"
      security_groups    = [aws_security_group.web_sg.id]
      subnets            = [aws_subnet.main.id]
    }
    ```

4. **Build and Push the Docker Image to AWS ECR:**
    ```bash
    docker tag my-react-app:latest <ECR_REPO_URL>/my-react-app:latest
    docker push <ECR_REPO_URL>/my-react-app:latest
    ```

5. **Deploy to AWS ECS Fargate:**
    Use Terraform to apply the infrastructure configuration:
    ```bash
    terraform apply
    ```

---

## 5. Deploy to Kubernetes

To deploy the app to a Kubernetes cluster, we create Kubernetes manifests and use Helm for package management.

### Kubernetes Manifests:

1. **Deployment Manifest:**
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: my-api
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: my-api
      template:
        metadata:
          labels:
            app: my-api
        spec:
          containers:
          - name: my-api
            image: <DOCKER_REGISTRY>/my-react-app
            ports:
            - containerPort: 3000
    ```

2. **Service Manifest:**
    ```yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: my-api-service
    spec:
      selector:
        app: my-api
      ports:
      - protocol: TCP
        port: 80
        targetPort: 3000
      type: NodePort
    ```

### Deploying to Kubernetes:
- Apply the Kubernetes manifests:
    ```bash
    kubectl apply -f deployment.yaml
    kubectl apply -f service.yaml
    ```

---

## 6. Deploy with Helm

You can also use Helm to manage and package Kubernetes deployments.

### Steps to Create Helm Chart:
1. Create a new Helm chart:
    ```bash
    helm create my-chart
    ```

2. Customize the `values.yaml` file with your image and Kubernetes settings.

3. Install the Helm chart to your Kubernetes cluster:
    ```bash
    helm install my-release my-chart
    ```

---

## Conclusion

This project covers the full DevOps cycle:
- **CI/CD** using GitLab pipelines.
- **Containerization** with Docker.
- **Cloud Deployment** to AWS ECS Fargate.
- **Kubernetes Deployment** using manifests and Helm.

Each step follows best DevOps practices, including multi-stage Docker builds, infrastructure as code with Terraform, and automated deployments to cloud and Kubernetes environments.
