# Stage 2: Build the application
FROM alpine:3.18.2 AS build_stage
RUN apk add --no-cache openjdk17-jdk
WORKDIR /app
RUN addgroup -S testuser && adduser -S testuser -G testuser && chown -R testuser:testuser /app
ARG JAR_FILE=target/spring-petclinic-3.1.0-SNAPSHOT.jar
COPY ${JAR_FILE} petclinic.jar

# Stage 3: Create a runtime image
FROM alpine:3.18.2 AS runtime
RUN apk add --no-cache openjdk17-jre
WORKDIR /app
COPY --from=build_stage /app/petclinic.jar .
EXPOSE 8080
CMD ["java", "-jar", "petclinic.jar"]
