import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';

class SidebarNavigation extends StatelessWidget {
  final String activeView;
  final ValueChanged<String> onViewChanged;
  final User user;
  final bool isArabic;

  const SidebarNavigation({
    super.key,
    required this.activeView,
    required this.onViewChanged,
    required this.user,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(isArabic);

    return Container(
      width: 260,
      color: AppColors.primaryGreen,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.secondaryGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.shield,
                  color: AppColors.textLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.translate('appName'),
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    loc.translate('appSubtitle'),
                    style: TextStyle(
                      color: AppColors.textLight.withOpacity(0.6),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Menu Items
          _buildMenuItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            title: loc.translate('menuDashboard'),
            value: 'dashboard',
            loc: loc,
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            icon: Icons.inventory_2_outlined,
            activeIcon: Icons.inventory_2,
            title: loc.translate('menuInventory'),
            value: 'inventory',
            loc: loc,
          ),
          const SizedBox(height: 8),
          _buildMenuItem(
            icon: Icons.assignment_outlined,
            activeIcon: Icons.assignment,
            title: loc.translate('menuRequests'),
            value: 'requests',
            loc: loc,
          ),

          const Spacer(),

          // User profile / Language Switcher / Logout
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondaryGreen.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight.withOpacity(0.15)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.secondaryGreen,
                      child: Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: AppColors.textLight,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              user.role == 'admin' 
                                  ? loc.translate('roleAdmin') 
                                  : loc.translate('roleUser'),
                              style: const TextStyle(
                                color: AppColors.textLight,
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: AppColors.borderLight, height: 20, thickness: 0.5),

                // Language Toggler
                InkWell(
                  onTap: () {
                    context.read<AuthBloc>().add(ToggleLanguage());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.language, color: AppColors.textLight, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          loc.translate('switchLanguage'),
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Logout
                InkWell(
                  onTap: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.logout, color: AppColors.errorRed, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          loc.translate('menuLogout'),
                          style: const TextStyle(
                            color: AppColors.errorRed,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required String value,
    required AppLocalizations loc,
  }) {
    final isActive = activeView == value;

    return InkWell(
      onTap: () => onViewChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.secondaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.textLight : AppColors.textLight.withOpacity(0.6),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isActive ? AppColors.textLight : AppColors.textLight.withOpacity(0.6),
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
