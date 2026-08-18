import 'dart:io';

import 'package:ecommerceapp/features/cars/controller/car_cubit.dart';
import 'package:ecommerceapp/features/cars/models/item.dart';
import 'package:ecommerceapp/features/cars/repository/image_repository.dart';
import 'package:ecommerceapp/features/cars/services/product_translation_service.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({
    super.key,
    this.car,
  });

  static const String screenRoute = 'addCar';

  final Item? car;

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _yearController = TextEditingController();
  final _brandController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final ImageRepository _imageRepository = ImageRepository();
  final ProductTranslationService _translationService =
  ProductTranslationService();

  File? _selectedImage;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.car != null) {
      final languageCode =
          Localizations.maybeLocaleOf(context)?.languageCode ?? 'ar';

      if (languageCode == 'en') {
        _nameController.text = widget.car!.nameEn;
        _brandController.text = widget.car!.brandEn;
        _locationController.text = widget.car!.locationEn;
        _descriptionController.text = widget.car!.descriptionEn;
      } else {
        _nameController.text = widget.car!.nameAr;
        _brandController.text = widget.car!.brandAr;
        _locationController.text = widget.car!.locationAr;
        _descriptionController.text = widget.car!.descriptionAr;
      }

      _priceController.text = widget.car!.price.toString();
      _yearController.text = widget.car!.year.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _yearController.dispose();
    _brandController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();

    _translationService.dispose();

    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    if (!mounted) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }

  Future<TranslatedText> _translateField(String text) async {
    final cleanText = text.trim();

    if (cleanText.isEmpty) {
      throw Exception('Text cannot be empty.');
    }

    return _translationService.translateAutomatically(cleanText);
  }

  Future<void> _saveCar() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImage == null && widget.car == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.chooseImageFirst),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try {
      String imageUrl = widget.car?.image ?? '';

      if (_selectedImage != null) {
        imageUrl = await _imageRepository.uploadImage(
          _selectedImage!,
        );
      }

      final nameTranslation =
      await _translateField(_nameController.text);

      final brandTranslation =
      await _translateField(_brandController.text);

      final locationTranslation =
      await _translateField(_locationController.text);

      final descriptionTranslation =
      await _translateField(_descriptionController.text);

      final data = {
        'nameAr': nameTranslation.arabic,
        'nameEn': nameTranslation.english,

        'brandAr': brandTranslation.arabic,
        'brandEn': brandTranslation.english,

        'locationAr': locationTranslation.arabic,
        'locationEn': locationTranslation.english,

        'descriptionAr': descriptionTranslation.arabic,
        'descriptionEn': descriptionTranslation.english,

        'price': double.parse(
          _priceController.text.trim(),
        ),

        'year': int.parse(
          _yearController.text.trim(),
        ),

        'image': imageUrl,

        'order': widget.car == null
            ? DateTime.now().millisecondsSinceEpoch
            : null,
      };

      data.removeWhere(
            (key, value) => value == null,
      );

      final carCubit = context.read<CarCubit>();

      if (widget.car == null) {
        await carCubit.addCar(data);
      } else {
        await carCubit.updateCar(
          widget.car!.id,
          data,
        );
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.car == null
                ? l10n.carAddedSuccessfully
                : l10n.changesSavedSuccessfully,
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.car == null
              ? l10n.addCar
              : l10n.editCar,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.carName,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return l10n.enterCarName;
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.price,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return l10n.enterPrice;
                  }

                  if (double.tryParse(value.trim()) == null) {
                    return l10n.invalidPrice;
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.manufactureYear,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return l10n.enterManufactureYear;
                  }

                  if (int.tryParse(value.trim()) == null) {
                    return l10n.invalidYear;
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(
                  labelText: l10n.brand,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return l10n.enterBrand;
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: l10n.location,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return l10n.enterLocation;
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 200,
                width: double.infinity,
                child: _selectedImage == null
                    ? Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      l10n.noImageSelected,
                    ),
                  ),
                )
                    : ClipRRect(
                  borderRadius:
                  BorderRadius.circular(12),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading
                      ? null
                      : _pickImage,
                  icon: const Icon(Icons.image),
                  label: Text(
                    l10n.chooseImage,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: l10n.descriptionLabel,
                ),
                validator: (value) {
                  if (value == null ||
                      value.trim().isEmpty) {
                    return l10n.enterDescription;
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _saveCar,
                  child: _isLoading
                      ? const SizedBox(
                    width: 25,
                    height: 25,
                    child:
                    CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                      : Text(
                    widget.car == null
                        ? l10n.addCarButton
                        : l10n.saveChanges,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}