import json
import traceback
import boto3
from boto3.dynamodb.conditions import Attr


TABLE_NAME = 'Quotes'
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(TABLE_NAME)


def response(code=200, headers=None, body='', encode=False):
    if not headers:
        headers = {'Content-Type': 'application/json'}
        # 'Access-Control-Allow-Origin': '*'
    return {
        'statusCode': code,
        'headers': headers,
        'body': json.dumps(body),
        "isBase64Encoded": encode
    }


def check_item_exists(item_id):
    db_response = table.get_item(Key={'ID': item_id})
    return ('Item' in db_response.keys())



def create_error(code=400, message='Something went wrong.'):
    return response(code, body={'code': code, "message": message})


def get_all():
    scan_result = table.scan()
    try:
        items = [] if ('Items' in scan_result) else scan_result['Items']
    except:
        return create_error()
    return response(code=200, body=items)


def create_item(item):
    item_json = json.loads(item)
    if check_item_exists(item_json['ID']):
        return create_error(303, 'Resource already exists.')
    table.put_item(Item=item_json)
    return response(code=201, body={'message': 'Resource created successfully.'})


def update_item(item_id, item, called_by_daily=False):
    item_id = int(item_id)
    if ((item_id == 0) and (not called_by_daily)):
        return create_error(409, 'Resource is reserved.')
    item_json = json.loads(item)
    item_json['ID'] = item_id
    table.put_item(Item=item_json)

    return response(code=201, body={'message': 'Resource updated successfully.'})


def delete_item(item_id):
    item_id = int(item_id)
    try:
        table.delete_item(Key={'ID': item_id})
    except:
        return create_error(400, 'Bad request.')
    return response(code=200, body={'message': 'Resource deleted successfully.'})
