# Usar uma imagem base Java
FROM openjdk:17-jdk-alpine

# Definir o diretório de trabalho dentro do container
WORKDIR /app

# Copiar o arquivo jar gerado para o container
COPY target/demo-0.0.1-SNAPSHOT.jar /app/aws-app.jar

# Comando para rodar a aplicação
ENTRYPOINT ["java", "-jar", "aws-app.jar"]
