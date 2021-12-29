import shared


def lambda_handler(event, context):
    item_id = event['pathParameters']['id']
    try:
        item = shared.table.get_item(Key={'ID': item_id})['Item']
    except:
        item = None
    if item:
        return shared.response(code=200, body=item)
    return shared.create_error(404, 'No such resource.')
