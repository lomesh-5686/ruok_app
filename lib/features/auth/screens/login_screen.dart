import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../safety/bloc/safety_bloc.dart';
import '../../safety/bloc/safety_event.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../models/country_code_model.dart';
import '../widgets/auth_header_widget.dart';
import '../widgets/country_picker_bottom_sheet.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final FocusNode _nameFocusNode;
  late final FocusNode _phoneFocusNode;

  List<CountryCodeModel> _countries = const [];

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    _nameController = TextEditingController(text: authState.name);
    _phoneController = TextEditingController(text: authState.phone);
    _nameFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();

    _loadCountries();
  }

  Future<void> _loadCountries() async {
    final list = await CountryCodeModel.loadFromAsset();
    if (mounted) {
      setState(() {
        _countries = list;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  void _onContinue() {
    FocusScope.of(context).unfocus();
    context.read<AuthBloc>().add(const AuthSubmitEvent());
  }

  void _openCountryPicker(String currentCode) async {
    FocusScope.of(context).unfocus();
    final selected = await CountryPickerBottomSheet.show(
      context,
      countries: _countries,
      selectedDialCode: currentCode,
    );
    if (selected != null && mounted) {
      context
          .read<AuthBloc>()
          .add(AuthCountryCodeChangedEvent(selected.dialCode));
    }
  }

  Widget _buildCountryCodeSelector(String currentCode) {
    for (final c in _countries) {
      if (c.dialCode == currentCode) {
        break;
      }
    }

    return GestureDetector(
      onTap: () => _openCountryPicker(currentCode),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            currentCode,
            style: AppTextStyles.cabinRegularCountryCodeDark16,
          ),
          SizedBox(width: 4.w),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.subtitleDark,
            size: 20.r,
          ),
          SizedBox(width: 12.w),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated) {
            context.read<SafetyBloc>().add(const InitSafetyStateEvent());
            Navigator.of(context).pushReplacementNamed(AppRoutes.alertIdle);
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32.h),
                    const AuthHeaderWidget(),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      iconAsset: AppAssets.profileCircle,
                      label: AppStrings.nameLabel,
                      hint: AppStrings.namePlaceholder,
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      errorText: state.nameError,
                      keyboardType: TextInputType.visiblePassword,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (val) {
                        context.read<AuthBloc>().add(AuthNameChangedEvent(val));
                      },
                    ),
                    SizedBox(height: 20.h),
                    CustomTextField(
                      iconAsset: AppAssets.call,
                      hint: AppStrings.phonePlaceholder,
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      errorText: state.phoneError,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      prefixWidget:
                          _buildCountryCodeSelector(state.countryCode),
                      onChanged: (val) {
                        context
                            .read<AuthBloc>()
                            .add(AuthPhoneChangedEvent(val));
                      },
                    ),
                    SizedBox(height: 30.h),
                    CustomButton(
                      text: AppStrings.btnContinue,
                      isLoading: state.isSubmitting,
                      onPressed: _onContinue,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
