import shared


def lambda_handler(event, context):
    return shared.update_item(event['pathParameters']['id'], event['body'])
