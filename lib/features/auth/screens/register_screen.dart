import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:jibon_Bachan_app/core/data/global_model/location_model.dart).dart';
import 'package:jibon_Bachan_app/core/data/repository/location_repository.dart';
import 'package:jibon_Bachan_app/core/utils/app_date_time.dart';
import 'package:jibon_Bachan_app/features/auth/bloc/auth_event.dart';
import 'package:jibon_Bachan_app/features/auth/bloc/auth_state.dart';
import 'package:jibon_Bachan_app/features/auth/data/model/register_model.dart';
import 'package:jibon_Bachan_app/features/auth/screens/register_screen_hospital.dart';
import 'package:jibon_Bachan_app/features/auth/widgets/map_full_screen.dart';
import 'package:jibon_Bachan_app/shared/widgets/app_dropdown_field.dart';
import 'package:jibon_Bachan_app/shared/widgets/app_snackbar.dart';
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

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _locationController = TextEditingController();
  final _birthDateController = TextEditingController();
  final LocationRepository _locationRepo = LocationRepository();
  List<LocationModel> _divisions = [];
  List<LocationModel> _districts = [];

  bool _isLoadingDistricts = false;
  bool _isDivisionLoading = false;
  String _selectedBloodGroup = '';
  LocationModel? _selectedDivision;
  LocationModel? _selectedDistrict;
  int? _selectedAreaId;
  String? _selectedGender;
  double _lat = 23.8103;
  double _long = 89.5103;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchDivisions();
  }

  Future<void> _fetchDivisions() async {
    setState(() => _isDivisionLoading = true);
    try {
      final data = await _locationRepo.getDivisions();
      setState(() {
        _divisions = data;
        _isDivisionLoading = false;
      });
    } catch (e) {
      setState(() => _isDivisionLoading = false);
    }
  }

  Future<void> _fetchDistricts(int divisionId) async {
    setState(() => _isLoadingDistricts = true);
    final data = await _locationRepo.getDistricts(divisionId);
    setState(() {
      _districts = data;
      _isLoadingDistricts = false;
    });
  }

  /// Handles the registration logic when the user submits the form
  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      String userType = _tabController.index == 0 ? "user" : "bank";
      debugPrint("🚀 REGISTRATION TYPE: ${userType.toUpperCase()}");

      if (_selectedBloodGroup.isEmpty) {
        AppSnackbar.show(
          context,
          message: "Please select your blood group",
          isError: true,
        );
        return;
      }

      final myRequestData = RegisterRequest(
        loginName: _nameController.text.trim(),
        contactNumber: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        type: userType,
        divisionId: _selectedDivision?.id ?? 0,
        districtId: _selectedDistrict?.id ?? 0,
        areaId: _selectedAreaId ?? 0,
        props: RegisterProps(
          address: _locationController.text.trim(),
          photo: "https://example.com/photo.jpg",
          birthDate: _birthDateController.text,
          gender: _selectedGender ?? "Male",
          bloodGroup: _selectedBloodGroup,
          geolocation: Geolocation(latitude: _lat, longitude: _long),
        ),
      );

      context.read<AuthBloc>().add(
        AuthRegisterSubmitted(requestData: myRequestData),
      );
    }
  }

  Future<void> _pickLocationFromMap() async {
    final Map<String, dynamic>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FullMapScreen(initialLocation: LatLng(_lat, _long)),
      ),
    );

    if (result != null) {
      setState(() {
        _lat = (result['location'] as LatLng).latitude;
        _long = (result['location'] as LatLng).longitude;
        _locationController.text = result['address'];
      });
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
          AppSnackbar.show(context, message: "Registration Successful!");
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        }
        if (state is AuthFailure) {
          AppSnackbar.show(context, message: state.message, isError: true);
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Column(
              children: [
                Container(
                  color: AppColors.backgroundWhite,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    labelStyle: AppTextStyles.inputLabel.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    unselectedLabelStyle: AppTextStyles.inputLabel.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                    dividerHeight: 0,
                    tabs: const [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_outline, size: 20),
                            SizedBox(width: 6),
                            Text('Individual'),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_hospital_outlined, size: 20),
                            SizedBox(width: 6),
                            Text('Hospital'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppColors.inputBorder),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            controller: _tabController,
            children: [_buildIndividualTab(), _buildHospitalTab()],
          ),
        ),
      ),
    );
  }

  Widget _buildIndividualTab() {
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
              prefixIcon: const Icon(
                Icons.person,
                color: AppColors.inputIcon,
                size: 18,
              ),
              validator: (v) => v!.isEmpty ? 'Please enter your name' : null,
            ),

            const SizedBox(height: AppDimens.spaceMD),

            //  Email
            AppInputField(
              label: AppStrings.emailAddress,
              hint: AppStrings.emailAddressHint,
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

            //Phone number
            AppInputField(
              label: AppStrings.phoneNumber,
              hint: AppStrings.phoneHint,
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(
                Icons.phone,
                color: AppColors.inputIcon,
                size: 18,
              ),
              validator: (v) =>
                  v!.isEmpty ? 'Please enter your phone number' : null,
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Location
            GestureDetector(
              onTap: _pickLocationFromMap,
              child: AbsorbPointer(
                child: AppInputField(
                  label: AppStrings.location,
                  hint: AppStrings.locationHint,
                  controller: _locationController,
                  prefixIcon: const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  validator: (v) => (v == null || v.isEmpty)
                      ? 'Please enter your city/location'
                      : null,
                ),
              ),
            ),

            const SizedBox(height: AppDimens.spaceMD),

            Text("Division", style: AppTextStyles.inputLabel),
            const SizedBox(height: 8),
            // Division & District Dropdowns
            CustomDropdown<LocationModel>(
              items: _divisions,
              value: _selectedDivision,
              selectedItem: _selectedDivision,
              hinText: "Select Division",
              suffixIcon: _isDivisionLoading
                  ? Padding(
                      padding: EdgeInsets.all(12.0),
                      child: const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
              //popupHeight: 150,
              itemAsString: (item) => item.name,
              onChanged: (val) {
                setState(() {
                  _selectedDivision = val;
                  _selectedDistrict = null;
                });
                if (val != null) _fetchDistricts(val.id);
              },
              validator: (v) => v == null ? 'Please select division' : null,
            ),

            const SizedBox(height: AppDimens.spaceMD),

            Text("District", style: AppTextStyles.inputLabel),
            const SizedBox(height: 8),

            CustomDropdown<LocationModel>(
              items: _districts,
              value: _selectedDistrict,
              selectedItem: _selectedDistrict,
              hinText: _isLoadingDistricts ? "Loading..." : "Select District",
              isLoading: _isLoadingDistricts,
              itemAsString: (item) => item.name,
              suffixIcon: _isLoadingDistricts
                  ? Padding(
                      padding: EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
              onChanged: (val) {
                setState(() => _selectedDistrict = val);
              },
              validator: (v) => v == null ? 'Please select district' : null,
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
                  prefixIcon: IconButton(
                    icon: Icon(
                      Icons.calendar_month_outlined,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    onPressed: () {},
                  ),
                  validator: (v) =>
                      v!.isEmpty ? 'Please set date of birth' : null,
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spaceMD),

            // Gender
            Text("Gender", style: AppTextStyles.inputLabel),
            const SizedBox(height: 8),

            CustomDropdown<String>(
              items: const ["Male", "Female", "Other"],
              value: _selectedGender,
              hinText: "Select Gender",
              popupHeight: 130,
              itemAsString: (item) => item,
              onChanged: (val) {
                setState(() {
                  _selectedGender = val;
                });
              },
              validator: (v) => v == null ? 'Please select gender' : null,
            ),

            const SizedBox(height: AppDimens.spaceMD),

            // Password
            AppInputField(
              label: AppStrings.password,
              hint: AppStrings.passwordHint,
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.inputIcon,
                size: 18,
              ),
              obscureText: !_isPasswordVisible,
              // suffixIcon: const Icon(
              //   Icons.lock_outline,
              //   color: AppColors.inputIcon,
              //   size: 18,
              // ),
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
              validator: (v) => v!.length < 6 ? 'Password too short' : null,
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
                        initialLocation: LatLng(23.8103, 89.5103),
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
                                  'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                              subdomains: const ['a', 'b', 'c', 'd'],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Dark Overlay with Text
                    Container(
                      width: double.infinity,
                      height: 150,
                      color: AppColors.mapOverlay.withOpacity(
                        0.6,
                      ), // Matched color with opacity
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.map_outlined,
                              color: AppColors.primary.withOpacity(0.5),
                              size: 30,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Tap to expand map",
                              style: TextStyle(
                                color: AppColors.primary.withOpacity(0.5),
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
    );
  }

  Widget _buildHospitalTab() {
    return HospitalRegistrationScreen();
  }
}
