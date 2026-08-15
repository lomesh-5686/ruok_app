import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class CustomTextField extends StatefulWidget {
  final String? iconAsset;
  final String? label;
  final String hint;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? errorText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixWidget;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.iconAsset,
    this.label,
    required this.hint,
    required this.controller,
    required this.focusNode,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.prefixWidget,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _isFocused = widget.focusNode.hasFocus;
    widget.focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant CustomTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChange);
      widget.focusNode.addListener(_onFocusChange);
      _isFocused = widget.focusNode.hasFocus;
    }
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  void _onFocusChange() {
    if (_isFocused != widget.focusNode.hasFocus) {
      setState(() {
        _isFocused = widget.focusNode.hasFocus;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasError =
        widget.errorText != null && widget.errorText!.isNotEmpty;
    final Color borderColor = _isFocused
        ? AppColors.accentGold
        : (hasError ? AppColors.timerRed : AppColors.inputBorder);
    final Color iconColor = _isFocused
        ? AppColors.accentGold
        : (hasError ? AppColors.timerRed : AppColors.iconGrey);

    final bool hasLabel =
        widget.label != null && widget.label!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: borderColor,
                width: (_isFocused || hasError) ? 1.8 : 1.4,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment:
                hasLabel ? CrossAxisAlignment.end : CrossAxisAlignment.center,
            children: [
              if (widget.iconAsset != null && widget.iconAsset!.isNotEmpty) ...[
                Padding(
                  padding: EdgeInsets.only(bottom: hasLabel ? 2.h : 0),
                  child: SvgPicture.asset(
                    widget.iconAsset!,
                    width: 22.r,
                    height: 22.r,
                    colorFilter: ColorFilter.mode(
                      iconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
              ],
              if (widget.prefixWidget != null)
                Padding(
                  padding: EdgeInsets.only(bottom: hasLabel ? 2.h : 0),
                  child: widget.prefixWidget!,
                ),
              Expanded(
                child: hasLabel
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.label!,
                            style: AppTextStyles.cabinRegularTextMuted14.copyWith(
                              color: hasError && !_isFocused
                                  ? AppColors.timerRed
                                  : AppColors.textMuted,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          TextField(
                            controller: widget.controller,
                            focusNode: widget.focusNode,
                            keyboardType: widget.keyboardType,
                            textCapitalization: widget.textCapitalization,
                            inputFormatters: widget.inputFormatters,
                            autocorrect: false,
                            enableSuggestions: false,
                            spellCheckConfiguration:
                                const SpellCheckConfiguration.disabled(),
                            style: AppTextStyles.cabinSemiBoldTextPrimary17.copyWith(
                              decoration: TextDecoration.none,
                              decorationColor: Colors.transparent,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: widget.hint,
                              hintStyle: AppTextStyles.cabinRegularTextMuted16.copyWith(
                                decoration: TextDecoration.none,
                              ),
                            ),
                            onChanged: widget.onChanged,
                          ),
                        ],
                      )
                    : TextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        keyboardType: widget.keyboardType,
                        textCapitalization: widget.textCapitalization,
                        inputFormatters: widget.inputFormatters,
                        autocorrect: false,
                        enableSuggestions: false,
                        spellCheckConfiguration:
                            const SpellCheckConfiguration.disabled(),
                        style: AppTextStyles.cabinSemiBoldTextPrimary17.copyWith(
                          decoration: TextDecoration.none,
                          decorationColor: Colors.transparent,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                          hintText: widget.hint,
                          hintStyle: AppTextStyles.cabinRegularTextMuted16.copyWith(
                            decoration: TextDecoration.none,
                          ),
                        ),
                        onChanged: widget.onChanged,
                      ),
              ),
            ],
          ),
        ),
        if (hasError && !_isFocused) ...[
          SizedBox(height: 4.h),
          Text(
            widget.errorText!,
            style: AppTextStyles.cabinRegularTextMuted14.copyWith(
              color: AppColors.timerRed,
              fontSize: 12.sp,
            ),
          ),
        ],
      ],
    );
  }
}
