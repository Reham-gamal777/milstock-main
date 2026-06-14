import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: AddItemForm(isArabic: isArabic),
        );
      },
    );
  }

  void _showItemDetailsSheet(BuildContext context, InventoryItem item, AppLocalizations loc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        return Directionality(
          textDirection: loc.textDirection,
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ],
                ),
                const Divider(color: AppColors.borderLight),
                const SizedBox(height: 12),
                _buildDetailRow(loc.translate('itemId'), item.id),
                _buildDetailRow(loc.translate('categoryLabel'), item.category),
                _buildDetailRow(loc.translate('quantityLabel'), '${item.quantity}'),
                _buildDetailRow(loc.translate('warehouseLabel'), item.warehouse),
                _buildDetailRow(loc.translate('serialNumber'), item.serialNumber ?? 'N/A'),
                _buildDetailRow(loc.translate('expiryDateLabel'), item.expiryDate ?? 'N/A'),
                _buildDetailRow(loc.translate('manufacturerLabel'), item.manufacturer ?? 'N/A'),
                _buildDetailRow(loc.translate('lastUpdated'), item.lastUpdated),
                const SizedBox(height: 16),
                const Text(
                  'Notes:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 4),
                Text(
                  item.notes ?? 'No notes available.',
                  style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.4),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textMuted),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textDark),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(isArabic);
    final categories = ['All', 'Food', 'Medical', 'Supplies', 'Equipment'];

    return Column(
      children: [
        // Search & Filter header
        Container(
          color: AppColors.cardBg,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        context.read<InventoryBloc>().add(SearchInventory(val));
                      },
                      decoration: InputDecoration(
                        hintText: loc.translate('searchPlaceholder'),
                        prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Add Floating Button next to search bar
                  InkWell(
                    onTap: () => _showAddItemDrawer(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: AppColors.textLight, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Category filter pills
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? AppColors.textLight : AppColors.textDark,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.secondaryGreen,
                        backgroundColor: AppColors.sandCream,
                        onSelected: (val) {
                          if (val) {
                            context.read<InventoryBloc>().add(FilterByCategory(cat));
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // List of items
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => _showItemDetailsSheet(context, item, loc),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.id,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.textMuted),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildStatusBadge(item.status, loc),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textDark),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.category} • ${item.warehouse}',
                                style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${item.quantity}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textDark),
                            ),
                            const SizedBox(height: 4),
                            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textMuted),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status, AppLocalizations loc) {
    Color color = AppColors.successGreen;
    String label = loc.translate('inStock');

    if (status == 'lowStock') {
      color = AppColors.warningOrange;
      label = loc.translate('lowStock');
    } else if (status == 'outOfStock') {
      color = AppColors.errorRed;
      label = loc.translate('outOfStock');
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
}
