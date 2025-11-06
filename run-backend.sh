#!/bin/bash

# Quick script to run the MindNest backend

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}   Starting MindNest Backend API${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if virtual environment exists
if [ ! -d "backend/venv" ]; then
    echo "Virtual environment not found. Please run setup.sh first."
    exit 1
fi

# Navigate to backend
cd backend

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

echo ""
echo -e "${GREEN}Starting FastAPI server...${NC}"
echo ""
echo "API will be available at:"
echo "  • http://localhost:8000"
echo "  • http://localhost:8000/docs (Swagger UI)"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Run the server
python app/main.py
