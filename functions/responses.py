import json


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
