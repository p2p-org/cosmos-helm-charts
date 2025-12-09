#!/bin/sh
# Common download utility functions for init container scripts
# This script can be sourced by other scripts to use these functions

# Helper functions for downloads
download_json() {
    local url="$1"
    local output_file="$2"
    echo "Downloading plain json..."
    wget -c -O "$output_file" "$url"
}

download_jsongz() {
    local url="$1"
    local output_file="$2"
    echo "Downloading json.gz..."
    wget -c -O - "$url" | gunzip -c > "$output_file"
}

download_tar() {
    local url="$1"
    local extract_dir="$2"
    echo "Downloading and extracting tar..."
    wget -c -O - "$url" | tar -x -C "$extract_dir"
}

download_targz() {
    local url="$1"
    local extract_dir="$2"
    echo "Downloading and extracting compressed tar..."
    wget -c -O - "$url" | tar -xz -C "$extract_dir"
}

download_zip() {
    local url="$1"
    local output_file="$2"
    echo "Downloading and extracting zip..."
    wget -c -O tmp_genesis.zip "$url"
    unzip tmp_genesis.zip
    rm tmp_genesis.zip
    mv genesis.json "$output_file"
}

download_lz4() {
    local url="$1"
    local extract_dir="$2"
    echo "Downloading and extracting lz4..."
    wget -c -O - "$url" | lz4 -c -d | tar -x -C "$extract_dir"
}

download_zst() {
    local url="$1"
    local extract_dir="$2"
    echo "Downloading and extracting zst..."
    wget -c -O - "$url" | zstd -d --stdout | tar -x -C "$extract_dir"
}

download_lz4_raw() {
    local url="$1"
    local extract_dir="$2"
    echo "Downloading and extracting raw lz4..."
    wget -c -O - "$url" | lz4 -d | tar -x -C "$extract_dir"
}

# Generic download function that handles file extension detection
download_file() {
    local url="$1"
    local output_file="$2"
    local extract_dir="$3"
    
    # If extract_dir is provided, it's an archive that extracts to a directory
    # If output_file is provided, it's a single file download
    
    case "$url" in
        *.json.gz)
            if [ -n "$output_file" ]; then
                download_jsongz "$url" "$output_file"
            else
                echo "Error: output_file required for json.gz"
                exit 1
            fi
            ;;
        *.json)
            if [ -n "$output_file" ]; then
                download_json "$url" "$output_file"
            else
                echo "Error: output_file required for json"
                exit 1
            fi
            ;;
        *.tar.gz|*.tar.gzip)
            if [ -n "$extract_dir" ]; then
                download_targz "$url" "$extract_dir"
            else
                echo "Error: extract_dir required for tar.gz"
                exit 1
            fi
            ;;
        *.tar)
            if [ -n "$extract_dir" ]; then
                download_tar "$url" "$extract_dir"
            else
                echo "Error: extract_dir required for tar"
                exit 1
            fi
            ;;
        *.tar.lz4)
            if [ -n "$extract_dir" ]; then
                download_lz4 "$url" "$extract_dir"
            else
                echo "Error: extract_dir required for tar.lz4"
                exit 1
            fi
            ;;
        *.tar.zst)
            if [ -n "$extract_dir" ]; then
                download_zst "$url" "$extract_dir"
            else
                echo "Error: extract_dir required for tar.zst"
                exit 1
            fi
            ;;
        *.lz4)
            if [ -n "$extract_dir" ]; then
                download_lz4_raw "$url" "$extract_dir"
            else
                echo "Error: extract_dir required for lz4"
                exit 1
            fi
            ;;
        *.zip)
            if [ -n "$output_file" ]; then
                download_zip "$url" "$output_file"
            else
                echo "Error: output_file required for zip"
                exit 1
            fi
            ;;
        *)
            echo "Unable to handle file extension for $url"
            exit 1
            ;;
    esac
}
