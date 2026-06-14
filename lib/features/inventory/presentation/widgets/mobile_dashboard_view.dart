import 'package:flutter/material.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/supply_request.dart';
import 'stock_chart.dart';

class MobileDashboardView extends StatelessWidget {
  final List<SupplyRequest> requests;
  final bool isArabic;

  const MobileDashboardView({
    super.key,
    required this.requests,
    required this.isArabic,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(isArabic);

    final pendingCount = requests.where((r) => r.status == 'pending').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat cards grid
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildStatCard(
                  title: loc.translate('activeRequests'),
                  value: '${requests.length}',
                  footer: loc.translate('approvedToday'),
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  title: loc.translate('pendingApproval'),
                  value: '$pendingCount',
                  footer: loc.translate('processingEst'),
                  color: AppColors.warningOrange,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  title: loc.translate('completedThisMonth'),
                  value: '8',
                  footer: loc.translate('vsLastMonth'),
                  color: AppColors.successGreen,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stock Level Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.lightGreenBg,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          loc.translate('capacityPercentage'),
                          style: const TextStyle(
                            color: AppColors.secondaryGreen,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 180,
                    child: StockChart(isArabic: isArabic),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Recent Requests
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
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
                          fontSize: 14,
                          color: AppColors.textDark,
                        ),
                      ),
                      Text(
                        loc.translate('viewAll'),
                        style: const TextStyle(
                          color: AppColors.secondaryGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: requests.length,
                    separatorBuilder: (context, index) => const Divider(color: AppColors.sandCream, height: 1),
                    itemBuilder: (context, index) {
                      final req = requests[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        req.id,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _buildPriorityBadge(req.id),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    req.itemName,
                                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildStatusBadge(req.status, loc),
                                const SizedBox(height: 2),
                                Text(
                                  req.time,
                                  style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                                ),
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
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String footer,
    required Color color,
  }) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
          const Spacer(),
          Text(
            footer,
            style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 8,
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

    return Text(
      label,
      style: TextStyle(
        color: color,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
