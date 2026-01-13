# BUILD STAGE
FROM gradle:jdk21-ubi-minimal AS build

WORKDIR /app

# Copy gradle wrapper and configs
COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .

# បន្ថែមសិទ្ធិ Execute ឱ្យ gradlew (ការពារកុំឱ្យ Error Permission Denied)
RUN chmod +x gradlew

# Pre-download dependencies
RUN ./gradlew dependencies --no-daemon || true

# Copy full source
COPY . .

# Build application
RUN ./gradlew clean build -x test --no-daemon

# RUN STAGE
FROM eclipse-temurin:21-jre-ubi9-minimal

WORKDIR /app

# កែសម្រួលកន្លែងនេះ៖ ប្រើ Wildcard ឱ្យចំ ឬប្រើឈ្មោះ JAR ដែលជាក់លាក់
# ប្រសិនបើ Project ឈ្មោះ 'demo' វានឹងបង្កើត demo-0.0.1-SNAPSHOT.jar
COPY --from=build /app/build/libs/*-SNAPSHOT.jar app.jar

EXPOSE 8080

# ប្រើ ENTRYPOINT ជំនួស CMD សម្រាប់ Java App គឺល្អជាង (Best Practice)
ENTRYPOINT ["java", "-jar", "app.jar"]
