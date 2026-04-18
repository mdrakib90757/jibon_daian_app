import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:jibon_Bachan_app/shared/widgets/app_dropdown_field.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/widgets.dart';

class HospitalRegistrationScreen extends StatefulWidget {
  const HospitalRegistrationScreen({super.key});

  @override
  State<HospitalRegistrationScreen> createState() =>
      _HospitalRegistrationScreenState();
}

class _HospitalRegistrationScreenState
    extends State<HospitalRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Basic Information Controllers
  final _hospitalNameController = TextEditingController();
  final _registrationNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alternatePhoneController = TextEditingController();
  final _websiteController = TextEditingController();

  // Location Controllers
  final _addressController = TextEditingController();
  final _zoneController = TextEditingController();

  // Details Controllers
  final _directorNameController = TextEditingController();
  final _directorPhoneController = TextEditingController();
  final _headDoctorNameController = TextEditingController();
  final _headDoctorQualificationController = TextEditingController();

  // Blood Stock Controllers
  final Map<String, TextEditingController> _bloodStockControllers = {
    'A+': TextEditingController(),
    'A-': TextEditingController(),
    'B+': TextEditingController(),
    'B-': TextEditingController(),
    'O+': TextEditingController(),
    'O-': TextEditingController(),
    'AB+': TextEditingController(),
    'AB-': TextEditingController(),
  };

  // Password Controllers
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State Variables
  String? _selectedDivision;
  String? _selectedDistrict;
  String _selectedInstitutionType = 'blood_bank';
  double _lat = 23.8103;
  double _long = 89.5103;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isGovernmentApproved = false;
  bool _agreedToTerms = false;
  String? _licenseFileName;

  // Dropdowns Data
  final List<String> _divisions = [
    'Dhaka',
    'Chittagong',
    'Khulna',
    'Rajshahi',
    'Sylhet',
    'Barishal',
    'Rangpur',
    'Mymensingh',
  ];

  final Map<String, List<String>> _districts = {
    'Dhaka': ['Dhaka', 'Gazipur', 'Narayanganj', 'Tangail', 'Manikganj'],
    'Chittagong': [
      'Chittagong',
      'Cox\'s Bazar',
      'Khagrachari',
      'Rangamati',
      'Feni',
    ],
    'Khulna': ['Khulna', 'Bagerhat', 'Satkhira', 'Jessore', 'Pirojpur'],
    'Rajshahi': ['Rajshahi', 'Pabna', 'Bogura', 'Natore', 'Naogaon'],
    'Sylhet': ['Sylhet', 'Moulvibazar', 'Habiganj', 'Sunamganj'],
    'Barishal': ['Barishal', 'Bhola', 'Jhalokati', 'Patuakhali', 'Pirojpur'],
    'Rangpur': ['Rangpur', 'Dinajpur', 'Thakurgaon', 'Kurigram'],
    'Mymensingh': ['Mymensingh', 'Jamalpur', 'Sherpur', 'Netrokona'],
  };

  final List<String> _institutionTypes = [
    'blood_bank',
    'hospital',
    'nursing_home',
    'medical_center',
  ];

  final Map<String, String> _institutionTypeLabels = {
    'blood_bank': 'Blood Bank',
    'hospital': 'Hospital with Blood Bank',
    'nursing_home': 'Nursing Home',
    'medical_center': 'Medical Center',
  };

  List<String> _availableDistricts = [];

  @override
  void initState() {
    super.initState();
    if (_divisions.isNotEmpty) {
      _selectedDivision = _divisions[0];
      _availableDistricts = _districts[_selectedDivision] ?? [];
      if (_availableDistricts.isNotEmpty) {
        _selectedDistrict = _availableDistricts[0];
      }
    }
  }

  @override
  void dispose() {
    _hospitalNameController.dispose();
    _registrationNumberController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _alternatePhoneController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _zoneController.dispose();
    _directorNameController.dispose();
    _directorPhoneController.dispose();
    _headDoctorNameController.dispose();
    _headDoctorQualificationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    for (var controller in _bloodStockControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to Terms & Conditions'),
            backgroundColor: AppColors.primary,
          ),
        );
        return;
      }

      // TODO: Submit registration data
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration submitted successfully!'),
          backgroundColor: AppColors.primary,
        ),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.pagePaddingH,
        vertical: AppDimens.pagePaddingV,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Basic Information', Icons.info_outlined),
            const SizedBox(height: AppDimens.spaceMD),

            // Hospital Name
            AppInputField(
              label: 'Hospital/Blood Bank Name',
              hint: 'Enter official name',
              controller: _hospitalNameController,
              prefixIcon: const Icon(
                Icons.local_hospital_outlined,
                color: AppColors.inputIcon,
                size: 18,
              ),
              validator: (v) =>
                  v!.isEmpty ? 'Please enter hospital name' : null,
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Registration Number
            AppInputField(
              label: 'Registration/License Number',
              hint: 'Government registration number',
              controller: _registrationNumberController,
              prefixIcon: const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.inputIcon,
                size: 18,
              ),
              validator: (v) =>
                  v!.isEmpty ? 'Please enter registration number' : null,
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Email
            AppInputField(
              label: 'Email Address',
              hint: 'hospital@example.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppColors.inputIcon,
                size: 18,
              ),
              validator: (v) => v!.isEmpty ? 'Please enter email' : null,
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Phone Number
            AppInputField(
              label: 'Phone Number',
              hint: '+880 0000 00000',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(
                Icons.phone_outlined,
                color: AppColors.inputIcon,
                size: 18,
              ),
              validator: (v) => v!.isEmpty ? 'Please enter phone number' : null,
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Alternate Phone (Optional)
            AppInputField(
              label: 'Alternate Phone (Optional)',
              hint: '+880 0000 00000',
              controller: _alternatePhoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(
                Icons.phone_outlined,
                color: AppColors.inputIcon,
                size: 18,
              ),
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Website (Optional)
            AppInputField(
              label: 'Website (Optional)',
              hint: 'www.example.com',
              controller: _websiteController,
              keyboardType: TextInputType.url,
              prefixIcon: const Icon(
                Icons.language_outlined,
                color: AppColors.inputIcon,
                size: 18,
              ),
            ),
            const SizedBox(height: AppDimens.spaceXL),

            _buildSectionHeader(
              'Location Information',
              Icons.location_on_outlined,
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Division
            Text('Division', style: AppTextStyles.inputLabel),
            const SizedBox(height: 8),
            CustomDropdown(
              items: _divisions,
              value: _selectedDivision,
              selectedItem: _selectedDivision,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedDivision = value;
                    _availableDistricts = _districts[value] ?? [];
                    if (_availableDistricts.isNotEmpty) {
                      _selectedDistrict = _availableDistricts[0];
                    }
                  });
                }
              },
              itemAsString: (value) => value,
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   decoration: BoxDecoration(
            //     color: AppColors.inputBackground,
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(color: AppColors.inputBorder),
            //   ),
            //   child: DropdownButton<String>(
            //     value: _selectedDivision,
            //     isExpanded: true,
            //     underline: const SizedBox.shrink(),
            //     items: _divisions.map((division) {
            //       return DropdownMenuItem(
            //         value: division,
            //         child: Text(division),
            //       );
            //     }).toList(),
            //     onChanged: (value) {
            //       if (value != null) {
            //         setState(() {
            //           _selectedDivision = value;
            //           _availableDistricts = _districts[value] ?? [];
            //           if (_availableDistricts.isNotEmpty) {
            //             _selectedDistrict = _availableDistricts[0];
            //           }
            //         });
            //       }
            //     },
            //   ),
            // ),
            const SizedBox(height: AppDimens.spaceMD),

            // District
            Text('District', style: AppTextStyles.inputLabel),
            const SizedBox(height: 8),
            CustomDropdown<String>(
              items: _availableDistricts,
              value: _selectedDistrict,
              selectedItem: _selectedDistrict,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedDistrict = value;
                  });
                }
              },
              itemAsString: (value) => value,
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Full Address
            AppInputField(
              label: 'Full Address',
              hint: 'Building no, street, area',
              controller: _addressController,
              prefixIcon: const Icon(
                Icons.location_on_outlined,
                color: AppColors.inputIcon,
                size: 18,
              ),
              validator: (v) => v!.isEmpty ? 'Please enter address' : null,
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Zone/Area (Optional)
            AppInputField(
              label: 'Zone/Area (Optional)',
              hint: 'e.g., Dhanmondi, Gulshan',
              controller: _zoneController,
              prefixIcon: const Icon(
                Icons.pin_drop_outlined,
                color: AppColors.inputIcon,
                size: 18,
              ),
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Map Location
            Text('Map Location', style: AppTextStyles.inputLabel),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.inputBorder),
                color: AppColors.inputBackground,
              ),
              child: Stack(
                children: [
                  AbsorbPointer(
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(_lat, _long),
                        initialZoom: 13.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                          subdomains: const ['a', 'b', 'c', 'd'],
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 32,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '$_lat, $_long',
                        style: AppTextStyles.inputHint.copyWith(
                          color: AppColors.textWhite,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spaceXL),

            _buildSectionHeader('Institution Details', Icons.business_outlined),
            const SizedBox(height: AppDimens.spaceMD),

            // Institution Type
            Text('Type of Institution', style: AppTextStyles.inputLabel),
            const SizedBox(height: 8),
            CustomDropdown(
              items: _institutionTypes,
              value: _selectedInstitutionType,
              selectedItem: _selectedInstitutionType,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedInstitutionType = value;
                  });
                }
              },
              itemAsString: (value) => _institutionTypeLabels[value] ?? value,
            ),

            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 12),
            //   decoration: BoxDecoration(
            //     color: AppColors.inputBackground,
            //     borderRadius: BorderRadius.circular(10),
            //     border: Border.all(color: AppColors.inputBorder),
            //   ),
            //   child: DropdownButton<String>(
            //     value: _selectedInstitutionType,
            //     isExpanded: true,
            //     underline: const SizedBox.shrink(),
            //     items: _institutionTypes.map((type) {
            //       return DropdownMenuItem(
            //         value: type,
            //         child: Text(_institutionTypeLabels[type] ?? type),
            //       );
            //     }).toList(),
            //     onChanged: (value) {
            //       if (value != null) {
            //         setState(() {
            //           _selectedInstitutionType = value;
            //         });
            //       }
            //     },
            //   ),
            // ),
            const SizedBox(height: AppDimens.spaceMD),

            // Director Name
            AppInputField(
              label: 'Director/Manager Name',
              hint: 'Full name',
              controller: _directorNameController,
              prefixIcon: const Icon(
                Icons.person_outlined,
                color: AppColors.inputIcon,
                size: 18,
              ),
              validator: (v) =>
                  v!.isEmpty ? 'Please enter director name' : null,
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Director Phone
            AppInputField(
              label: 'Director Contact Number',
              hint: '+880 0000 00000',
              controller: _directorPhoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(
                Icons.phone_outlined,
                color: AppColors.inputIcon,
                size: 18,
              ),
              validator: (v) =>
                  v!.isEmpty ? 'Please enter director phone' : null,
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Head Doctor Name (Optional)
            AppInputField(
              label: 'Head Doctor Name (Optional)',
              hint: 'Full name',
              controller: _headDoctorNameController,
              prefixIcon: const Icon(
                Icons.person_outlined,
                color: AppColors.inputIcon,
                size: 18,
              ),
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Head Doctor Qualification (Optional)
            AppInputField(
              label: 'Head Doctor Qualification (Optional)',
              hint: 'MBBS, MD, etc.',
              controller: _headDoctorQualificationController,
              prefixIcon: const Icon(
                Icons.school_outlined,
                color: AppColors.inputIcon,
                size: 18,
              ),
            ),
            const SizedBox(height: AppDimens.spaceXL),

            _buildSectionHeader(
              'Current Blood Stock (Optional)',
              Icons.water_drop_outlined,
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Blood Groups Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _bloodStockControllers.length,
              itemBuilder: (context, index) {
                final bloodGroup = _bloodStockControllers.keys.toList()[index];
                return TextField(
                  controller: _bloodStockControllers[bloodGroup],
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.inputText,
                  decoration: InputDecoration(
                    //labelText: '$bloodGroup Units',
                    hintText: '$bloodGroup Units',
                    hintStyle: AppTextStyles.inputHint,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: AppColors.inputBorder,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppDimens.spaceXL),

            _buildSectionHeader(
              'Security & Agreements',
              Icons.security_outlined,
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Password
            AppInputField(
              label: 'Password',
              hint: 'Create a strong password',
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.inputIcon,
                size: 18,
              ),
              obscureText: !_isPasswordVisible,
              suffixIcon: GestureDetector(
                onTap: () => {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  }),
                },
                child: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.inputIcon,
                  size: 18,
                ),
              ),
              validator: (v) => v!.length < 6
                  ? 'Password must be at least 6 characters'
                  : null,
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Confirm Password
            AppInputField(
              label: 'Confirm Password',
              hint: 'Re-enter password',
              controller: _confirmPasswordController,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.inputIcon,
                size: 18,
              ),
              obscureText: !_isConfirmPasswordVisible,
              suffixIcon: GestureDetector(
                onTap: () => {
                  setState(() {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  }),
                },
                child: Icon(
                  _isConfirmPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.inputIcon,
                  size: 18,
                ),
              ),
              validator: (v) {
                if (v!.isEmpty) return 'Please confirm password';
                if (v != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Government Approval Checkbox
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.ripple3,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.ripple1),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: _isGovernmentApproved,
                    side: BorderSide(color: Colors.black87),
                    onChanged: (value) {
                      setState(() {
                        _isGovernmentApproved = value ?? false;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Government Approved',
                          style: AppTextStyles.hospitalName,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'This institution is government approved',
                          style: AppTextStyles.hospitalSub,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Terms & Conditions Checkbox
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.ripple2,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: Row(
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    side: BorderSide(color: Colors.black54),
                    onChanged: (value) {
                      setState(() {
                        _agreedToTerms = value ?? false;
                      });
                    },
                    activeColor: AppColors.primary,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Text('I agree to ', style: AppTextStyles.inputHint),
                        GestureDetector(
                          onTap: () {
                            // TODO: Show terms & conditions
                          },
                          child: Text(
                            'Terms & Conditions',
                            style: AppTextStyles.authLinkBold.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spaceXL),

            // Register Button
            AppPrimaryButton(
              label: 'Register Hospital',
              isLoading: false,
              icon: const Icon(
                Icons.check_circle_outline,
                color: AppColors.textWhite,
                size: 20,
              ),
              onPressed: _handleRegister,
            ),

            const SizedBox(height: AppDimens.spaceLG),

            // Already have account
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style: AppTextStyles.authSubtitle,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.login),
                    child: Text('Sign In', style: AppTextStyles.authLinkBold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimens.spaceXXL),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.ripple2,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
