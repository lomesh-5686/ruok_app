import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../../safety/cubit/safety_cubit.dart';
import '../../safety/screens/alert_idle_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  String? _nameError;
  String? _phoneError;

  String _selectedCountryCode = '+0123';
  final List<String> _countryCodes = [
    '+0123',
    '+91',
    '+1',
    '+44',
    '+61',
    '+971'
  ];

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(() {
      if (_nameFocusNode.hasFocus && _nameError != null) {
        setState(() {
          _nameError = null;
        });
      } else {
        setState(() {});
      }
    });

    _phoneFocusNode.addListener(() {
      if (_phoneFocusNode.hasFocus && _phoneError != null) {
        setState(() {
          _phoneError = null;
        });
      } else {
        setState(() {});
      }
    });

    _nameController.addListener(() {
      if (_nameError != null && _nameController.text.trim().isNotEmpty) {
        setState(() {
          _nameError = null;
        });
      }
    });

    _phoneController.addListener(() {
      if (_phoneError != null && _phoneController.text.trim().length == 10) {
        setState(() {
          _phoneError = null;
        });
      }
    });
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

    final String name = _nameController.text.trim();
    final String phone = _phoneController.text.trim();

    setState(() {
      _nameError = name.isEmpty ? AppStrings.nameValidation : null;
      _phoneError = phone.isEmpty
          ? 'Please enter your mobile number'
          : (phone.length < 10
              ? 'Please enter a valid 10-digit mobile number'
              : null);
    });

    if (_nameError != null || _phoneError != null) {
      return;
    }

    context.read<AuthCubit>().submitAuth(
          name: name,
          phone: phone,
          countryCode: _selectedCountryCode,
        );
  }

  @override
  Widget build(BuildContext context) {
    final bool isNameFocused = _nameFocusNode.hasFocus;
    final bool isPhoneFocused = _phoneFocusNode.hasFocus;

    // Focus state gives yellow/gold (#FF9E00), unfocused with error gives red (#EF4444), default gives grey (#E0E0E0 / #82858A)
    final Color nameBorderColor = isNameFocused
        ? AppColors.accentGold
        : (_nameError != null ? AppColors.timerRed : AppColors.inputBorder);

    final Color nameIconColor = isNameFocused
        ? AppColors.accentGold
        : (_nameError != null ? AppColors.timerRed : AppColors.iconGrey);

    final Color phoneBorderColor = isPhoneFocused
        ? AppColors.accentGold
        : (_phoneError != null ? AppColors.timerRed : AppColors.inputBorder);

    final Color phoneIconColor = isPhoneFocused
        ? AppColors.accentGold
        : (_phoneError != null ? AppColors.timerRed : AppColors.iconGrey);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.read<SafetyCubit>().initSafetyState();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const AlertIdleScreen()),
            );
          } else if (state is AuthError) {
            setState(() {
              if (state.message.contains('name')) {
                _nameError = state.message;
              } else {
                _phoneError = state.message;
              }
            });
          }
        },
        builder: (context, state) {
          final bool isLoading = state is AuthLoading;

          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32.h),

                    // App Icon (width: 114.17px, height: 136px)
                    Center(
                      child: SvgPicture.asset(
                        AppAssets.appLogo,
                        width: 114.17.w,
                        height: 136.h,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Title: Tell us about yourself
                    Text(
                      AppStrings.authTitle,
                      style: AppTextStyles.authTitle,
                    ),
                    SizedBox(height: 8.h),

                    // Subtitle: Enter your name and phone number to continue.
                    Text(
                      AppStrings.authSubtitle,
                      style: AppTextStyles.authSubtitle,
                    ),
                    SizedBox(height: 20.h),

                    // --- FIELD 1: Name Field ---
                    Container(
                      padding: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: nameBorderColor,
                            width: (isNameFocused || _nameError != null)
                                ? 1.8
                                : 1.4,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profile Circle Icon
                          SvgPicture.asset(
                            AppAssets.profileCircle,
                            width: 22.r,
                            height: 22.r,
                            colorFilter: ColorFilter.mode(
                              nameIconColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppStrings.nameLabel,
                                  style: AppTextStyles.fieldLabel.copyWith(
                                    color: _nameError != null && !isNameFocused
                                        ? AppColors.timerRed
                                        : AppColors.textMuted,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                TextField(
                                  controller: _nameController,
                                  focusNode: _nameFocusNode,
                                  keyboardType: TextInputType.visiblePassword,
                                  textCapitalization: TextCapitalization.words,
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  spellCheckConfiguration:
                                      const SpellCheckConfiguration.disabled(),
                                  style: AppTextStyles.fieldInput.copyWith(
                                    decoration: TextDecoration.none,
                                    decorationColor: Colors.transparent,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                    hintText: AppStrings.namePlaceholder,
                                    hintStyle: AppTextStyles.fieldHint.copyWith(
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_nameError != null && !isNameFocused) ...[
                      SizedBox(height: 4.h),
                      Text(
                        _nameError!,
                        style: AppTextStyles.fieldLabel.copyWith(
                          color: AppColors.timerRed,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                    SizedBox(height: 20.h),
                    Container(
                      padding: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: phoneBorderColor,
                            width: (isPhoneFocused || _phoneError != null)
                                ? 1.8
                                : 1.4,
                          ),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Call Icon
                          SvgPicture.asset(
                            AppAssets.call,
                            width: 22.r,
                            height: 22.r,
                            colorFilter: ColorFilter.mode(
                              phoneIconColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: 14.w),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCountryCode,
                              icon: Padding(
                                padding: EdgeInsets.only(left: 4.w),
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.subtitleDark,
                                  size: 20.r,
                                ),
                              ),
                              items: _countryCodes.map((code) {
                                return DropdownMenuItem<String>(
                                  value: code,
                                  child: Text(
                                    code,
                                    style: AppTextStyles.countryCode,
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedCountryCode = val;
                                  });
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              focusNode: _phoneFocusNode,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              autocorrect: false,
                              enableSuggestions: false,
                              spellCheckConfiguration:
                                  const SpellCheckConfiguration.disabled(),
                              style: AppTextStyles.fieldInput.copyWith(
                                decoration: TextDecoration.none,
                                decorationColor: Colors.transparent,
                              ),
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                hintText: AppStrings.phonePlaceholder,
                                hintStyle: AppTextStyles.fieldHint.copyWith(
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_phoneError != null && !isPhoneFocused) ...[
                      SizedBox(height: 4.h),
                      Text(
                        _phoneError!,
                        style: AppTextStyles.fieldLabel.copyWith(
                          color: AppColors.timerRed,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                    SizedBox(height: 30.h),

                    // Continue Button
                    CustomButton(
                      text: AppStrings.btnContinue,
                      isLoading: isLoading,
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
