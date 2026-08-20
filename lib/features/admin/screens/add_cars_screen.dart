import 'dart:io';
import 'package:ecommerceapp/features/products/presentation/manager/product_cubit.dart';
import 'package:ecommerceapp/features/products/domain/entities/product_entity.dart';
import 'package:ecommerceapp/features/cars/repository/image_repository.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddCarScreen extends StatefulWidget {
  final ProductEntity? product;

  const AddCarScreen({super.key, this.product});

  static const String screenRoute = 'addCar';

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for bilingual support
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

  File? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  final ImageRepository _imageRepository = ImageRepository();

  @override
  void initState() {
    super.initState();
    // Fill controllers if editing existing product
    if (widget.product != null) {
      _nameArController.text = widget.product!.nameAr;
      _nameEnController.text = widget.product!.nameEn;
      _priceController.text = widget.product!.price.toString();
      _yearController.text = widget.product!.year.toString();
      _brandArController.text = widget.product!.brandAr;
      _brandEnController.text = widget.product!.brandEn;
      _locationArController.text = widget.product!.locationAr;
      _locationEnController.text = widget.product!.locationEn;
      _descriptionArController.text = widget.product!.descriptionAr;
      _descriptionEnController.text = widget.product!.descriptionEn;
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
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _selectedImage = File(image.path));
  }

  Future<void> _saveProduct() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_selectedImage == null && widget.product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.chooseImageFirst)),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      String imageUrl = widget.product?.image ?? '';
      if (_selectedImage != null) {
        imageUrl = await _imageRepository.uploadImage(_selectedImage!);
      }

      final newProduct = ProductEntity(
        id: widget.product?.id ?? '',
        nameAr: _nameArController.text,
        nameEn: _nameEnController.text,
        brandAr: _brandArController.text,
        brandEn: _brandEnController.text,
        locationAr: _locationArController.text,
        locationEn: _locationEnController.text,
        descriptionAr: _descriptionArController.text,
        descriptionEn: _descriptionEnController.text,
        price: double.parse(_priceController.text),
        year: int.parse(_yearController.text),
        image: imageUrl,
      );

      if (widget.product == null) {
        await context.read<ProductCubit>().addProduct(newProduct);
      } else {
        await context.read<ProductCubit>().updateProduct(widget.product!.id, newProduct);
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(widget.product == null ? l10n.addCar : l10n.editCar)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField(_nameArController, 'الاسم (عربي)'),
            _buildTextField(_nameEnController, 'Name (English)'),
            _buildTextField(_priceController, 'Price', isNumber: true),
            _buildTextField(_yearController, 'Year', isNumber: true),
            _buildTextField(_brandArController, 'الماركة (عربي)'),
            _buildTextField(_brandEnController, 'Brand (English)'),
            _buildTextField(_locationArController, 'الموقع (عربي)'),
            _buildTextField(_locationEnController, 'Location (English)'),
            _buildTextField(_descriptionArController, 'الوصف (عربي)', maxLines: 3),
            _buildTextField(_descriptionEnController, 'Description (English)', maxLines: 3),
            const SizedBox(height: 20),
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 200, fit: BoxFit.cover)
            else if (widget.product != null)
              Image.network(widget.product!.image, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.image),
              label: Text(l10n.chooseImage),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveProduct,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(widget.product == null ? l10n.addCarButton : l10n.saveChanges),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        maxLines: maxLines,
        validator: (value) => (value == null || value.trim().isEmpty) ? 'Required field' : null,
      ),
    );
  }
}