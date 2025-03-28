# Project Documentation: The Step-by-Step Process, Issues Encountered, and Solutions

## Overview
This documentation outlines the process of creating a cross-platform shell script to query AWS Cost Explorer. The script calculates date ranges for the previous month and uses these dates to retrieve AWS cost data. It supports both macOS and Linux/Windows environments, allowing it to run seamlessly across different platforms.

---

## Step-by-Step Process

### 1. **Identifying the Requirements**
The primary goal was to create a shell script that works across macOS, Linux, and Windows systems. This script calculates the start and end dates of the previous month and retrieves AWS cost data using AWS Cost Explorer. 

Key functionalities:
- **Cross-platform compatibility**: The script should work on both macOS and Linux/Windows systems.
- **AWS Cost Query**: The script must query AWS for cost data based on dynamic date ranges.
- **Automation**: Ideally, the script should be automatable for regular, scheduled use.

---

### 2. **Handling Date Calculation for Cross-Platform Compatibility**

The first challenge was ensuring the date calculations worked across macOS and Linux/Windows, as the `date` command behaves differently on these platforms:

- **macOS** uses `-v` to manipulate dates (e.g., getting the first day of the previous month).
- **Linux/Windows** (via WSL or Git Bash) uses `-d` for similar date manipulations.

To address this, I added conditional checks in the script based on the `OSTYPE` variable to ensure the correct date format for each platform.

#### Code for Date Calculation:
```bash
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
```

- **Solution**: The script checks the operating system and applies the correct syntax for date manipulation, ensuring that it works seamlessly on macOS, Linux, and Windows systems.

---

### 3. **AWS Cost Query with Dynamic Date Ranges**

Once the dates were calculated, I used these date ranges to query AWS Cost Explorer via the AWS CLI. The script uses the calculated start and end dates to pull monthly usage and cost data.

#### Code for AWS Cost Query:
```bash
aws ce get-cost-and-usage --time-period Start=$Start,End=$End --granularity MONTHLY --metrics "BlendedCost" --group-by Type=DIMENSION,Key=SERVICE
```

- This command queries AWS Cost Explorer for the **BlendedCost** metric, grouped by **SERVICE**, using the dynamically calculated start and end dates.

---

### 4. **Handling Command-Line Options**

To add flexibility to the script, I implemented command-line options using `getopts`. The script supports two modes:
- **Simple mode (`-s`)**: Retrieves and sums up the AWS cost data.
- **Detailed mode (`-d`)**: Retrieves and displays the AWS cost data for each service.

#### Code for Command-Line Options:
```bash
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
```

- **Solution**: I implemented a simple argument parsing mechanism that allows the user to run the script in two different modes. This ensures flexibility and allows for easy retrieval of AWS cost data.

---

### 5. **Issues Encountered and Solutions**

#### **Issue 1: OS-specific `date` Command Syntax**
- **Problem**: The `date` command behaves differently on macOS and Linux/Windows.
- **Solution**: The script checks the OS type using the `OSTYPE` variable and uses the appropriate `date` syntax for each platform.

#### **Issue 2: Handling Different Shell Environments**
- **Problem**: The script had to work across different environments (macOS, Linux, and Windows via WSL/Git Bash).
- **Solution**: Conditional logic was used to ensure compatibility with different shells and date command syntax.

#### **Issue 3: AWS CLI Query**
- **Problem**: The query to AWS Cost Explorer needed to handle dynamic date ranges, which required careful handling of date formatting.
- **Solution**: The dynamic date calculation and formatting ensured accurate results when querying AWS.

---

### 6. **Automation of the Script**

While the script does not include built-in scheduling functionality, I used **external scheduling tools** to automate the execution of the script at regular intervals.

#### Automating on Linux (with `cron`):
```bash
0 0 1 * * /path/to/aws-cost-query-script.sh -s
```
This schedules the script to run at midnight on the first day of every month using **cron**.

#### Automating on macOS (with `launchd`):
The automation process on macOS involves creating a `plist` file to define the schedule and loading it into `launchd` for execution.

---

### Conclusion

This script successfully handles date calculations across platforms, queries AWS Cost Explorer, and can be automated using **cron** or **launchd** for periodic execution. The challenges faced were mainly related to platform compatibility, but these were overcome by using conditional logic to account for different environments. The script is now robust, cross-platform, and easily automatable for recurring AWS cost tracking.

---