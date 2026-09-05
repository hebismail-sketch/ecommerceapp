import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class DeliveryDetails {
  final String firstName;
  final String lastName;
  final String phone;
  final String street;
  final String buildingNumber;
  final String floorNumber;
  final String apartmentNumber;
  final String additionalNotes;
  final double latitude;
  final double longitude;

  const DeliveryDetails({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.street,
    required this.buildingNumber,
    required this.floorNumber,
    required this.apartmentNumber,
    required this.additionalNotes,
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

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingNumberController = TextEditingController();
  final _floorNumberController = TextEditingController();
  final _apartmentNumberController = TextEditingController();
  final _additionalNotesController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _buildingNumberController.dispose();
    _floorNumberController.dispose();
    _apartmentNumberController.dispose();
    _additionalNotesController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? value, String message) {
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

  void _saveDeliveryDetails() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.pop(
      context,
      DeliveryDetails(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        street: _streetController.text.trim(),
        buildingNumber: _buildingNumberController.text.trim(),
        floorNumber: _floorNumberController.text.trim(),
        apartmentNumber: _apartmentNumberController.text.trim(),
        additionalNotes: _additionalNotesController.text.trim(),
        latitude: widget.selectedLocation.latitude,
        longitude: widget.selectedLocation.longitude,
      ),
    );
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
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
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
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.red.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your delivery location has been selected.',
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
                'Recipient Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(
                        label: 'First Name',
                        icon: Icons.person_outline,
                      ),
                      validator: (value) =>
                          _requiredValidator(value, 'Please enter your first name'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(
                        label: 'Last Name',
                        icon: Icons.person_outline,
                      ),
                      validator: (value) =>
                          _requiredValidator(value, 'Please enter your last name'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  label: 'Phone Number',
                  hint: '01xxxxxxxxx',
                  icon: Icons.phone_outlined,
                ),
                validator: _phoneValidator,
              ),
              const SizedBox(height: 24),
              const Text(
                'Address Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _streetController,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  label: 'Street and Area',
                  hint: 'Street name, district...',
                  icon: Icons.route_outlined,
                ),
                validator: (value) =>
                    _requiredValidator(value, 'Please enter your street and area'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _buildingNumberController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(
                        label: 'Building',
                        icon: Icons.apartment_outlined,
                      ),
                      validator: (value) => _requiredValidator(
                        value,
                        'Please enter the building number',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _floorNumberController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: _inputDecoration(
                        label: 'Floor',
                        icon: Icons.stairs_outlined,
                      ),
                      validator: (value) =>
                          _requiredValidator(value, 'Please enter the floor'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _apartmentNumberController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: _inputDecoration(
                  label: 'Apartment Number',
                  icon: Icons.door_front_door_outlined,
                ),
                validator: (value) =>
                    _requiredValidator(value, 'Please enter the apartment number'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _additionalNotesController,
                textInputAction: TextInputAction.done,
                maxLines: 3,
                decoration: _inputDecoration(
                  label: 'Additional Notes',
                  hint: 'Nearby landmark or delivery instructions',
                  icon: Icons.notes_outlined,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _saveDeliveryDetails,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text(
                    'Save Order Details',
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
