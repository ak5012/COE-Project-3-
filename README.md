# Image-to-Sentiment Pipeline: Multi-Model Inference Server
By: Akshay Karthik   COE 379L

A production-ready machine learning pipeline that chains image captioning and sentiment analysis models, deployed as a containerized REST API.

##  Project Video
The video for this project can be found here: [https://drive.google.com/file/d/1aehdB5hlrcKaOdm31QIj8PmDwBURBJI5/view?usp=drive_link](https://drive.google.com/file/d/1aehdB5hlrcKaOdm31QIj8PmDwBURBJI5/view?usp=drive_link)

##  Overview

This project implements a **multi-model inference pipeline** where:
1. **Model 1** (Image Captioning): Converts input images into descriptive text captions using BLIP
2. **Model 2** (Sentiment Analysis): Analyzes the generated caption to determine sentiment (POSITIVE/NEGATIVE) using DistilBERT
3. **Unified API**: Both models are served through a single FastAPI endpoint

### Key Features
-  RESTful API with automatic documentation
-  Docker containerization for easy deployment
-  GPU support (optional)
-  Comprehensive evaluation metrics
-  Production-ready error handling
-  Health check endpoints

##  Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    User Request                          │
│                  (Upload Image)                          │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│                  FastAPI Server                          │
│                 (Port 8000)                              │
└────────────┬──────────────────────────┬─────────────────┘
             │                          │
             ▼                          ▼
┌─────────────────────┐    ┌──────────────────────────────┐
│ Image Captioning    │───▶│  Sentiment Analysis          │
│ (BLIP Model)        │    │  (DistilBERT)               │
│                     │    │                              │
│ Input: PIL Image    │    │  Input: Text Caption         │
│ Output: Caption     │    │  Output: Sentiment + Score   │
└─────────────────────┘    └──────────────────────────────┘
             │                          │
             └──────────┬───────────────┘
                        ▼
        ┌───────────────────────────────┐
        │   JSON Response                │
        │   {                            │
        │     "caption": "...",          │
        │     "sentiment": "POSITIVE",   │
        │     "confidence": 0.98,        │
        │     "processing_time_ms": 234  │
        │   }                            │
        └───────────────────────────────┘
```

##  Quick Start

### Prerequisites
- Python 3.10+
- Docker (optional, for containerized deployment)
- 4GB+ RAM
- (Optional) NVIDIA GPU with CUDA support

### Option 1: Local Installation

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd image-sentiment-pipeline
```

2. **Install dependencies**
```bash
pip install -r requirements.txt
```

3. **Run the server**
```bash
cd src
python server.py
```

The API will be available at `http://localhost:8000`

### Option 2: Docker Deployment

1. **Build and run with Docker Compose**
```bash
docker-compose up --build
```

2. **Or build manually**
```bash
docker build -t image-sentiment-pipeline .
docker run -p 8000:8000 image-sentiment-pipeline
```

##  API Usage

### Health Check
```bash
curl http://localhost:8000/health
```

### Analyze Image (Full Pipeline)
```bash
curl -X POST "http://localhost:8000/analyze-image" \
  -F "file=@/path/to/your/image.jpg"
```

**Response:**
```json
{
  "caption": "a person sitting on a bench with a laptop",
  "sentiment": "POSITIVE",
  "sentiment_confidence": 0.8234,
  "processing_time_ms": 456.78,
  "model_info": {
    "captioning_model": "Salesforce/blip-image-captioning-base",
    "sentiment_model": "distilbert-base-uncased-finetuned-sst-2-english",
    "caption_time_ms": 389.12,
    "sentiment_time_ms": 67.66
  }
}
```

### Python Client Example

```python
from client import ImageSentimentClient

# Initialize client
client = ImageSentimentClient(base_url="http://localhost:8000")

# Analyze an image
result = client.analyze_image("path/to/image.jpg")

print(f"Caption: {result['caption']}")
print(f"Sentiment: {result['sentiment']} ({result['sentiment_confidence']:.2%})")
```

### Interactive API Documentation

Visit `http://localhost:8000/docs` for Swagger UI documentation
Visit `http://localhost:8000/redoc` for ReDoc documentation

##  Evaluation

Run comprehensive model evaluation:

```bash
cd evaluation
python evaluate_models.py
```

This will generate:
- BLEU and METEOR scores for image captioning
- Accuracy and F1 scores for sentiment analysis
- End-to-end latency metrics
- Results saved to `evaluation/results.json`

##  Project Structure

```
image-sentiment-pipeline/
├── src/
│   ├── server.py              # FastAPI application
│   ├── image_captioner.py     # Image captioning model wrapper
│   ├── sentiment_analyzer.py  # Sentiment analysis model wrapper
│   └── client.py              # Python API client
├── evaluation/
│   └── evaluate_models.py     # Model evaluation script
├── data/                      # Sample images and test data
├── docs/                      # Additional documentation
├── tests/                     # Unit tests
├── Dockerfile                 # Docker container definition
├── docker-compose.yml         # Docker Compose configuration
├── requirements.txt           # Python dependencies
└── README.md                  # This file
```

##  Configuration

### Model Selection

You can change the models by modifying the initialization in `server.py`:

```python
# For image captioning, options include:
# - Salesforce/blip-image-captioning-base (default)
# - Salesforce/blip-image-captioning-large
# - nlpconnect/vit-gpt2-image-captioning

captioner = ImageCaptioner(model_name="Salesforce/blip-image-captioning-base")

# For sentiment analysis, options include:
# - distilbert-base-uncased-finetuned-sst-2-english (default)
# - cardiffnlp/twitter-roberta-base-sentiment-latest
# - nlptown/bert-base-multilingual-uncased-sentiment

sentiment_analyzer = SentimentAnalyzer(model_name="distilbert-base-uncased-finetuned-sst-2-english")
```

### GPU Support

To enable GPU acceleration:

1. Install PyTorch with CUDA support:
```bash
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu118
```

2. The code automatically detects and uses GPU if available

##  Performance Benchmarks

Typical performance on CPU (Intel i7):
- Image Captioning: ~400-600ms per image
- Sentiment Analysis: ~50-100ms per caption
- **Total End-to-End Latency: ~500-700ms**

With GPU (NVIDIA RTX 3080):
- Image Captioning: ~100-150ms per image
- Sentiment Analysis: ~20-30ms per caption
- **Total End-to-End Latency: ~120-180ms**

##  Use Cases

1. **Social Media Monitoring**: Analyze image posts and determine sentiment
2. **Content Moderation**: Automatically flag images with negative sentiment
3. **Marketing Analytics**: Understand visual content sentiment in campaigns
4. **Accessibility**: Generate captions for images with sentiment context
5. **Research**: Study the relationship between visual content and text sentiment

##  Troubleshooting

### Models not loading
- Ensure you have sufficient RAM (4GB+ required)
- Check internet connection for initial model download
- Models are cached in `~/.cache/huggingface/`

### Slow performance
- Consider using GPU acceleration
- Reduce image resolution before uploading
- Use batch processing for multiple images

### Docker issues
- Ensure Docker has sufficient memory allocated (4GB+)
- Check logs: `docker-compose logs -f`

##  Example Outputs

**Input Image**: Beach sunset with people
```json
{
  "caption": "people walking on the beach at sunset",
  "sentiment": "POSITIVE",
  "sentiment_confidence": 0.9234
}
```

**Input Image**: Dark alley
```json
{
  "caption": "a dark alley with graffiti on the walls",
  "sentiment": "NEGATIVE",
  "sentiment_confidence": 0.8456
}
```

##  Contributing

Contributions are welcome! Areas for improvement:
- Add more model options
- Implement model caching
- Add batch processing endpoint
- Improve error handling
- Add more evaluation metrics


##  Acknowledgments

- **BLIP**: Salesforce Research for the image captioning model
- **DistilBERT**: HuggingFace for the sentiment analysis model
- **FastAPI**: For the excellent web framework
- **Transformers**: HuggingFace transformers library



