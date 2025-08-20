import shared


def lambda_handler(event, context):
    item_id = event['pathParameters']['id']
    if item_id == shared.DAILY_RESOURCE_NAME:
        return shared.create_error(403, 'Cannot delete daily quote.')
    try:
        shared.table.delete_item(Key={'ID': item_id})
    except:
        return shared.create_error(400, 'Bad request.')
    return shared.response(code=200, body={'message': 'Resource deleted successfully.'})
