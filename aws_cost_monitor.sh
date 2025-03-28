#!/bin/bash

# Function to get the first day of the previous month and yesterday's date
get_dates() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS: Using -v option for date
    Start=$(date -v-1d +%Y-%m-01)  # First day of last month
    End=$(date -v-1d +%Y-%m-%d)    # Yesterday's date
  else
    # Linux/Windows (WSL, Git Bash, etc.): Using -d option for date
    Start=$(date -d "yesterday" +%Y-%m-01)  # First day of last month
    End=$(date -d "yesterday" +%Y-%m-%d)    # Yesterday's date
  fi
}

# Parse the command-line options
while getopts ":sd" opt; do
  case $opt in
    s)
      # Simple mode: Retrieve and sum up the AWS cost data
      echo "Running in simple mode..."
      get_dates  # Get the start and end dates
      aws ce get-cost-and-usage --time-period Start=$Start,End=$End --granularity MONTHLY --metrics "BlendedCost" --group-by Type=DIMENSION,Key=SERVICE | jq '.ResultsByTime[].Groups[] | select(.Keys[0] == "AWS Cost Explorer") | .Metrics.BlendedCost.Amount' | awk '{s+=$1} END {print s}'
      ;;

    d)
      # Detailed mode: Retrieve and show the AWS cost data for each service
      echo "Running in detailed mode..."
      get_dates  # Get the start and end dates
      aws ce get-cost-and-usage --time-period Start=$Start,End=$End --granularity MONTHLY --metrics "BlendedCost" --group-by Type=DIMENSION,Key=SERVICE | jq '.ResultsByTime[].Groups[] | select(.Keys[0] == "AWS Cost Explorer") | .Metrics.BlendedCost.Amount'
      ;;
    \?)
      # Handle invalid options
      echo "Invalid option: -$OPTARG" >&2
      echo "Usage: $0 [-s | -d]"
      exit 1
      ;;
  esac
done

# Check if no option was provided
if [ $OPTIND -eq 1 ]; then
  echo "No options were provided."
  echo "Usage: $0 [-s] [-d]"
  exit 1
fi