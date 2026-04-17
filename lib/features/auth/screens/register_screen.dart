import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:jibon_Bachan_app/core/utils/app_date_time.dart';
import 'package:jibon_Bachan_app/features/auth/bloc/auth_event.dart';
import 'package:jibon_Bachan_app/features/auth/bloc/auth_state.dart';
import 'package:jibon_Bachan_app/features/auth/data/model/register_model.dart';
import 'package:jibon_Bachan_app/features/auth/widgets/map_full_screen.dart';
import 'package:jibon_Bachan_app/shared/widgets/app_dropdown_field.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/widgets.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _locationController = TextEditingController();
  final _birthDateController = TextEditingController();
  String _selectedBloodGroup = '';
  int? _selectedDivisionId;
  int? _selectedDistrictId;
  int? _selectedAreaId;
  String? _selectedGender;

  /// Handles the registration logic when the user submits the form
  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      final myRequestData = RegisterRequest(
        name: _nameController.text.trim(),
        contactNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        divisionId: _selectedDivisionId ?? 0,
        districtId: _selectedDistrictId ?? 0,
        areaId: _selectedAreaId ?? 0,
        props: RegisterProps(
          address: _locationController.text.trim(),
          photo: "https://example.com/photo.jpg",
          birthDate: _birthDateController.text,
          gender: _selectedGender ?? "Male",
          bloodGroup: _selectedBloodGroup,
          geolocation: Geolocation(latitude: 23.8103, longitude: 89.5103),
        ),
      );

      context.read<AuthBloc>().add(
        AuthRegisterSubmitted(requestData: myRequestData),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthRegisterSuccess) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundWhite,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(AppStrings.createAccount, style: AppTextStyles.navTitle),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.pagePaddingH,
              vertical: AppDimens.pagePaddingV,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  Logo + Heading
                  // Center(
                  //   child: Column(
                  //     children: [
                  //       Container(
                  //         width: 56,
                  //         height: 56,
                  //         decoration: const BoxDecoration(
                  //           shape: BoxShape.circle,
                  //           color: AppColors.ripple2,
                  //         ),
                  //         child: const Icon(
                  //           Icons.water_drop,
                  //           color: AppColors.primary,
                  //           size: 30,
                  //         ),
                  //       ),
                  //       const SizedBox(height: AppDimens.spaceMD),
                  //       Text(
                  //         AppStrings.joinTitle,
                  //         style: AppTextStyles.authTitle,
                  //       ),
                  //       const SizedBox(height: 6),
                  //       Text(
                  //         AppStrings.joinSubtitle,
                  //         style: AppTextStyles.authSubtitle,
                  //         textAlign: TextAlign.center,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: AppColors.ripple2,
                              child: const Icon(
                                Icons.person,
                                size: 50,
                                color: AppColors.primary,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: AppColors.primary,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.camera_alt,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimens.spaceMD),

                        Text(
                          AppStrings.joinTitle,
                          style: AppTextStyles.authTitle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppStrings.joinSubtitle,
                          style: AppTextStyles.authSubtitle,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceXL),

                  //const SizedBox(height: AppDimens.spaceMD),
                  AppInputField(
                    label: AppStrings.fullName,
                    hint: AppStrings.fullNameHint,
                    controller: _nameController,
                    validator: (v) =>
                        v!.isEmpty ? 'Please enter your name' : null,
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  //  Email
                  AppInputField(
                    label: AppStrings.emailAddress,
                    hint: AppStrings.emailAddressHint,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    suffixIcon: const Icon(
                      Icons.email_outlined,
                      color: AppColors.inputIcon,
                      size: 18,
                    ),
                    validator: (v) => v!.isEmpty ? 'Please enter email' : null,
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  //Phone number
                  AppInputField(
                    label: AppStrings.phoneNumber,
                    hint: AppStrings.phoneHint,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // Location
                  AppInputField(
                    label: AppStrings.location,
                    hint: AppStrings.locationHint,
                    controller: _locationController,
                    prefixIcon: const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // Division & District Dropdowns
                  AppDropdownField<int>(
                    label: "Division",
                    hint: "Select Division",
                    value: _selectedDivisionId,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("Dhaka")),
                      DropdownMenuItem(value: 2, child: Text("Chittagong")),
                    ],
                    onChanged: (val) =>
                        setState(() => _selectedDivisionId = val),
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // District dropdown (should ideally be dynamic based on selected division)
                  AppDropdownField<int>(
                    label: "District",
                    hint: "Select District",
                    value: _selectedDistrictId,
                    items: const [
                      DropdownMenuItem(value: 1, child: Text("Joypurhat")),
                    ],
                    onChanged: (val) =>
                        setState(() => _selectedDistrictId = val),
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // date of birth with date picker
                  GestureDetector(
                    onTap: () async {
                      String? date = await AppUtils.pickDate(context);
                      if (date != null) {
                        setState(() {
                          _birthDateController.text = date;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: AppInputField(
                        label: "Date of Birth",
                        hint: "YYYY-MM-DD",
                        controller: _birthDateController,
                        readOnly: false,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.calendar_month_outlined,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceMD),

                  // Gender
                  AppDropdownField<String>(
                    label: "Gender",
                    hint: "Select Gender",
                    value: _selectedGender,
                    items: const [
                      DropdownMenuItem(value: "Male", child: Text("Male")),
                      DropdownMenuItem(value: "Female", child: Text("Female")),
                      DropdownMenuItem(value: "Other", child: Text("Other")),
                    ],
                    onChanged: (val) => setState(() => _selectedGender = val),
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // Password
                  AppInputField(
                    label: AppStrings.password,
                    hint: AppStrings.passwordHint,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    suffixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.inputIcon,
                      size: 18,
                    ),
                    validator: (v) =>
                        v!.length < 6 ? 'Password too short' : null,
                  ),

                  const SizedBox(height: AppDimens.spaceMD),

                  // Blood Group
                  Text(AppStrings.bloodGroup, style: AppTextStyles.inputLabel),
                  const SizedBox(height: 10),
                  BloodGroupSelector(
                    onSelected: (group) =>
                        setState(() => _selectedBloodGroup = group),
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  // Register Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return AppPrimaryButton(
                        label: AppStrings.register,
                        isLoading: state is AuthLoading,
                        icon: const Icon(
                          Icons.person_add_outlined,
                          color: AppColors.textWhite,
                          size: 18,
                        ),
                        onPressed: _handleRegister,
                      );
                    },
                  ),

                  const SizedBox(height: AppDimens.spaceLG),

                  //  Login link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.alreadyAccount,
                          style: AppTextStyles.authLink,
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Text(
                            AppStrings.login,
                            style: AppTextStyles.authLinkBold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppDimens.spaceXL),

                  // Map placeholder
                  // ClipRRect(
                  //   borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                  //   child: Container(
                  //     width: double.infinity,
                  //     height: 120,
                  //     color: AppColors.mapOverlay,
                  //     child: const Center(
                  //       child: Icon(
                  //         Icons.map_outlined,
                  //         color: AppColors.textSecondary,
                  //         size: 40,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  //  Map Preview Section
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: GestureDetector(
                      onTap: () {
                        // Navigate to full screen map
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FullMapScreen(
                              initialLocation: LatLng(
                                23.8103,
                                89.5103,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          // Live Map Preview (Non-interactive)
                          SizedBox(
                            width: double.infinity,
                            height: 120,
                            child: AbsorbPointer(
                              // Disable interaction in preview
                              child: FlutterMap(
                                options: const MapOptions(
                                  initialCenter: LatLng(23.8103, 89.5103),
                                  initialZoom: 13.0,
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    subdomains: const ['a', 'b', 'c', 'd'],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Dark Overlay with Text
                          Container(
                            width: double.infinity,
                            height: 120,
                            color: AppColors.mapOverlay.withOpacity(
                              0.6,
                            ), // Matched color with opacity
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.map_outlined,
                                    color: AppColors.textWhite,
                                    size: 30,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    "Tap to expand map",
                                    style: TextStyle(
                                      color: AppColors.textWhite,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spaceLG),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
