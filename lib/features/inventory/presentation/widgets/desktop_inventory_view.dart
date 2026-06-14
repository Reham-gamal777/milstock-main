import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/inventory_item.dart';
import '../bloc/inventory_bloc.dart';
import 'add_item_form.dart';

class DesktopInventoryView extends StatelessWidget {
  final List<InventoryItem> items;
  final String searchQuery;
  final String selectedCategory;
  final String selectedStatus;
  final bool isArabic;

  const DesktopInventoryView({
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

  void _showItemDetailsDialog(BuildContext context, InventoryItem item, AppLocalizations loc) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: loc.textDirection,
          child: AlertDialog(
            backgroundColor: AppColors.cardBg,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Row(
              children: [
                const Icon(Icons.info, color: AppColors.secondaryGreen),
                const SizedBox(width: 8),
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(loc.translate('itemId'), item.id),
                  _buildDetailRow(loc.translate('categoryLabel'), item.category),
                  _buildDetailRow(loc.translate('quantityLabel'), '${item.quantity}'),
                  _buildDetailRow(loc.translate('warehouseLabel'), item.warehouse),
                  _buildDetailRow(loc.translate('serialNumber'), item.serialNumber ?? 'N/A'),
                  _buildDetailRow(loc.translate('expiryDateLabel'), item.expiryDate ?? 'N/A'),
                  _buildDetailRow(loc.translate('manufacturerLabel'), item.manufacturer ?? 'N/A'),
                  _buildDetailRow(loc.translate('lastUpdated'), item.lastUpdated),
                  const SizedBox(height: 12),
                  const Text(
                    'Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.notes ?? 'No notes available.',
                    style: const TextStyle(fontSize: 13, color: AppColors.textDark, height: 1.4),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  loc.translate('cancelButton'),
                  style: const TextStyle(color: AppColors.secondaryGreen, fontWeight: FontWeight.bold),
                ),
              ),
            ],
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
    final statuses = ['All', 'inStock', 'lowStock', 'outOfStock'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.translate('inventoryManagement'),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.translate('inventorySubtitle'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 18),
                label: Text(loc.translate('addNewItem')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                onPressed: () => _showAddItemDrawer(context),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Filters Row
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Search Input
                  Expanded(
                    flex: 3,
                    child: TextField(
                      onChanged: (val) {
                        context.read<InventoryBloc>().add(SearchInventory(val));
                      },
                      decoration: InputDecoration(
                        hintText: loc.translate('searchPlaceholder'),
                        prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Category Filter Dropdown
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedCategory,
                      decoration: InputDecoration(
                        labelText: loc.translate('categoryLabel'),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          context.read<InventoryBloc>().add(FilterByCategory(val));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Status Filter Dropdown
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      initialValue: selectedStatus,
                      decoration: InputDecoration(
                        labelText: loc.translate('status'),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: statuses.map((stat) {
                        return DropdownMenuItem(
                          value: stat,
                          child: Text(loc.translate(stat)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          context.read<InventoryBloc>().add(FilterByStatus(val));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Data Table Card
          Card(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Theme(
                data: Theme.of(context).copyWith(
                  dividerColor: AppColors.borderLight,
                ),
                child: DataTable(
                  columnSpacing: 16,
                  horizontalMargin: 16,
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                  columns: [
                    DataColumn(label: Text(loc.translate('itemId'))),
                    DataColumn(label: Text(loc.translate('itemName'))),
                    DataColumn(label: Text(loc.translate('category'))),
                    DataColumn(label: Text(loc.translate('quantity'))),
                    DataColumn(label: Text(loc.translate('status'))),
                    DataColumn(label: Text(loc.translate('lastUpdated'))),
                    DataColumn(label: Text(loc.translate('warehouse'))),
                    DataColumn(label: Text(loc.translate('action'))),
                  ],
                  rows: items.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(Text(item.id, style: const TextStyle(fontWeight: FontWeight.bold))),
                        DataCell(Text(item.name)),
                        DataCell(Text(item.category)),
                        DataCell(Text('${item.quantity}')),
                        DataCell(_buildStatusBadge(item.status, loc)),
                        DataCell(Text(item.lastUpdated)),
                        DataCell(Text(item.warehouse)),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.visibility, color: AppColors.secondaryGreen, size: 18),
                            onPressed: () => _showItemDetailsDialog(context, item, loc),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
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
}
