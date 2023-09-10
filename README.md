# self_dev

3 層構造＋ cloudfront ＋ Fargate まで完成（62 リソース）。
※terraform.tfvars の northeast_domain、alb_domain、top_domain を変更する際は、environment-layer の方も、同じ値に変更する必要がある.

# ECR image

image_tag = "変更"
※ECR repository の jenkins/practice に存在する image_tag を記載する
