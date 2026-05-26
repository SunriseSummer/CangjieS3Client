#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# ========== Cangjie SDK Setup ==========
if [ -z "$CANGJIE_HOME" ]; then
    # Try to find cangjie SDK in common locations
    if [ -f "../cangjie/envsetup.sh" ]; then
        source ../cangjie/envsetup.sh
    elif [ -f "../../cangjie/envsetup.sh" ]; then
        source ../../cangjie/envsetup.sh
    else
        echo "Error: Please set CANGJIE_HOME or source cangjie/envsetup.sh"
        exit 1
    fi
fi

# ========== STDX Setup ==========
if [ -z "$CANGJIE_STDX_PATH" ]; then
    # Try to find STDX in common locations
    for dir in ../cangjie-stdx-linux-x64-*/linux_x86_64_cjnative/dynamic/stdx \
               ../../cangjie-stdx-linux-x64-*/linux_x86_64_cjnative/dynamic/stdx; do
        if [ -d "$dir" ]; then
            export CANGJIE_STDX_PATH="$(cd "$dir" && pwd)"
            break
        fi
    done
    if [ -z "$CANGJIE_STDX_PATH" ]; then
        echo "Error: Please set CANGJIE_STDX_PATH to point to STDX dynamic/stdx directory"
        exit 1
    fi
fi

export LD_LIBRARY_PATH=$CANGJIE_STDX_PATH:$LD_LIBRARY_PATH

# ========== Start Docker Services ==========
echo "Starting Docker services (MinIO + OpenGauss)..."
sudo docker-compose up -d

echo "Waiting for services to be ready..."
sleep 15

# ========== Build & Run ==========
echo "Building CDrive..."
cjpm build

echo ""
echo "Starting CDrive application..."
echo "================================"
cjpm run
