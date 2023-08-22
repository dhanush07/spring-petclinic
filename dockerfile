ARG DOCKER_USERNAME
ARG DOCKER_PASSWORD

RUN echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin vmdhanush.jfrog.io

FROM vmdhanush.jfrog.io/docker-remote/alpine:3.18.2 AS builder
RUN apk add --no-cache openjdk17-jdk
WORKDIR /app
RUN addgroup -S testuser && adduser -S testuser -G testuser && chown -R testuser:testuser /app
ARG JAR_FILE=target/spring-petclinic-3.1.0-SNAPSHOT.jar
COPY ${JAR_FILE} petclinic.jar

EXPOSE 8080

FROM vmdhanush.jfrog.io/docker-remote/alpine:3.18.2 AS runtime
RUN apk add --no-cache openjdk17-jre
WORKDIR /app
COPY --from=builder /app/petclinic.jar .
CMD ["java", "-jar", "petclinic.jar"]
