#!/bin/bash
# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Read stdin to consume the hook payload, though we won't use it directly here.
cat > /dev/null

# Prevent infinite recursion if the nested gemini call triggers this hook again
if [ "$DEV_ASSIST_NESTED" = "1" ]; then
  echo '{"hookSpecificOutput": {"additionalContext": ""}}'
  exit 0
fi

echo "Querying GitHub for assigned issues..." >&2

# Run a nested gemini instance to fetch the issues
# We set DEV_ASSIST_NESTED=1 so the nested instance skips this hook
# --screen-reader forces plain text output
export GH_ISSUES=$(DEV_ASSIST_NESTED=1 gemini "Use the dev-agent tool to check my assigned GitHub issues. List the issues assigned to me and provide a brief summary of what I should work on." --screen-reader)

# Safely output the required JSON using Node.js to handle string escaping
node -e "
const issues = process.env.GH_ISSUES || 'No issues found or error occurred.';
console.log(JSON.stringify({
  systemMessage: 'GitHub issues retrieved.',
  hookSpecificOutput: {
    additionalContext: 'Here are my assigned GitHub issues and suggested tasks:\\n\\n' + issues
  }
}));
"