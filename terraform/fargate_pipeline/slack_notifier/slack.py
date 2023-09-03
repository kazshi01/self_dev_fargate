import json
import urllib.request
import boto3

def lambda_handler(event, context):
    client = boto3.client('codepipeline')

    # CodePipeline からの event の場合
    if 'CodePipeline.job' in event:
        job_id = event['CodePipeline.job']['id']
        approval_token = event['CodePipeline.job']['data']['actionConfiguration']['configuration'].get('UserParameters', 'Default_Value')
        
        # Slack に承認が必要な旨を通知
        slack_url = "https://hooks.slack.com/services/XXXX/XXXX/XXXX"
        message = {
            "text": "承認が必要です",
            "attachments": [
                {
                    "text": "承認しますか？",
                    "callback_id": job_id,  # CodePipeline の job ID を callback_id として保存
                    "actions": [
                        {
                            "name": "approve",
                            "text": "承認",
                            "type": "button",
                            "value": approval_token  # 承認用トークンを value として保存
                        },
                        {
                            "name": "reject",
                            "text": "却下",
                            "type": "button",
                            "value": approval_token  # 承認用トークンを value として保存
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
        
        try:
            response = urllib.request.urlopen(request)
            print("Response:", response.read().decode('utf-8'))
        except Exception as e:
            print("Error occurred:", e)
        
    # Slack からの event の場合
    elif 'body' in event:
        slack_event = json.loads(event['body'])
        action = slack_event['actions'][0]['name']
        approval_token = slack_event['actions'][0]['value']
        job_id = slack_event['callback_id']

        if action == 'approve':
            client.put_approval_result(
                pipelineName='fargate-pipeline',
                stageName='InvokeLambdaBeforeApproval',
                actionName='Approval',
                result={
                    'summary': 'Approved from Slack',
                    'status': 'Approved'
                },
                token=approval_token
            )
        elif action == 'reject':
            client.put_approval_result(
                pipelineName='fargate-pipeline',
                stageName='InvokeLambdaBeforeApproval',
                actionName='Approval',
                result={
                    'summary': 'Rejected from Slack',
                    'status': 'Rejected'
                },
                token=approval_token
            )

        return {
            'statusCode': 200,
            'body': 'Done'
        }

    return {
        'statusCode': 200,
        'body': 'Done'
    }
