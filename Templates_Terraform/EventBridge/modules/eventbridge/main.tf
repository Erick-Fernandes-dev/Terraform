resource "aws_cloudwatch_event_rule" "this" {
  name                = var.rule_name
  schedule_expression = var.schedule
  is_enabled          = true

}