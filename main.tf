terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.0"
        }
    }
}

provider "aws" {
    profile = "default"
    region = "us-east-1"
}

variable "username" {
  type = string
}

variable "policyname" {
  type = string
}

variable "runtimefile" {
}

locals {
  content = file("${path.module}/${var.runtimefile}")
}

data "aws_iam_policy_document" "ec2poweruser" {
 statement {
    actions = ["ec2:*"]
    effect = "Allow"
    resources = ["*"]
  }
}

output "policydataoutput" {
  value = local.content
}

output "userpolicydataoutputid" {
  value = aws_iam_user_policy.lb_ro.id
}

output "userpolicydataoutputname" {
  value = aws_iam_user_policy.lb_ro.name
}

resource "aws_iam_user" "lb" {
  name = var.username
  path = "/system/"
}

resource "aws_iam_user_policy" "lb_ro" {
  name = var.policyname
  user = aws_iam_user.lb.name
  policy = local.content
}