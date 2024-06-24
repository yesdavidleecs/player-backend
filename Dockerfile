# Use the official Maven image to create a build artifact.
# https://hub.docker.com/_/maven
FROM maven:3.8.4-openjdk-17-slim AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pom.xml and the source code to the container
COPY src ./src
COPY pom.xml .

# Package the application
RUN mvn clean package
#RUN mvn clean package -DskipTests

# Use an official OpenJDK runtime as a parent image for a lean production stage
# https://hub.docker.com/_/openjdk
FROM openjdk:23-ea-17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the packaged application from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port the application runs on
EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]
