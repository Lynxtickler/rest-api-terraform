import responses

def lambda_handler(event, context):
    return responses.create_error(404, 'Bad request.')
