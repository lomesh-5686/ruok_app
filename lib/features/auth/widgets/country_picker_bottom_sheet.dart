import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/country_code_model.dart';

class CountryPickerBottomSheet extends StatefulWidget {
  final List<CountryCodeModel> countries;
  final String selectedDialCode;
  final ValueChanged<CountryCodeModel> onSelect;

  const CountryPickerBottomSheet({
    super.key,
    required this.countries,
    required this.selectedDialCode,
    required this.onSelect,
  });

  static Future<CountryCodeModel?> show(
    BuildContext context, {
    required List<CountryCodeModel> countries,
    required String selectedDialCode,
  }) {
    return showModalBottomSheet<CountryCodeModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CountryPickerBottomSheet(
        countries: countries,
        selectedDialCode: selectedDialCode,
        onSelect: (country) => Navigator.of(context).pop(country),
      ),
    );
  }

  @override
  State<CountryPickerBottomSheet> createState() =>
      _CountryPickerBottomSheetState();
}

class _CountryPickerBottomSheetState extends State<CountryPickerBottomSheet> {
  late final TextEditingController _searchController;
  late List<CountryCodeModel> _filteredCountries;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredCountries = widget.countries;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final lower = query.trim().toLowerCase();
    setState(() {
      if (lower.isEmpty) {
        _filteredCountries = widget.countries;
      } else {
        _filteredCountries = widget.countries.where((c) {
          return c.name.toLowerCase().contains(lower) ||
              c.dialCode.toLowerCase().contains(lower) ||
              c.code.toLowerCase().contains(lower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.dividerColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Country',
                  style: AppTextStyles.cabinBoldBlack18,
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, size: 22.r),
                  color: AppColors.iconGrey,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                style: AppTextStyles.cabinMediumTextPrimary15,
                decoration: InputDecoration(
                  hintText: 'Search country or code...',
                  hintStyle: AppTextStyles.cabinRegularTextMuted14,
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.iconGrey,
                    size: 20.r,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                ),
              ),
            ),
          ),
          Divider(color: AppColors.dividerColor, height: 1.h),
          Expanded(
            child: _filteredCountries.isEmpty
                ? Center(
                    child: Text(
                      'No countries found',
                      style: AppTextStyles.cabinRegularTextMuted14,
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: _filteredCountries.length,
                    separatorBuilder: (_, __) => Divider(
                      color: AppColors.dividerColor.withValues(alpha: 0.5),
                      height: 1.h,
                      indent: 20.w,
                      endIndent: 20.w,
                    ),
                    itemBuilder: (context, index) {
                      final country = _filteredCountries[index];
                      final isSelected =
                          country.dialCode == widget.selectedDialCode;

                      return InkWell(
                        onTap: () => widget.onSelect(country),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 14.h,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  country.name,
                                  style: AppTextStyles.cabinSemiBoldTextPrimary17
                                      .copyWith(
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              Text(
                                country.dialCode,
                                style: AppTextStyles
                                    .cabinRegularCountryCodeDark16
                                    .copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.countryCodeDark,
                                ),
                              ),
                              if (isSelected) ...[
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.check_rounded,
                                  color: AppColors.primary,
                                  size: 18.r,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
