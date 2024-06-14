#!/bin/bash

GITHUB_EVENT_INPUTS_ARTIFACT_ID="$1"
GITHUB_EVENT_INPUTS_CONTAINER_NAME="$2"
GITHUB_EVENTS_INPUTS_SOURCE="$3"

if [ -z "${{ github.events.inputs.source }}"]; then
    echo "container_name=$container_name" >> $GITHUB_ENV
    echo "::set-output name=container_name::$SOURCE"
    echo "SOURCE=local" >> $GITHUB_ENV
    echo "::set-output name="
fi

  # Fetch the latest artifact ID using GitHub CLI and jq
  ARTIFACT_ID=$(gh api -X GET /repos/$GITHUB_REPOSITORY/actions/artifacts | jq -r '.artifacts[0].id')
  echo "Fetched artifact ID: $ARTIFACT_ID"
else
  ARTIFACT_ID=$GITHUB_EVENT_INPUTS_ARTIFACT_ID
  echo "Provided artifact ID: $ARTIFACT_ID"
fi

# You can now use $ARTIFACT_ID as needed in your script
echo "artifact_id=$ARTIFACT_ID" >> "$GITHUB_ENV"
echo "source=$SOURCE" >> "$GITHUB_ENV"
echo "type=$TYPE" >> "$GITHUB_ENV"
echo "path=$PATH" >> "$GITHUB_ENV"
# Optionally, set the artifact_id in an output file (for further use in a CI/CD pipeline, for example)
# echo "artifact_id=$ARTIFACT_ID" >> /path/to/your/output/file
