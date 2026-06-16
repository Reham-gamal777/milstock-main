import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';

class ConsumptionWasteView extends StatelessWidget {
  final bool isArabic;

  const ConsumptionWasteView({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(isArabic);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.translate('menuConsumption'),
            style: GoogleFonts.cairo(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 24),
          
          // Stats Row
          Row(
            children: [
              _buildStatCard(
                loc.isArabic ? 'إجمالي الاستهلاك' : 'Total Consumption',
                '1,250',
                Icons.trending_up,
                AppColors.secondaryGreen,
                loc,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                loc.isArabic ? 'إجمالي الهدر' : 'Total Waste',
                '42',
                Icons.delete_outline,
                AppColors.errorRed,
                loc,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                loc.isArabic ? 'معدل الكفاءة' : 'Efficiency Rate',
                '96.8%',
                Icons.analytics_outlined,
                AppColors.successGreen,
                loc,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Main Table/List
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.isArabic ? 'التقارير الأخيرة' : 'Recent Reports',
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                _buildReportItem(
                  loc.isArabic ? 'وجبات جاهزة (MRE)' : 'MRE Rations',
                  '200 Units',
                  '5 Units',
                  '2026-05-10',
                  loc,
                ),
                _buildReportItem(
                  loc.isArabic ? 'مستلزمات طبية' : 'Medical Supplies',
                  '150 Units',
                  '2 Units',
                  '2026-05-09',
                  loc,
                ),
                _buildReportItem(
                  loc.isArabic ? 'معدات صيانة' : 'Maintenance Gear',
                  '80 Units',
                  '0 Units',
                  '2026-05-08',
                  loc,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, AppLocalizations loc) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.cairo(
                color: AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.cairo(
                color: AppColors.textDark,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportItem(String item, String consumed, String wasted, String date, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item,
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: AppColors.textDark),
                ),
                Text(
                  date,
                  style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildValueChip(loc.isArabic ? 'استهلاك: ' : 'Cons: ', consumed, AppColors.secondaryGreen),
              const SizedBox(width: 8),
              _buildValueChip(loc.isArabic ? 'هدر: ' : 'Waste: ', wasted, AppColors.errorRed),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(fontSize: 11, color: color),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
