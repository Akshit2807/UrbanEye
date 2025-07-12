// views/civilian/report_issue_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportIssuePage extends StatefulWidget {
  const ReportIssuePage({Key? key}) : super(key: key);

  @override
  State<ReportIssuePage> createState() => _ReportIssuePageState();
}

class _ReportIssuePageState extends State<ReportIssuePage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  File? _selectedImage;
  String? _aiDescription;
  String? _issueCategory;
  String? _selectedService;
  bool _isAnalyzing = false;
  bool _isSubmitting = false;

  // Updated API URL - make sure this matches your backend URL
  static const String API_BASE_URL = 'https://ue-backend.onrender.com';

  final List<String> _categories = [
    'Pothole',
    'Garbage/Waste',
    'Street Light',
    'Water Leakage',
    'Road Damage',
    'Traffic Signal',
    'Other'
  ];

  final List<Map<String, dynamic>> _services = [
    {
      'type': 'Government',
      'title': 'Municipal Corporation',
      'subtitle': 'Official government channel',
      'icon': Icons.account_balance_rounded,
      'color': AppColors.primary,
    },
    {
      'type': 'NGO',
      'title': 'Local NGOs',
      'subtitle': 'Community organizations',
      'icon': Icons.volunteer_activism_rounded,
      'color': AppColors.secondary,
    },
    {
      'type': 'Local Worker',
      'title': 'Private Contractors',
      'subtitle': 'Paid service providers',
      'icon': Icons.business_center_rounded,
      'color': AppColors.accent,
    },
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _isAnalyzing = true;
          // Reset previous results
          _aiDescription = null;
          _issueCategory = null;
        });

        await _analyzeImage();
      }
    } catch (e) {
      print("Error picking image: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error selecting image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    print("Image selected: ${_selectedImage!.path}");

    setState(() {
      _isAnalyzing = true;
    });

    try {
      // First check if the backend is reachable
      print("Checking backend health...");
      final healthResponse = await http.get(
        Uri.parse('$API_BASE_URL/health'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 10));

      print("Health check status: ${healthResponse.statusCode}");
      print("Health check body: ${healthResponse.body}");

      if (healthResponse.statusCode != 200) {
        throw Exception('Backend server is not reachable');
      }

      print("Sending image to API...");

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$API_BASE_URL/report_civic_issue'),
      );

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
      });

      // Add the image file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _selectedImage!.path,
          filename: 'issue_image.jpg',
        ),
      );

      print("Request headers: ${request.headers}");
      print("Request files: ${request.files.map((f) => f.filename)}");

      // Send request with timeout
      var streamedResponse = await request.send().timeout(Duration(seconds: 30));
      var response = await http.Response.fromStream(streamedResponse);

      print("API response status: ${response.statusCode}");
      print("API response headers: ${response.headers}");
      print("API response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        print("Parsed JSON: $jsonResponse");

        // Handle the updated response format from your backend
        if (jsonResponse['success'] == true) {
          if (jsonResponse['issues_detected'] == true &&
              jsonResponse['issues'] != null &&
              jsonResponse['issues'].isNotEmpty) {

            // Extract first issue for display
            final firstIssue = jsonResponse['issues'][0];

            setState(() {
              _aiDescription = firstIssue['description'] ?? 'Issue detected in the image';
              _issueCategory = _mapIssueTypeToCategory(firstIssue['category'] ?? firstIssue['type'] ?? 'Other');
            });
          } else {
            // No issues detected
            setState(() {
              _aiDescription = null;
              _issueCategory = null;
              _selectedImage = null;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(jsonResponse['message'] ?? 'No civic issues detected in the image. Please try another photo.'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        } else {
          throw Exception(jsonResponse['message'] ?? 'Analysis failed');
        }
      } else if (response.statusCode == 502) {
        throw Exception('Backend server error (502). Please try again later.');
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Invalid request');
      } else {
        throw Exception('Server error (${response.statusCode}). Please try again.');
      }
    } catch (e) {
      print("Error analyzing image: $e");
      setState(() {
        _aiDescription = null;
        _issueCategory = null;
        _selectedImage = null;
      });

      String errorMessage = 'AI Analysis failed. Please try again.';
      if (e.toString().contains('502')) {
        errorMessage = 'Backend server is temporarily unavailable. Please try again later.';
      } else if (e.toString().contains('timeout')) {
        errorMessage = 'Request timed out. Please check your internet connection and try again.';
      } else if (e.toString().contains('not reachable')) {
        errorMessage = 'Cannot connect to the server. Please check your internet connection.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  // Helper method to map backend issue types to frontend categories
  String _mapIssueTypeToCategory(String issueType) {
    switch (issueType.toLowerCase()) {
      case 'pothole':
        return 'Pothole';
      case 'garbage':
      case 'waste':
      case 'illegal_dumping':
        return 'Garbage/Waste';
      case 'streetlight':
      case 'street_light':
        return 'Street Light';
      case 'sewage':
      case 'drainage':
      case 'waterlogging':
        return 'Water Leakage';
      case 'infrastructure':
      case 'sidewalk':
        return 'Road Damage';
      case 'traffic_signal':
        return 'Traffic Signal';
      default:
        return 'Other';
    }
  }

  void _submitReport() async {
    if (_formKey.currentState!.validate() && _selectedImage != null && _selectedService != null) {
      setState(() {
        _isSubmitting = true;
      });

      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report submitted to $_selectedService! 🎉'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } else {
      // Show validation errors
      String errorMessage = '';
      if (_selectedImage == null) {
        errorMessage = 'Please select an image';
      } else if (_selectedService == null) {
        errorMessage = 'Please select a service type';
      } else {
        errorMessage = 'Please fill in all required fields';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: AppColors.warning,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Issue'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCameraSection(),
                if (_selectedImage != null) ...[
                  const SizedBox(height: 24),
                  _buildImagePreview(),
                ],
                if (_isAnalyzing) ...[
                  const SizedBox(height: 24),
                  _buildAnalyzingSection(),
                ],
                if (_aiDescription != null) ...[
                  const SizedBox(height: 24),
                  _buildAIAnalysis(),
                  const SizedBox(height: 24),
                  _buildCategorySelection(),
                  const SizedBox(height: 24),
                  _buildDescriptionField(),
                  const SizedBox(height: 24),
                  _buildLocationField(),
                  const SizedBox(height: 24),
                  _buildServiceSelection(),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                ],
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraSection() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showImageSourceDialog(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Capture or Select Photo',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Take a clear photo of the issue',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, end: 0, duration: 600.ms);
  }

  Widget _buildImagePreview() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
        ),
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .scale(delay: 200.ms, duration: 600.ms);
  }

  Widget _buildAnalyzingSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'AI is analyzing your image...',
            style: AppTextStyles.subtitle1.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few seconds',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .shimmer(delay: 500.ms, duration: 2000.ms);
  }

  Widget _buildAIAnalysis() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.info.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.info,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'AI Analysis',
                style: AppTextStyles.subtitle1.copyWith(
                  color: AppColors.info,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _aiDescription!,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Looks correct?',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    _aiDescription = null;
                    _issueCategory = null;
                  });
                },
                child: const Text('Edit'),
              ),
            ],
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, end: 0, duration: 600.ms);
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Issue Category',
          style: AppTextStyles.subtitle1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _categories.map((category) {
            final isSelected = _issueCategory == category;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _issueCategory = category;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.textTertiary.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  category,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate()
        .fadeIn(delay: 200.ms, duration: 600.ms);
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (Optional)',
          style: AppTextStyles.subtitle1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'Add any additional details...',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    ).animate()
        .fadeIn(delay: 400.ms, duration: 600.ms);
  }

  Widget _buildLocationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: AppTextStyles.subtitle1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _locationController,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the location';
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Enter location or address',
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textTertiary,
              ),
              prefixIcon: const Icon(
                Icons.location_on_rounded,
                color: AppColors.primary,
              ),
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.my_location_rounded,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  _locationController.text = "Current Location";
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    ).animate()
        .fadeIn(delay: 600.ms, duration: 600.ms);
  }

  Widget _buildServiceSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Service Type',
          style: AppTextStyles.subtitle1.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          children: _services.map((service) {
            final isSelected = _selectedService == service['type'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedService = service['type'];
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? service['color'].withOpacity(0.1) : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? service['color'] : AppColors.textTertiary.withOpacity(0.2),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: service['color'].withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        service['icon'],
                        color: service['color'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            service['title'],
                            style: AppTextStyles.subtitle2.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            service['subtitle'],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle_rounded,
                        color: service['color'],
                        size: 24,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    ).animate()
        .fadeIn(delay: 800.ms, duration: 600.ms);
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isSubmitting ? null : _submitReport,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: _isSubmitting
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.5,
              ),
            )
                : Text(
              'Submit Report',
              style: AppTextStyles.button,
            ),
          ),
        ),
      ),
    ).animate()
        .fadeIn(delay: 1000.ms, duration: 600.ms)
        .slideY(begin: 0.3, end: 0, delay: 1000.ms, duration: 600.ms);
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textTertiary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Select Image Source',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildSourceOption(
                      title: 'Camera',
                      icon: Icons.camera_alt_rounded,
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSourceOption(
                      title: 'Gallery',
                      icon: Icons.photo_library_rounded,
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSourceOption({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.textTertiary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: AppTextStyles.subtitle2.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}