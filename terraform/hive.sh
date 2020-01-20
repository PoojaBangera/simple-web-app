#!/bin/bash
# Setup cloud watch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb

sudo dpkg -i amazon-cloudwatch-agent.deb
mkdir -p /usr/share/collectd/
touch /usr/share/collectd/types.db
cat << EOF > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "agent": {
    "metrics_collection_interval": 300,
    "logfile": "/var/log/amazon-cloudwatch-agent.log",
    "debug": false
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/cloud-init.log",
            "log_group_name": "hive-app-access-logs",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/var/log/cloud-init-output.log",
            "log_group_name": "hive-app-error-logs",
            "log_stream_name": "{instance_id}"
          },
          {
            "file_path": "/var/log/messages.log",                                                                                                                                                                              "log_group_name": "hive-app-error-logs",                                                                                                                                                                           "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  },
  "metrics": {
    "append_dimensions": {
      # shellcheck disable=SC2154
      "AutoScalingGroupName": "${auto_scaling_group_name}",
      "InstanceId": "{instance_id}"
    },
    "aggregation_dimensions": [["AutoScalingGroupName"]],
    "metrics_collected": {
      "collectd": {
        "metrics_aggregation_interval": 300
      },
      "statsd": {
        "metrics_aggregation_interval": 300,
        "metrics_collection_interval": 300,
        "service_address": ":8125"
      },
      "cpu": {
        "measurement": [
          "cpu_usage_idle",
          "cpu_usage_iowait",
          "cpu_usage_user",
          "cpu_usage_system"
        ],
        "totalcpu": true
      },
      "disk": {
        "measurement": [
          "used_percent",
          "inodes_free"
        ],
        "resources": [
          "*"
        ]
      },
      "diskio": {
        "measurement": [
          "io_time",
          "write_bytes",
          "read_bytes",
          "writes",
          "reads"
        ],
        "resources": [
          "*"
        ]
      },
      "mem": {
        "measurement": [
          "mem_used_percent"
        ]
      },
      "netstat": {
        "measurement": [
          "tcp_established",
          "tcp_time_wait"
        ]
      },
      "swap": {
        "measurement": [
          "swap_used_percent"
        ]
      }
    }
  }
}

sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s

sudo systemctl restart amazon-cloudwatch-agent

#sudo systemctl stop amazon-cloudwatch-agent
EOF
#install docker engine
sudo apt-get update

sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

curl -fsSL https://yum.dockerproject.org/gpg | sudo apt-key add -
sudo add-apt-repository \
    "deb https://apt.dockerproject.org/repo/ \
    ubuntu-$(lsb_release -cs) \
    main"
sudo apt-get update
sudo apt-get -y install docker-engine
# add current user to docker group so there is no need to use sudo when running docker
sudo usermod -aG docker $(whoami)

mkdir app
cd app
git init
git clone https://github.com/hivehr/devops-assessment.git
cd devops-assessment
docker build --tag devops:latest .
docker run -d -p 3000:3000 devops:latest
