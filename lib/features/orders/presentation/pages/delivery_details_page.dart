import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class DeliveryDetails {
  final String name;
  final String phone;
  final String address;
  final String notes;
  final double latitude;
  final double longitude;

  const DeliveryDetails({
    required this.name,
    required this.phone,
    required this.address,
    required this.notes,
    required this.latitude,
    required this.longitude,
  });
}

class DeliveryDetailsPage extends StatefulWidget {
  final LatLng selectedLocation;

  const DeliveryDetailsPage({
    super.key,
    required this.selectedLocation,
  });

  static const String screenRoute = 'deliveryDetails';

  @override
  State<DeliveryDetailsPage> createState() => _DeliveryDetailsPageState();
}

class _DeliveryDetailsPageState extends State<DeliveryDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _requiredValidator(
    String? value,
    String message,
  ) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }

    return null;
  }

  String? _phoneValidator(String? value) {
    final phone = value?.trim() ?? '';

    if (phone.isEmpty) {
      return 'Please enter your phone number';
    }

    if (phone.length < 8) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  void _continue() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final details = DeliveryDetails(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      notes: _notesController.text.trim(),
      latitude: widget.selectedLocation.latitude,
      longitude: widget.selectedLocation.longitude,
    );

    Navigator.pop(context, details);
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: Colors.red.shade600,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.red.shade100,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.red.shade700,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Location selected successfully',
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Enter your delivery information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please provide accurate information so we can deliver your order.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  icon: Icons.person_outline,
                ),
                validator: (value) => _requiredValidator(
                  value,
                  'Please enter your name',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  icon: Icons.phone_outlined,
                ),
                validator: _phoneValidator,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                textInputAction: TextInputAction.next,
                maxLines: 2,
                decoration: _inputDecoration(
                  label: 'Detailed Address',
                  hint: 'Building, street, area...',
                  icon: Icons.home_outlined,
                ),
                validator: (value) => _requiredValidator(
                  value,
                  'Please enter your detailed address',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                textInputAction: TextInputAction.done,
                maxLines: 3,
                decoration: _inputDecoration(
                  label: 'Additional Notes',
                  hint: 'Optional delivery instructions',
                  icon: Icons.notes_outlined,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _continue,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.arrow_forward),
                  label: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
