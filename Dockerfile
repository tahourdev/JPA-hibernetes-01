# ប្រើតែ Run Stage បានហើយ ព្រោះ JAR មានស្រាប់ក្នុង Workspace
FROM eclipse-temurin:21-jre-ubi9-minimal

WORKDIR /app

# ចម្លង JAR ដែល Build រួចពី Workspace (build/libs/) មកដាក់ក្នុង Image
# ប្រើ Wildcard ចាប់យក JAR ដែលមានលេខ version (ចៀសវាង plain jar)
COPY build/libs/*SNAPSHOT.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
