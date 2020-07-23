#!/bin/bash
TMP_DIR="/tmp/gradlehome"
if [ -d "$TMP_DIR" ]; then
    echo "Deleteing Gradle Temporay Dir: $TMP_DIR recursively "
    rm -Rf "$TMP_DIR"
fi
git clone "$1"@git.apgsga.ch:/var/git/repos/apg-gradle-properties.git "$TMP_DIR"