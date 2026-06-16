import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/inventory_item.dart';
import '../bloc/inventory_bloc.dart';
import 'add_item_form.dart';

class MobileInventoryView extends StatelessWidget {
  final List<InventoryItem> items;
  final String searchQuery;
  final String selectedCategory;
  final String selectedStatus;
  final bool isArabic;

  const MobileInventoryView({
    super.key,
    required this.items,
    required this.searchQuery,
    required this.selectedCategory,
    required this.selectedStatus,
    required this.isArabic,
  });

  void _showAddItemDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.9,
          child: AddItemForm(isArabic: isArabic),
        );
      },
    );
  }

  void _showItemDetailsSheet(BuildContext context, InventoryItem item, AppLocalizations loc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return Directionality(
          textDirection: loc.textDirection,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.lightGreenBg,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.inventory_2_outlined, color: AppColors.secondaryGreen),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.translate(item.name),
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColors.textDark,
                            ),
                          ),
                          Text(
                            item.id,
                            style: GoogleFonts.cairo(
                              color: AppColors.textMuted,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildSectionTitle(loc.translate('basicInfo')),
                _buildDetailTile(loc.translate('categoryLabel'), loc.translate('cat${item.category}'), Icons.category_outlined),
                _buildDetailTile(loc.translate('warehouseLabel'), loc.translate(item.warehouse), Icons.warehouse_outlined),
                _buildDetailTile(loc.translate('lastUpdated'), item.lastUpdated, Icons.update_outlined),
                const SizedBox(height: 24),
                _buildSectionTitle(loc.translate('stockInfo')),
                _buildDetailTile(loc.translate('quantityLabel'), '${item.quantity}', Icons.numbers_outlined),
                _buildDetailTile(loc.translate('status'), loc.translate(item.status), Icons.info_outline),
                const SizedBox(height: 24),
                _buildSectionTitle(loc.translate('additionalDetails')),
                _buildDetailTile(loc.translate('serialNumber'), item.serialNumber ?? 'N/A', Icons.qr_code_outlined),
                _buildDetailTile(loc.translate('expiryDateLabel'), item.expiryDate ?? 'N/A', Icons.event_busy_outlined),
                const SizedBox(height: 24),
                if (item.notes != null) ...[
                  _buildSectionTitle(loc.translate('additionalNotes')),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.sandCream,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      item.notes!,
                      style: GoogleFonts.cairo(fontSize: 14, color: AppColors.textDark, height: 1.6),
                    ),
                  ),
                ],
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      loc.translate('cancelButton'),
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDetailTile(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Text(
            label,
            style: GoogleFonts.cairo(fontSize: 14, color: AppColors.textMuted),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textDark),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(isArabic);
    final categories = ['catAll', 'catFood', 'catMedical', 'catSupplies', 'catEquipment'];

    return Column(
      children: [
        _buildSearchAndFilterHeader(context, loc, categories),
        Expanded(
          child: _buildItemsList(context, loc),
        ),
      ],
    );
  }

  Widget _buildSearchAndFilterHeader(BuildContext context, AppLocalizations loc, List<String> categories) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.translate('inventoryManagement'),
            style: GoogleFonts.cairo(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.sandCream,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: TextField(
                    onChanged: (val) {
                      context.read<InventoryBloc>().add(SearchInventory(val));
                    },
                    decoration: InputDecoration(
                      hintText: loc.translate('searchPlaceholder'),
                      hintStyle: GoogleFonts.cairo(color: AppColors.textMuted, fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () => _showAddItemDrawer(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryGreen,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondaryGreen.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final catKey = categories[index];
                final catValue = catKey == 'catAll' ? 'All' : catKey.replaceFirst('cat', '');
                final isSelected = selectedCategory == catValue;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(
                      loc.translate(catKey),
                      style: GoogleFonts.cairo(
                        color: isSelected ? Colors.white : AppColors.textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.primaryGreen,
                    backgroundColor: AppColors.sandCream,
                    showCheckmark: false,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected ? Colors.transparent : AppColors.borderLight,
                      ),
                    ),
                    onSelected: (val) {
                      if (val) context.read<InventoryBloc>().add(FilterByCategory(catValue));
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(BuildContext context, AppLocalizations loc) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
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
          child: InkWell(
            onTap: () => _showItemDetailsSheet(context, item, loc),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.sandCream,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.inventory_2_outlined, color: AppColors.textMuted),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.translate(item.name),
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${item.id} • ${loc.translate('cat${item.category}')}',
                              style: GoogleFonts.cairo(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${item.quantity}',
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.textDark,
                        ),
                      ),
                      _buildStatusBadge(item.status, loc),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status, AppLocalizations loc) {
    Color color = AppColors.successGreen;
    if (status == 'lowStock') color = AppColors.warningOrange;
    if (status == 'outOfStock') color = AppColors.errorRed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        loc.translate(status),
        style: GoogleFonts.cairo(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
