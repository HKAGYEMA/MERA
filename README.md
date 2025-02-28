# MERA

To deploy the solution, several steps/ prerequisites are necessary. These prerequisites ensure that the environment is set up properly, the necessary AWS resources are available, and you have the tools to deploy and manage the infrastructure.


Below is a list of the key steps taken to deploy this serverless solution:

### 1. **AWS Account**
   - You will need an active AWS account. If you don’t already have one, you can sign up at [https://aws.amazon.com].
   - Ensure that you have the necessary IAM permissions to create resources like S3, Lambda, DynamoDB, API Gateway, and IAM roles.
  
### 2. IAM Permissions
   - The user or role you use to deploy the resources should have the following permissions:
     - `s3:CreateBucket`, `s3:PutObject`, `s3:GetObject`, `s3:PutBucketPolicy` (to create and configure the S3 bucket).
     - `dynamodb:CreateTable`, `dynamodb:PutItem`, `dynamodb:GetItem` (to create and interact with the DynamoDB table).
     - `lambda:CreateFunction`, `lambda:UpdateFunctionCode`, `lambda:InvokeFunction`, `iam:PassRole` (to deploy the Lambda function and set the IAM role).
     - `apigateway:POST` (to create API Gateway endpoints).
  
   I use an admin IAM user perms due to time constraints / for challenge purposes
   
### 3. AWS CLI Setup
   - Install and configure the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html).
     - Run `aws configure` to set your AWS Access Key ID, Secret Access Key, default region (the region you want to deploy)(e.g.,  `eu-west-2`),
   
### 4. Terraform Setup for Infrastructure as Code
   - [Install Terraform](https://www.terraform.io/downloads) to automate the provisioning of AWS resources.
     - Use Terraform to provision and manage the infrastructure, including the S3 bucket, Lambda, DynamoDB, and API Gateway.
   - Run `terraform init` to initialize the configuration, and then use `terraform apply` to deploy the resources.
   - You will need a `main.tf` file (like the one you shared earlier) to define the resources.

### 5. Lambda Deployment Package
     - Lambda Function Code: I chose python because is the language I am familiar with. But aws Lambda supports many others like Node.js
     - Ensured that my Lambda function code is ready. If you have external dependencies (e.g., `boto3`), you might need to create a deployment package.
     - If there are no external dependencies, simply upload the `.py` file directly.
   
   - Create a Lambda Function Deployment Package (if needed):
     - The Lambda function relies on external libraries (like `boto3`), so you will need it!
     - I Could do this by creating a virtual environment, installing the required libraries (`pip install boto3`), and zipping them along with the function code.

### 6. Terraform State Management (Optional but Recommended) - I didnt do so as I am the only Engineer here !
   - If you're using Terraform, make sure to configure a remote backend (e.g., AWS S3 with DynamoDB locking) to manage Terraform's state file in a shared manner.
     - Example configuration for `backend` in Terraform:

       ```hcl
       terraform {
         backend "s3" {
           bucket = "your-terraform-state-bucket"
           key    = "path/to/terraform.tfstate"
           region = "eu-west-2"
           encrypt = true
           dynamodb_table = "your-dynamodb-lock-table"
         }
       }
       ```

   - Note: If you're not using Terraform, manually manage resources through AWS Console or CLI.

### 7. API Gateway Setup
     - API Gateway was set up to route HTTP requests to your Lambda function.
     - I used Terraform iac`aws_api_gateway_rest_api` and `aws_api_gateway_method` resources to define my API.

### 8. S3 Bucket Configuration
   - Ensured my S3 bucket is set up to serve static content (HTML). This is achieved by setting the correct bucket policy and enabling static website hosting in S3.
   - Configure S3 to serve the HTML file (`index.html`), which dynamically displays the string from DynamoDB.

### 9. **DynamoDB Table**
   - You will need a **DynamoDB table** to store the dynamic string.
     - Table Name: `dynamic_string_table`
     - Primary Key: `id` (String)
     - Example item in the table: `{ "id": "1", "value": "initial value" }`

### 10. Git Setup (For Version Control)
   - If using Git to version control the project:
     - Initialize a Git repository (`git init`), and create a `.gitignore` file that excludes `*.tfstate`, `*.tfstate.backup`, and `*.zip` files.
     - Push your Terraform configuration and Lambda code to a Git repository for source code management.

     Example `.gitignore`:
     ```
     .terraform/
     terraform.tfstate
     terraform.tfstate.backup
     *.zip
     ```



### 11.Security Considerations**
   - IAM Roles and Policies**: Ensure that the Lambda function has the appropriate IAM role to access S3, DynamoDB, and other AWS services.
   - S3 Bucket Policy**: Ensure that the S3 bucket is publicly accessible for the HTML file but secure the access to the backend API with proper authorization methods (e.g., API keys or Cognito).

---

### Final Checklist:
- [ ] AWS account with necessary IAM permissions.
- [ ] AWS CLI configured and working.
- [ ] Terraform configured for infrastructure provisioning (optional but recommended).
- [ ] Lambda function code and deployment package ready.
- [ ] API Gateway configured to trigger Lambda.
- [ ] DynamoDB table created to store the dynamic string.
- [ ] S3 bucket configured for static website hosting.
- [ ] Git repository initialized with `.gitignore` to exclude Terraform state and large files.
- [ ] CloudFront and Route 53 (optional) for improved performance and domain management.

---

FUTURE CONSIDERATIONS 
### r53 and CloudFront (Optional for Better Performance)**
   - CloudFront: If you plan to use a custom domain or improve performance by caching the HTML, you can configure CloudFront with your S3 bucket as the origin.
   - Route 53: If you want to use a custom domain (e.g., `www.dynamicstring.com`), set up Route 53 to manage the domain and point it to your CloudFront distribution.


References
•	AWS Lambda
•	Amazon S3
•	DynamoDB
•	API Gateway
•	Terraform
