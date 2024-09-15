package com.example.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import software.amazon.awssdk.auth.credentials.EnvironmentVariableCredentialsProvider;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.sqs.SqsClient;

@Configuration
public class AwsConfig {

    @Bean
    public DynamoDbClient dynamoDbClient() {
        return DynamoDbClient.builder()
                .region(Region.of(System.getenv("AWS_REGION")))  // Região da AWS configurada como variável de ambiente
                .credentialsProvider(EnvironmentVariableCredentialsProvider.create())  // Provedor de credenciais via ambiente
                .build();
    }

    @Bean
    public SqsClient sqsClient() {
        return SqsClient.builder()
                .region(Region.of(System.getenv("AWS_REGION")))  // Região da AWS configurada como variável de ambiente
                .credentialsProvider(EnvironmentVariableCredentialsProvider.create())  // Provedor de credenciais via ambiente
                .build();
    }
}
