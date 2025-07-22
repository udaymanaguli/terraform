import boto3

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')  # Create EC2 client

    # Get all running EC2 instances
    instances = ec2.describe_instances(
        Filters=[{'Name': 'instance-state-name', 'Values': ['running']}]
    )

    stop_ids = []  # List to store instances to be stopped

    # Loop through all instances
    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            instance_id = instance['InstanceId']
            
            # Convert tags to dictionary for easy lookup
            tags = {t['Key']: t['Value'] for t in instance.get('Tags', [])}

            # If 'Owner' tag is missing, add to stop list
            if 'Owner' not in tags:
                stop_ids.append(instance_id)

    # Stop all untagged instances
    if stop_ids:
        print(f"Stopping untagged instances: {stop_ids}")
        ec2.stop_instances(InstanceIds=stop_ids)
    else:
        print("No untagged instances found.")
