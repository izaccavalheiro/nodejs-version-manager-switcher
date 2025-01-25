#!/bin/bash

# Detect and setup NVM
setup_nvm() {
    # Check for NVM in common locations
    if [ -z "$NVM_DIR" ]; then
        export NVM_DIR="$HOME/.nvm"
    fi

    # Load NVM if not already loaded
    if [ -s "$NVM_DIR/nvm.sh" ]; then
        # shellcheck source=/dev/null
        \. "$NVM_DIR/nvm.sh"
    elif [ -s "$(brew --prefix nvm)/nvm.sh" ]; then
        # shellcheck source=/dev/null
        \. "$(brew --prefix nvm)/nvm.sh"
    else
        # Install NVM if not present
        if command -v curl >/dev/null 2>&1; then
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
            # shellcheck source=/dev/null
            \. "$NVM_DIR/nvm.sh"
        else
            echo "Unable to install NVM: curl not found"
            return 1
        fi
    fi
}

# Detect operating system
detect_os() {
    local os=$(uname -s | tr '[:upper:]' '[:lower:]')
    case "$os" in
        darwin*)
            echo "macos"
            ;;
        linux*)
            echo "linux"
            ;;
        msys*|mingw*|cygwin*)
            echo "windows"
            ;;
        *)
            echo "unsupported"
            ;;
    esac
}

# Function to install Node.js version
install_nodejs() {
    local version="$1"
    local os=$(detect_os)

    # Ensure NVM is set up
    setup_nvm || return 1

    case "$os" in
        macos|linux)
            nvm install "$version"
            nvm use "$version"
            ;;
        windows)
            nvm install "$version"
            nvm use "$version"
            ;;
        *)
            echo "Unsupported operating system"
            return 1
            ;;
    esac
}

# Function to parse package.json and extract Node.js version
get_version_from_package_json() {
    if [ -f "package.json" ]; then
        local version=$(grep -E '"engines"\s*:' package.json | sed -E 's/.*"node"\s*:\s*"?([^"~^]+)[^"]*".*/\1/' | tr -d ' ')
        
        if [ ! -z "$version" ]; then
            echo "$version"
            return 0
        fi
    fi
    return 1
}

# Function to display usage information
usage() {
    echo "Usage: $0 [options]"
    echo
    echo "Retrieve Node.js version from:"
    echo "  1. .nvmrc file"
    echo "  2. .node-version file"
    echo "  3. 'engines.node' in package.json"
    echo
    echo "Options:"
    echo "  -i, --install   Automatically install the discovered Node.js version"
    echo "  -h, --help      Show this help message"
    exit 1
}

# Main script logic
main() {
    local install_mode=0
    local version=""

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -i|--install)
                install_mode=1
                shift
                ;;
            -h|--help)
                usage
                ;;
            *)
                echo "Unknown option: $1"
                usage
                ;;
        esac
    done

    # Check .nvmrc file
    if [ -f ".nvmrc" ]; then
        version=$(cat .nvmrc | tr -d '\n')
        echo "Version found in .nvmrc: $version"
    
    # Check .node-version file
    elif [ -f ".node-version" ]; then
        version=$(cat .node-version | tr -d '\n')
        echo "Version found in .node-version: $version"
    
    # Check package.json
    else
        version=$(get_version_from_package_json)
        if [ $? -eq 0 ]; then
            echo "Version found in package.json: $version"
        else
            echo "No Node.js version found in .nvmrc, .node-version, or package.json"
            exit 1
        fi
    fi

    # Install the version if install mode is on
    if [ $install_mode -eq 1 ]; then
        install_nodejs "$version"
    else
        # Just output the version
        echo "$version"
    fi
}

# Run the main function
main "$@"