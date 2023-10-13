module "sqs" {
  source  = "terraform-aws-modules/sqs/aws"

  name = local.sqs_name
  dlq_name = local.sqs_name

  create_dlq = true
  redrive_policy = {
    # default is 5 for this module
    maxReceiveCount = 10
  }
}
