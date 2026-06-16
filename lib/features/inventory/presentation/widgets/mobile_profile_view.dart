import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class MobileProfileView extends StatefulWidget {
  final User user;
  final bool isArabic;
  final String? initialImagePath;
  final int initialAvatarIndex;
  final Function(String?, int)? onProfileChanged;

  const MobileProfileView({
    super.key,
    required this.user,
    required this.isArabic,
    this.initialImagePath,
    this.initialAvatarIndex = 0,
    this.onProfileChanged,
  });

  @override
  State<MobileProfileView> createState() => _MobileProfileViewState();
}

class _MobileProfileViewState extends State<MobileProfileView> {
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _unitController;

  late String _currentName;
  late String _currentEmail;
  late String _currentPhone;
  late String _currentUnit;
  String? _emailError;
  String? _passwordError;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showPasswords = false;
  late int _selectedAvatarIndex;
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  final List<IconData> _availableAvatars = [
    Icons.person,
    Icons.person_outline,
    Icons.account_circle,
    Icons.face,
    Icons.military_tech,
  ];

  @override
  void initState() {
    super.initState();
    _selectedAvatarIndex = widget.initialAvatarIndex;
    if (widget.initialImagePath != null) {
      _imageFile = File(widget.initialImagePath!);
    }
    
    _currentName = widget.user.name;
    _currentEmail = widget.user.email;
    _currentPhone = '+966 50 123 4567';
    _currentUnit = 'militaryUnitValue'; // Using a key instead

    _nameController = TextEditingController(text: _currentName);
    _emailController = TextEditingController(text: _currentEmail);
    _phoneController = TextEditingController(text: _currentPhone);
    _unitController = TextEditingController(text: _currentUnit);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _unitController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateEmail(String value) {
    if (value.isEmpty) {
      setState(() => _emailError = null);
      return;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      setState(() => _emailError = widget.isArabic 
          ? 'يجب أن يحتوي على @ ونطاق صحيح (مثل .com)' 
          : 'Must contain @ and a valid domain (e.g. .com)');
    } else {
      setState(() => _emailError = null);
    }
  }

  void _validatePassword(String value) {
    if (value.isEmpty) {
      setState(() => _passwordError = null);
      return;
    }

    if (value.length < 8) {
      setState(() => _passwordError = widget.isArabic 
          ? 'يجب أن تكون 8 أحرف على الأقل' 
          : 'Must be at least 8 characters');
      return;
    }

    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasDigits = value.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase || !hasDigits || !hasSpecialCharacters) {
      setState(() => _passwordError = widget.isArabic
          ? 'يجب أن تحتوي على حرف كبير، رقم، ورمز خاص'
          : 'Must include uppercase, number, and special char');
    } else {
      setState(() => _passwordError = null);
    }
  }

  void _handleEditSave() {
    final loc = AppLocalizations(widget.isArabic);
    setState(() {
      if (_isEditing) {
        // التحقق النهائي عند الحفظ
        _validateEmail(_emailController.text);
        if (_emailError != null) {
          return;
        }

        _currentName = _nameController.text;
        _currentEmail = _emailController.text;
        _currentPhone = _phoneController.text;
        _currentUnit = _unitController.text;
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              loc.translate('saveSuccess'),
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: AppColors.secondaryGreen,
          ),
        );
      }
      _isEditing = !_isEditing;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          widget.onProfileChanged?.call(_imageFile!.path, _selectedAvatarIndex);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  void _showImagePicker(AppLocalizations loc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              loc.isArabic ? 'تغيير الصورة الشخصية' : 'Change Profile Picture',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_availableAvatars.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatarIndex = index;
                      _imageFile = null;
                    });
                    widget.onProfileChanged?.call(null, index);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _selectedAvatarIndex == index 
                          ? AppColors.secondaryGreen.withOpacity(0.1) 
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedAvatarIndex == index 
                            ? AppColors.secondaryGreen 
                            : AppColors.borderLight,
                      ),
                    ),
                    child: Icon(
                      _availableAvatars[index],
                      color: _selectedAvatarIndex == index 
                          ? AppColors.secondaryGreen 
                          : AppColors.textMuted,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: AppColors.textDark),
              title: Text(loc.isArabic ? 'المعرض' : 'Gallery', style: GoogleFonts.cairo()),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, color: AppColors.textDark),
              title: Text(loc.isArabic ? 'الكاميرا' : 'Camera', style: GoogleFonts.cairo()),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(widget.isArabic);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(loc),
          const SizedBox(height: 32),
          _buildMainProfileCard(loc),
          const SizedBox(height: 24),
          _buildPersonalInfoCard(loc),
          const SizedBox(height: 24),
          _buildSettingsCard(loc),
          const SizedBox(height: 24),
          _buildChangePasswordCard(loc),
          const SizedBox(height: 24),
          _buildRecentActivityCard(loc),
          const SizedBox(height: 32),
          _buildLogoutButton(context, loc),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations loc) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          context.read<AuthBloc>().add(LogoutRequested());
        },
        icon: const Icon(Icons.logout, color: AppColors.errorRed, size: 18),
        label: Text(
          loc.translate('menuLogout'),
          style: GoogleFonts.cairo(
            color: AppColors.errorRed,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.errorRed),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.translate('menuProfile'),
          style: GoogleFonts.cairo(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          loc.translate('profileSubtitle'),
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildMainProfileCard(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(16),
                    image: _imageFile != null 
                        ? DecorationImage(image: FileImage(_imageFile!), fit: BoxFit.cover)
                        : null,
                  ),
                  child: _imageFile == null 
                      ? Icon(_availableAvatars[_selectedAvatarIndex], color: Colors.white, size: 48)
                      : null,
                ),
                Positioned(
                  bottom: -4,
                  right: -4,
                  child: InkWell(
                    onTap: () => _showImagePicker(loc),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderLight),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 3,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.camera_alt_outlined, size: 16, color: AppColors.textMuted),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _currentName,
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          Text(
            loc.translate('rank'), 
            style: GoogleFonts.cairo(
              fontSize: 16,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.errorRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.errorRed.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.errorRed,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  loc.translate('roleAdmin'),
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.errorRed,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: AppColors.sandBeige),
          const SizedBox(height: 12),
          _buildInfoRow(loc.translate('militaryUnit'), _currentUnit, loc),
          const SizedBox(height: 12),
          _buildInfoRow(loc.translate('employeeId'), 'MIL-10042', loc),
          const SizedBox(height: 12),
          _buildStatusRow(loc.translate('accountStatus'), loc.translate('active')),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, AppLocalizations loc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(fontSize: 14, color: AppColors.textMuted),
        ),
        Text(
          loc.translate(value),
          style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
        ),
      ],
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(fontSize: 14, color: AppColors.textMuted),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.successGreen.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.successGreen.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.successGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                value,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.successGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInfoCard(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                loc.translate('personalInfo'),
                style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              InkWell(
                onTap: _handleEditSave,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Text(
                    _isEditing ? loc.translate('save') : loc.translate('edit'),
                    style: GoogleFonts.cairo(
                      color: _isEditing ? AppColors.secondaryGreen : AppColors.textDark, 
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.sandBeige),
          const SizedBox(height: 16),
          _buildTextFieldLabel(loc.translate('fullName')),
          _isEditing 
              ? _buildEditableTextField(_nameController, Icons.person_outline)
              : _buildDisabledTextField(_currentName, Icons.person_outline, loc),
          const SizedBox(height: 16),
          _buildTextFieldLabel(loc.translate('email')),
          _isEditing
              ? _buildEditableTextField(_emailController, Icons.email_outlined, isEmail: true)
              : _buildDisabledTextField(_currentEmail, Icons.email_outlined, loc),
          const SizedBox(height: 16),
          _buildTextFieldLabel(loc.translate('phoneNumber')),
          _isEditing
              ? _buildEditableTextField(_phoneController, Icons.phone_outlined)
              : _buildDisabledTextField(_currentPhone, Icons.phone_outlined, loc),
          const SizedBox(height: 16),
          _buildTextFieldLabel(loc.translate('militaryUnit')),
          _isEditing
              ? _buildEditableTextField(_unitController, Icons.shield_outlined)
              : _buildDisabledTextField(_currentUnit, Icons.shield_outlined, loc),
        ],
      ),
    );
  }

  Widget _buildTextFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
      ),
    );
  }

  Widget _buildEditableTextField(TextEditingController controller, IconData icon, {bool isEmail = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (isEmail && _emailError != null) 
                  ? AppColors.errorRed 
                  : AppColors.primaryGreen.withOpacity(0.3)
            ),
          ),
          child: TextField(
            controller: controller,
            onChanged: isEmail ? _validateEmail : null,
            style: GoogleFonts.cairo(fontSize: 16, color: AppColors.textDark),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 16, color: AppColors.textDark),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        if (isEmail && _emailError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 8, left: 8),
            child: Text(
              _emailError!,
              style: GoogleFonts.cairo(color: AppColors.errorRed, fontSize: 11),
            ),
          ),
      ],
    );
  }

  Widget _buildDisabledTextField(String value, IconData icon, AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightGreenBg.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textDark),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              loc.translate(value),
              style: GoogleFonts.cairo(fontSize: 16, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.translate('menuSettings'),
            style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const Divider(color: AppColors.sandBeige),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.language, color: AppColors.textDark),
            title: Text(
              loc.translate('switchLanguage'),
              style: GoogleFonts.cairo(fontSize: 16, color: AppColors.textDark),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              context.read<AuthBloc>().add(ToggleLanguage());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChangePasswordCard(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.lock_outline, size: 20, color: AppColors.textDark),
                  const SizedBox(width: 8),
                  Text(
                    loc.translate('changePassword'),
                    style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(_showPasswords ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                onPressed: () => setState(() => _showPasswords = !_showPasswords),
              ),
            ],
          ),
          const Divider(color: AppColors.sandBeige),
          const SizedBox(height: 16),
          _buildTextFieldLabel(loc.translate('currentPassword')),
          _buildPasswordField(_currentPasswordController, loc.translate('passwordPlaceholder')),
          const SizedBox(height: 16),
          _buildTextFieldLabel(loc.translate('newPassword')),
          _buildPasswordField(_newPasswordController, loc.translate('passwordPlaceholder'), isNewPassword: true),
          const SizedBox(height: 16),
          _buildTextFieldLabel(loc.translate('confirmPassword')),
          _buildPasswordField(_confirmPasswordController, loc.translate('confirmPassword')),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                _validatePassword(_newPasswordController.text);
                if (_passwordError != null) return;

                if (_newPasswordController.text != _confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(loc.translate('error'), style: GoogleFonts.cairo()),
                      backgroundColor: AppColors.errorRed,
                    ),
                  );
                  return;
                }
                
                _currentPasswordController.clear();
                _newPasswordController.clear();
                _confirmPasswordController.clear();
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(loc.translate('saveSuccess'), style: GoogleFonts.cairo()),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              },
              icon: const Icon(Icons.update, size: 16),
              label: Text(loc.translate('updatePassword'), style: GoogleFonts.cairo(fontWeight: FontWeight.w500)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String placeholder, {bool isNewPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (isNewPassword && _passwordError != null) 
                  ? AppColors.errorRed 
                  : AppColors.borderLight
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: !_showPasswords,
            onChanged: isNewPassword ? _validatePassword : null,
            style: GoogleFonts.cairo(fontSize: 14, color: AppColors.textDark),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: GoogleFonts.cairo(fontSize: 14, color: AppColors.textMuted.withOpacity(0.5)),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        if (isNewPassword && _passwordError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, right: 8, left: 8),
            child: Text(
              _passwordError!,
              style: GoogleFonts.cairo(color: AppColors.errorRed, fontSize: 11),
            ),
          ),
      ],
    );
  }

  Widget _buildRecentActivityCard(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.translate('recentActivity'),
            style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const Divider(color: AppColors.sandBeige),
          const SizedBox(height: 12),
          _buildActivityItem(loc.translate('actLogin'), '2026-05-05 08:32', '192.168.1.10'),
          const SizedBox(height: 12),
          _buildActivityItem(loc.translate('actApproval'), '2026-05-05 10:01', '192.168.1.18'),
          const SizedBox(height: 12),
          _buildActivityItem(loc.translate('actExport'), '2026-05-04 16:45', '192.168.1.10'),
          const SizedBox(height: 12),
          _buildActivityItem(loc.translate('actSecurity'), '2026-05-03 11:00', '192.168.1.10'),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String action, String time, String ip) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightGreenBg.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ip,
            style: const TextStyle(fontFamily: 'Consolas', fontSize: 12, color: AppColors.textMuted),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                action,
                style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textDark),
              ),
              Text(
                time,
                style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
