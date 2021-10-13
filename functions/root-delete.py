import responses


def lambda_handler(event, context):
    return responses.delete_item(event['pathParameters']['id'])
