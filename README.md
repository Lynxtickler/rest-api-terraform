# REST API Gateway on AWS
SOA and Cloud Computing -course Demo6 created with Terraform.

## Description
REST API for viewing, adding, modifying and deleting quotes.
Data is handled and returned in JSON format.
A special daily quote resource is implemented and updated from BrainyQuote.
DELETE requests to daily quote resource are discarded in the Lambda function.

Deployment and infrastructure are completely handled by Terraform.
When run, it builds all the required resources and uploads the Python code to AWS.

## Resources
- API Gateway (REST)
- Main path resource "quotes"
    - GET, POST
- Path sub-resource "quotes/{id}"
    - GET, PUT, DELETE
    - Reserved "quotes/daily" for a daily quote that is updated by cron at 06.00 daily
    - Prevented DELETE on "quotes/daily"
- Lambdas
- IAM Roles for Lambdas
- DynamoDB for storing quotes
- CloudWatch event rule (cron job)
- Integrations and bridging between everything above
