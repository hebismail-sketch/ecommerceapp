import 'dart:io';

import 'package:ecommerceapp/features/orders/presentation/pages/order_screen.dart';
import 'package:ecommerceapp/features/profile/presentation/manager/profile_cubit.dart';

import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:ecommerceapp/l10n/settings/presentation/pages/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const String screenRoute = 'profile';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  File? _selectedImage;
  String? _profileImageUrl;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<ProfileCubit>().loadProfile(user.uid);
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
      return;
    }

    setState(() {
      _selectedImage = File(pickedFile.path);
    });
  }

  Future<void> _deleteProfileImage() async {
    setState(() {
      _selectedImage = null;
      _profileImageUrl = null;
    });
  }

  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await context.read<ProfileCubit>().saveImage(
        userId: user.uid,
        selectedImage: _selectedImage,
        currentImageUrl: _profileImageUrl,
      );

      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;
      final state = context.read<ProfileCubit>().state;
      if (state is ProfileFailure) {
        throw Exception(state.message);
      }
      final imageUrl = state is ProfileLoaded ? state.profile.imageUrl : null;

      setState(() {
        _profileImageUrl = imageUrl;
        _selectedImage = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.changesSavedSuccessfully),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      final l10n = AppLocalizations.of(context)!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToSaveChanges),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showImageEditor() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final hasSelectedImage = _selectedImage != null;

            final hasSavedImage =
                _profileImageUrl != null &&
                    _profileImageUrl!.isNotEmpty;

            return AlertDialog(
              title: Text(
                l10n.profilePicture,
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: hasSelectedImage
                        ? Image.file(
                      _selectedImage!,
                      fit: BoxFit.contain,
                    )
                        : hasSavedImage
                        ? Image.network(
                      _profileImageUrl!,
                      fit: BoxFit.contain,
                    )
                        : const Icon(
                      Icons.person,
                      size: 100,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await _pickImage();

                            if (context.mounted) {
                              setDialogState(() {});
                            }
                          },
                          icon: const Icon(
                            Icons.photo_library_outlined,
                          ),
                          label: Text(l10n.chooseImage),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: hasSelectedImage || hasSavedImage
                              ? () {
                            _deleteProfileImage();
                            setDialogState(() {});
                          }
                              : null,
                          icon: const Icon(
                            Icons.delete_outline,
                          ),
                          label: Text(l10n.deleteImage),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    final hasSelectedImage = _selectedImage != null;

    final hasSavedImage =
        _profileImageUrl != null &&
            _profileImageUrl!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myAccount),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: _showImageEditor,
            child: Center(
              child: CircleAvatar(
                radius: 45,
                backgroundImage: hasSelectedImage
                    ? FileImage(_selectedImage!)
                    : hasSavedImage
                    ? NetworkImage(_profileImageUrl!)
                    : null,
                child: !hasSelectedImage && !hasSavedImage
                    ? Text(
                  user?.email
                      ?.substring(0, 1)
                      .toUpperCase() ??
                      'U',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Center(
            child: Text(
              user?.email ?? l10n.user,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 30),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.shopping_bag_outlined,
              ),
              title: Text(l10n.orders),
              trailing: const Icon(
                Icons.arrow_forward_ios,
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  OrdersScreen.screenRoute,
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: const Icon(
                Icons.settings_outlined,
              ),
              title: Text(l10n.settings),
              trailing: const Icon(
                Icons.arrow_forward_ios,
              ),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SettingsScreen.screenRoute,
                );
              },
            ),
          ),

          const SizedBox(height: 30),

          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveChanges,
            icon: _isSaving
                ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Icon(
              Icons.save_outlined,
            ),
            label: Text(
              _isSaving
                  ? l10n.saving
                  : l10n.saveChanges,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
