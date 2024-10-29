#FROM eclipse-temurin:17-jdk-alpine
FROM openjdk:17-alpine

WORKDIR /Torneig_Mort

COPY  ./target/Torneig_Mort-0.0.1-SNAPSHOT.jar app.jar

ENTRYPOINT ["java","-jar","/Torneig_Mort/app.jar"]