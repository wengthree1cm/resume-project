import os, json, re, boto3

ses = boto3.client("ses")
TO_EMAIL   = os.environ["CONTACT_TO"]
FROM_EMAIL = os.environ["CONTACT_FROM"]

def resp(status, body):
    return {
        "statusCode": status,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "POST,OPTIONS",
            "Access-Control-Allow-Headers": "*",
        },
        "body": json.dumps(body)
    }

def lambda_handler(event, context):
    # 处理 CORS 预检
    if event.get("requestContext", {}).get("http", {}).get("method") == "OPTIONS":
        return resp(200, {"ok": True})

    try:
        body = json.loads(event.get("body") or "{}")
        name    = (body.get("name") or "").strip()
        email   = (body.get("email") or "").strip()
        subject = (body.get("subject") or "").strip()
        message = (body.get("message") or "").strip()
        honeyp  = (body.get("company") or "").strip()

        # 反爬：蜜罐被填就拒绝
        if honeyp:
            return resp(400, {"error": "Bad request"})

        if not name or not subject or not message:
            return resp(400, {"error": "Missing fields"})
        if not re.match(r"[^@]+@[^@]+\.[^@]+", email):
            return resp(400, {"error": "Invalid email"})

        body_text = f"""New message from your portfolio contact form

Name: {name}
Email: {email}
Subject: {subject}

Message:
{message}
"""
        ses.send_email(
            Source=FROM_EMAIL,
            Destination={"ToAddresses": [TO_EMAIL]},
            Message={
                "Subject": {"Data": f"[Portfolio] {subject}"},
                "Body": {"Text": {"Data": body_text}}
            },
            ReplyToAddresses=[email]
        )
        return resp(200, {"ok": True})
    except Exception as e:
        return resp(500, {"error": str(e)})
