// File: lib/features/products/presentation/pages/add_product_page.dart

import 'dart:io';

import 'package:ecommerceapp/core/constants/app_categories.dart';
import 'package:ecommerceapp/core/services/cloudinary_service.dart';
import 'package:ecommerceapp/core/theme/app_colors.dart';
import 'package:ecommerceapp/core/services/product_translation_service.dart';
import 'package:ecommerceapp/core/notifications/notification_api.dart';
import 'package:ecommerceapp/core/widgets/profile_avatar.dart';
import 'package:ecommerceapp/features/products/domain/entities/product_entity.dart';
import 'package:ecommerceapp/features/products/presentation/manager/product_cubit.dart';
import 'package:ecommerceapp/features/profile/presentation/pages/profile_screen.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
  final _descriptionArController = TextEditingController();
  final _descriptionEnController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String? _existingImageUrl;
  String _selectedCategory = ProductCategoryHelper.clothing;
  late bool _isArabicInput;
  bool _isLanguageInitialized = false;
  bool _isTranslating = false;
  bool _isUploadingImage = false;

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
      _descriptionArController.text = widget.product!.descriptionAr;
      _descriptionEnController.text = widget.product!.descriptionEn;
      _existingImageUrl = widget.product!.image;
      if (widget.product!.category.isNotEmpty) {
        _selectedCategory = widget.product!.category;
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLanguageInitialized) {
      _isArabicInput = Localizations.localeOf(context).languageCode == 'ar';
      _isLanguageInitialized = true;
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
    _descriptionArController.dispose();
    _descriptionEnController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) return;

    setState(() {
      _selectedImage = File(pickedFile.path);
    });
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
      _existingImageUrl = null;
    });
  }

  Future<void> _saveProduct(AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate() || _isTranslating || _isUploadingImage) {
      return;
    }

    final hasImage = _selectedImage != null ||
        (_existingImageUrl != null && _existingImageUrl!.trim().isNotEmpty);

    if (!hasImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.chooseImageFirst),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    final productCubit = context.read<ProductCubit>();
    setState(() => _isTranslating = true);
    try {
      final translated = await ProductTranslationService.translateAll(
        texts: [
          _isArabicInput ? _nameArController.text : _nameEnController.text,
          _isArabicInput ? _brandArController.text : _brandEnController.text,
          _isArabicInput
              ? _descriptionArController.text
              : _descriptionEnController.text,
        ],
        fromArabic: _isArabicInput,
      );

      if (_isArabicInput) {
        _nameEnController.text = translated[0];
        _brandEnController.text = translated[1];
        _descriptionEnController.text = translated[2];
      } else {
        _nameArController.text = translated[0];
        _brandArController.text = translated[1];
        _descriptionArController.text = translated[2];
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.translationFailed(error.toString()),
            ),
          ),
        );
        setState(() => _isTranslating = false);
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isTranslating = false;
        _isUploadingImage = true;
      });
    }

    String imageUrl = _existingImageUrl ?? '';

    if (_selectedImage != null) {
      try {
        imageUrl = await CloudinaryService.uploadImage(_selectedImage!);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.imageUploadFailed),
              backgroundColor: Colors.red.shade700,
            ),
          );
          setState(() => _isUploadingImage = false);
        }
        return;
      }
    }

    if (imageUrl.trim().isEmpty) {
      imageUrl =
          'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?q=80&w=800';
    }

    final product = ProductEntity(
      id: widget.product?.id ?? '',
      nameAr: _nameArController.text.trim(),
      nameEn: _nameEnController.text.trim(),
      brandAr: _brandArController.text.trim(),
      brandEn: _brandEnController.text.trim(),
      descriptionAr: _descriptionArController.text.trim(),
      descriptionEn: _descriptionEnController.text.trim(),
      price: double.tryParse(_priceController.text.trim()) ?? 0,
      year: int.tryParse(_yearController.text.trim()) ?? 2024,
      image: imageUrl,
      category: _selectedCategory,
    );

    if (widget.product == null) {
      await productCubit.addProduct(product);
      await NotificationApi.notify(
        action: 'notify_users',
        title: 'New Product',
        body: '${product.nameEn} is now available in the store.',
        data: {'type': 'new_product'},
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(l10n.productAddedSuccessfully),
          ),
        );
      }
    } else {
      await productCubit.updateProduct(product.id, product);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(l10n.changesSavedSuccessfully),
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isTranslating = false;
        _isUploadingImage = false;
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isEditing = widget.product != null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : null,
        title: Text(
          isEditing ? l10n.editProduct : l10n.addProduct,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : null,
          ),
        ),
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                tooltip: l10n.back,
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: isDark ? AppColors.gold : null,
                ),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: ProfileAvatar(
              size: 32,
              onTap: () =>
                  Navigator.pushNamed(context, ProfileScreen.screenRoute),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Image Picker Section (From Gallery)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.chooseImage,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_selectedImage == null &&
                      (_existingImageUrl == null ||
                          _existingImageUrl!.trim().isEmpty))
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: (_isTranslating || _isUploadingImage)
                          ? null
                          : _pickImage,
                      child: Container(
                        width: double.infinity,
                        height: 160,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 48,
                              color: isDark
                                  ? AppColors.gold
                                  : Colors.grey.shade600,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              l10n.chooseFromGallery,
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _selectedImage != null
                          ? Image.file(
                              _selectedImage!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              _existingImageUrl!,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 180,
                                color: Colors.grey.shade100,
                                child: const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: (_isTranslating || _isUploadingImage)
                                ? null
                                : _pickImage,
                            icon: const Icon(Icons.photo_library_outlined,
                                size: 18),
                            label: Text(l10n.changeImage),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          tooltip: l10n.deleteImage,
                          style: IconButton.styleFrom(
                            foregroundColor: Colors.red.shade700,
                          ),
                          onPressed: (_isTranslating || _isUploadingImage)
                              ? null
                              : _removeImage,
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // The admin enters text in the current app language only.
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
                    controller: _isArabicInput
                        ? _nameArController
                        : _nameEnController,
                    label: l10n.productName,
                    icon: Icons.shopping_bag_outlined,
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

            // Category
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.categoryLabel,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    dropdownColor: isDark ? AppColors.darkCard : Colors.white,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.category_outlined,
                        size: 20,
                        color: isDark ? AppColors.gold : null,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : Colors.grey.shade300,
                        ),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkSurface
                          : Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                    ),
                    items: ProductCategoryHelper.getSelectableCategories()
                        .map((cat) {
                      return DropdownMenuItem<String>(
                        value: cat.id,
                        child: Row(
                          children: [
                            Icon(
                              cat.icon,
                              size: 20,
                              color: isDark ? AppColors.gold : Colors.red.shade600,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              cat.getTitle(l10n),
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (_isTranslating || _isUploadingImage)
                        ? null
                        : (value) {
                            if (value != null) {
                              setState(() => _selectedCategory = value);
                            }
                          },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Brand
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
              ),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _isArabicInput
                        ? _brandArController
                        : _brandEnController,
                    label: l10n.brand,
                    icon: Icons.branding_watermark_outlined,
                    isDark: isDark,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Description
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : Colors.grey.shade200,
                ),
              ),
              child: Column(
                children: [
                  _buildTextField(
                    controller: _isArabicInput
                        ? _descriptionArController
                        : _descriptionEnController,
                    label: l10n.descriptionLabel,
                    icon: Icons.description_outlined,
                    maxLines: 2,
                    isDark: isDark,
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
                  backgroundColor:
                      isDark ? AppColors.gold : Colors.red.shade600,
                  foregroundColor:
                      isDark ? const Color(0xFF0B0E14) : Colors.white,
                  elevation: isDark ? 4 : 2,
                  shadowColor:
                      isDark ? AppColors.goldGlow : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: (_isTranslating || _isUploadingImage)
                    ? null
                    : () => _saveProduct(l10n),
                icon: (_isTranslating || _isUploadingImage)
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  _isTranslating
                      ? l10n.translating
                      : (_isUploadingImage
                          ? l10n.uploadingImage
                          : (isEditing ? l10n.saveChanges : l10n.addProductButton)),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
    bool required = true,
    bool isDark = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.text,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? AppColors.darkTextSecondary : null,
        ),
        prefixIcon: Icon(
          icon,
          size: 20,
          color: isDark ? AppColors.gold : null,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
          ),
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
      validator: required
          ? (value) {
              if (value == null || value.trim().isEmpty) {
                return AppLocalizations.of(context)!.requiredField;
              }
              return null;
            }
          : null,
    );
  }
}
