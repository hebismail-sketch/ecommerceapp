// File: lib/features/products/presentation/pages/add_product_page.dart

import 'package:ecommerceapp/features/products/domain/entities/product_entity.dart';
import 'package:ecommerceapp/features/products/presentation/manager/product_cubit.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddProductPage extends StatefulWidget {
  final ProductEntity? product;

  const AddProductPage({super.key, this.product});

  static const String screenRoute = 'addProduct';

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameArController = TextEditingController();
  final _nameEnController = TextEditingController();
  final _priceController = TextEditingController();
  final _yearController = TextEditingController();
  final _brandArController = TextEditingController();
  final _brandEnController = TextEditingController();
  final _locationArController = TextEditingController();
  final _locationEnController = TextEditingController();
  final _descriptionArController = TextEditingController();
  final _descriptionEnController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameArController.text = widget.product!.nameAr;
      _nameEnController.text = widget.product!.nameEn;
      _priceController.text = widget.product!.price.toStringAsFixed(0);
      _yearController.text = widget.product!.year.toString();
      _brandArController.text = widget.product!.brandAr;
      _brandEnController.text = widget.product!.brandEn;
      _locationArController.text = widget.product!.locationAr;
      _locationEnController.text = widget.product!.locationEn;
      _descriptionArController.text = widget.product!.descriptionAr;
      _descriptionEnController.text = widget.product!.descriptionEn;
      _imageUrlController.text = widget.product!.image;
    }
  }

  @override
  void dispose() {
    _nameArController.dispose();
    _nameEnController.dispose();
    _priceController.dispose();
    _yearController.dispose();
    _brandArController.dispose();
    _brandEnController.dispose();
    _locationArController.dispose();
    _locationEnController.dispose();
    _descriptionArController.dispose();
    _descriptionEnController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) return;

    final image = _imageUrlController.text.trim().isNotEmpty
        ? _imageUrlController.text.trim()
        : 'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=800';

    final product = ProductEntity(
      id: widget.product?.id ?? '',
      nameAr: _nameArController.text.trim(),
      nameEn: _nameEnController.text.trim(),
      brandAr: _brandArController.text.trim(),
      brandEn: _brandEnController.text.trim(),
      locationAr: _locationArController.text.trim(),
      locationEn: _locationEnController.text.trim(),
      descriptionAr: _descriptionArController.text.trim(),
      descriptionEn: _descriptionEnController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0,
      year: int.tryParse(_yearController.text.trim()) ?? 2024,
      image: image,
    );

    if (widget.product == null) {
      await context.read<ProductCubit>().addProduct(product);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(l10n.carAddedSuccessfully),
          ),
        );
      }
    } else {
      await context.read<ProductCubit>().updateProduct(product.id, product);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(l10n.changesSavedSuccessfully),
          ),
        );
      }
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.product != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          isEditing ? l10n.editCar : l10n.addCar,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image URL & Preview Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.chooseImage,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(
                      hintText: 'https://example.com/car-image.jpg',
                      prefixIcon: const Icon(Icons.link),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  if (_imageUrlController.text.trim().isNotEmpty) ...[
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _imageUrlController.text.trim(),
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 100,
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Car Names (AR & EN)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _nameArController,
                    label: '${l10n.carName} (عربي)',
                    icon: Icons.directions_car,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _nameEnController,
                    label: '${l10n.carName} (English)',
                    icon: Icons.directions_car_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Price & Year
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      label: '${l10n.price} (${l10n.egp})',
                      icon: Icons.attach_money,
                      isNumber: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _yearController,
                      label: l10n.manufactureYear,
                      icon: Icons.calendar_today,
                      isNumber: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Brand (AR & EN)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _brandArController,
                    label: '${l10n.brand} (عربي)',
                    icon: Icons.branding_watermark,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _brandEnController,
                    label: '${l10n.brand} (English)',
                    icon: Icons.branding_watermark_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Location (AR & EN)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _locationArController,
                    label: '${l10n.location} (عربي)',
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _locationEnController,
                    label: '${l10n.location} (English)',
                    icon: Icons.location_on_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _descriptionArController,
                    label: '${l10n.descriptionLabel} (عربي)',
                    icon: Icons.description,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _descriptionEnController,
                    label: '${l10n.descriptionLabel} (English)',
                    icon: Icons.description_outlined,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                onPressed: () => _saveProduct(l10n),
                icon: const Icon(Icons.check_circle_outline),
                label: Text(
                  isEditing ? l10n.saveChanges : l10n.addCarButton,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade600),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
      validator: (value) => (value == null || value.trim().isEmpty) ? 'Required' : null,
    );
  }
}
