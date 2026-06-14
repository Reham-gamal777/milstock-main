import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/inventory_item.dart';
import '../bloc/inventory_bloc.dart';

class AddItemForm extends StatefulWidget {
  final bool isArabic;

  const AddItemForm({super.key, required this.isArabic});

  @override
  State<AddItemForm> createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  final _formKey = GlobalKey<FormState>();
  
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController();
  final _serialController = TextEditingController();
  final _expiryController = TextEditingController();
  final _manufacturerController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedCategory = 'Food';
  String _selectedWarehouse = 'Warehouse A';

  @override
  void initState() {
    super.initState();
    // Pre-generate a mock item ID
    final randId = 100 + (DateTime.now().millisecond % 900);
    _idController.text = 'INV-$randId';
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _qtyController.dispose();
    _serialController.dispose();
    _expiryController.dispose();
    _manufacturerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final qty = int.tryParse(_qtyController.text) ?? 0;
      final status = qty == 0 
          ? 'outOfStock' 
          : qty < 200 
              ? 'lowStock' 
              : 'inStock';

      final newItem = InventoryItem(
        id: _idController.text,
        name: _nameController.text,
        category: _selectedCategory,
        quantity: qty,
        status: status,
        lastUpdated: DateTime.now().toString().split(' ')[0],
        warehouse: _selectedWarehouse,
        serialNumber: _serialController.text.isEmpty ? null : _serialController.text,
        expiryDate: _expiryController.text.isEmpty ? 'N/A' : _expiryController.text,
        manufacturer: _manufacturerController.text.isEmpty ? null : _manufacturerController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
      );

      context.read<InventoryBloc>().add(AddNewInventoryItemEvent(newItem));
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations(widget.isArabic).translate('successAddItem')),
          backgroundColor: AppColors.successGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(widget.isArabic);
    final categories = ['Food', 'Medical', 'Supplies', 'Equipment'];
    final warehouses = ['Warehouse A', 'Warehouse B', 'Warehouse C'];

    return Directionality(
      textDirection: loc.textDirection,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Form Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    loc.translate('addItemTitle'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: AppColors.borderLight, height: 24),

              // Basic Info Section
              _buildSectionHeader(loc.translate('basicInfo')),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _idController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: loc.translate('itemId'),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                validator: (val) => val == null || val.isEmpty ? loc.translate('itemNamePlaceholder') : null,
                decoration: InputDecoration(
                  labelText: loc.translate('itemNameLabel'),
                  hintText: loc.translate('itemNamePlaceholder'),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: InputDecoration(
                  labelText: loc.translate('categoryLabel'),
                ),
                items: categories.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Stock Info Section
              _buildSectionHeader(loc.translate('stockInfo')),
              const SizedBox(height: 12),

              TextFormField(
                controller: _qtyController,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return loc.translate('quantityPlaceholder');
                  if (int.tryParse(val) == null) return 'Enter a valid number';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: loc.translate('quantityLabel'),
                  hintText: loc.translate('quantityPlaceholder'),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _serialController,
                decoration: InputDecoration(
                  labelText: loc.translate('serialNumber'),
                  hintText: loc.translate('serialNumberPlaceholder'),
                ),
              ),
              const SizedBox(height: 24),

              // Location & Storage Section
              _buildSectionHeader(loc.translate('locationStorage')),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                initialValue: _selectedWarehouse,
                decoration: InputDecoration(
                  labelText: loc.translate('warehouseLabel'),
                ),
                items: warehouses.map((wh) {
                  return DropdownMenuItem(
                    value: wh,
                    child: Text(wh),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedWarehouse = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Expiration & Tracking Section
              _buildSectionHeader(loc.translate('expirationTracking')),
              const SizedBox(height: 12),

              TextFormField(
                controller: _expiryController,
                decoration: InputDecoration(
                  labelText: loc.translate('expiryDateLabel'),
                  hintText: loc.translate('expiryDatePlaceholder'),
                  suffixIcon: const Icon(Icons.calendar_today, size: 18),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode()); // Hide keyboard
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 365)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (date != null) {
                    _expiryController.text = date.toString().split(' ')[0];
                  }
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _manufacturerController,
                decoration: InputDecoration(
                  labelText: loc.translate('manufacturerLabel'),
                  hintText: loc.translate('manufacturerPlaceholder'),
                ),
              ),
              const SizedBox(height: 24),

              // Additional Notes Section
              _buildSectionHeader(loc.translate('additionalDetails')),
              const SizedBox(height: 12),

              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: loc.translate('additionalNotes'),
                  hintText: loc.translate('additionalNotesPlaceholder'),
                ),
              ),
              const SizedBox(height: 32),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderLight),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        loc.translate('cancelButton'),
                        style: const TextStyle(color: AppColors.textMuted, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: _submit,
                      child: Text(loc.translate('saveItemButton')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppColors.secondaryGreen,
        letterSpacing: 1.1,
      ),
    );
  }
}
