# -----------------------------
# 1. Build Stage
# -----------------------------
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set working directory inside container
WORKDIR /app

# Copy only pom.xml first
COPY CustomeLoginAndSignup/pom.xml .

# Download dependencies (cache layer)
RUN mvn dependency:go-offline

# Copy full project
COPY CustomeLoginAndSignup ./

# Build the JAR
RUN mvn clean package -DskipTests


# -----------------------------
# 2. Run Stage
# -----------------------------
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

# Default command
ENTRYPOINT ["java", "-jar", "app.jar"]
