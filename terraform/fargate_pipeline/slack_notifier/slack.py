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
        slack_url = "https://hooks.slack.com/services/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"
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
        
        # CodePipelineのジョブを成功状態にする
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
