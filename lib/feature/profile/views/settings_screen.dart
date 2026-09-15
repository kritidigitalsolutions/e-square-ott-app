import 'package:e_square_ott_app/constants/app_colors.dart';
import 'package:e_square_ott_app/constants/app_text_styles.dart';
import 'package:e_square_ott_app/core/localization/locale_controller.dart';
import 'package:e_square_ott_app/shared/widgets/custom_bottomsheet.dart';
import 'package:e_square_ott_app/shared/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _autoplay = true;
  String _videoQuality = 'Auto';

  // Selected content languages (used by the bottom sheet)
  List<String> _selectedContentLanguages = [];

  void _openContentLanguageSheet() {
    CustomBottomSheet.show(
      context: context,
      child: ContentLanguageSheet(
        initialSelected: _selectedContentLanguages,
        onSave: (selected) {
          setState(() => _selectedContentLanguages = selected);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.loginBgGradient,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomBackButton(
                        onTap: () {
                          Get.back();
                        },
                      ),
                      const SizedBox(width: 14),
                      Text("Settings".tr, style: AppTextStyles.text18Bold),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        _SettingsSection(
                          label: 'PLAYBACK'.tr,
                          children: [
                            _SettingsRow(
                              title: 'Autoplay next episode'.tr,
                              subtitle: 'Automatically continue your story'.tr,
                              trailing: Switch(
                                value: _autoplay,
                                activeColor: AppColors.white,
                                activeTrackColor: AppColors.primary,
                                inactiveThumbColor: AppColors.textSecondary,
                                inactiveTrackColor: AppColors.cardBackground,
                                onChanged: (v) => setState(() => _autoplay = v),
                              ),
                            ),
                            _SettingsRow(
                              title: 'Video quality'.tr,
                              subtitle: 'Choose your default quality'.tr,
                              trailing: _SettingsDropdownChip(
                                value: _videoQuality,
                                options: const [
                                  'Auto',
                                  'Low',
                                  'Medium',
                                  'High',
                                ],
                                onSelected: (v) =>
                                    setState(() => _videoQuality = v),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _SettingsSection(
                          label: 'LANGUAGE'.tr,
                          children: [
                            _SettingsRow(
                              title: 'App language'.tr,
                              subtitle: 'Choose your preferred language'.tr,
                              trailing: Obx(
                                () => _SettingsDropdownChip(
                                  value: localeController.currentLanguage.value,
                                  options: LocaleController.supportedLanguages,
                                  onSelected: (v) {
                                    localeController.changeLanguage(v);
                                  },
                                ),
                              ),
                            ),
                            _SettingsRow(
                              title: 'Content language'.tr,
                              subtitle: 'Choose one or more languages'.tr,
                              onTap: _openContentLanguageSheet,
                              trailing: const FaIcon(
                                FontAwesomeIcons.chevronDown,
                                color: AppColors.textSecondary,
                                size: 12,
                              ),
                              isLast: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String label;
  final List<Widget> children;

  const _SettingsSection({required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 6, bottom: 10),
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: AppTextStyles.fontFamily,
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF14141E).withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;
  final bool isLast;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.isLast = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.fontFamily,
                          color: AppColors.textSecondary,
                          fontSize: 12.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                trailing,
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 0.8,
            color: Colors.white.withValues(alpha: 0.06),
          ),
      ],
    );
  }
}

class _SettingsDropdownChip extends StatelessWidget {
  final String value;
  final List<String> options;
  final ValueChanged<String> onSelected;

  const _SettingsDropdownChip({
    required this.value,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      color: const Color(0xFF1C1C28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      onSelected: onSelected,
      itemBuilder: (context) => options
          .map(
            (o) => PopupMenuItem<String>(
              value: o,
              child: Text(
                o,
                style: const TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF222232).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontFamily: AppTextStyles.fontFamily,
                color: AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            const FaIcon(
              FontAwesomeIcons.chevronDown,
              color: AppColors.textSecondary,
              size: 11,
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================================================================
/// CONTENT LANGUAGE — BOTTOM SHEET
/// =======================================================================
class ContentLanguageSheet extends StatefulWidget {
  final List<String> initialSelected;
  final ValueChanged<List<String>> onSave;
  final List<String> languages;

  const ContentLanguageSheet({
    super.key,
    required this.initialSelected,
    required this.onSave,
    this.languages = const [
      'English',
      'Hindi',
      'Tamil',
      'Telugu',
      'Kannada',
      'Malayalam',
    ],
  });

  @override
  State<ContentLanguageSheet> createState() => _ContentLanguageSheetState();
}

class _ContentLanguageSheetState extends State<ContentLanguageSheet> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialSelected.toSet();
  }

  void _toggle(String language) {
    setState(() {
      if (_selected.contains(language)) {
        _selected.remove(language);
      } else {
        _selected.add(language);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool canSave = _selected.isNotEmpty;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    // Split languages into rows of 2 for the chip grid.
    final List<Widget> rows = [];
    for (var i = 0; i < widget.languages.length; i += 2) {
      final first = widget.languages[i];
      final second = (i + 1 < widget.languages.length)
          ? widget.languages[i + 1]
          : null;
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                child: _LanguageChip(
                  label: first,
                  selected: _selected.contains(first),
                  onTap: () => _toggle(first),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: second == null
                    ? const SizedBox.shrink()
                    : _LanguageChip(
                        label: second,
                        selected: _selected.contains(second),
                        onTap: () => _toggle(second),
                      ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, 24, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Content language'.tr,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Select the languages you want to see across your Home feed.'.tr,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          ...rows,
          const SizedBox(height: 8),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: canSave
                ? () {
                    widget.onSave(_selected.toList());
                    Navigator.of(context).pop();
                  }
                : null,
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: canSave ? AppColors.primary : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'Save Preference'.tr,
                style: TextStyle(
                  color: canSave ? Colors.white : AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Center(
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel'.tr,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.textSecondary.withOpacity(0.25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.textSecondary,
                fontSize: 13.5,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: selected ? Colors.white : AppColors.textSecondary,
                  width: 1.5,
                ),
              ),
              child: selected
                  ? const Center(
                      child: FaIcon(
                        FontAwesomeIcons.check,
                        size: 10,
                        color: AppColors.primary,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
