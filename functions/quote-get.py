import responses


def lambda_handler(event, context):
    return responses.get_one_item(event['pathParameters']['id'])
