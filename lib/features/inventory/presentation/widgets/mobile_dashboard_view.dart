import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/supply_request.dart';
import 'stock_chart.dart';

class MobileDashboardView extends StatelessWidget {
  final List<SupplyRequest> requests;
  final bool isArabic;
  final VoidCallback? onViewAllRequests;
  final Function(int)? onTabChanged;

  const MobileDashboardView({
    super.key,
    required this.requests,
    required this.isArabic,
    this.onViewAllRequests,
    this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(isArabic);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeSection(loc),
          const SizedBox(height: 32),
          _buildQuickStats(loc),
          const SizedBox(height: 24),
          _buildChartSection(loc),
          const SizedBox(height: 24),
          _buildRecentRequestsSection(loc),
          const SizedBox(height: 24),
          _buildAverageProcessingCard(loc),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(AppLocalizations loc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.translate('dashboard'),
          style: GoogleFonts.cairo(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          loc.translate('dashboardOverview'),
          style: GoogleFonts.cairo(
            fontSize: 14,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(AppLocalizations loc) {
    final pendingCount = requests.where((r) => r.status == 'pending').length;
    
    return Column(
      children: [
        _buildStatTile(
          title: loc.translate('activeRequests'),
          value: '${requests.length}',
          footer: loc.translate('approvedToday'),
          icon: Icons.assignment_outlined,
          color: AppColors.secondaryGreen,
          onTap: () => onTabChanged?.call(2), // Navigate to Requests
        ),
        const SizedBox(height: 16),
        _buildStatTile(
          title: loc.translate('pendingApproval'),
          value: '$pendingCount',
          footer: loc.translate('processingEst'),
          icon: Icons.hourglass_empty_outlined,
          color: AppColors.warningOrange,
          onTap: () => onTabChanged?.call(2), // Navigate to Requests
        ),
        const SizedBox(height: 16),
        _buildStatTile(
          title: loc.translate('completedThisMonth'),
          value: '8',
          footer: loc.translate('vsLastMonth'),
          icon: Icons.check_circle_outline,
          color: AppColors.successGreen,
          onTap: () => onTabChanged?.call(3), // Navigate to Waste/Reports
        ),
      ],
    );
  }

  Widget _buildStatTile({
    required String title,
    required String value,
    required String footer,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: GoogleFonts.cairo(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  footer,
                  style: GoogleFonts.cairo(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(AppLocalizations loc) {
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
                loc.translate('stockLevelTitle'),
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textDark,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  loc.translate('capacityPercentage'),
                  style: GoogleFonts.cairo(
                    color: AppColors.successGreen,
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
    );
  }

  Widget _buildRecentRequestsSection(AppLocalizations loc) {
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
                loc.translate('recentRequests'),
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textDark,
                ),
              ),
              InkWell(
                onTap: onViewAllRequests,
                child: Text(
                  loc.translate('viewAll'),
                  style: GoogleFonts.cairo(
                    color: AppColors.secondaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 32, color: AppColors.sandBeige),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: requests.length,
            separatorBuilder: (context, index) => const Divider(height: 24, color: AppColors.sandBeige),
            itemBuilder: (context, index) {
              final req = requests[index];
              return _buildRequestRow(req, loc);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRequestRow(SupplyRequest req, AppLocalizations loc) {
    Color statusColor = req.status == 'pending' ? AppColors.warningOrange : AppColors.successGreen;
    
    return Row(
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
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildPriorityBadge(req.id, loc),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${loc.translate(req.unit)} • ${loc.translate(req.itemName)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
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
    );
  }

  Widget _buildPriorityBadge(String reqId, AppLocalizations loc) {
    bool isUrgent = reqId.contains('1234') || reqId.contains('1233');
    Color color = isUrgent ? AppColors.errorRed : AppColors.infoGrey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isUrgent ? loc.translate('priorityUrgent') : loc.translate('priorityNormal'),
        style: GoogleFonts.cairo(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAverageProcessingCard(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.successGreen.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.access_time_filled,
              color: AppColors.successGreen,
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
                  style: GoogleFonts.cairo(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  loc.translate('averageHours'),
                  style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  loc.translate('hoursChange'),
                  style: GoogleFonts.cairo(
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
    );
  }
}
