# modules/lambda/main.tf

// Esse resource cria uma função Lambda com o nome especificado na variável "function_name". 
//Ele também define a política de execução para a função, permitindo que ela seja assumida pelo serviço Lambda.
resource "aws_iam_role" "this" {
  name = "${var.function_name}_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "lambda.amazonaws.com" } }]
  })
}

// Esse resource anexa a política de execução básica do Lambda a função Lambda criada,
// permitindo que ela tenha as permissões necessárias para ser executada e registrar logs.
resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}




// Esse resource cria a função lambda usando o arquivo zip gerado pelo data source "archive_file.zip".
// Ele especifica o nome da função, o handler, o runtime e a role associada
data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.root}/functions/index.mjs"
  output_path = "${path.root}/functions/lambda.zip"
}

// Esse resource cria a função lambda usando o arquivo zip gerado pelo data source "archive_file.zip". Ele especifica o nome da função, o handler, o runtime e a role associada.
resource "aws_lambda_function" "this" {
  filename         = data.archive_file.zip.output_path
  function_name    = var.function_name
  role             = aws_iam_role.this.arn
  handler          = "index.handler"
  runtime          = "nodejs24.x"
  source_code_hash = data.archive_file.zip.output_base64sha256
}