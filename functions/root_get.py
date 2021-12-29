import shared


def lambda_handler(event, context):
    items = shared.table.scan()['Items']
    return shared.response(code=200, body=str(items))
