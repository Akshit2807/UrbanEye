// views/auth/signup_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:math' as math;
import '../../utils/app_colors.dart';
import '../../utils/app_text_styles.dart';
import '../../services/auth_service.dart';
import '../../views/civilian/civilian_dashboard.dart';
import '../../views/social_worker/social_worker_dashboard.dart';
import 'widgets/animated_auth_field.dart';
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
  final _authService = AuthService();

  late AnimationController _progressController;
  late AnimationController _floatingController;
  late AnimationController _rotationController;

  int _currentStep = 0;
  bool _isLoading = false;

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();
  final _nagarNigamController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
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
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _rotationController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _floatingController.dispose();
    _rotationController.dispose();
    // Dispose all controllers
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

  Gradient _getRoleGradient() {
    return widget.role == 'civilian'
        ? AppColors.primaryGradient
        : AppColors.secondaryGradient;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: _getRoleGradient(),
        ),
        child: Stack(
          children: [
            _buildAnimatedBackground(),

            SafeArea(
              child: Column(
                children: [
                  _buildEpicHeader(),
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
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _floatingController,
          builder: (context, child) {
            return Positioned(
              top: 150 + _floatingController.value * 40,
              right: 20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            return Positioned(
              bottom: 300,
              left: 30,
              child: Transform.rotate(
                angle: _rotationController.value * 2 * math.pi,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEpicHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Navigation and title
          Row(
            children: [
              GestureDetector(
                onTap: _currentStep == 0
                    ? () => Navigator.pop(context)
                    : () {
                  setState(() => _currentStep = 0);
                  _progressController.reverse();
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                  );
                },
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

              const Spacer(),

              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Colors.white, Colors.white.withOpacity(0.8)],
                ).createShader(bounds),
                child: Text(
                  'Join UrbanEye',
                  style: AppTextStyles.heading2.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ).animate()
                  .fadeIn(delay: 400.ms, duration: 600.ms),

              const Spacer(),
              const SizedBox(width: 44),
            ],
          ),

          const SizedBox(height: 32),

          // Epic Progress Visualization
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildStepIndicator(0, 'Basic Info', Icons.person_outline_rounded),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _progressController,
                        builder: (context, child) {
                          return Container(
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white,
                                  _currentStep >= 1 ? Colors.white : Colors.white.withAlpha((0.3 * 255).toInt()),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    _buildStepIndicator(1, 'Details', widget.role == 'civilian'
                        ? Icons.location_on_outlined
                        : Icons.work_outline_rounded),
                  ],
                ),
              ],
            ),
          ).animate()
              .fadeIn(delay: 600.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0, delay: 600.ms),

          const SizedBox(height: 20),

          Text(
            'Create your ${_getRoleTitle()} account',
            style: AppTextStyles.subtitle1.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ).animate()
              .fadeIn(delay: 800.ms, duration: 600.ms),
        ],
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'Tell us about yourself',
                style: AppTextStyles.heading3.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                ),
                textAlign: TextAlign.center,
              ).animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0, delay: 200.ms),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: AnimatedAuthField(
                      label: 'First Name',
                      hint: 'Enter first name',
                      controller: _firstNameController,
                      animationDelay: 400,
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
                      animationDelay: 600,
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
                animationDelay: 800,
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
                animationDelay: 1000,
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
                animationDelay: 1200,
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
                animationDelay: 1400,
                prefixIcon: const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.textTertiary,
                ),
              ),

              const SizedBox(height: 32),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.info.withOpacity(0.1),
                      AppColors.primary.withOpacity(0.05),
                    ],
                  ),
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
                  .fadeIn(delay: 1600.ms, duration: 600.ms)
                  .slideY(begin: 0.3, end: 0, delay: 1600.ms),
            ],
          ),
        ),
      ).animate()
          .fadeIn(delay: 100.ms, duration: 800.ms)
          .slideY(begin: 0.3, end: 0, delay: 100.ms, duration: 800.ms),
    );
  }

  Widget _buildAdditionalInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              widget.role == 'civilian'
                  ? 'Where are you located?'
                  : 'Tell us about your work',
              style: AppTextStyles.heading3.copyWith(
                color: AppColors.textPrimary,
                fontSize: 22,
              ),
              textAlign: TextAlign.center,
            ).animate()
                .fadeIn(delay: 200.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0, delay: 200.ms),

            const SizedBox(height: 32),

            if (widget.role == 'civilian') ..._buildCivilianFields(),
            if (widget.role == 'social_worker') ..._buildSocialWorkerFields(),
          ],
        ),
      ).animate()
          .fadeIn(delay: 100.ms, duration: 800.ms)
          .slideY(begin: 0.3, end: 0, delay: 100.ms, duration: 800.ms),
    );
  }

  Widget _buildStepIndicator(int step, String label, IconData icon) {
    final isActive = _currentStep == step;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
            shape: BoxShape.circle,
            boxShadow: isActive
                ? [
              BoxShadow(
                color: Colors.white.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Icon(
            icon,
            color: isActive ? _getRoleGradient().colors.first : Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withOpacity(isActive ? 1.0 : 0.7),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildCivilianFields() {
    return [
      AnimatedAuthField(
        label: 'Full Address',
        hint: 'Enter your complete address',
        controller: _addressController,
        animationDelay: 400,
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
        animationDelay: 600,
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
              animationDelay: 800,
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
              animationDelay: 1000,
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
        animationDelay: 1200,
        prefixIcon: const Icon(
          Icons.pin_drop_outlined,
          color: AppColors.textTertiary,
        ),
      ),
    ];
  }

  List<Widget> _buildSocialWorkerFields() {
    return [
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
              .fadeIn(delay: 400.ms, duration: 600.ms),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildCategoryCard(
                  'Government',
                  'government',
                  Icons.account_balance_rounded,
                  AppColors.primaryGradient,
                  600,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCategoryCard(
                  'NGO',
                  'ngo',
                  Icons.volunteer_activism_rounded,
                  AppColors.secondaryGradient,
                  800,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCategoryCard(
                  'Private',
                  'private',
                  Icons.business_center_rounded,
                  AppColors.accentGradient,
                  1000,
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
        animationDelay: 1200,
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
        animationDelay: 1400,
        prefixIcon: const Icon(
          Icons.build_outlined,
          color: AppColors.textTertiary,
        ),
      ),
    ];
  }

  Widget _buildCategoryCard(
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
            color: isSelected ? null : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : AppColors.textTertiary.withOpacity(0.3),
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
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              gradient: _getRoleGradient(),
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
                onTap: _isLoading ? null : () {
                  if (_currentStep == 0) {
                    if (_validateBasicInfo()) {
                      setState(() => _currentStep = 1);
                      _progressController.forward();
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutCubic,
                      );
                    }
                  } else {
                    _handleSignup();
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Center(
                  child: _isLoading
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : Text(
                    _currentStep == 0 ? 'Continue' : 'Create My Account',
                    style: AppTextStyles.button.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ).animate()
              .fadeIn(delay: 200.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0, delay: 200.ms),

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
              .fadeIn(delay: 400.ms, duration: 600.ms),
        ],
      ),
    );
  }

  bool _validateBasicInfo() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      _showErrorSnackBar('Please fill all required fields');
      return false;
    }

    if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$')
        .hasMatch(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return false;
    }

    if (_passwordController.text.length < 6) {
      _showErrorSnackBar('Password must be at least 6 characters');
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorSnackBar('Passwords do not match');
      return false;
    }

    return true;
  }

  Future<void> _handleSignup() async {
    if (widget.role == 'civilian') {
      if (_addressController.text.isEmpty ||
          _nagarNigamController.text.isEmpty ||
          _cityController.text.isEmpty ||
          _stateController.text.isEmpty) {
        _showErrorSnackBar('Please fill all required fields');
        return;
      }
    } else {
      if (_selectedCategory == null ||
          _areaOfServiceController.text.isEmpty ||
          _skillsController.text.isEmpty) {
        _showErrorSnackBar('Please fill all required fields');
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, dynamic> userData = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phone': _phoneController.text.trim(),
      };

      if (widget.role == 'civilian') {
        userData.addAll({
          'address': _addressController.text.trim(),
          'nagarNigam': _nagarNigamController.text.trim(),
          'city': _cityController.text.trim(),
          'state': _stateController.text.trim(),
          'pincode': _pincodeController.text.trim(),
        });
      } else {
        userData.addAll({
          'category': _selectedCategory!,
          'areaOfService': _areaOfServiceController.text.trim(),
          'skills': _skillsController.text.trim().split(',').map((s) => s.trim()).toList(),
        });
      }

      final result = await _authService.signUpWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: widget.role,
        userData: userData,
      );

      if (result != null && result.user != null) {
        if (mounted) {
          if (widget.role == 'civilian') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const CivilianDashboard(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SocialWorkerDashboard(category: _selectedCategory!),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

