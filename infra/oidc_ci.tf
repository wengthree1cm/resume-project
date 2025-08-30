# -----------------------------
# GitHub Actions OIDC role for deploying to S3 + CloudFront
# -----------------------------

# GitHub OIDC Provider（全局一次；已有可复用）
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# 仓库路径（按你的实际仓库改）
locals {
  gh_repo = "wengthree1cm/resume-project"
}

# 允许该仓库 main 分支通过 OIDC 假设角色
data "aws_iam_policy_document" "gh_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${local.gh_repo}:ref:refs/heads/main"]
    }
  }
}

resource "aws_iam_role" "gh_pages_deploy" {
  name               = "gh-pages-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.gh_assume.json
  lifecycle { prevent_destroy = true } # 防误删
}

# 最小权限：同步到 S3 + 失效 CloudFront
data "aws_iam_policy_document" "gh_policy" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.site.arn]
  }
  statement {
    actions   = ["s3:PutObject", "s3:DeleteObject", "s3:PutObjectAcl"]
    resources = ["${aws_s3_bucket.site.arn}/*"]
  }
  statement {
    actions   = ["cloudfront:CreateInvalidation", "cloudfront:GetDistribution", "cloudfront:GetDistributionConfig"]
    resources = [aws_cloudfront_distribution.site.arn]
  }
}

resource "aws_iam_policy" "gh_policy" {
  name   = "gh-pages-deploy-policy"
  policy = data.aws_iam_policy_document.gh_policy.json
}

resource "aws_iam_role_policy_attachment" "gh_attach" {
  role       = aws_iam_role.gh_pages_deploy.name
  policy_arn = aws_iam_policy.gh_policy.arn
}

# 只保留这一项输出
output "gh_deploy_role_arn" {
  value = aws_iam_role.gh_pages_deploy.arn
}
