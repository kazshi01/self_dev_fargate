import json
import urllib.request

def lambda_handler(event, context):
    slack_url = "https://hooks.slack.com/services/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"

    message = {
        "text": "承認が必要です",
        "attachments": [
            {
                "text": "承認しますか？",
                "fallback": "承認するかどうかを選んでください",
                "callback_id": "approval",
                "color": "#3AA3E3",
                "attachment_type": "default",
                "actions": [
                    {
                        "name": "approve",
                        "text": "承認",
                        "type": "button",
                        "value": "approve"
                    },
                    {
                        "name": "reject",
                        "text": "却下",
                        "type": "button",
                        "value": "reject"
                    }
                ]
            }
        ]
    }

    request = urllib.request.Request(
        slack_url, 
        data=json.dumps(message).encode('utf-8'), 
        headers={'Content-Type': 'application/json'}
    )
    urllib.request.urlopen(request)
