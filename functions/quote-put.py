import responses


def lambda_handler(event, context):
    return responses.update_item(event['pathParameters']['id'], event['body'])
