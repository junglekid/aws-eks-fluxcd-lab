module "sqs" {
  source = "terraform-aws-modules/sqs/aws"

  name = "${local.sqs_name}-queue"
  # dlq_name = "${local.sqs_name}-dead-letter-queue"

  create_dlq = true
  redrive_policy = {
    # default is 5 for this module
    maxReceiveCount = 10
  }
}

resource "aws_iam_policy" "sqs" {
  name        = "${local.sqs_name}-policy"
  description = "Policy for EKS sqs_app to access SQS Queue"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "SQS"
        Action = [
          "sqs:DeleteMessage",
          "sqs:SendMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ReceiveMessage"
        ]
        Effect = "Allow",
        Resource = [
          module.sqs.queue_arn,
          module.sqs.dead_letter_queue_arn
        ],
      },
    ]
  })
}

resource "aws_iam_policy" "sqs-keda" {
  name        = "${local.sqs_name}-keda-policy"
  description = "Policy for EKS sqs_app to access SQS Queue"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "SQS"
        Action = [
          "sqs:GetQueueAttributes"
        ]
        Effect = "Allow",
        Resource = [
          module.sqs.queue_arn,
          module.sqs.dead_letter_queue_arn
        ],
      },
    ]
  })
}
