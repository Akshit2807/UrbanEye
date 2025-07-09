// lib/services/ai_service.dart
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AIAnalysisResult {
  final String category;
  final double confidence;
  final String humanReadable;
  final String description;
  final String urgency;
  final String estimatedCost;
  final String recommendedAction;
  final DateTime analysisTimestamp;

  AIAnalysisResult({
    required this.category,
    required this.confidence,
    required this.humanReadable,
    required this.description,
    required this.urgency,
    required this.estimatedCost,
    required this.recommendedAction,
    required this.analysisTimestamp,
  });

  factory AIAnalysisResult.fromJson(Map<String, dynamic> json) {
    return AIAnalysisResult(
      category: json['classification']['category'],
      confidence: json['classification']['confidence'].toDouble(),
      humanReadable: json['classification']['human_readable'],
      description: json['description'],
      urgency: json['suggestions']['urgency'],
      estimatedCost: json['suggestions']['estimated_cost'],
      recommendedAction: json['suggestions']['recommended_action'],
      analysisTimestamp: DateTime.parse(json['analysis_timestamp']),
    );
  }
}

class IssueCategory {
  final String id;
  final String name;
  final String description;

  IssueCategory({
    required this.id,
    required this.name,
    required this.description,
  });

  factory IssueCategory.fromJson(Map<String, dynamic> json) {
    return IssueCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

class AIService {
  static const String _baseUrl = 'https://urbaneye-ai-api.onrender.com'; // Replace with your Render URL
  static const Duration _timeout = Duration(seconds: 30);

  // Convert image file to base64
  static String _imageToBase64(File imageFile) {
    final bytes = imageFile.readAsBytesSync();
    return base64Encode(bytes);
  }

  // Convert Uint8List to base64
  static String _uint8ListToBase64(Uint8List bytes) {
    return base64Encode(bytes);
  }

  // Check API health
  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['status'] == 'healthy' && data['ai_available'] == true;
      }
      return false;
    } catch (e) {
      print('Health check failed: $e');
      return false;
    }
  }

  // Analyze image from File
  static Future<AIAnalysisResult?> analyzeImageFile(
      File imageFile, {
        String? location,
        String? userDescription,
      }) async {
    try {
      final base64Image = _imageToBase64(imageFile);
      return await _analyzeImage(base64Image, location, userDescription);
    } catch (e) {
      print('Error analyzing image file: $e');
      throw Exception('Failed to process image file: $e');
    }
  }

  // Analyze image from Uint8List
  static Future<AIAnalysisResult?> analyzeImageBytes(
      Uint8List imageBytes, {
        String? location,
        String? userDescription,
      }) async {
    try {
      final base64Image = _uint8ListToBase64(imageBytes);
      return await _analyzeImage(base64Image, location, userDescription);
    } catch (e) {
      print('Error analyzing image bytes: $e');
      throw Exception('Failed to process image bytes: $e');
    }
  }

  // Internal method to analyze image
  static Future<AIAnalysisResult?> _analyzeImage(
      String base64Image,
      String? location,
      String? userDescription,
      ) async {
    try {
      // Prepare request body
      final Map<String, dynamic> requestBody = {
        'image': base64Image,
      };

      if (location != null && location.isNotEmpty) {
        requestBody['location'] = location;
      }

      if (userDescription != null && userDescription.isNotEmpty) {
        requestBody['description'] = userDescription;
      }

      // Make API request
      final response = await http.post(
        Uri.parse('$_baseUrl/analyze'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          return AIAnalysisResult.fromJson(data);
        } else {
          throw Exception(data['error'] ?? 'Analysis failed');
        }
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['error'] ?? 'Invalid request');
      } else if (response.statusCode == 503) {
        throw Exception('AI service is currently unavailable');
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in AI analysis: $e');
      if (e is Exception) {
        rethrow;
      } else {
        throw Exception('Network error: Failed to connect to AI service');
      }
    }
  }

  // Get available categories
  static Future<List<IssueCategory>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> categoriesJson = data['categories'];

        return categoriesJson
            .map((categoryJson) => IssueCategory.fromJson(categoryJson))
            .toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error getting categories: $e');
      throw Exception('Failed to load categories: $e');
    }
  }

  // Validate image file
  static bool isValidImageFile(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'bmp', 'webp'].contains(extension);
  }

  // Check file size (max 16MB)
  static bool isValidFileSize(File file) {
    const maxSize = 16 * 1024 * 1024; // 16MB
    return file.lengthSync() <= maxSize;
  }

  // Validate image
  static Future<String?> validateImage(File imageFile) async {
    if (!isValidImageFile(imageFile)) {
      return 'Invalid image format. Please use JPG, PNG, or WebP.';
    }

    if (!isValidFileSize(imageFile)) {
      return 'File too large. Maximum size is 16MB.';
    }

    return null; // Valid
  }
}

// Usage example widget
/*
class AIAnalysisWidget extends StatefulWidget {
  final File imageFile;
  final String? location;

  const AIAnalysisWidget({
    Key? key,
    required this.imageFile,
    this.location,
  }) : super(key: key);

  @override
  State<AIAnalysisWidget> createState() => _AIAnalysisWidgetState();
}

class _AIAnalysisWidgetState extends State<AIAnalysisWidget> {
  AIAnalysisResult? _result;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _analyzeImage();
  }

  Future<void> _analyzeImage() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Validate image first
      final validationError = await AIService.validateImage(widget.imageFile);
      if (validationError != null) {
        throw Exception(validationError);
      }

      // Check if service is healthy
      final isHealthy = await AIService.checkHealth();
      if (!isHealthy) {
        throw Exception('AI service is currently unavailable');
      }

      // Analyze image
      final result = await AIService.analyzeImageFile(
        widget.imageFile,
        location: widget.location,
      );

      setState(() {
        _result = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Analyzing image with AI...'),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text('Error: $_error'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _analyzeImage,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_result != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Analysis Result',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Chip(
                        label: Text(_result!.humanReadable),
                        backgroundColor: Colors.blue.shade100,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${(_result!.confidence * 100).toStringAsFixed(1)}% confident',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Description:',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 4),
                  Text(_result!.description),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Urgency: ${_result!.urgency}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getUrgencyColor(_result!.urgency),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text('Cost: ${_result!.estimatedCost}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Recommended Action:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  SizedBox(height: 4),
                  Text(_result!.recommendedAction),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox.shrink();
  }

  Color _getUrgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
*/