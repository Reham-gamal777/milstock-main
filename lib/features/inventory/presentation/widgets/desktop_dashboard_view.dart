import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/supply_request.dart';
import '../../domain/entities/notification_item.dart';
import 'stock_chart.dart';

class DesktopDashboardView extends StatelessWidget {
  final List<SupplyRequest> requests;
  final List<NotificationItem> notifications;
  final bool isArabic;

  const DesktopDashboardView({
    super.key,
    required this.requests,
    required this.notifications,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(isArabic);

    final pendingCount = requests.where((r) => r.status == 'pending').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // View Header
          Text(
            loc.translate('dashboard'),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),

          // Statistics Row
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: loc.translate('activeRequests'),
                  value: '${requests.length}',
                  footer: loc.translate('approvedToday'),
                  icon: Icons.assignment,
                  iconColor: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildStatCard(
                  title: loc.translate('pendingApproval'),
                  value: '$pendingCount',
                  footer: loc.translate('processingEst'),
                  icon: Icons.hourglass_empty,
                  iconColor: AppColors.warningOrange,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildStatCard(
                  title: loc.translate('completedThisMonth'),
                  value: '8', // Mock total completed
                  footer: loc.translate('vsLastMonth'),
                  icon: Icons.check_circle_outline,
                  iconColor: AppColors.successGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Split Content area
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side charts & requests
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    // Stock Level Chart Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  loc.translate('stockLevelTitle'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.lightGreenBg,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    loc.translate('capacityPercentage'),
                                    style: const TextStyle(
                                      color: AppColors.secondaryGreen,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 200,
                              child: StockChart(isArabic: isArabic),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Recent Requests Table Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  loc.translate('recentRequests'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    '${loc.translate('viewAll')} →',
                                    style: const TextStyle(
                                      color: AppColors.secondaryGreen,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: requests.length,
                              separatorBuilder: (context, index) => const Divider(color: AppColors.sandCream, height: 1),
                              itemBuilder: (context, index) {
                                final req = requests[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                req.id,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textDark,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              _buildPriorityBadge(req.id),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${req.unit} • ${req.itemName}',
                                            style: const TextStyle(
                                              color: AppColors.textMuted,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            req.time,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: AppColors.textMuted,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          _buildStatusBadge(req.status, loc),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),

              // Right side panels (Alerts & processing time)
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    // Critical Alerts Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.translate('criticalAlerts'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.textDark,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: notifications.length,
                              itemBuilder: (context, index) {
                                final item = notifications[index];
                                return _buildNotificationTile(item);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Average Processing Time Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.lightGreenBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.access_time_filled,
                                color: AppColors.secondaryGreen,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.translate('averageProcessingTime'),
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    loc.translate('averageHours'),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textDark,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    loc.translate('hoursChange'),
                                    style: const TextStyle(
                                      color: AppColors.successGreen,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String footer,
    required IconData icon,
    required Color iconColor,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  footer,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(String reqId) {
    String label = 'NORMAL';
    Color color = AppColors.infoGrey;
    if (reqId == 'REQ-1234') {
      label = 'HIGH';
      color = AppColors.errorRed;
    } else if (reqId == 'REQ-1233') {
      label = 'URGENT';
      color = AppColors.errorRed;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status, AppLocalizations loc) {
    Color color = AppColors.infoGrey;
    String label = loc.translate('pending');

    if (status == 'approved') {
      color = AppColors.successGreen;
      label = loc.translate('approved');
    } else if (status == 'delivered') {
      color = AppColors.successGreen;
      label = loc.translate('delivered');
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNotificationTile(NotificationItem item) {
    Color indicatorColor = AppColors.infoGrey;
    IconData icon = Icons.info_outline;

    if (item.type == 'error') {
      indicatorColor = AppColors.errorRed;
      icon = Icons.error_outline;
    } else if (item.type == 'warning') {
      indicatorColor = AppColors.warningOrange;
      icon = Icons.warning_amber_outlined;
    } else if (item.type == 'info') {
      indicatorColor = AppColors.successGreen;
      icon = Icons.check_circle_outline;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: indicatorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: indicatorColor, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.message,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
