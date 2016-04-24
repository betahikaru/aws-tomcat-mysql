#!/bin/sh

function ec2_count_by_id_and_status() {
  instance_id=$1
  filter_status=$2
  aws ec2 describe-instances \
    --filters \
      "Name=instance-id,Values=${instance_id}" \
      "Name=instance-state-name,Values=${filter_status}" \
    | jq -c ".Reservations | length"
}

instance_id=i-35fd55aa
filter_status=running
count=`ec2_count_by_id_and_status instance_id filter_status`

if [ ${count} -eq 0 ]; then
  echo "Instance(${instance_id}) is running"
else
  echo "Instance(${instance_id}) is stopped"
fi
