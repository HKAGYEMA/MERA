resource "aws_dynamodb_table" "dynamic_string_table" {
  name           = "DynamicStringTable"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }
}