# self_dev

3層構造＋cloudfront＋Fargateまで完成（６２リソース）。
※```terraform.tfvars```のnortheast_domain、alb_domain、top_domainを変更する際は、environment-layerの方も、同じ値に変更する必要がある

```terraform.tfvars```は、```Jenkins```　or ```github/actions``` or ```codepipeline```ブランチにサンプルがあるのでそちらを使用
