import boto3
from operator import itemgetter
import schedule
ec2_client = boto3.client('ec2', region='us-east-1') 
#list of all snapshots
snapshots = ec2_client.describe_snapshots(
    OwnerIds=['self']
)

print(snapshots['Snapshots'])
#check what time the snapshots was created and sort them by the creation date descending min kbir lil sghir 
sorted_by_date=sorted(snapshots['Snapshots'], key=itemgetter("StartTime"), reverse=True)
# print the start time of the snapshots
for snap in snapshots['Snapshots']:
    print(snap['StartTime'])


print('################################################################')
# print the start time of the snapshots sorted by time
for snap in sorted_by_date:
    print(snap['StartTime'])

#delet snapshot start from the 2 item in the list
for snap in sorted_by_date[2:]:
    # delete snapshot
    res = ec2_client.delete_snapshot(
        SnapshotId=snap['SnapshotId']
    )
    print(res)

def cleanup_snapshot():
    #list of specifics snapshots
    volumes = ec2_client.describe_snapshots(
    Filters=[
        {
            "Name": "tag:Name",
            "Values": ["prod"]
        }
    ]
    )
    for volume in volumes['volumes']:
        #list of all snapshots
        snapshots = ec2_client.describe_snapshots(
            OwnerIds=['self'],
            Filters=[
                {
                    "Name": "volume-id",
                    "Values": [volume["VolumeId"]]
                }
            ]

        )
        
        #check what time the snapshots was created and sort them by the creation date descending min kbir lil sghir 
        sorted_by_date=sorted(snapshots['Snapshots'], key=itemgetter("StartTime"), reverse=True)
        for snap in sorted_by_date[2:]:
        # delete snapshot
            res = ec2_client.delete_snapshot(
                SnapshotId=snap['SnapshotId']
            )
            print(res)
