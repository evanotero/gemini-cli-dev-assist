# Gemini CLI Dev Assist Extension

A Gemini CLI extension designed to help developers do their best work. It automatically checks GitHub for assigned issues and summarizes your tasks when starting a new session.

## Features

*   **`dev-agent`**: A specialized local subagent that queries GitHub for your assigned open issues and provides a brief, actionable list of recommended next steps for your day.
*   **Startup Hook (`bootstrap.sh`)**: Automatically runs on `SessionStart` to query GitHub (using the `dev-agent`) and load your assigned issues directly into the CLI's initial context.
*   **GitHub Copilot MCP Server Integration**: Leverages the GitHub Copilot MCP server to securely interact with the GitHub API.

## Prerequisites

*   **Gemini CLI**: Ensure you have the Gemini CLI installed and configured.
*   **GitHub Personal Access Token**: You must have a GitHub Personal Access Token (PAT) with appropriate scopes to read issues.

## Setup & Usage

1.  **Enable Subagents**: Ensure that subagents are enabled in your Gemini CLI `settings.json`:
    ```json
    "experimental": { 
      "enableAgents": true 
    }
    ```

2.  **Export your GitHub PAT**: Set the `GITHUB_PAT` environment variable before running the Gemini CLI. The extension's MCP server uses this token to authenticate with GitHub.
    ```bash
    export GITHUB_PAT="your_github_personal_access_token"
    ```

3.  **Start a Session**: The extension's bootstrap hook will automatically trigger when you start a new Gemini CLI session, querying your assigned issues and preparing your development context for the day.
