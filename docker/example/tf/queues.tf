//module "some_queue" {
//  source                    = "terraform.management.form3.tech/applications/form3_sqs_with_dead_letter/aws"
//  version                   = "1.2.3"
//  queue_name                = "some-queue"
//  stack_name                = "local"
//  dead_letter_alarm_actions = []
//  is_local                  = true
//  environment               = "local"
//}