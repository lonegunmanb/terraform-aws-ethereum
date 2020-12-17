[
    {
        "command": ${jsonencode(command)},
        "essential": true,
        "image": "${image}",
        "memoryReservation": 8096,
        "mountPoints": [
            {
                "containerPath": "/data",
                "sourceVolume": "gethvol"
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${log_group_name}",
                "awslogs-region": "${region}",
                "awslogs-stream-prefix": "eth2"
            }
        },
        "name": "${name}",
        "portMappings": [
            {
                "containerPort": ${http_api_port},
                "hostPort": ${http_api_port},
                "protocol": "tcp"
            },
            {
                "containerPort": ${ws_api_port},
                "hostPort": ${ws_api_port},
                "protocol": "tcp"
            },
            {
                "containerPort":${p2p_port},
                "hostPort": ${p2p_port},
                "protocol": "tcp"
            },
            {
                "containerPort": ${p2p_port},
                "hostPort": ${p2p_port},
                "protocol": "udp"
            }
        ]
    }
]
