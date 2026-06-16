import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
import '../widgets/mobile_notifications_view.dart';
import '../widgets/mobile_profile_view.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/consumption_waste_view.dart';

class DashboardPage extends StatefulWidget {
  final User user;

  const DashboardPage({super.key, required this.user});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _activeDesktopView = 'dashboard';
  int _activeMobileIndex = 0; // Set to Dashboard page by default
  String? _profileImagePath;
  int _selectedAvatarIndex = 0;

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
                    '${loc.translate('error')}: ${inventoryState.message}',
                    style: const TextStyle(color: AppColors.errorRed, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }

            if (inventoryState is InventoryLoaded) {
              return Directionality(
                textDirection: loc.textDirection,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 800;

                    if (isDesktop) {
                      return Scaffold(
                        backgroundColor: AppColors.sandBeige,
                        body: Row(
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
                        ),
                      );
                    } else {
                      return _buildMobileLayout(inventoryState, isArabic, loc);
                    }
                  },
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
      case 'consumption':
        return ConsumptionWasteView(isArabic: isArabic);
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
                  subtitle: Text('${loc.translate(req.unit)} • ${loc.translate(req.itemName)}'),
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
      loc.translate('menuConsumption'),
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
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              setState(() {
                _activeMobileIndex = 4; // Switch to notifications
              });
            },
          ),
        ],
      ),
      body: _buildMobileBody(state, isArabic, loc),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _activeMobileIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.cardBg,
        selectedItemColor: AppColors.secondaryGreen,
        unselectedItemColor: AppColors.textMuted.withOpacity(0.6),
        selectedLabelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 10),
        unselectedLabelStyle: GoogleFonts.cairo(fontSize: 10),
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
            icon: const Icon(Icons.bar_chart_outlined),
            activeIcon: const Icon(Icons.bar_chart),
            label: loc.isArabic ? 'هدر' : 'Waste',
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
        return MobileDashboardView(
          requests: state.requests,
          isArabic: isArabic,
          onViewAllRequests: () {
            setState(() {
              _activeMobileIndex = 2; // Navigate to Requests tab
            });
          },
          onTabChanged: (index) {
            setState(() {
              _activeMobileIndex = index;
            });
          },
        );
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
        return ConsumptionWasteView(isArabic: isArabic);
      case 4:
        return _buildMobileNotificationsView(state, isArabic);
      case 5:
        return _buildMobileProfileView(isArabic, loc);
      default:
        return const SizedBox();
    }
  }

  Widget _buildMobileRequestsView(InventoryLoaded state, AppLocalizations loc) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: state.requests.length,
      itemBuilder: (context, index) {
        final req = state.requests[index];
        final isPending = req.status == 'pending';
        final statusColor = isPending ? AppColors.warningOrange : AppColors.successGreen;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreenBg.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    isPending ? Icons.hourglass_empty : Icons.check_circle_outline,
                    color: statusColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        req.id,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        '${loc.translate(req.unit)} • ${loc.translate(req.itemName)}',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        loc.translate(req.status),
                        style: GoogleFonts.cairo(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      loc.translate(req.time),
                      style: GoogleFonts.cairo(
                        fontSize: 10,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileNotificationsView(InventoryLoaded state, bool isArabic) {
    return MobileNotificationsView(
      notifications: state.notifications,
      isArabic: isArabic,
    );
  }

  Widget _buildMobileProfileView(bool isArabic, AppLocalizations loc) {
    return MobileProfileView(
      user: widget.user,
      isArabic: isArabic,
      initialImagePath: _profileImagePath,
      initialAvatarIndex: _selectedAvatarIndex,
      onProfileChanged: (path, avatarIndex) {
        setState(() {
          _profileImagePath = path;
          _selectedAvatarIndex = avatarIndex;
        });
      },
    );
  }
}
