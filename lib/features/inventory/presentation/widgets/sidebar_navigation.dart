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
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.shield,
                  color: AppColors.textLight,
                  size: 24,
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
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    loc.translate('appSubtitle'),
                    style: TextStyle(
                      color: AppColors.textLight.withOpacity(0.6),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 48),

          // Menu Items
          _buildMenuItem(
            icon: Icons.dashboard_outlined,
            activeIcon: Icons.dashboard,
            title: loc.translate('menuDashboard'),
            value: 'dashboard',
            loc: loc,
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.inventory_2_outlined,
            activeIcon: Icons.inventory_2,
            title: loc.translate('menuInventory'),
            value: 'inventory',
            loc: loc,
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.assignment_outlined,
            activeIcon: Icons.assignment,
            title: loc.translate('menuRequests'),
            value: 'requests',
            loc: loc,
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.bar_chart_outlined,
            activeIcon: Icons.bar_chart,
            title: loc.translate('menuConsumption'),
            value: 'consumption',
            loc: loc,
          ),

          const Spacer(),

          // User profile / Language Switcher / Logout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.secondaryGreen,
                      child: Text(
                        user.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
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
                          Text(
                            user.role == 'admin' 
                                ? loc.translate('roleAdmin') 
                                : loc.translate('roleUser'),
                            style: TextStyle(
                              color: AppColors.textLight.withOpacity(0.5),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.white10, height: 24),

                // Language Toggler
                InkWell(
                  onTap: () {
                    context.read<AuthBloc>().add(ToggleLanguage());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.language, color: AppColors.textLight, size: 18),
                        const SizedBox(width: 12),
                        Text(
                          loc.translate('switchLanguage'),
                          style: const TextStyle(
                            color: AppColors.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Logout
                InkWell(
                  onTap: () {
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.logout, color: AppColors.errorRed, size: 18),
                        const SizedBox(width: 12),
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? AppColors.secondaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.textLight : AppColors.textLight.withOpacity(0.5),
              size: 22,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isActive ? AppColors.textLight : AppColors.textLight.withOpacity(0.5),
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
