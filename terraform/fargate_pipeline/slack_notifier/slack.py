import json
import urllib.request
import boto3

def get_ssm_parameter(name):
    ssm = boto3.client('ssm')
    parameter = ssm.get_parameter(Name=name, WithDecryption=True)
    return parameter['Parameter']['Value']

def lambda_handler(event, context):
    client = boto3.client('codepipeline')
    
    # SSMからSlack Webhook URLを取得
    slack_url = get_ssm_parameter('PIPELINE_SLACK_WEBHOOK_URL')

    # CodePipeline からの event の場合
    if 'CodePipeline.job' in event:
        job_id = event['CodePipeline.job']['id']
        approval_token = event['CodePipeline.job']['data']['actionConfiguration']['configuration'].get('UserParameters', 'Default_Value')
        
        # Slack に承認が必要な旨を通知
        message = {
            "text": "ビルドフェーズが完了しました。手動承認が必要です。"
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
        
        try:
            client.put_job_success_result(jobId=job_id)
        except Exception as e:
            print("Failed to put job success result:", e)
            return {
                'statusCode': 500,
                'body': 'Failed to put job success result'
            }
        
        return {
            'statusCode': 200,
            'body': 'Successfully sent Slack message and set job to success'
        }
    
    # それ以外の場合
    else:
        return {
            'statusCode': 200,
            'body': 'Done'
        }
