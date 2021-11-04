terraform {
  backend "s3" {
    bucket         = "multi-tier-state-backend"
    key            = "multi-tier"
    region         = "eu-north-1"
    dynamodb_table = "multi-tier_state_lock"
  }
}