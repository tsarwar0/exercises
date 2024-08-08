# Docker Container with Sample Java App

This project contains a Dockerfile for building, scanning, and running a Java application. The application is built using Maven, and the Docker image is created in multiple stages to demonstrate some aspects of security and efficiency.

## Dockerfile Explanation

### Stage 1: Build the Application

1. **Base Image**: `maven:3.8.6-openjdk-11`
2. **Working Directory**: `/app`
3. **Dependencies Installation**:
    ```sh
    COPY pom.xml .
    RUN mvn dependency:go-offline
    ```
4. **Source Code**: `COPY . .`
5. **Build Command**:
    ```sh
    RUN mvn package -DskipTests
    ```

### Stage 2: Security Scanning with Trivy - This can be part of CI/CD pipeline as well if you dont chose to ember here.

1. **Base Image**: Uses the builder stage as the base
2. **Copy Trivy**: `COPY --from=aquasec/trivy:latest /usr/local/bin/trivy /usr/local/bin/trivy`
3. **Run TRivy Scan**: `RUN trivy rootfs --exit-code 1 --no-progress /`

### Stage 3: Create the Final Image

1. **Base Image**: `openjdk:11-jre-slim`
2. **Create Non-Root User**:
    ```sh
    RUN groupadd -r webgroup && useradd -r -g webgroup webuser
    USER webuser
    ```
3. **Working Directory**: `/app`
4. **Copy Built JAR**: `COPY --from=builder /app/target/webapp-1.0-SNAPSHOT.jar ./webapp.jar.`
5. **Java Options**:
    ```sh
    ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:InitialRAMPercentage=50.0 -XX:MinRAMPercentage=25.0"
    ```
6. **Expose Port**: `EXPOSE 8080`
7. **Run Command**:
    ```sh
    CMD ["java", "$JAVA_OPTS", "-jar", "webapp.jar"]
    ```

## Building and Pushing the Docker Image

1. **Login to Azure**:
    ```sh
    az login
    ```

2. **Create Resource Group**:
    ```sh
    az group create --name WebAppResourceGroup --location eastus
    ```

3. **Create Azure Container Registry**:
    ```sh
    az acr create --resource-group WebAppResourceGroup --name webappacr --sku Basic
    ```

4. **Login to ACR**:
    ```sh
    az acr login --name webappacr
    ```

5. **Build Docker Image**:
    ```sh
    docker build -t webappacr.azurecr.io/webapp:latest .
    ```

6. **Push Docker Image**:
    ```sh
    docker push webappacr.azurecr.io/webapp:latest
    ```

## Enable Microsoft Defender for Containers

Ensure Microsoft Defender for Cloud is enabled:

```sh
az security auto-provisioning-setting update --name default --set autoProvision=On


