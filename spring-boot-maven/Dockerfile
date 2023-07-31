FROM eclipse-temurin:17-jdk-alpine as builder
WORKDIR /opt/app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline
COPY ./src ./src
RUN ./mvnw clean install
 
FROM eclipse-temurin:17-jdk-alpine
# Update the package index and upgrade installed packages
RUN apk update && apk upgrade
WORKDIR /opt/app
EXPOSE 8084
COPY --from=builder /opt/app/target/*.jar /opt/app/*.jar
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
ENTRYPOINT ["java", "-jar", "/opt/app/*.jar"]