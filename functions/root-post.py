import responses


def lambda_handler(event, context):
    return responses.create_item(event['body'])
