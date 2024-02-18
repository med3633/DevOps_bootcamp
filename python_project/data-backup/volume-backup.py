import boto3
import schedule
try:
    def create_volume():
        ec2_client = boto3.client('ec2' , region_name="us-east-1")
        volumes = ec2_client.describe_volumes(
            Filters=[
                {
                    'Name': 'tag:Name',
                    'Values' : ['prod']
                 }
            ]
        )
        print(volumes)
        for volume in volumes['volumes']:
            new_snapshot=ec2_client.create_snapshot(
                volumeId=volume['VolumeId']
                )
            print(new_snapshot)
     # implimentig schedule every day
    schedule.every().day.do(create_volume)
    while True:
        schedule.run_pending()
except Exception as ex:
    print(ex)