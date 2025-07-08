// views/auth/signup_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:urbaneye/views/auth/widgets/auth_button.dart';
import 'dart:ui';
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import 'widgets/animated_auth_field.dart';
import 'widgets/glassmorphic_container.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  final String role;

  const SignupPage({Key? key, required this.role}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  late AnimationController _progressController;
  late AnimationController _floatingController;

  int _currentStep = 0;
  bool _isLoading = false;

  // Basic Info Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Additional Info Controllers (Civilian)
  final _addressController = TextEditingController();
  final _nagarNigamController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  // Social Worker Specific Controllers
  final _areaOfServiceController = TextEditingController();
  final _skillsController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _progressController.dispose();
    _floatingController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _nagarNigamController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _areaOfServiceController.dispose();
    _skillsController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  String _getRoleTitle() {
    return widget.role == 'civilian' ? 'Civilian' : 'Social Worker';
  }

  IconData _getRoleIcon() {
    return widget.role == 'civilian' ? Icons.person_rounded : Icons.volunteer_activism_rounded;
  }

  Gradient _getRoleGradient() {
    return widget.role == 'civilian'
        ? AppColors.primaryGradient
        : AppColors.secondaryGradient;
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_validateBasicInfo()) {
        setState(() {
          _currentStep = 1;
        });
        _progressController.forward();
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        );
      }
    } else {
      _handleSignup();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep = 0;
      });
      _progressController.reverse();
      _pageController.previousPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    }
  }

  bool _validateBasicInfo() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showCustomSnackBar('Please fill all required fields', AppColors.error);
      return false;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(_emailController.text)) {
      _showCustomSnackBar('Please enter a valid email', AppColors.error);
      return false;
    }

    if (_passwordController.text.length < 6) {
      _showCustomSnackBar('Password must be at least 6 characters', AppColors.error);
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showCustomSnackBar('Passwords do not match', AppColors.error);
      return false;
    }

    return true;
  }

  void _handleSignup() async {
    if (widget.role == 'civilian') {
      if (_addressController.text.isEmpty ||
          _nagarNigamController.text.isEmpty ||
          _cityController.text.isEmpty ||
          _stateController.text.isEmpty) {
        _showCustomSnackBar('Please fill all required fields', AppColors.error);
        return;
      }
    } else {
      if (_selectedCategory == null ||
          _areaOfServiceController.text.isEmpty ||
          _skillsController.text.isEmpty) {
        _showCustomSnackBar('Please fill all required fields', AppColors.error);
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    // TODO: Implement Firebase Auth signup and Firestore data storage
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    _showCustomSnackBar('Account created successfully! 🎉', AppColors.success);
  }

  void _showCustomSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _getRoleGradient(),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAnimatedHeader(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildBasicInfoStep(),
                    _buildAdditionalInfoStep(),
                  ],
                ),
              ),
              _buildBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Back button and title row
          Row(
            children: [
              GestureDetector(
                onTap: _currentStep == 0
                    ? () => Navigator.pop(context)
                    : _previousStep,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms).scale(delay: 200.ms),

              const SizedBox(width: 20),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: AppTextStyles.heading2.copyWith(color: Colors.white),
                    ).animate()
                        .fadeIn(delay: 600.ms, duration: 600.ms)
                        .slideX(begin: 0.3, end: 0, delay: 600.ms),

                    Text(
                      _getRoleTitle(),
                      style: AppTextStyles.subtitle2.copyWith(
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ).animate()
                        .fadeIn(delay: 800.ms, duration: 600.ms)
                        .slideX(begin: 0.3, end: 0, delay: 800.ms),
                  ],
                ),
              ),

              // Floating animated icon
              AnimatedBuilder(
                animation: _floatingController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _floatingController.value * 10 - 5),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        _getRoleIcon(),
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ).animate()
                  .fadeIn(delay: 1000.ms, duration: 600.ms)
                  .scale(delay: 1000.ms, duration: 600.ms),
            ],
          ),

          const SizedBox(height: 32),

          // Enhanced Progress Indicator
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.white, Colors.white70],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _progressController,
                    builder: (context, child) {
                      return Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: _currentStep >= 1
                              ? const LinearGradient(
                            colors: [Colors.white, Colors.white70],
                          )
                              : null,
                          color: _currentStep >= 1
                              ? null
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ).animate()
              .fadeIn(delay: 1200.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0, delay: 1200.ms),

          const SizedBox(height: 16),

          // Step labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Basic Info',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _currentStep >= 1
                          ? Colors.white.withOpacity(0.2)
                          : Colors.white.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.role == 'civilian'
                          ? Icons.location_on_outlined
                          : Icons.work_outline_rounded,
                      color: Colors.white.withOpacity(_currentStep >= 1 ? 1.0 : 0.5),
                      size: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.role == 'civilian' ? 'Location Details' : 'Work Details',
                    style: AppTextStyles.caption.copyWith(
                      color: Colors.white.withOpacity(_currentStep >= 1 ? 1.0 : 0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ).animate()
              .fadeIn(delay: 1400.ms, duration: 600.ms),
        ],
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GlassmorphicContainer(
        borderRadius: BorderRadius.circular(32),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  'Tell us about yourself',
                  style: AppTextStyles.heading3,
                  textAlign: TextAlign.center,
                ).animate()
                    .fadeIn(delay: 400.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, delay: 400.ms),

                const SizedBox(height: 32),

                Row(
                  children: [
                    Expanded(
                      child: AnimatedAuthField(
                        label: 'First Name',
                        hint: 'Enter first name',
                        controller: _firstNameController,
                        animationDelay: 600,
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: AnimatedAuthField(
                        label: 'Last Name',
                        hint: 'Enter last name',
                        controller: _lastNameController,
                        animationDelay: 800,
                        prefixIcon: const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                AnimatedAuthField(
                  label: 'Email Address',
                  hint: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  animationDelay: 1000,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.textTertiary,
                  ),
                ),

                const SizedBox(height: 24),

                AnimatedAuthField(
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  animationDelay: 1200,
                  prefixIcon: const Icon(
                    Icons.phone_outlined,
                    color: AppColors.textTertiary,
                  ),
                ),

                const SizedBox(height: 24),

                AnimatedAuthField(
                  label: 'Password',
                  hint: 'Create a strong password',
                  controller: _passwordController,
                  isPassword: true,
                  animationDelay: 1400,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textTertiary,
                  ),
                ),

                const SizedBox(height: 24),

                AnimatedAuthField(
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  animationDelay: 1600,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textTertiary,
                  ),
                ),

                const SizedBox(height: 32),

                // Security Tips
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.info.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.security_rounded,
                        color: AppColors.info,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your data is encrypted and secure with us',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.info,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate()
                    .fadeIn(delay: 1800.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, delay: 1800.ms),
              ],
            ),
          ),
        ),
      ).animate()
          .fadeIn(delay: 200.ms, duration: 800.ms)
          .slideY(begin: 0.3, end: 0, delay: 200.ms, duration: 800.ms),
    );
  }

  Widget _buildAdditionalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GlassmorphicContainer(
        borderRadius: BorderRadius.circular(32),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Text(
                widget.role == 'civilian'
                    ? 'Where are you located?'
                    : 'Tell us about your work',
                style: AppTextStyles.heading3,
                textAlign: TextAlign.center,
              ).animate()
                  .fadeIn(delay: 400.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0, delay: 400.ms),

              const SizedBox(height: 32),

              if (widget.role == 'civilian') ..._buildCivilianFields(),
              if (widget.role == 'social_worker') ..._buildSocialWorkerFields(),
            ],
          ),
        ),
      ).animate()
          .fadeIn(delay: 200.ms, duration: 800.ms)
          .slideY(begin: 0.3, end: 0, delay: 200.ms, duration: 800.ms),
    );
  }

  List<Widget> _buildCivilianFields() {
    return [
      AnimatedAuthField(
        label: 'Full Address',
        hint: 'Enter your complete address',
        controller: _addressController,
        animationDelay: 600,
        prefixIcon: const Icon(
          Icons.home_outlined,
          color: AppColors.textTertiary,
        ),
      ),

      const SizedBox(height: 24),

      AnimatedAuthField(
        label: 'Nagar Nigam/Palika/Panchayat',
        hint: 'Enter your local authority',
        controller: _nagarNigamController,
        animationDelay: 800,
        prefixIcon: const Icon(
          Icons.business_outlined,
          color: AppColors.textTertiary,
        ),
      ),

      const SizedBox(height: 24),

      Row(
        children: [
          Expanded(
            child: AnimatedAuthField(
              label: 'City',
              hint: 'Enter city',
              controller: _cityController,
              animationDelay: 1000,
              prefixIcon: const Icon(
                Icons.location_city_outlined,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: AnimatedAuthField(
              label: 'State',
              hint: 'Enter state',
              controller: _stateController,
              animationDelay: 1200,
              prefixIcon: const Icon(
                Icons.map_outlined,
                color: AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 24),

      AnimatedAuthField(
        label: 'Pincode',
        hint: 'Enter your area pincode',
        controller: _pincodeController,
        keyboardType: TextInputType.number,
        animationDelay: 1400,
        prefixIcon: const Icon(
          Icons.pin_drop_outlined,
          color: AppColors.textTertiary,
        ),
      ),

      const SizedBox(height: 32),

      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.success.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              color: AppColors.success,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'This helps us connect you with local authorities',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ).animate()
          .fadeIn(delay: 1600.ms, duration: 600.ms)
          .slideY(begin: 0.3, end: 0, delay: 1600.ms),
    ];
  }

  List<Widget> _buildSocialWorkerFields() {
    return [
      // Enhanced Category Selection
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Your Category',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ).animate()
              .fadeIn(delay: 600.ms, duration: 600.ms),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildEnhancedCategoryCard(
                  'Government',
                  'government',
                  Icons.account_balance_rounded,
                  AppColors.primaryGradient,
                  800,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEnhancedCategoryCard(
                  'NGO',
                  'ngo',
                  Icons.volunteer_activism_rounded,
                  AppColors.secondaryGradient,
                  1000,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEnhancedCategoryCard(
                  'Private',
                  'private',
                  Icons.business_center_rounded,
                  AppColors.accentGradient,
                  1200,
                ),
              ),
            ],
          ),
        ],
      ),

      const SizedBox(height: 32),

      AnimatedAuthField(
        label: 'Area of Service',
        hint: 'e.g., Bhopal, Indore, etc.',
        controller: _areaOfServiceController,
        animationDelay: 1400,
        prefixIcon: const Icon(
          Icons.place_outlined,
          color: AppColors.textTertiary,
        ),
      ),

      const SizedBox(height: 24),

      AnimatedAuthField(
        label: 'Skills & Expertise',
        hint: 'e.g., Road repair, Waste management, etc.',
        controller: _skillsController,
        animationDelay: 1600,
        prefixIcon: const Icon(
          Icons.build_outlined,
          color: AppColors.textTertiary,
        ),
      ),

      const SizedBox(height: 32),

      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.warning.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.warning.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.star_rounded,
              color: AppColors.warning,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Your profile will be reviewed for verification',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ).animate()
          .fadeIn(delay: 1800.ms, duration: 600.ms)
          .slideY(begin: 0.3, end: 0, delay: 1800.ms),
    ];
  }

  Widget _buildEnhancedCategoryCard(
      String title,
      String value,
      IconData icon,
      Gradient gradient,
      int delay,
      ) {
    final isSelected = _selectedCategory == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        transform: Matrix4.identity()
          ..scale(isSelected ? 1.05 : 1.0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? gradient : null,
            color: isSelected ? null : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.3)
                    : Colors.black.withOpacity(0.05),
                blurRadius: isSelected ? 20 : 10,
                offset: Offset(0, isSelected ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.2)
                      : AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: AppTextStyles.caption.copyWith(
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ).animate()
        .fadeIn(delay: Duration(milliseconds: delay), duration: 600.ms)
        .slideY(begin: 0.3, end: 0, delay: Duration(milliseconds: delay), duration: 600.ms);
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          GradientButton(
            text: _currentStep == 0 ? 'Continue' : 'Create My Account',
            gradient: _getRoleGradient(),
            onPressed: _nextStep,
            isLoading: _isLoading,
            animationDelay: 400,
          ),

          const SizedBox(height: 16),

          if (_currentStep == 1)
            GradientButton(
              text: 'Back to Basic Info',
              onPressed: _previousStep,
              isOutlined: true,
              color: Colors.white,
              animationDelay: 600,
            ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account? ',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, _) =>
                          LoginPage(role: widget.role),
                      transitionsBuilder: (context, animation, _, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(-1.0, 0.0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          )),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Text(
                  'Sign In',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ).animate()
              .fadeIn(delay: 800.ms, duration: 600.ms),
        ],
      ),
    );
  }
}