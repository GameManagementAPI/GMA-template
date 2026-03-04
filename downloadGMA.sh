#!/bin/sh
url() {
    API_URL="https://api.github.com/repos/GameManagementAPI/$1/releases/latest"

    DOWNLOAD_URL=$(curl -s "$API_URL" \
      | grep "browser_download_url" \
      | grep "$2" \
      | cut -d '"' -f 4)

    if [ -z "$DOWNLOAD_URL" ]; then
      echo "Error: Could not find $2 in the latest release."
      exit 1
    fi

    echo "$DOWNLOAD_URL"
}

download() {
    NAME="$(basename "$2")"
    echo "Downloading $1 from $2..."
    mkdir -p "run/plugins/"
    curl -L -o "run/plugins/$NAME" "$2"
}

repos="GameManager GameLobby GameStats"
for repo in $repos; do
    download "$repo" "$(url "$repo" "$repo")"
done