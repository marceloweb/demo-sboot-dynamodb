package com.example.demo;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.ScanRequest;
import software.amazon.awssdk.services.dynamodb.model.ScanResponse;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.SendMessageRequest;

import java.util.UUID;

@SpringBootApplication
@ComponentScan(basePackages = "com.example.config")
public class DemoApplication {

    private final DynamoDbClient dynamoDbClient;
    private final SqsClient sqsClient;

    public DemoApplication(DynamoDbClient dynamoDbClient, SqsClient sqsClient) {
        this.dynamoDbClient = dynamoDbClient;
        this.sqsClient = sqsClient;
    }

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    @Bean
    public CommandLineRunner commandLineRunner() {
        return args -> {
            // Consumir tabela do DynamoDB
            String tableName = System.getenv("DYNAMODB_TABLE");
            ScanRequest scanRequest = ScanRequest.builder()
                    .tableName(tableName)
                    .build();

            ScanResponse scanResponse = dynamoDbClient.scan(scanRequest);
            System.out.println("Itens do DynamoDB: " + scanResponse.items());

            // Postar mensagem no SQS
            String queueUrl = System.getenv("SQS_QUEUE_URL");

            String message = "{ \"messageId\": \"" + UUID.randomUUID() + "\", \"content\": \"Mensagem aleatória\" }";

            SendMessageRequest sendMsgRequest = SendMessageRequest.builder()
                    .queueUrl(queueUrl)
                    .messageBody(message)
                    .build();

            sqsClient.sendMessage(sendMsgRequest);

            System.out.println("Mensagem enviada com sucesso para o SQS!");
        };
    }
}
