# Test Automation with Postman

## Introduction
This project contains automated tests for the [Restful Booker API](https://restful-booker.herokuapp.com/apidoc/index.html).

## Prerequisites
- [Postman](https://www.postman.com/downloads/) installed.
- (Optional) [Newman](https://github.com/postmanlabs/newman) for CLI execution.
- Exported environment variables (if needed).

## Repository Setup

 - **Clone the Repository:**
   ```bash
   git clone https://github.com/Flora24-Yedidya/restful-booker.git
   cd restful-booker

## How to Run the Tests

### 1. Using Postman:
   - Import the collection by uploading the `restful-booker.postman_collection.json` file into Postman.
   - Run the collection using the **Collection Runner** in Postman.

### 2. Using Newman:
   - **Install Newman:**
     If `npm` is already installed on your system, you can install Newman with the following command:
     ```bash
     npm install -g newman
     ```

   - **Verify Installation:**
     After installation, verify that Newman is accessible by running the following command:
     ```bash
     newman --version
     ```
     This should display the installed version of Newman.

   - **Add Newman to PATH (if necessary):**
     If Newman is installed but not recognized, it might not be in your PATH. To add it, you can modify your `.bashrc` or `.bash_profile` file (depending on your system) by adding the following line:
     ```bash
     export PATH=$PATH:/usr/local/bin
     ```
     Then, execute:
     ```bash
     source ~/.bashrc
     ```
     Or:
     ```bash
     source ~/.bash_profile
     ```

   - **Alternatives if `npm` is not installed:**
     - Install [Node.js](https://nodejs.org/) and `npm` by following the instructions on the official website.
     - After installing `npm`, you can install Newman as described above.

   - **Automating with Newman:**
     Once installed, you can execute your automated Postman tests with a command like:
     ```bash
     newman run restful-booker.postman_collection.json
     ```
