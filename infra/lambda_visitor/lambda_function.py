import os, json, boto3
from decimal import Decimal

dynamodb   = boto3.client("dynamodb")
TABLE_NAME = os.environ["TABLE_NAME"]
PK_NAME    = os.environ["PK_NAME"]
ITEM_ID    = os.environ["ITEM_ID"]
VIEW_ATTR  = os.environ["VIEW_ATTR"]

def resp(status, body):
    return {
        "statusCode": status,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET,OPTIONS",
            "Access-Control-Allow-Headers": "*"
        },
        "body": json.dumps(body)
    }

def lambda_handler(event, context):
    try:
        r = dynamodb.update_item(
            TableName=TABLE_NAME,
            Key={ PK_NAME: { "S": ITEM_ID } },
            UpdateExpression="SET #v = if_not_exists(#v, :zero) + :inc",
            ExpressionAttributeNames={ "#v": VIEW_ATTR },
            ExpressionAttributeValues={ ":zero": { "N": "0" }, ":inc": { "N": "1" } },
            ReturnValues="UPDATED_NEW"
        )
        count = int(Decimal(r["Attributes"][VIEW_ATTR]["N"]))
        return resp(200, {"count": count})
    except Exception as e:
        return resp(500, {"error": str(e)})
