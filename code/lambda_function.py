# Shut off machines that are not tagged with "KeepRunning : true"

import boto3
import os
from botocore.config import Config

# Case-sensitive ag to check again for `true`. Default: KeepRunning
RUNNING_TAG = os.environ.get('RUNNING_TAG', 'KeepRunning') 

# Optional comma-separated list of regions to skip. Default: None
SKIP_REGIONS = os.environ.get('SKIP_REGIONS', None)

# Flag to DryRun shutdown. Used for testing. Default: 'false'
TEST = os.environ.get('TEST', 'false').lower()

if SKIP_REGIONS is None:
    SKIP_REGIONS = []
else:
    SKIP_REGIONS = SKIP_REGIONS.split(",")


def _get_regions():
    """
    Gets a list of available AWS regions.
    :return: Array of AWS regions
    """
    return [region['RegionName'] for region in boto3.client('ec2').describe_regions()['Regions']]


def _get_untagged_instances(region):
    """
    Find instances in a given AWS region not tagged for Always Running and returns the InstanceIds.
    :param region: AWS Region
    :return: Array of InstanceIds
    """
    not_tagged = []

    filters = [
        {
            'Name': 'instance-state-name',
            'Values': ['running']
        }
    ]

    config = Config(region_name=region)
    client = boto3.client("ec2", config=config)
    response = client.describe_instances(Filters=filters)

    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            if len(instance['Tags']) > 0:
                if not [tag for tag in instance['Tags'] if
                        tag['Key'] == 'KeepRunning' and (tag['Value'] == 'True' or tag['Value'] == 'true')]:
                    not_tagged.append(instance['InstanceId'])
                    print('  - %s' % instance['InstanceId'])
            else:
                not_tagged.append(instance['InstanceId'])
                print('  - %s' % instance['InstanceId'])

    return not_tagged


def _shutdown_instances(instances, region):
    """
    Shutdown a set of instances based on InstanceIds in a given region.
    :param instances: Array of InstanceIds
    :param region: AWS Region
    :return: N/A
    """
    config = Config(region_name=region)
    client = boto3.client("ec2", config=config)

    if len(instances) > 0:
        client.stop_instances(InstanceIds=instances, DryRun=True if TEST == 'true' else False)
    else:
        print('  - No untagged instances found.')


def lambda_handler(event, context):
    """
    Handler for Lambda execution
    :param event: Event of Lambda request (not used)
    :param context: Context of Lambda request (not used)
    :return: N/A
    """
    for region in _get_regions():
        print('Region: %s' % region)
        if region in SKIP_REGIONS:
            print("  - Region '%s' marked for skip. Excluding." % region)
        else:
            _shutdown_instances(_get_untagged_instances(region), region)