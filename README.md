# DevSecOps Security 

## Overview
This repository demonstrates some proof of concepts and tasks that gives you basic idea and understanding of securing pods and your pipelines . Will also provide some common best practices used in the world of docker , pod security and CI/CD pipelines.

## Docker Security Best Practice
- **Authentic Base Images:** Reduces the risk of vulnerabilities by always using official images from trusted sources. Official images are regularly updated ,maintained and verified.

- **Least Privilege:** Running a container as the root user opens the doorway to security risks. Its should be a common security practice to use a non-root user and then run your applications with that user.  This should be done regardless of the environment used for containers.

- **Multi-Stage Builds:** Using multistage builds helps your create a low fat and lean image cutting all the unnecessary dependencies and packages thats needed to build the image . This greatly reduces the attack surface area automatically limits potential vulnerabilities.

- **Periodic Docker Update:** Update Docker regularly to the latest version to make sure that you have the latest patches about security, and be updated with all the current features.

- **Image Scanning:** You should set up periodic scanning of your Docker images for known vulnerabilities by either using tools such as Trivy , SonarQube, or Microsoft Defender. This can be embedded as part of docker file and/or as art of CI/CD Pipelines.

- **Resource Limitation:** Providing Specific resource limitation allows applications to effectively manage memory and cpu resources and adhere to docker best practices in a containerized enviroment.

Refer to docker file doc to see some of the above mentioned pratices implemented , See: [DOCKER-README](./documentation/docker_readme.md)

## Local Development Setup

### Prerequisites
Ensure you have the following setup:
- A running Kubernetes cluster
- `kubectl` installed and configured
- `helm` installed
- Argo Rollouts installed in your cluster
- Create the required namespaces (canary and bluegreen) by running:
   ```sh
   kubectl create ns canary
   kubectl create ns bluegreen
   ```

### Installing Argo Rollouts
To install Argo Rollouts, execute the following commands:

>```sh
>helm repo add argo https://argoproj.github.io/argo-helm
>helm repo update
>helm install --name-template argo-rollouts argo/argo-rollouts --create-namespace -n argo-rollouts --set dashboard.enabled=true --version 2.32.5 --wait
>kubectl get deploy -n argo-rollouts
>```

To check the dashboard service:
>```sh
>kubectl get services -n argo-rollouts
>```

To access the dashboard, run the following command:
>```sh
>kubectl port-forward service/{mention_the_name_of_argo_rollout_dashboard_service} 31000:3100 -n argo-rollouts
>```
Then open your browser and navigate to `http://localhost:31000`.

## Deployment Strategies

### Canary Deployment
A Canary deployment gradually introduces a new version of the application to a subset of users, reducing the risk of widespread issues. 

- **Folder:** [canary](./canary/)
- **Description:** Contains manifests for canary deployment, including the Rollout and Service definitions.
  - `canary-rollout.yml`: Defines the Rollout strategy for the canary deployment.
  - `canary-service.yml`: Service definition to support the canary deployment.
  - `kustomization.yml`: Used by Kustomize to manage the deployment.

### Blue-Green Deployment
A Blue-Green deployment runs both old and new versions of the application simultaneously. The old version handles production traffic until the new version is verified.

- **Folder:** [bluegreen](./bluegreen/)
- **Description:** Contains manifests for blue-green deployment, including the Rollout and Service definitions.
  - `bluegreen-rollout.yml`: Defines the Rollout strategy for the blue-green deployment.
  - `bluegreen-service.yml`: Service definition for the active deployment.
  - `bluegreen-service-preview.yml`: Service definition for the preview deployment.
  - `kustomization.yml`: Used by Kustomize to manage the deployment.

## Using Kustomize
Kustomize is a tool for customizing Kubernetes resource configuration. We use it to manage and deploy the Kubernetes manifests for both deployment strategies.

## How to Run from Local
1. **Clone the Repository**
   ```sh
   git clone https://github.com/AAInternal/argo-rollouts-deployment-strategies.git
   cd argo-rollouts-deployment-strategies/
   ```

2. **Apply Canary Deployment**
   ```sh
   cd canary/
   kubectl apply -k .
   ```

3. **Apply Blue-Green Deployment**
   ```sh
   cd bluegreen/
   kubectl apply -k .
   ```

4. **Check Deployment Status**
   ```sh
   kubectl get all -n <namespace>
   ```

## Additional Resources
- [Argo Rollouts Documentation](https://argoproj.github.io/argo-rollouts/)
- [Kustomize Documentation](https://kustomize.io/)

For detailed procedures and additional information, See: [PROCEDURE-README](./documentation/PROCEDURE-README.md)
