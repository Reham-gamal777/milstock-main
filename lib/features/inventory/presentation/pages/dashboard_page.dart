import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../bloc/inventory_bloc.dart';
import '../widgets/desktop_dashboard_view.dart';
import '../widgets/desktop_inventory_view.dart';
import '../widgets/mobile_dashboard_view.dart';
import '../widgets/mobile_inventory_view.dart';
import '../widgets/sidebar_navigation.dart';

class DashboardPage extends StatefulWidget {
  final User user;

  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _activeDesktopView = 'dashboard';
  int _activeMobileIndex = 0;

  @override
  void initState() {
    super.initState();
    // Dispatch fetch event on initial load
    context.read<InventoryBloc>().add(FetchInventoryData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final isArabic = authState.isArabic;
        final loc = AppLocalizations(isArabic);

        return BlocBuilder<InventoryBloc, InventoryState>(
          builder: (context, inventoryState) {
            if (inventoryState is InventoryLoading) {
              return const Scaffold(
                backgroundColor: AppColors.sandBeige,
                body: Center(
                  child: CircularProgressIndicator(color: AppColors.secondaryGreen),
                ),
              );
            }

            if (inventoryState is InventoryError) {
              return Scaffold(
                backgroundColor: AppColors.sandBeige,
                body: Center(
                  child: Text(
                    'Error: ${inventoryState.message}',
                    style: const TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }

            if (inventoryState is InventoryLoaded) {
              return Scaffold(
                backgroundColor: AppColors.sandBeige,
                body: Directionality(
                  textDirection: loc.textDirection,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isDesktop = constraints.maxWidth > 800;

                      if (isDesktop) {
                        return Row(
                          children: [
                            SidebarNavigation(
                              activeView: _activeDesktopView,
                              onViewChanged: (view) {
                                setState(() {
                                  _activeDesktopView = view;
                                });
                              },
                              user: widget.user,
                              isArabic: isArabic,
                            ),
                            Expanded(
                              child: _buildDesktopContent(inventoryState, isArabic, loc),
                            ),
                          ],
                        );
                      } else {
                        return _buildMobileLayout(inventoryState, isArabic, loc);
                      }
                    },
                  ),
                ),
              );
            }

            return const Scaffold(
              backgroundColor: AppColors.sandBeige,
              body: SizedBox(),
            );
          },
        );
      },
    );
  }

  Widget _buildDesktopContent(
    InventoryLoaded state,
    bool isArabic,
    AppLocalizations loc,
  ) {
    switch (_activeDesktopView) {
      case 'dashboard':
        return DesktopDashboardView(
          requests: state.requests,
          notifications: state.notifications,
          isArabic: isArabic,
        );
      case 'inventory':
        return DesktopInventoryView(
          items: state.filteredItems,
          searchQuery: state.searchQuery,
          selectedCategory: state.selectedCategory,
          selectedStatus: state.selectedStatus,
          isArabic: isArabic,
        );
      case 'requests':
        return _buildDesktopRequestsView(state, loc);
      default:
        return Center(child: Text(loc.translate('menuDashboard')));
    }
  }

  Widget _buildDesktopRequestsView(InventoryLoaded state, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.translate('menuRequests'),
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const SizedBox(height: 24),
          Card(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: state.requests.length,
              separatorBuilder: (context, index) => const Divider(color: AppColors.sandCream, height: 1),
              itemBuilder: (context, index) {
                final req = state.requests[index];
                return ListTile(
                  title: Text(req.id, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${req.unit} • ${req.itemName}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (req.status == 'pending' ? AppColors.warningOrange : AppColors.successGreen).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      loc.translate(req.status),
                      style: TextStyle(
                        color: req.status == 'pending' ? AppColors.warningOrange : AppColors.successGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
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

  Widget _buildMobileLayout(
    InventoryLoaded state,
    bool isArabic,
    AppLocalizations loc,
  ) {
    final titleList = [
      loc.translate('dashboard'),
      loc.translate('inventoryManagement'),
      loc.translate('menuRequests'),
      loc.translate('notifications'),
      loc.translate('menuProfile'),
    ];

    return Scaffold(
      backgroundColor: AppColors.sandBeige,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textLight,
        centerTitle: true,
        title: Text(
          titleList[_activeMobileIndex],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              setState(() {
                _activeMobileIndex = 3; // Switch to notifications
              });
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: _buildMobileBody(state, isArabic, loc),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeMobileIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardBg,
        selectedItemColor: AppColors.secondaryGreen,
        unselectedItemColor: AppColors.textMuted.withOpacity(0.6),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (index) {
          setState(() {
            _activeMobileIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            activeIcon: const Icon(Icons.dashboard),
            label: loc.translate('menuDashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.inventory_2_outlined),
            activeIcon: const Icon(Icons.inventory_2),
            label: loc.translate('menuInventory'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assignment_outlined),
            activeIcon: const Icon(Icons.assignment),
            label: loc.translate('menuRequests'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications_outlined),
            activeIcon: const Icon(Icons.notifications),
            label: loc.translate('notifications'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: loc.translate('menuProfile'),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileBody(
    InventoryLoaded state,
    bool isArabic,
    AppLocalizations loc,
  ) {
    switch (_activeMobileIndex) {
      case 0:
        return MobileDashboardView(requests: state.requests, isArabic: isArabic);
      case 1:
        return MobileInventoryView(
          items: state.filteredItems,
          searchQuery: state.searchQuery,
          selectedCategory: state.selectedCategory,
          selectedStatus: state.selectedStatus,
          isArabic: isArabic,
        );
      case 2:
        return _buildMobileRequestsView(state, loc);
      case 3:
        return _buildMobileNotificationsView(state);
      case 4:
        return _buildMobileProfileView(isArabic, loc);
      default:
        return const SizedBox();
    }
  }

  Widget _buildMobileRequestsView(InventoryLoaded state, AppLocalizations loc) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: state.requests.length,
      itemBuilder: (context, index) {
        final req = state.requests[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            title: Text(req.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            subtitle: Text('${req.unit} • ${req.itemName}', style: const TextStyle(fontSize: 11)),
            trailing: Text(
              loc.translate(req.status),
              style: TextStyle(
                color: req.status == 'pending' ? AppColors.warningOrange : AppColors.successGreen,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileNotificationsView(InventoryLoaded state) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.notifications.length,
      itemBuilder: (context, index) {
        final alert = state.notifications[index];
        Color color = AppColors.infoGrey;
        if (alert.type == 'error') color = AppColors.errorRed;
        if (alert.type == 'warning') color = AppColors.warningOrange;
        if (alert.type == 'info') color = AppColors.successGreen;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(Icons.circle, color: color, size: 8),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alert.message, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(alert.time, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileProfileView(bool isArabic, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.secondaryGreen,
                child: Text(
                  widget.user.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: AppColors.textLight, fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.user.name,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark),
              ),
              const SizedBox(height: 4),
              Text(
                widget.user.role == 'admin' ? loc.translate('roleAdmin') : loc.translate('roleUser'),
                style: const TextStyle(color: AppColors.textMuted, fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                widget.user.email,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const Divider(height: 40, color: AppColors.borderLight),
              
              // Language toggler row
              ListTile(
                leading: const Icon(Icons.language, color: AppColors.secondaryGreen),
                title: Text(loc.translate('switchLanguage'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.read<AuthBloc>().add(ToggleLanguage());
                },
              ),

              // Logout row
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.errorRed),
                title: Text(loc.translate('menuLogout'), style: const TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.bold, fontSize: 14)),
                trailing: const Icon(Icons.chevron_right, color: AppColors.errorRed),
                onTap: () {
                  context.read<AuthBloc>().add(LogoutRequested());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
