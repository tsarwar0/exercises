# DevSecOps Security 

## Overview This repository demonstrates some common concepts and sample code that gives you  idea and understanding of securing pods , containers and your pipelines . Will also provide some common best practices used in the world of K8s , docker , pod security and CI/CD pipelines.

## Docker Security Best Practice
- **Authentic Base Images:** Reduces the risk of vulnerabilities by always using official images from trusted sources. Official images are regularly updated ,maintained and verified.

- **Least Privilege:** Running a container as the root user opens the doorway to security risks. Its should be a common security practice to use a non-root user and then run your applications with that user.  This should be done regardless of the environment used for containers.

- **Multi-Stage Builds:** Using multistage builds helps your create a low fat and lean image cutting all the unnecessary dependencies and packages thats needed to build the image . This greatly reduces the attack surface area automatically limits potential vulnerabilities.

- **Periodic Docker Update:** Update Docker regularly to the latest version to make sure that you have the latest patches about security, and be updated with all the current features.

- **Image Scanning:** You should set up periodic scanning of your Docker images for known vulnerabilities by either using tools such as Trivy , SonarQube, or Microsoft Defender. This can be embedded as part of docker file and/or as art of CI/CD Pipelines.

- **Resource Limitation:** Providing Specific resource limitation allows applications to effectively manage memory and cpu resources and adhere to docker best practices in a containerized enviroment.

Refer to docker file doc to see some of the above mentioned pratices implemented , See: [DOCKER-README](docker_readme.md)

## Kubernetes security features
Security has become a critical feature from end to end application development along with Infrastructure as they compliment each other to bring the best of the security posture . Below are the most common security features of K8s that should not be ignored.  All of them combine together to minimize the attack surface.
- **Cluster Hardening:**
  - Role-Based Access Control (RBAC): RBAC is an  standard for enterprises that requires minimizing the control as much as possible within the cluster whether it's on-prem or in the cloud. Thus, user and service 
    permissions are assigned and are tightly scoped. For Example Use Role and Role Bindings for assigning access to resources.
    
  - API Server Security: Providing restricted access through the following ways: direct access limitation, TLS encryption for all API traffic whether OnPrem or cloud. Usually managed K8s implementations already takes of it unless you have setup your own cluster.

- **Pod Security:**
  - Run Containers as Non-Root: Not engendering containers with root privileges is a notable method to provide a second defense line on the time that a compromise is possible. Make use of non-root containers and/or       
    rootless container engines to the higher security management. For Example use of flags like allowPrivilegeEscalation along with RunAsUser under security context allows you to get started with this implementation.
    
  - Immutable File System: Utilizing a read-only root filesystem for containers is the best way to apply an immutable infrastructure strategy. It is also the way of stopping any unapproved changes in memory to happen 
    during container processing period. Use of readOnlyRootFilesystem under Security Context ,helps you get started with this feature.
    
- **Network Security:**
  - Network Policies: For instance, the setting of network policies is for controlling the still open communication between pods and the limitation of the accesses to the resources which are being altered or effectively      owned. It is a method of preventing lateral movement of the clustered applications from other containers in the event of a breach. For Example , Setting Network Policy to allow ingress from pods with only specific 
    labels on specific pors sets a start where it can be furthur implemented as needed.
    
  - Audit Logging:  Audit logging is a security measure that records all actions done by the API in order to able to analyze such logs at a later time point. The practice to discover and respond to malicious traffic 
    among the inner parts of a cluster is one of the ways in which clear records of the activities are of much use. For Example creat an Audit File Policy or use Prometheus , Dynatrace on prem or in cloud for more in 
    depth vsisibility to metrices etc.

  Refer to securpod.yaml read me file to see some of the above mentioned pratices implemented , See: See: [SECUREPOD-README](podsec_readme.md)


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
