#!/bin/bash

# MindNest Setup Script
# Automates the setup of backend and frontend

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Main setup
main() {
    print_header "🧘 MindNest Setup Script"

    # Check prerequisites
    print_status "Checking prerequisites..."

    # Check Python
    if command_exists python3; then
        PYTHON_VERSION=$(python3 --version)
        print_success "Python found: $PYTHON_VERSION"
    else
        print_error "Python 3 not found. Please install Python 3.9 or higher."
        exit 1
    fi

    # Check Flutter
    if command_exists flutter; then
        FLUTTER_VERSION=$(flutter --version | head -n 1)
        print_success "Flutter found: $FLUTTER_VERSION"
    else
        print_warning "Flutter not found. Frontend setup will be skipped."
        print_warning "Install Flutter from: https://flutter.dev/docs/get-started/install"
        SKIP_FLUTTER=true
    fi

    # Check pip
    if command_exists pip3; then
        print_success "pip3 found"
    else
        print_error "pip3 not found. Please install pip."
        exit 1
    fi

    echo ""

    # Setup Backend
    print_header "🐍 Setting up Backend (FastAPI)"

    cd backend

    print_status "Creating Python virtual environment..."
    python3 -m venv venv
    print_success "Virtual environment created"

    print_status "Activating virtual environment..."
    source venv/bin/activate || . venv/bin/activate

    print_status "Installing Python dependencies..."
    pip install --upgrade pip
    pip install -r requirements.txt
    print_success "Backend dependencies installed"

    print_status "Creating .env file from template..."
    if [ ! -f .env ]; then
        cp .env.example .env
        print_success ".env file created (please update with your API keys)"
    else
        print_warning ".env file already exists, skipping"
    fi

    cd ..

    echo ""

    # Setup Frontend
    if [ "$SKIP_FLUTTER" != true ]; then
        print_header "📱 Setting up Frontend (Flutter)"

        cd frontend

        print_status "Running Flutter pub get..."
        flutter pub get
        print_success "Flutter dependencies installed"

        print_status "Checking Flutter setup..."
        flutter doctor

        cd ..

        echo ""
    fi

    # Summary
    print_header "✅ Setup Complete!"

    echo "Next steps:"
    echo ""
    echo "1. Start the Backend:"
    echo "   ${GREEN}cd backend${NC}"
    echo "   ${GREEN}source venv/bin/activate${NC}  # On Windows: venv\\Scripts\\activate"
    echo "   ${GREEN}python app/main.py${NC}"
    echo ""
    echo "2. Test the API (in another terminal):"
    echo "   ${GREEN}cd backend${NC}"
    echo "   ${GREEN}source venv/bin/activate${NC}"
    echo "   ${GREEN}python test_api.py${NC}"
    echo ""

    if [ "$SKIP_FLUTTER" != true ]; then
        echo "3. Update Frontend API URL:"
        echo "   Edit ${GREEN}frontend/lib/services/api_service.dart${NC}"
        echo "   Update baseUrl to match your backend:"
        echo "   - iOS Simulator: ${GREEN}http://localhost:8000${NC}"
        echo "   - Android Emulator: ${GREEN}http://10.0.2.2:8000${NC}"
        echo "   - Physical Device: ${GREEN}http://YOUR_COMPUTER_IP:8000${NC}"
        echo ""
        echo "4. Start the Flutter app:"
        echo "   ${GREEN}cd frontend${NC}"
        echo "   ${GREEN}flutter run${NC}"
        echo ""
    fi

    echo "📚 Documentation:"
    echo "   - Main README: ${GREEN}README.md${NC}"
    echo "   - Backend docs: ${GREEN}backend/README.md${NC}"
    echo "   - Frontend docs: ${GREEN}frontend/README.md${NC}"
    echo "   - API docs (after starting): ${GREEN}http://localhost:8000/docs${NC}"
    echo ""

    print_success "Happy meditating! 🧘💜"
}

# Run main function
main
