import json
import traceback
import boto3
from boto3.dynamodb.conditions import Attr


TABLE_NAME = 'Quotes'
DAILY_RESOURCE_NAME = 'daily'
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(TABLE_NAME)


def response(code=200, headers=None, body='', encode=False):
    if not headers:
        headers = {'Content-Type': 'application/json'}
        # 'Access-Control-Allow-Origin': '*'
    if isinstance(body, dict):
        body = json.dumps(body)
    return {
        'statusCode': code,
        'headers': headers,
        'body': body,
        "isBase64Encoded": encode
    }


def create_error(code=400, message='Something went wrong.'):
    return response(code, body={'code': code, "message": message})


def get_all():
    items = table.scan()['Items']
    return response(code=200, body=str(items))


def get_one_item(item_id):
    try:
        item = table.get_item(Key={'ID': item_id})['Item']
    except:
        item = None
    if item:
        return response(code=200, body=item)
    return create_error(404, 'No such resource.')


def check_item_exists(item_id):
    db_response = table.get_item(Key={'ID': item_id})
    return ('Item' in db_response.keys())


def create_item(item):
    item_json = json.loads(item)
    if check_item_exists(item_json['ID']):
        return create_error(303, 'Resource already exists.')
    table.put_item(Item=item_json)
    return response(code=201, body={'message': 'Resource created successfully.'})


def update_item(item_id, item, called_by_daily=False):
    if ((item_id == DAILY_RESOURCE_NAME) and (not called_by_daily)):
        return create_error(409, 'Resource is reserved.')
    if isinstance(item, dict):
        item_json = item
    else:
        item_json = json.loads(item)
    item_json['ID'] = item_id
    table.put_item(Item=item_json)
    return response(code=201, body={'message': 'Resource updated successfully.'})


def delete_item(item_id):
    try:
        table.delete_item(Key={'ID': item_id})
    except:
        return create_error(400, 'Bad request.')
    return response(code=200, body={'message': 'Resource deleted successfully.'})
