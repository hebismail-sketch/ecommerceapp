import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/product_cubit.dart';
import '../../domain/entities/product_entity.dart';

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

  @override
  void initState() {
    super.initState();
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

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    // logic to save using ProductCubit
    final product = ProductEntity(
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
      image: widget.product?.image ?? '',
    );

    if (widget.product == null) {
      await context.read<ProductCubit>().addProduct(product);
    } else {
      await context.read<ProductCubit>().updateProduct(product.id, product);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField(_nameArController, 'الاسم (عربي)'),
            _buildTextField(_nameEnController, 'Name (English)'),
            _buildTextField(_priceController, 'Price', isNumber: true),
            _buildTextField(_yearController, 'Year', isNumber: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProduct,
              child: const Text('Save Product'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) => value!.isEmpty ? 'Required' : null,
      ),
    );
  }
}