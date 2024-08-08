### Following Dockerfile for a Java application with multi-stage build to demonstrate certain aspect of security pratice that can be adopted.
### Assumptions:
    ### 1. Existing application with source code is in the root directory.
    ### 2. The application JAR file is named webapp.jar.
    ### 3. pom.xml exists in the root directory.
### This Dockerfile is for a Java application that uses Maven for building the applicationand Trivy for security scanning. 
### Trivy Scan can be remove from here and can be done in CI/CD pipeline
### The Dockerfile has three stages:
    ### 1. Build the application using Maven
    ### 2. Create an intermediate image for security scanning using Trivy
    ### 3. Create the final image for running the application
### Some of the security features include:
    ### - Running the application as a non-root user
    ### - Using a slim base image
    ### - Setting Java options for resource limits
    ### - Using multi-stage build for security scanning
    ### - Using Trivy for security scanning
    ### - Optimizing the Dockerfile for security and resource efficiency

# Stage 1: Build the application
FROM maven:3.8.6-openjdk-11 AS builder

# Set the working directory
WORKDIR /app

# Copy the pom.xml file and install dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the application source code
COPY . .

# Build the application
RUN mvn package -DskipTests

# Stage 2: Vulnerability scanning with Trivy
FROM builder AS vulnscan
COPY --from=aquasec/trivy:latest /usr/local/bin/trivy /usr/local/bin/trivy
RUN trivy rootfs --exit-code 1 --no-progress /

# Stage 3: Create the final image
FROM openjdk:11-jre-slim AS final

# Create a non-root user
RUN groupadd -r webgroup && useradd -r -g webgroup webuser
USER webuser

# Set the working directory
WORKDIR /app

# Copy the built JAR file from the builder stage
COPY --from=builder /app/target/webapp-1.0-SNAPSHOT.jar ./webapp.jar

# Set Java options for resource limits
ENV JAVA_OPTS="-XX:MaxRAMPercentage=75.0 -XX:InitialRAMPercentage=50.0 -XX:MinRAMPercentage=25.0"

# Expose the application port
EXPOSE 8080

# Run the application with Java options
CMD ["java", "$JAVA_OPTS", "-jar", "webapp.jar"]