provider "aws" {
  region = "us-east-1"
}

# Criar Tabela DynamoDB
resource "aws_dynamodb_table" "my_table" {
  name         = "tb_test"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

# Criar Fila SQS
resource "aws_sqs_queue" "my_queue" {
  name = "sqs_test"
}

# Políticas para a aplicação acessar DynamoDB e SQS
resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy" "access_dynamodb_sqs" {
  name        = "AccessDynamoDBSQS"
  description = "Permite acessar DynamoDB e SQS"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["dynamodb:Scan", "sqs:SendMessage"],
        Resource = "*",
        Effect   = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.access_dynamodb_sqs.arn
}
