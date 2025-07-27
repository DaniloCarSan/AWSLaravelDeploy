#!/bin/bash
PARAMETER_NAME="$1"
PARAMETER_VALUE=$(aws ssm get-parameter --name "$PARAMETER_NAME" --query "Parameter.Value" --output text 2>/dev/null)
echo "$PARAMETER_VALUE"