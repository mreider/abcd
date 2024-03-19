# Use an OpenJDK image with Java 17
FROM openjdk:17

WORKDIR /app

# Copy your application and the OpenTelemetry Java agent
COPY . /app
COPY opentelemetry-javaagent.jar /app/opentelemetry-javaagent.jar

# Package your application
RUN ./mvnw package


# Run your Java application with the OpenTelemetry Java agent
CMD ["java", "-javaagent:/app/opentelemetry-javaagent.jar", "-Dotel.resource.attributes=service.name=serviceA", "-jar", "/app/target/servicea-0.0.1-SNAPSHOT.jar"]
