module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "test-eks-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "eks_service_account_role" {
  name = "eks-service-account-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${module.eks.cluster_oidc_issuer_url}"
        }
        Condition = {
          StringEquals = {
            "${module.eks.cluster_oidc_issuer_url}:sub" = "system:serviceaccount:default:your-service-account"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_service_account_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"  # Policy de DynamoDB
  role       = aws_iam_role.eks_service_account_role.name
}

resource "aws_iam_role_policy_attachment" "eks_sqs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"  # Policy de SQS
  role       = aws_iam_role.eks_service_account_role.name
}

resource "kubernetes_service_account" "app_service_account" {
  metadata {
    name      = "demo-sa"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks_service_account_role.arn
    }
  }
}
