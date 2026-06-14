import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _autofill(String email) {
    setState(() {
      _emailController.text = email;
      _passwordController.text = 'password123';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.errorRed,
            ),
          );
        }
      },
      builder: (context, state) {
        final loc = AppLocalizations(state.isArabic);
        
        return Scaffold(
          body: Directionality(
            textDirection: loc.textDirection,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 800;
                
                if (isDesktop) {
                  return Row(
                    children: [
                      // Left branding panel
                      Expanded(
                        flex: 12,
                        child: _buildBrandingPanel(loc),
                      ),
                      // Right form panel
                      Expanded(
                        flex: 10,
                        child: Container(
                          color: AppColors.sandBeige,
                          child: Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(40),
                              child: Container(
                                constraints: const BoxConstraints(maxWidth: 420),
                                child: _buildLoginForm(loc, state),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Mobile Layout
                  return Container(
                    color: AppColors.sandBeige,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildMobileHeader(loc),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                            child: _buildLoginForm(loc, state),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBrandingPanel(AppLocalizations loc) {
    return Container(
      color: AppColors.primaryGreen,
      padding: const EdgeInsets.all(48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Name
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.secondaryGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shield,
                  color: AppColors.textLight,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.translate('appName'),
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    loc.translate('appSubtitle'),
                    style: TextStyle(
                      color: AppColors.textLight.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Slogan details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.translate('slogan'),
                style: const TextStyle(
                  color: AppColors.textLight,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                loc.translate('sloganDetails'),
                style: TextStyle(
                  color: AppColors.textLight.withOpacity(0.8),
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              // Feature badges
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildFeatureBadge(Icons.lock, loc.translate('badgeSecure')),
                  _buildFeatureBadge(Icons.supervised_user_circle, loc.translate('badgeRole')),
                  _buildFeatureBadge(Icons.analytics, loc.translate('badgeAnalytics')),
                ],
              ),
            ],
          ),
          const Spacer(),
          // Footer
          Text(
            '© 2026 MilStock. ${loc.isArabic ? "جميع الحقوق محفوظة." : "All rights reserved."}',
            style: TextStyle(
              color: AppColors.textLight.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.secondaryGreen.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentGreen.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textLight, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: AppColors.textLight, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader(AppLocalizations loc) {
    return Container(
      width: double.infinity,
      color: AppColors.primaryGreen,
      padding: const EdgeInsets.only(top: 60, bottom: 32, left: 24, right: 24),
      child: Column(
        children: [
          const Icon(
            Icons.shield,
            color: AppColors.textLight,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            loc.translate('appName'),
            style: const TextStyle(
              color: AppColors.textLight,
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          Text(
            loc.translate('appSubtitle'),
            style: TextStyle(
              color: AppColors.textLight.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(AppLocalizations loc, AuthState state) {
    final isLoading = state is AuthLoading;
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            loc.translate('loginTitle'),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            loc.translate('loginSub'),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 32),

          // Email Input
          Text(
            loc.translate('emailOrUsername'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.translate('emailPlaceholder');
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: loc.translate('emailPlaceholder'),
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 20),

          // Password Input
          Text(
            loc.translate('password'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return loc.translate('passwordPlaceholder');
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: loc.translate('passwordPlaceholder'),
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: AppColors.textMuted,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Remember & Forgot Password row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: AppColors.secondaryGreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    loc.translate('rememberMe'),
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ],
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  loc.translate('forgotPassword'),
                  style: const TextStyle(
                    color: AppColors.secondaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Submit button
          ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthBloc>().add(
                            LoginSubmitted(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ),
                          );
                    }
                  },
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: AppColors.textLight, strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.login, size: 18),
                      const SizedBox(width: 8),
                      Text(loc.translate('signInButton')),
                    ],
                  ),
          ),
          const SizedBox(height: 24),

          // Demo credentials box
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.sandCream,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.translate('demoCredentials'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: AppColors.textMuted,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                _buildCredentialRow(
                  label: loc.translate('demoAdmin'),
                  email: 'admin@milstock.mil',
                  onTap: () => _autofill('admin@milstock.mil'),
                ),
                const SizedBox(height: 8),
                _buildCredentialRow(
                  label: loc.translate('demoUser'),
                  email: 'unit@milstock.mil',
                  onTap: () => _autofill('unit@milstock.mil'),
                ),
                const SizedBox(height: 8),
                Text(
                  loc.translate('demoPasswordInfo'),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Language switcher
          Center(
            child: TextButton.icon(
              icon: const Icon(Icons.language, size: 16, color: AppColors.secondaryGreen),
              label: Text(
                loc.translate('switchLanguage'),
                style: const TextStyle(
                  color: AppColors.secondaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                context.read<AuthBloc>().add(ToggleLanguage());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCredentialRow({
    required String label,
    required String email,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$label:',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textDark),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  Text(
                    email,
                    style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: AppColors.textDark),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.copy_all, size: 12, color: AppColors.textMuted),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
