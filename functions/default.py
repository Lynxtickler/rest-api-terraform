import shared

def lambda_handler(event, context):
    return shared.create_error(404, 'Bad request.')
