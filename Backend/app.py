# app.py - Main Flask Application
from flask import Flask, request, jsonify
from flask_cors import CORS
import base64
import io
import os
from PIL import Image
import torch
import torch.nn as nn
import torchvision.transforms as transforms
from transformers import BlipProcessor, BlipForConditionalGeneration
import cv2
import numpy as np
import logging
from datetime import datetime
import traceback

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)

# Configuration
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB max file size

class CivicIssueClassifier:
    def __init__(self):
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        self.classes = [
            'pothole', 'garbage_waste', 'street_light', 'water_leakage',
            'road_damage', 'traffic_signal', 'drainage_issue', 'tree_fallen',
            'illegal_dumping', 'broken_infrastructure', 'other'
        ]

        # Image preprocessing
        self.transform = transforms.Compose([
            transforms.Resize((224, 224)),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406],
                               std=[0.229, 0.224, 0.225])
        ])

        # Load BLIP model for image captioning
        try:
            self.caption_processor = BlipProcessor.from_pretrained("Salesforce/blip-image-captioning-base")
            self.caption_model = BlipForConditionalGeneration.from_pretrained("Salesforce/blip-image-captioning-base")
            self.caption_model.to(self.device)
            logger.info("BLIP model loaded successfully")
        except Exception as e:
            logger.error(f"Error loading BLIP model: {e}")
            self.caption_processor = None
            self.caption_model = None

        # Load custom classifier (simplified CNN for demo)
        self.classifier = self._build_classifier()

    def _build_classifier(self):
        """Build a simple CNN classifier for civic issues"""
        model = nn.Sequential(
            nn.Conv2d(3, 32, 3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2),
            nn.Conv2d(32, 64, 3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2),
            nn.Conv2d(64, 128, 3, padding=1),
            nn.ReLU(),
            nn.AdaptiveAvgPool2d((7, 7)),
            nn.Flatten(),
            nn.Linear(128 * 7 * 7, 512),
            nn.ReLU(),
            nn.Dropout(0.5),
            nn.Linear(512, len(self.classes))
        )

        # Initialize with pretrained weights or random weights
        model.to(self.device)
        model.eval()
        return model

    def classify_image(self, image):
        """Classify civic issue from image"""
        try:
            # Preprocess image
            if isinstance(image, np.ndarray):
                image = Image.fromarray(cv2.cvtColor(image, cv2.COLOR_BGR2RGB))

            image_tensor = self.transform(image).unsqueeze(0).to(self.device)

            # For demo purposes, we'll use rule-based classification
            # In production, you'd use a trained model
            return self._rule_based_classification(image)

        except Exception as e:
            logger.error(f"Classification error: {e}")
            return "other", 0.5

    def _rule_based_classification(self, image):
        """Rule-based classification for demo (replace with trained model)"""
        # Convert PIL to numpy array
        img_array = np.array(image)

        # Simple heuristics for demo
        # In production, replace with trained deep learning model
        gray = cv2.cvtColor(img_array, cv2.COLOR_RGB2GRAY)
        edges = cv2.Canny(gray, 50, 150)
        contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

        # Analyze image characteristics
        height, width = img_array.shape[:2]
        total_pixels = height * width
        edge_density = np.sum(edges > 0) / total_pixels

        # Color analysis
        hsv = cv2.cvtColor(img_array, cv2.COLOR_RGB2HSV)

        # Brown/dark colors might indicate potholes
        brown_mask = cv2.inRange(hsv, (10, 50, 20), (20, 255, 200))
        brown_ratio = np.sum(brown_mask > 0) / total_pixels

        # Green colors might indicate garbage/vegetation
        green_mask = cv2.inRange(hsv, (40, 50, 50), (80, 255, 255))
        green_ratio = np.sum(green_mask > 0) / total_pixels

        # Classification logic
        if brown_ratio > 0.3 and edge_density > 0.1:
            return "pothole", 0.85
        elif edge_density > 0.15:
            return "road_damage", 0.75
        elif green_ratio > 0.4:
            return "garbage_waste", 0.70
        else:
            return "other", 0.60

    def generate_description(self, image, issue_class):
        """Generate description for the civic issue"""
        try:
            # Use BLIP for image captioning if available
            base_description = ""
            if self.caption_model and self.caption_processor:
                inputs = self.caption_processor(image, return_tensors="pt").to(self.device)
                out = self.caption_model.generate(**inputs, max_length=50)
                base_description = self.caption_processor.decode(out[0], skip_special_tokens=True)

            # Generate detailed civic issue description
            return self._generate_civic_description(issue_class, base_description, image)

        except Exception as e:
            logger.error(f"Description generation error: {e}")
            return self._get_fallback_description(issue_class)

    def _generate_civic_description(self, issue_class, base_description, image):
        """Generate detailed civic issue description"""
        descriptions = {
            'pothole': [
                "A significant pothole has been identified on the road surface that poses a safety risk to vehicles and pedestrians.",
                "The road shows visible damage with a deep cavity that could cause vehicle damage and traffic disruption.",
                "A large pothole is present that requires immediate attention to prevent accidents and further road deterioration."
            ],
            'garbage_waste': [
                "Accumulated waste and garbage visible in the area that needs proper disposal and cleanup.",
                "Improper waste disposal observed that could lead to health hazards and environmental concerns.",
                "Garbage overflow detected that requires immediate waste management intervention."
            ],
            'street_light': [
                "Street lighting infrastructure appears to be malfunctioning or damaged, affecting public safety.",
                "Non-functional street light identified that could compromise pedestrian and vehicle safety during night hours.",
                "Street lighting issue detected that needs electrical maintenance for proper illumination."
            ],
            'water_leakage': [
                "Water leakage detected that could lead to water wastage and potential infrastructure damage.",
                "Visible water seepage that requires plumbing attention to prevent further complications.",
                "Water leak identified that needs immediate repair to conserve water resources."
            ],
            'road_damage': [
                "Road surface damage observed that affects traffic flow and vehicle safety.",
                "Significant road deterioration that requires maintenance to ensure safe transportation.",
                "Road infrastructure damage that could worsen without timely intervention."
            ],
            'traffic_signal': [
                "Traffic signal malfunction detected that could cause traffic disruption and safety concerns.",
                "Non-operational traffic control system requiring immediate technical attention.",
                "Traffic signal issue that needs repair to maintain proper traffic flow."
            ],
            'drainage_issue': [
                "Drainage system blockage or malfunction observed that could lead to waterlogging.",
                "Poor drainage conditions that require cleaning and maintenance to prevent flooding.",
                "Drainage infrastructure issue that needs attention to ensure proper water flow."
            ],
            'other': [
                "A civic infrastructure issue has been identified that requires attention from relevant authorities.",
                "Municipal maintenance issue detected that needs proper assessment and resolution.",
                "Public infrastructure concern that requires appropriate municipal intervention."
            ]
        }

        import random
        base_desc = random.choice(descriptions.get(issue_class, descriptions['other']))

        # Add severity assessment
        severity = self._assess_severity(image)
        priority_text = f" Priority level: {severity['level']} - {severity['description']}"

        return base_desc + priority_text

    def _assess_severity(self, image):
        """Assess severity of the civic issue"""
        # Simple severity assessment (enhance with ML in production)
        severities = [
            {"level": "High", "description": "Requires immediate attention within 24-48 hours"},
            {"level": "Medium", "description": "Should be addressed within 3-7 days"},
            {"level": "Low", "description": "Can be scheduled for routine maintenance"}
        ]

        import random
        return random.choice(severities)

    def _get_fallback_description(self, issue_class):
        """Fallback descriptions when AI generation fails"""
        fallbacks = {
            'pothole': "Road damage detected requiring maintenance attention.",
            'garbage_waste': "Waste management issue identified that needs cleanup.",
            'street_light': "Street lighting problem requiring electrical maintenance.",
            'water_leakage': "Water leakage detected needing plumbing repair.",
            'road_damage': "Road infrastructure damage requiring maintenance.",
            'traffic_signal': "Traffic signal malfunction needing technical repair.",
            'other': "Civic infrastructure issue requiring municipal attention."
        }
        return fallbacks.get(issue_class, "Municipal issue detected requiring attention.")

# Initialize the AI classifier
try:
    ai_classifier = CivicIssueClassifier()
    logger.info("AI Classifier initialized successfully")
except Exception as e:
    logger.error(f"Failed to initialize AI Classifier: {e}")
    ai_classifier = None

def decode_base64_image(base64_string):
    """Decode base64 image string to PIL Image"""
    try:
        # Remove data URL prefix if present
        if ',' in base64_string:
            base64_string = base64_string.split(',')[1]

        # Decode base64
        image_data = base64.b64decode(base64_string)
        image = Image.open(io.BytesIO(image_data))

        # Convert to RGB if necessary
        if image.mode != 'RGB':
            image = image.convert('RGB')

        return image
    except Exception as e:
        logger.error(f"Image decoding error: {e}")
        raise ValueError(f"Invalid image format: {e}")

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'ai_available': ai_classifier is not None
    })

@app.route('/analyze', methods=['POST'])
def analyze_image():
    """Main endpoint for image analysis"""
    try:
        # Validate request
        if not request.json:
            return jsonify({'error': 'No JSON data provided'}), 400

        if 'image' not in request.json:
            return jsonify({'error': 'No image data provided'}), 400

        if ai_classifier is None:
            return jsonify({'error': 'AI service unavailable'}), 503

        # Get image data
        base64_image = request.json['image']

        # Optional parameters
        location = request.json.get('location', '')
        user_description = request.json.get('description', '')

        # Decode image
        try:
            image = decode_base64_image(base64_image)
        except ValueError as e:
            return jsonify({'error': str(e)}), 400

        # Classify image
        issue_class, confidence = ai_classifier.classify_image(image)

        # Generate description
        description = ai_classifier.generate_description(image, issue_class)

        # Prepare response
        response = {
            'success': True,
            'classification': {
                'category': issue_class,
                'confidence': round(confidence, 2),
                'human_readable': issue_class.replace('_', ' ').title()
            },
            'description': description,
            'analysis_timestamp': datetime.now().isoformat(),
            'suggestions': {
                'urgency': _get_urgency_level(issue_class),
                'estimated_cost': _get_estimated_cost(issue_class),
                'recommended_action': _get_recommended_action(issue_class)
            }
        }

        # Add location if provided
        if location:
            response['location'] = location

        logger.info(f"Successfully analyzed image: {issue_class} ({confidence:.2f})")
        return jsonify(response)

    except Exception as e:
        logger.error(f"Analysis error: {e}")
        logger.error(traceback.format_exc())
        return jsonify({
            'success': False,
            'error': 'Internal server error',
            'message': str(e)
        }), 500

def _get_urgency_level(issue_class):
    """Get urgency level for different issue types"""
    urgency_map = {
        'pothole': 'High',
        'road_damage': 'High',
        'traffic_signal': 'High',
        'water_leakage': 'Medium',
        'street_light': 'Medium',
        'garbage_waste': 'Medium',
        'drainage_issue': 'Medium',
        'other': 'Low'
    }
    return urgency_map.get(issue_class, 'Medium')

def _get_estimated_cost(issue_class):
    """Get estimated repair cost range"""
    cost_map = {
        'pothole': '₹5,000 - ₹15,000',
        'road_damage': '₹10,000 - ₹50,000',
        'traffic_signal': '₹15,000 - ₹30,000',
        'water_leakage': '₹3,000 - ₹12,000',
        'street_light': '₹2,000 - ₹8,000',
        'garbage_waste': '₹1,000 - ₹5,000',
        'drainage_issue': '₹8,000 - ₹25,000',
        'other': '₹2,000 - ₹10,000'
    }
    return cost_map.get(issue_class, '₹5,000 - ₹20,000')

def _get_recommended_action(issue_class):
    """Get recommended action for issue type"""
    action_map = {
        'pothole': 'Road maintenance and resurfacing required',
        'road_damage': 'Infrastructure repair and traffic management needed',
        'traffic_signal': 'Electrical inspection and signal repair required',
        'water_leakage': 'Plumbing inspection and pipe repair needed',
        'street_light': 'Electrical maintenance and bulb replacement required',
        'garbage_waste': 'Waste collection and area cleaning needed',
        'drainage_issue': 'Drain cleaning and water flow restoration required',
        'other': 'Municipal inspection and appropriate action required'
    }
    return action_map.get(issue_class, 'Municipal assessment required')

@app.route('/categories', methods=['GET'])
def get_categories():
    """Get all available issue categories"""
    if ai_classifier is None:
        return jsonify({'error': 'AI service unavailable'}), 503

    categories = []
    for category in ai_classifier.classes:
        categories.append({
            'id': category,
            'name': category.replace('_', ' ').title(),
            'description': _get_category_description(category)
        })

    return jsonify({
        'categories': categories,
        'total': len(categories)
    })

def _get_category_description(category):
    """Get description for each category"""
    descriptions = {
        'pothole': 'Road surface damage with cavities',
        'garbage_waste': 'Improper waste disposal and accumulation',
        'street_light': 'Non-functional or damaged street lighting',
        'water_leakage': 'Water pipe leaks and seepage issues',
        'road_damage': 'General road infrastructure damage',
        'traffic_signal': 'Malfunctioning traffic control systems',
        'drainage_issue': 'Blocked or damaged drainage systems',
        'tree_fallen': 'Fallen trees blocking roads or pathways',
        'illegal_dumping': 'Unauthorized waste disposal',
        'broken_infrastructure': 'Damaged public infrastructure',
        'other': 'Other civic issues requiring attention'
    }
    return descriptions.get(category, 'Municipal infrastructure issue')

@app.errorhandler(413)
def file_too_large(e):
    return jsonify({'error': 'File too large. Maximum size is 16MB.'}), 413

@app.errorhandler(404)
def not_found(e):
    return jsonify({'error': 'Endpoint not found'}), 404

@app.errorhandler(500)
def internal_error(e):
    return jsonify({'error': 'Internal server error'}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    debug = os.environ.get('FLASK_ENV') == 'development'

    logger.info(f"Starting UrbanEye AI API on port {port}")
    app.run(host='0.0.0.0', port=port, debug=debug)