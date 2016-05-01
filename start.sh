#!/bin/sh
# refer http://muramasa64.fprog.org/diary/?date=20141111
instance_id=i-35fd55aa

aws ec2 start-instances --instance-ids ${instance_id}
aws ec2 wait instance-running --instance-ids ${instance_id}
aws ec2 wait instance-status-ok --instance-ids ${instance_id}
echo "display notification 'instance ${instance_id} running now' with title 'EC2 Notification'" \
  | osascript
