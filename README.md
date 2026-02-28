<p align="center">
  <img src="./img.png" alt="Project Banner" width="100%">
</p>

# KeralaSeva AI 🎯

## Basic Details

### Team Name: DELULU

### Team Members
- Member 1: Negha R - Sree Chitra Thirunal Collage of Engineering
- Member 2: Bhagavathy A N - Sree Chitra Thirunal Collage of Engineering

### Hosted Project Link
https://github.com/NullPioneer/Tink-Her-Hack-2

### Project Description
KeralaSeva AI is an intelligent scholarship navigation and alert system designed to help students discover eligible scholarships based on their profile. It also automatically notifies local authorities when new scholarships are added, ensuring faster awareness and outreach.

### The Problem statement
Students often miss scholarship opportunities due to lack of centralized information, poor filtering mechanisms, and limited awareness at the local level.
Local authorities also lack automated notification systems when new scholarships are introduced.

### The Solution
KeralaSeva AI provides:

1. Personalized scholarship matching based on profile data
2. AI-powered chatbot for instant queries
3. Automated email alerts to local authorities
4. Deadline notification system
5. Centralized scholarship management

## Technical Details

### Technologies/Components Used

**For Software:**
- Languages used: Python, Javascript, SQL
- Frameworks used: Flask, Super base
- Libraries used: requests
                  resend
                  APScheduler
                  OpenAI / Ollama (for chatbot)
                  flask-cors
- Tools used: VS Code, Git, Supa base, Ngrok

## Features

List the key features of your project:
- Feature 1: Personalized scholarship matching based on profile data
- Feature 2: AI-powered chatbot for instant queries
- Feature 3: Deadline notification system
- Feature 4: Automated email alerts to local authorities

## Implementation

### For Software:

#### Installation
```bash
git clone https://github.com/yourusername/keralaseva-ai.git
cd keralaseva-ai

# Create virtual environment
python -m venv .venv
.venv\Scripts\activate   # Windows
# source .venv/bin/activate  # Mac/Linux
pip install -r requirements.txt
```
### Environment Variables (.env)

Create a .env file:

SUPABASE_URL=https://yourproject.supabase.co
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
RESEND_API_KEY=your_resend_key
OPENAI_API_KEY=your_openai_key (if using OpenAI)
WEBHOOK_SECRET=optional_secret

#### Run
```bash
python run.py
```

## Project Documentation

### For Software:

#### Screenshots (Add at least 3)

![<img width="1919" height="910" alt="Screenshot of user interface" src="https://github.com/user-attachments/assets/4ab813ed-0601-48b5-a666-688cfdad4048" />](Add screenshot 1 here with proper name)
This shows the user interface of the website

![<img width="1917" height="910" alt="Screenshot of account creation" src="https://github.com/user-attachments/assets/bdd093d0-f59c-4781-a4c4-bea0ad272ff5" />]
(Add screenshot 2 here with proper name)
This shows the account craetion of the user

![<img width="1916" height="915" alt="Screenshot of filtered scholarships" src="https://github.com/user-attachments/assets/987ba0e0-3cff-4132-bd31-897b344286f8" />
](Add screenshot 3 here with proper name)
Scholarships are filtered according to user specifications



#### Diagrams

**System Architecture:**

![Architecture Diagram](docs/architecture.png)
*Explain your system architecture - components, data flow, tech stack interaction*

**Application Workflow:**

![Workflow](docs/workflow.png)
*Add caption explaining your workflow*

---

## Additional Documentation

### For Web Projects with Backend:

#### API Documentation

**Base URL:** `https://api.yourproject.com`

##### Endpoints

**GET /api/endpoint**
- **Description:** [What it does]
- **Parameters:**
  - `param1` (string): [Description]
  - `param2` (integer): [Description]
- **Response:**
```json
{
  "status": "success",
  "data": {}
}
```

**POST /api/endpoint**
- **Description:** [What it does]
- **Request Body:**
```json
{
  "field1": "value1",
  "field2": "value2"
}
```
- **Response:**
```json
{
  "status": "success",
  "message": "Operation completed"
}
```

[Add more endpoints as needed...]

### For Scripts/CLI Tools:

#### Command Reference

**Basic Usage:**
```bash
python script.py [options] [arguments]
```

**Available Commands:**
- `command1 [args]` - Description of what command1 does
- `command2 [args]` - Description of what command2 does
- `command3 [args]` - Description of what command3 does

**Options:**
- `-h, --help` - Show help message and exit
- `-v, --verbose` - Enable verbose output
- `-o, --output FILE` - Specify output file path
- `-c, --config FILE` - Specify configuration file
- `--version` - Show version information

**Examples:**

```bash
# Example 1: Basic usage
python script.py input.txt

# Example 2: With verbose output
python script.py -v input.txt

# Example 3: Specify output file
python script.py -o output.txt input.txt

# Example 4: Using configuration
python script.py -c config.json --verbose input.txt
```

#### Demo Output

**Example 1: Basic Processing**

**Input:**
```
This is a sample input file
with multiple lines of text
for demonstration purposes
```

**Command:**
```bash
python script.py sample.txt
```

**Output:**
```
Processing: sample.txt
Lines processed: 3
Characters counted: 86
Status: Success
Output saved to: output.txt
```

**Example 2: Advanced Usage**

**Input:**
```json
{
  "name": "test",
  "value": 123
}
```

**Command:**
```bash
python script.py -v --format json data.json
```

**Output:**
```
[VERBOSE] Loading configuration...
[VERBOSE] Parsing JSON input...
[VERBOSE] Processing data...
{
  "status": "success",
  "processed": true,
  "result": {
    "name": "test",
    "value": 123,
    "timestamp": "2024-02-07T10:30:00"
  }
}
[VERBOSE] Operation completed in 0.23s
```

---

## Project Demo

### Video

https://drive.google.com/drive/folders/1HAcjz_zKbaY601Ao5nbZdZ6ESAHQdHu1
It shows the user interface,login page and the filtered scholarships provided to the person as per certain specifications like gender,community,qualifications etc .It also shows a chatbot for assistance . It gives the documents to be uploaded, deadline alerts,steps to apply and redirect link to the official website.

## AI Tools Used (Optional - For Transparency Bonus)

**Tool Used:** [e.g., GitHub Copilot, v0.dev, Cursor, ChatGPT, Claude]

**Purpose:** [What you used it for]
- Example: "Generated boilerplate React components"
- Example: "Debugging assistance for async functions"
- Example: "Code review and optimization suggestions"

**Key Prompts Used:**
- "Create a REST API endpoint for user authentication"
- "Debug this async function that's causing race conditions"
- "Optimize this database query for better performance"



Made with ❤️ at TinkerHub
