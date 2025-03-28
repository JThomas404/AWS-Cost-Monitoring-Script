# AWS Cost Monitoring Script

## Project Overview

This shell script automates the process of monitoring AWS resources to help identify potential areas of cost savings. The script provides a straightforward approach to reviewing resource utilisation, helping AWS users optimise their usage in a simple manner.

### Purpose
The primary goal of this script is to automate the retrieval of basic AWS resource data (like EC2 instances and EBS volumes) and provide a simple report that highlights resources that are underutilised or inactive. This helps teams stay within budget while managing their infrastructure effectively.

---

## Problem Statement

In many AWS environments, resources can go unused or underutilised, leading to unnecessary costs. For example, stopped EC2 instances or unattached EBS volumes continue to incur charges. This script aims to:

- Identify inactive or underused EC2 instances and volumes
- Provide a summary of these resources
- Suggest potential cost savings based on resource status

---

## Technical Approach

### Resource Coverage
The script will review the following AWS resources:
- EC2 Instances (running and stopped)
- Elastic Block Store (EBS) Volumes
- Snapshots (if applicable)

---

### Key Tasks
1. **Resource Discovery**: The script will query the AWS account using AWS CLI commands to fetch data about EC2 instances and EBS volumes.
2. **Simple Reporting**: It will generate an easy-to-read report showing which resources are underutilised or unused.
3. **Basic Cost Estimation**: It will provide a rough estimate of potential cost savings if certain unused resources are terminated.

---

## Technical Requirements

### Tools
- Bash Shell
- AWS Command Line Interface (CLI)

### Execution Modes
- **Simple Mode**: Fetches basic resource information and generates a summary report.
- **Detailed Mode**: Offers more detailed information about the resources and their status.

---

## Expected Outputs

1. A simple **text file** showing a summary of resources.
2. A **CSV file** with the details of unused or underutilised resources.
3. A basic **cost estimation** based on resource inactivity.

---

## Security Considerations
- Uses read-only AWS permissions to gather resource information.
- No resource changes or deletions are made automatically by the script.

---

## Getting Started

### Prerequisites
```bash
# Install the required tools
$ brew install awscli

# Configure AWS credentials
$ aws configure
```

---

### Running the Script
```bash
# Basic Analysis
$ ./aws_cost_monitor.sh --simple

# Detailed Analysis
$ ./aws_cost_monitor.sh --detailed
```

---

## Future Possibilities
- Adding more detailed cost estimations.
- Automating notifications for resources that should be terminated.

---

## Additional Info  

I designed this project from scratch with the assistance of AI (GPT-4-turbo & Claude 3.5 Haiku), which guided me through this project. As a beginner who was still fresh to Bash, I sought structured support to learn effectively while building a functional project following best practices. The AI followed a heuristic approach when guiding, providing me with incremental steps and explanations rather than simply telling me the answer or doing the work for me. This method allowed me to actively learn and expedite my skills significantly.  

You can find the prompt I used and copy it to use yourself here: [AI Prompt](AI_Prompt.md)  

---