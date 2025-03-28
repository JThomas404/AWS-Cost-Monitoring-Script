# **Commands Used When Creating This Script**

### **Summary of Commands Used**

This document outlines all the commands used in the AWS Cost Monitoring project, covering the setup of the environment, script preparation, querying AWS Cost Explorer, processing the output, and navigating the terminal. It also includes commands for file management and text processing.

#### **Key Areas Covered**:
- **Shell Setup**: `aws configure`, `curl`, `jq`, `awk`, `date`, `getopts`
- **AWS Cost Query**: `aws ce get-cost-and-usage`
- **JSON Processing**: `jq`
- **Text Processing**: `awk`, `sed`, `grep`
- **Platform Compatibility**: `date` (for macOS and Linux/Windows)
- **File Management**: `touch`, `chmod`, `nano`, `cat`
- **Terminal Navigation**: `cd`, `ls`, `pwd`

---

## **Commands Used for Shell Script and Associated Tasks**

### 1. **Setting Up Your Environment**

#### **1.1 `aws configure`**
- **Function**: Configures AWS CLI with the necessary credentials and region.
- **Project Context**: This command is used to set up AWS access keys, secret keys, and the default region for querying AWS Cost Explorer.
  
```bash
aws configure
```
- **Explanation**: You will be prompted to enter AWS Access Key ID, Secret Access Key, default region name, and default output format. This setup ensures that the AWS CLI is authenticated and ready to interact with AWS services.

#### **1.2 `curl`**
- **Function**: A tool for transferring data from or to a server, typically used for APIs.
- **Project Context**: This command could be used to test connectivity to AWS APIs or query services manually, especially for debugging or when integrating external APIs.
  
```bash
curl https://api.example.com/data
```
- **Explanation**: Useful for querying REST APIs or pulling data from remote servers. For example, it could help fetch metadata from other AWS services outside of Cost Explorer.

#### **1.3 File Management Commands**
- **`touch`**: Creates a new file.
  
```bash
touch script.sh
```
- **Explanation**: Used to create a new shell script file.

- **`chmod`**: Changes file permissions, making the script executable.
  
```bash
chmod +x script.sh
```
- **Explanation**: Ensures the shell script is executable by the user.

- **`nano`**: Opens a text editor to write or edit a file.
  
```bash
nano script.sh
```
- **Explanation**: Used to open the shell script and modify its content.

- **`cat`**: Outputs the content of a file to the terminal.
  
```bash
cat script.sh
```
- **Explanation**: This is useful for reviewing or displaying the content of a shell script or configuration files.

---

### 2. **Script Structure and Basic Functionality**

#### **2.1 `date` Command**
- **Function**: The `date` command is used for formatting and manipulating dates.
- **Project Context**: Utilised to calculate the first day of the previous month and yesterday’s date, which are then used to define the time period for the AWS Cost Explorer query.

```bash
Start=$(date -v-1d +%Y-%m-01)
End=$(date -v-1d +%Y-%m-%d)
```
- **Explanation**: This command is used on macOS to adjust the date and obtain the first day of the previous month and yesterday's date.

For Linux/Windows systems, the command would look like:

```bash
Start=$(date -d "yesterday" +%Y-%m-01)
End=$(date -d "yesterday" +%Y-%m-%d)
```
- **Why not Python?** I chose `date` because it’s simple, lightweight, and doesn’t require additional dependencies, making it easier to execute directly from the shell.

#### **2.2 `getopts` Command**
- **Function**: This command is used for parsing command-line options in a shell script.
- **Project Context**: Used in the script to manage user input, allowing the script to run in either simple or detailed mode.
  
```bash
while getopts ":sd" opt; do
  case $opt in
    s) # Simple mode
      ;;
    d) # Detailed mode
      ;;
    \?) # Invalid option
      ;;
  esac
done
```
- **Explanation**: This command ensures that the script accepts flags such as `-s` (simple mode) and `-d` (detailed mode), running the respective blocks of code.

---

### 3. **Fetching AWS Cost Data**

#### **3.1 `aws ce get-cost-and-usage`**
- **Function**: AWS CLI command to query AWS Cost Explorer for usage and cost data.
- **Project Context**: Used in the script to retrieve monthly cost and usage data for a specific time period (from the `Start` to `End` dates).

```bash
aws ce get-cost-and-usage --time-period Start=$Start,End=$End --granularity MONTHLY --metrics "BlendedCost" --group-by Type=DIMENSION,Key=SERVICE
```
- **Explanation**: This command fetches the cost and usage data for the time range specified, grouping by service to show costs per service.

#### **3.2 `jq` Command**
- **Function**: `jq` is a tool for parsing and processing JSON data.
- **Project Context**: Used to extract the necessary cost data from the JSON response returned by the AWS Cost Explorer API.

```bash
jq '.ResultsByTime[].Groups[] | select(.Keys[0] == "AWS Cost Explorer") | .Metrics.BlendedCost.Amount'
```
- **Explanation**: `jq` filters and extracts the `BlendedCost.Amount` from the JSON response, which contains the cost details.

#### **3.3 `awk` Command**
- **Function**: A text-processing tool that is used to manipulate and process data.
- **Project Context**: Used to sum up the cost data extracted by `jq`.

```bash
awk '{s+=$1} END {print s}'
```
- **Explanation**: Sums the numbers returned by `jq` and prints the total cost, which is necessary to calculate the total AWS usage cost.

---

### 4. **Navigating the Terminal**

#### **4.1 `cd` Command**
- **Function**: Changes the directory.
- **Project Context**: Used for navigating between directories to find files or scripts.

```bash
cd /path/to/directory
```
- **Explanation**: This command is used to change to the specified directory where the script is located or where other resources are stored.

#### **4.2 `ls` Command**
- **Function**: Lists the contents of a directory.
- **Project Context**: Used to view the contents of directories to confirm that files or scripts exist.

```bash
ls
```
- **Explanation**: It helps confirm the files present in the current directory, useful for confirming whether the shell script is in the right place.

#### **4.3 `pwd` Command**
- **Function**: Prints the current working directory.
- **Project Context**: Helps in confirming the current location in the directory structure.

```bash
pwd
```
- **Explanation**: Useful to confirm the directory you're currently working in, ensuring you're in the correct location before running commands.

---

## **Alternative Commands and Reasons for Choosing Specific Ones**

### 1. **Date Manipulation**
- **Alternative**: Python `datetime` module.
  - **Why I chose `date`**: The `date` command is simple and available by default on both macOS and Linux/Windows. Using Python would require additional setup and dependencies, which wasn’t necessary for this relatively simple date calculation.

### 2. **AWS Querying**
- **Alternative**: AWS SDKs (e.g., Boto3 for Python).
  - **Why I chose `aws` CLI**: The AWS CLI is a streamlined tool that doesn’t require setting up an SDK or additional libraries. It’s simpler to use in a shell script and avoids the overhead of managing dependencies for a small task.

### 3. **JSON Parsing**
- **Alternative**: Using `grep`, `sed`, or `awk` for JSON parsing.
  - **Why I chose `jq`**: `jq` is designed for JSON parsing, making it far more efficient and reliable than using text-based tools like `grep` or `awk`, which could easily break when the JSON structure changes.

### 4. **Summing Data**
- **Alternative**: Using `python` or `bc`.
  - **Why I chose `awk`**: `awk` is already available in most shell environments and is efficient for summing numbers in a text stream. It’s lightweight, simple, and doesn't introduce the complexity of additional languages or libraries.

---