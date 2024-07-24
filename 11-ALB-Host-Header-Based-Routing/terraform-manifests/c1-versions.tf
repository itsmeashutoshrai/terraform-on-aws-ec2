# Terraform Block
terraform {
  required_version = ">= 1.6" # which means any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.0"
    }        
  }
}

# Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default"
}
/*
Note-1:  AWS Credentials Profile (profile = "default") configured on your local desktop terminal  
$HOME/.aws/credentials
*/
/*
here what is null?
The use of the Null provider in Terraform, even when you have already defined other providers like AWS, serves specific purposes which might not be immediately clear if you're only thinking about managing infrastructure directly. Here are some scenarios where the Null provider is useful:

1. Provisioning Steps Without Infrastructure
Sometimes, you need to run certain scripts or commands that aren't tied to any specific resource in your infrastructure. For example, you might want to run a local script that sets up something on your local machine or triggers a CI/CD pipeline step.

hcl
Copy code
resource "null_resource" "example" {
  provisioner "local-exec" {
    command = "echo Hello, World"
  }
}
2. Creating Dependencies
You can use the Null provider to create dependencies between resources. For example, you might want to ensure that a certain script runs only after a specific AWS resource is created.

hcl
Copy code
resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}

resource "null_resource" "wait_for_instance" {
  depends_on = [aws_instance.example]

  provisioner "local-exec" {
    command = "echo AWS instance is created"
  }
}
3. Complex Workflows
In complex workflows, you might need to chain together multiple steps that aren't purely about resource creation but involve running scripts, waiting for certain conditions, or other orchestration tasks.

4. Generating Random Values or Data
You can use the Null provider in combination with other Terraform resources like the random provider to generate values that are used elsewhere in your configuration.

hcl
Copy code
resource "null_resource" "example" {
  triggers = {
    random_value = random_id.example.hex
  }
}

resource "random_id" "example" {
  byte_length = 8
}
Example in a Complete Context
Here’s a more concrete example incorporating both AWS and Null providers:

hcl
Copy code
terraform {
  required_version = ">= 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 3.0"
    }        
  }
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-123456"
  instance_type = "t2.micro"
}

resource "null_resource" "post_provision" {
  depends_on = [aws_instance.example]

  provisioner "local-exec" {
    command = "echo 'Instance provisioned!'"
  }
}
In this example, the Null provider is used to run a local script after the AWS instance has been created. The null_resource "post_provision" depends on the aws_instance.example resource, ensuring the script only runs after the instance is successfully created.

In summary, the Null provider is valuable for tasks that require execution steps, dependencies, or workflows not directly tied to creating or managing cloud infrastructure resources.
*/

