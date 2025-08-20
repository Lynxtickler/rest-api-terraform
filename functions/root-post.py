import json
import shared


def lambda_handler(event, context):
    item_json = json.loads(event['body'])
    if shared.check_item_exists(item_json['ID']):
        return shared.create_error(409, 'Resource already exists.')
    shared.table.put_item(Item=item_json)
    return shared.response(code=201, body={'message': 'Resource created successfully.'})
