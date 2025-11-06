#!/bin/bash

# Quick script to run the MindNest Flutter app

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Starting MindNest Flutter App${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Flutter not found. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Navigate to frontend
cd frontend

# Check for dependencies
if [ ! -d ".dart_tool" ]; then
    echo -e "${YELLOW}Dependencies not found. Running flutter pub get...${NC}"
    flutter pub get
    echo ""
fi

echo -e "${GREEN}Starting Flutter app...${NC}"
echo ""
echo "Available devices:"
flutter devices
echo ""
echo "The app will launch on your selected device."
echo ""
echo -e "${YELLOW}IMPORTANT:${NC} Make sure the backend is running at http://localhost:8000"
echo "Run in another terminal: ./run-backend.sh"
echo ""

# Run the app
flutter run
