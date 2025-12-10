# Build stage
FROM maven:3.9.1-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Run stage
FROM eclipse-temurin:11-jre-alpine
WORKDIR /opt/app
COPY --from=build /app/target/spring-boot-web.jar spring-boot-web.jar
ENTRYPOINT ["java", "-jar", "spring-boot-web.jar"]
