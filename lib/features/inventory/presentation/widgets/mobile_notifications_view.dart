import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/notification_item.dart';
import '../bloc/inventory_bloc.dart';

class MobileNotificationsView extends StatefulWidget {
  final List<NotificationItem> notifications;
  final bool isArabic;

  const MobileNotificationsView({
    super.key,
    required this.notifications,
    required this.isArabic,
  });

  @override
  State<MobileNotificationsView> createState() => _MobileNotificationsViewState();
}

class _MobileNotificationsViewState extends State<MobileNotificationsView> {
  String _activeFilter = 'all';
  bool _showOnlyUnread = false;

  void _markAllRead() {
    context.read<InventoryBloc>().add(MarkAllNotificationsAsRead());
  }

  int get _unreadCount => widget.notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(widget.isArabic);
    
    return Column(
      children: [
        _buildHeader(loc),
        _buildFilters(loc),
        Expanded(
          child: _buildNotificationsList(loc),
        ),
      ],
    );
  }

  Widget _buildHeader(AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    loc.translate('notifications'),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (_unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.errorRed,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$_unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: _unreadCount > 0 ? _markAllRead : null,
                icon: const Icon(Icons.check, size: 16),
                label: Text(
                  loc.translate('markAllRead'),
                  style: const TextStyle(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryGreen,
                  disabledBackgroundColor: AppColors.secondaryGreen.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            loc.translate('notificationsSubtitle'),
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildTabButton(loc.translate('allNotifications'), !_showOnlyUnread, () {
                setState(() => _showOnlyUnread = false);
              }),
              const SizedBox(width: 8),
              _buildTabButton(loc.translate('unread'), _showOnlyUnread, () {
                setState(() => _showOnlyUnread = true);
              }, isSecondary: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isActive, VoidCallback onTap, {bool isSecondary = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive 
                ? (isSecondary ? AppColors.lightGreenBg : AppColors.secondaryGreen)
                : (isSecondary ? AppColors.lightGreenBg.withOpacity(0.5) : Colors.transparent),
            borderRadius: BorderRadius.circular(12),
            border: isActive ? null : Border.all(color: AppColors.primaryGreen.withOpacity(0.1)),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive 
                  ? (isSecondary ? AppColors.textMuted : Colors.white)
                  : AppColors.textMuted,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilters(AppLocalizations loc) {
    final filters = [
      {'id': 'all', 'label': loc.translate('all')},
      {'id': 'inventory', 'label': loc.translate('inventory')},
      {'id': 'requests', 'label': loc.translate('menuRequests')},
      {'id': 'validity', 'label': loc.translate('validity')},
      {'id': 'system', 'label': loc.translate('system')},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: filters.map((filter) {
          final isActive = _activeFilter == filter['id'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter['label']!),
              selected: isActive,
              onSelected: (selected) {
                if (selected) setState(() => _activeFilter = filter['id']!);
              },
              selectedColor: AppColors.primaryGreen,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isActive ? Colors.white : AppColors.textDark,
                fontSize: 14,
              ),
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: isActive ? Colors.transparent : AppColors.borderLight,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationsList(AppLocalizations loc) {
    final filteredList = widget.notifications.where((item) {
      final matchesTab = _activeFilter == 'all' || item.category == _activeFilter;
      final matchesUnread = !_showOnlyUnread || !item.isRead;
      return matchesTab && matchesUnread;
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return _buildNotificationCard(loc, item);
      },
    );
  }

  Widget _buildNotificationCard(AppLocalizations loc, NotificationItem item) {
    final String type = item.type;
    final bool isNew = !item.isRead;
    
    Color borderColor;
    IconData iconData;
    Color iconBg;

    switch (type) {
      case 'error':
        borderColor = AppColors.errorRed;
        iconData = Icons.error_outline;
        iconBg = AppColors.errorRed.withOpacity(0.1);
        break;
      case 'warning':
        borderColor = AppColors.warningOrange;
        iconData = Icons.access_time;
        iconBg = AppColors.warningOrange.withOpacity(0.1);
        break;
      case 'success':
        borderColor = AppColors.successGreen;
        iconData = Icons.check_circle_outline;
        iconBg = AppColors.successGreen.withOpacity(0.1);
        break;
      default:
        borderColor = AppColors.infoGrey;
        iconData = type == 'info' ? Icons.info_outline : Icons.notifications_none;
        iconBg = AppColors.infoGrey.withOpacity(0.05);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          top: BorderSide(color: borderColor, width: 1.2),
          bottom: BorderSide(color: borderColor, width: 1.2),
          left: widget.isArabic ? BorderSide(color: borderColor, width: 1.2) : BorderSide(color: borderColor, width: 4),
          right: widget.isArabic ? BorderSide(color: borderColor, width: 4) : BorderSide(color: borderColor, width: 1.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, color: borderColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        loc.translate(item.titleKey),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.textDark,
                        ),
                      ),
                      Row(
                        children: [
                          if (isNew) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryGreen.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.secondaryGreen.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: const BoxDecoration(
                                      color: AppColors.secondaryGreen,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    loc.translate('newBadge'),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            loc.translate(item.time),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    loc.translate(item.message),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
