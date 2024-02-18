import boto3
from operator import itemgetter

try:
    ec2_client = boto3.client('ec2', region_name='us-east-1')
    ec2_ressource= boto3.resource('ec2', region_name='us-east-1')

    instance_id = "i-0c9a0b5d1fcca586c"
    #volume attach to that ec2 instance with id
    volumes = ec2_client.describe_volumes(
        Filters = {
            'Name': 'attachement.instance-id',
            'Value': [instance_id]
        }
    )
    instance_volume = volumes['Volumes'][0]
    print(instance_volume)
    #recover all snapshots of our instance
    ec2_client.describe_snapshot(
        OwnerIds=['self'],
        Filters = [
            { 
                'Name': 'volume-id',
                'Values': [instance_volume['VolumeId']]
                }
        ]
    )
    # find the latest snapshot for this volume
    latest_snapshot =sorted(snapshots['Snapshots'], key=itemgetter("StartTime"), reverse=True)[0]
    print(latest_snapshot['startTime'])
    # create volume from this latest snapshot
    new_volume=ec2_client.create_volume(
        SnapshotId=latest_snapshot['SnapshotId'],
        AvaibilityZone = 'us-east-1a',
        #add tag
        TagSpecifications=[
            {
                'RessourceType': 'volume',
                'Tags' : [
                    {
                        'key': 'Name',
                        'value': 'prod'
                    }
                ]
                
            }
        ]
    )
    #check the state of volume until to be a vailable
    while True:
        vol=ec2_ressource.Volume(new_volume['VolumeId'])
        print(vol.state)
        if vol.state == 'available':
            #attach volume it must be available to ec2
            ec2_ressource.Instance(instance_id).attach_volume(
                VolumeId=new_volume['VolumeId'],
                Device=''
            )
            #break the loop 
            break

   
except Exception as ex:
    print(ex)