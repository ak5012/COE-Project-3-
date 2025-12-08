#!/bin/bash

# Quick Start Script for Image-to-Sentiment Pipeline
# This script helps you get started quickly

echo "========================================="
echo "Image-to-Sentiment Pipeline - Quick Start"
echo "========================================="
echo ""

# Check Python version
echo "Checking Python version..."
python_version=$(python3 --version 2>&1 | awk '{print $2}')
echo "Python version: $python_version"
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Option selection
echo "Choose deployment option:"
echo "1. Local Python installation"
echo "2. Docker deployment"
echo ""
read -p "Enter option (1 or 2): " option

case $option in
    1)
        echo ""
        echo "Option 1: Local Python Installation"
        echo "===================================="
        echo ""
        
        # Create virtual environment
        echo "Creating virtual environment..."
        python3 -m venv venv
        
        # Activate virtual environment
        echo "Activating virtual environment..."
        source venv/bin/activate
        
        # Install dependencies
        echo "Installing dependencies..."
        pip install --upgrade pip
        pip install -r requirements.txt
        
        echo ""
        echo "✅ Installation complete!"
        echo ""
        echo "To start the server:"
        echo "  source venv/bin/activate"
        echo "  cd src"
        echo "  python server.py"
        echo ""
        echo "The API will be available at: http://localhost:8000"
        echo "API documentation at: http://localhost:8000/docs"
        ;;
        
    2)
        echo ""
        echo "Option 2: Docker Deployment"
        echo "==========================="
        echo ""
        
        # Check if Docker is installed
        if ! command_exists docker; then
            echo "❌ Docker is not installed. Please install Docker first."
            echo "Visit: https://docs.docker.com/get-docker/"
            exit 1
        fi
        
        # Check if Docker Compose is installed
        if ! command_exists docker-compose; then
            echo "❌ Docker Compose is not installed. Please install Docker Compose first."
            echo "Visit: https://docs.docker.com/compose/install/"
            exit 1
        fi
        
        echo "Building and starting Docker containers..."
        docker-compose up --build -d
        
        echo ""
        echo "✅ Docker deployment complete!"
        echo ""
        echo "The API is now running at: http://localhost:8000"
        echo "API documentation at: http://localhost:8000/docs"
        echo ""
        echo "To view logs:"
        echo "  docker-compose logs -f"
        echo ""
        echo "To stop the server:"
        echo "  docker-compose down"
        ;;
        
    *)
        echo "Invalid option. Please run the script again and choose 1 or 2."
        exit 1
        ;;
esac

echo ""
echo "========================================="
echo "Next Steps:"
echo "========================================="
echo ""
echo "1. Test the API:"
echo "   curl http://localhost:8000/health"
echo ""
echo "2. Analyze an image:"
echo "   curl -X POST http://localhost:8000/analyze-image \\"
echo "     -F \"file=@path/to/your/image.jpg\""
echo ""
echo "3. Use the Python client:"
echo "   python src/client.py"
echo ""
echo "4. Run the demonstration notebook:"
echo "   jupyter notebook demonstration.ipynb"
echo ""
echo "========================================="
