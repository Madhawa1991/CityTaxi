import 'dart:convert';
import 'dart:typed_data';
import 'package:citytaxi1/DriverDashboardPage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'dart:html' as html;

import 'package:shared_preferences/shared_preferences.dart'; // For Flutter Web

class DriverHomePage extends StatelessWidget {
  final String driverName;

  DriverHomePage({required this.driverName});

  @override
  Widget build(BuildContext context) {
    // Get the current date
    String currentDate =
        DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi $driverName\nWelcome to City Taxi Pvt',
          style: const TextStyle(fontSize: 20, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFE6B300),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Image.asset('assets/logo.png', height: 80),
          ),
          const SizedBox(height: 10),
          // Display the current date
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Today is: $currentDate',
              style: const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DriverDashboardPage()),
              );
            },
            icon: const Icon(Icons.drive_eta, size: 30, color: Colors.white),
            label: const Text(
              'Let’s Ride',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE6B300),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 10,
              shadowColor: Colors.grey.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Add content related to the driver's profile
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'About City Taxi (PVT) Ltd...',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'City Taxi’s drivers provide exceptional service for both short and long journeys...',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                            '- Ensure timely pickups and smooth rides for all passengers.\n'),
                        Text(
                            '- Maintain clean, well-maintained vehicles at all times.\n'),
                        Text('- Focus on passenger safety and satisfaction.\n'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Your safety and the safety of your passengers is our top priority. Always adhere to traffic rules, wear your seatbelt, and ensure your vehicle is well-maintained....',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomNavigationBar(context),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      color: const Color(0xFFE6B300),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildVerticalButton(
            context,
            icon: Icons.home,
            label: 'Home',
            onPressed: () {
              // Handle Home button press
            },
          ),
          _buildVerticalButton(
            context,
            icon: Icons.local_activity,
            label: 'Activities',
            onPressed: () {
              // Handle Activities button press
            },
          ),
          _buildVerticalButton(
            context,
            icon: Icons.notifications,
            label: 'Notifications',
            onPressed: () {
              // Handle Notifications button press
            },
          ),
          _buildVerticalButton(
            context,
            icon: Icons.car_repair,
            label: 'Add Vehicle',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DriverVehiclePage(), // Make sure DriverVehiclePage is defined
                ),
              );
            },
          ),
          _buildVerticalButton(
            context,
            icon: Icons.person,
            label: 'Profile',
            onPressed: () {
              // Handle Profile button press
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.black),
          onPressed: onPressed,
          iconSize: 30,
        ),
        const SizedBox(height: 5), // Gap between icon and label
        Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ],
    );
  }
}

class DriverVehiclePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage My Vehicle',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFE6B300), // Set the background color
        iconTheme:
            IconThemeData(color: Colors.black), // Set icon color to black
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align text to the left
          children: [
            const SizedBox(height: 10),
            Center(
              child: Image.asset('assets/logo.png', height: 80),
            ),
            const SizedBox(height: 20),

            // Information about the vehicle
            Text(
              'Information about your vehicle:',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              '- It should be not less than 20 years old.\n'
              '- Should be well maintained.\n'
              '- Customers will rate you and your vehicle.\n'
              '- When you change your vehicle, you must update it in our database.',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 20),

            // Special note in a white background
            Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.white, // White background for special note
              child: Text(
                'Special Note: Don\'t use other vehicles apart from the ones you updated here.',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),

            // Add Vehicle Button
            _buildMenuButton(
              context,
              label: 'Add Vehicle',
              icon: Icons.add_box,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddVehiclePage()),
                );
              },
            ),
            const SizedBox(height: 20), // Spacing between buttons

            // Edit Vehicle Information Button
            _buildMenuButton(
              context,
              label: 'Edit Vehicle Information',
              icon: Icons.edit,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditVehiclePage()),
                );
              },
            ),
            const SizedBox(height: 20), // Spacing between buttons

            // View My Vehicle Information Button
            _buildMenuButton(
              context,
              label: 'View My Vehicle Information',
              icon: Icons.directions_car,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewVehiclePage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Custom button builder for the menu
  Widget _buildMenuButton(BuildContext context,
      {required String label,
      required IconData icon,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity, // Make buttons full width
      height: 60, // Fixed height for uniformity
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: const Color(0xFFE6B300), // Button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
          elevation: 5, // Shadow effect
        ),
        icon: Icon(icon, size: 28), // Icon size
        label: Text(
          label,
          style: TextStyle(
            fontSize: 18, // Text size
            fontWeight: FontWeight.w600, // Text weight
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}

class AddVehiclePage extends StatefulWidget {
  @override
  _AddVehiclePageState createState() => _AddVehiclePageState();
}

class _AddVehiclePageState extends State<AddVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNumberController = TextEditingController();
  final _vehicleYearController = TextEditingController();
  final _passengerController = TextEditingController();
  String? vehicleCategory;
  int currentYear = DateTime.now().year;

  Map<String, Uint8List?> vehicleImages = {
    'Front View': null,
    'Left Side': null,
    'Right Side': null,
    'Back View': null,
    'Inside View': null,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Vehicle'),
        backgroundColor: const Color(0xFFE6B300),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Vehicle Number Field
              TextFormField(
                controller: _vehicleNumberController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Number',
                  hintText: 'ABC-1199', // Sample number hint
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFE6B300)), // Border color on focus
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                validator: _validateVehicleNumber,
              ),
              const SizedBox(height: 16),

              // Vehicle Category Dropdown
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Vehicle Category',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: ['Car', 'Van', 'Bus', 'Three-Wheeler'].map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    vehicleCategory = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a vehicle category' : null,
              ),
              const SizedBox(height: 16),

              // Vehicle Year Field
              TextFormField(
                controller: _vehicleYearController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Year',
                  hintText: 'e.g. 2005',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFE6B300)), // Border color on focus
                  ),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                validator: _validateVehicleYear,
              ),
              const SizedBox(height: 16),

              // Number of Passengers Field
              TextFormField(
                controller: _passengerController,
                decoration: const InputDecoration(
                  labelText: 'Number of Passengers',
                  hintText: '1-52',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFE6B300)), // Border color on focus
                  ),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                validator: _validatePassengers,
              ),
              const SizedBox(height: 20),

              // Upload Vehicle Images Section
              const Text(
                'Upload Vehicle Images',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              for (var view in vehicleImages.keys) _buildImagePicker(view),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  // Validate individual fields
                  String? vehicleNumberError =
                      _validateVehicleNumber(_vehicleNumberController.text);
                  String? vehicleYearError =
                      _validateVehicleYear(_vehicleYearController.text);
                  String? passengersError =
                      _validatePassengers(_passengerController.text);

                  // Check if there are any validation errors
                  if (vehicleNumberError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(vehicleNumberError),
                        duration: Duration(seconds: 10), //  duration here
                      ),
                    );
                    return; // Exit early if there are errors
                  }
                  if (vehicleYearError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(vehicleYearError),
                        duration: Duration(seconds: 10), // duration here
                      ),
                    );
                    return; // Exit early if there are errors
                  }
                  if (passengersError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(passengersError),
                        duration: Duration(seconds: 10), // duration here
                      ),
                    );
                    return; // Exit early if there are errors
                  }

                  // Validate all form fields including category and images
                  if (_validateForm()) {
                    // Save form data
                    _formKey.currentState!.save();
                    _showConfirmationDialog();
                  } else {
                    // Display error messages if validations fail
                    _showErrorMessages();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6B300),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Validate all form fields
  bool _validateForm() {
    return _formKey.currentState!.validate() &&
        vehicleCategory != null && // Check if vehicle category is selected
        _validateImages(); // Check if all images are uploaded
  }

  // Vehicle Number Validation
  String? _validateVehicleNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the vehicle number';
    }
    RegExp regex = RegExp(r'^[A-Za-z]{2,3}-\d{4}$');
    if (!regex.hasMatch(value)) {
      return 'Invalid vehicle number. Format: ABC-1234 or AB-1234';
    }
    return null; // Validation passed
  }

  // Vehicle Year Validation
  String? _validateVehicleYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the vehicle year';
    }
    int? year = int.tryParse(value);
    if (year == null || year > currentYear || year < currentYear - 20) {
      return 'Vehicle year must be within the last 20 years, including this year';
    }
    return null; // Validation passed
  }

  // Passengers Validation
  String? _validatePassengers(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the number of passengers';
    }
    int? passengers = int.tryParse(value);
    if (passengers == null || passengers < 1 || passengers > 52) {
      return 'Number of passengers must be between 1 and 52';
    }
    return null; // Validation passed
  }

  // Image Picker Functionality for Flutter Web (using Image.memory)
  Widget _buildImagePicker(String view) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () async {
          final html.FileUploadInputElement uploadInput =
              html.FileUploadInputElement();
          uploadInput.accept = 'image/*';
          uploadInput.click();

          uploadInput.onChange.listen((event) {
            final files = uploadInput.files;
            if (files!.isNotEmpty) {
              final reader = html.FileReader();
              reader.readAsArrayBuffer(files[0]);
              reader.onLoadEnd.listen((event) {
                setState(() {
                  vehicleImages[view] = reader.result as Uint8List?;
                });
              });
            }
          });
        },
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: vehicleImages[view] == null
                ? Text(
                    'Upload $view',
                    style: const TextStyle(color: Colors.black54),
                  )
                : Image.memory(
                    vehicleImages[view]!,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
    );
  }

  // Validate that all images are uploaded
  bool _validateImages() {
    for (var image in vehicleImages.values) {
      if (image == null) {
        return false; // At least one image is missing
      }
    }
    return true; // All images are uploaded
  }

  // Show Error Messages
  void _showErrorMessages() {
    if (_vehicleNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the vehicle number.')),
      );
    }

    if (vehicleCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a vehicle category.')),
      );
    }

    if (_vehicleYearController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the vehicle year.')),
      );
    }

    if (_passengerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the number of passengers.')),
      );
    }

    if (!_validateImages()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please upload all required vehicle images.')),
      );
    }
  }

  // Show confirmation dialog
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content:
            const Text('Vehicle information has been submitted successfully.'),
        actions: [
          TextButton(
            onPressed: () async {
              final SharedPreferences prefs = await SharedPreferences.getInstance();
              final parsedJson = jsonDecode(prefs.getString("currentUser")!);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DriverHomePage(
                      driverName: parsedJson['user']["first_name"],
                    )),
              ); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class EditVehiclePage extends StatefulWidget {
  @override
  _EditVehiclePageState createState() => _EditVehiclePageState();
}

class _EditVehiclePageState extends State<EditVehiclePage> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleNumberController = TextEditingController();
  final _vehicleYearController = TextEditingController();
  final _passengerController = TextEditingController();
  String? vehicleCategory;
  String? vehicleStatus; // Status is read-only for everyone
  int currentYear = DateTime.now().year;
  bool isDriver = true; // Check user role (set this dynamically)

  Map<String, Uint8List?> vehicleImages = {
    'Front View': null,
    'Left Side': null,
    'Right Side': null,
    'Back View': null,
    'Inside View': null,
  };

  @override
  void initState() {
    super.initState();
    _loadVehicleDetailsFromAPI(); // Load vehicle details from backend
  }

  // Simulate loading vehicle details from backend API (use real API in your project)
  Future<void> _loadVehicleDetailsFromAPI() async {
    // Simulate API call to load vehicle details
    await Future.delayed(Duration(seconds: 2)); // Simulate network delay
    setState(() {
      _vehicleNumberController.text = ""; // Example data
      _vehicleYearController.text = "";
      _passengerController.text = "";
      vehicleCategory = " ";
      vehicleStatus = "No Vehicle"; // Status is read-only
      vehicleImages['Front View'] = null; // Add Uint8List of image if available
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Vehicle'),
        backgroundColor: const Color(0xFFE6B300),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Vehicle Status Field (Read-only for everyone)
              DropdownButtonFormField<String>(
                value: vehicleStatus,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Status',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: ['No Vehicle', 'Pending', 'Approved', 'Rejected']
                    .map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: null, // Make it read-only
              ),
              const SizedBox(height: 16),

              // Vehicle Number Field (editable for drivers)
              TextFormField(
                controller: _vehicleNumberController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Number',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                style: const TextStyle(color: Colors.white),
                validator: _validateVehicleNumber,
              ),
              const SizedBox(height: 16),

              // Vehicle Category Dropdown (editable for drivers)
              DropdownButtonFormField<String>(
                value: vehicleCategory,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Category',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items:
                    [' ', 'Car', 'Van', 'Bus', 'Three-Wheeler'].map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    vehicleCategory = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a vehicle category' : null,
              ),
              const SizedBox(height: 16),

              // Vehicle Year Field (editable for drivers)
              TextFormField(
                controller: _vehicleYearController,
                decoration: const InputDecoration(
                  labelText: 'Vehicle Year',
                  hintText: 'e.g. 2005',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                validator: _validateVehicleYear,
              ),
              const SizedBox(height: 16),

              // Number of Passengers Field (editable for drivers)
              TextFormField(
                controller: _passengerController,
                decoration: const InputDecoration(
                  labelText: 'Number of Passengers',
                  hintText: '1-52',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                validator: _validatePassengers,
              ),
              const SizedBox(height: 20),

              // Upload Vehicle Images Section (drivers can update images)
              const Text(
                'Vehicle Images',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              for (var view in vehicleImages.keys) _buildImagePicker(view),
              const SizedBox(height: 20),

              // Save Changes Button (visible for both drivers and admins)
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _showConfirmationDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6B300),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 20),

              // Delete Vehicle Button (visible for both drivers and admins)
              ElevatedButton(
                onPressed: () {
                  _confirmDeleteVehicle();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Delete Vehicle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Confirm vehicle deletion
  void _confirmDeleteVehicle() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: const Text('Are you sure you want to delete this vehicle?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Add delete vehicle functionality here
              Navigator.of(context).pop(); // Close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Vehicle deleted successfully')),
              );
              Navigator.of(context).pop(); // Go back to previous page
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Validate Vehicle Number
  String? _validateVehicleNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the vehicle number';
    }
    RegExp regex = RegExp(r'^[A-Za-z]{2,3}-\d{4}$');
    if (!regex.hasMatch(value)) {
      return 'Invalid vehicle number. Format: ABC-1234 or AB-1234';
    }
    return null; // Passed
  }

  // Validate Vehicle Year
  String? _validateVehicleYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the vehicle year';
    }
    int? year = int.tryParse(value);
    if (year == null || year > currentYear || year < currentYear - 20) {
      return 'Vehicle year must be within the last 20 years';
    }
    return null; // Passed
  }

  // Validate Number of Passengers
  String? _validatePassengers(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the number of passengers';
    }
    int? passengers = int.tryParse(value);
    if (passengers == null || passengers < 1 || passengers > 52) {
      return 'Number of passengers must be between 1 and 52';
    }
    return null; // Passed
  }

  // Image Picker (drivers can update images)
  Widget _buildImagePicker(String view) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text('$view', style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () => _pickImage(view), // Allow drivers to change images
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.black12,
              border: Border.all(color: Colors.white),
            ),
            child: vehicleImages[view] != null
                ? Image.memory(vehicleImages[view]!, fit: BoxFit.cover)
                : const Icon(Icons.camera_alt, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Image Picker for both Admins and Drivers
  Future<void> _pickImage(String view) async {
    // Use image picker to get image from gallery or camera
    // Example: Picked image will be stored in vehicleImages[view]
  }

  // Confirmation dialog when saving changes
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save Changes'),
        content: const Text('Are you sure you want to save the changes?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Save vehicle changes to backend (add your logic here)
              Navigator.of(context).pop(); // Close dialog
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Vehicle details updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

class ViewVehiclePage extends StatelessWidget {
  // Mock vehicle details loaded from the backend
  final String vehicleNumber = "";
  final String vehicleCategory = " ";
  final String vehicleYear = "";
  final String vehiclePassengers = "";
  final String vehicleStatus = "No Vehicle";

  final Map<String, Uint8List?> vehicleImages = {
    'Front View': null,
    'Left Side': null,
    'Right Side': null,
    'Back View': null,
    'Inside View': null,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Vehicle'),
        backgroundColor: const Color(0xFFE6B300),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Vehicle Status Field (Read-only)
            DropdownButtonFormField<String>(
              value: vehicleStatus,
              decoration: const InputDecoration(
                labelText: 'Vehicle Status',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              items: ['No Vehicle', 'Pending', 'Approved', 'Rejected']
                  .map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: null, // Disable changing status (view-only)
            ),
            const SizedBox(height: 16),

            // Vehicle Number Field (Read-only)
            TextFormField(
              initialValue: vehicleNumber,
              decoration: const InputDecoration(
                labelText: 'Vehicle Number',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
              readOnly: true, // Make it read-only
            ),
            const SizedBox(height: 16),

            // Vehicle Category Dropdown (Read-only)
            DropdownButtonFormField<String>(
              value: vehicleCategory,
              decoration: const InputDecoration(
                labelText: 'Vehicle Category',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              items:
                  [' ', 'Car', 'Van', 'Bus', 'Three-Wheeler'].map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: null, // Disable changing category (view-only)
            ),
            const SizedBox(height: 16),

            // Vehicle Year Field (Read-only)
            TextFormField(
              initialValue: vehicleYear,
              decoration: const InputDecoration(
                labelText: 'Vehicle Year',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
              readOnly: true, // Make it read-only
            ),
            const SizedBox(height: 16),

            // Number of Passengers Field (Read-only)
            TextFormField(
              initialValue: vehiclePassengers,
              decoration: const InputDecoration(
                labelText: 'Number of Passengers',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
              readOnly: true, // Make it read-only
            ),
            const SizedBox(height: 20),

            // Vehicle Images Section (view-only)
            const Text(
              'Vehicle Images',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            for (var view in vehicleImages.keys) _buildImageView(view),
          ],
        ),
      ),
    );
  }

  // Image View (view-only, display images if available)
  Widget _buildImageView(String view) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text('$view', style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.black12,
            border: Border.all(color: Colors.white),
          ),
          child: vehicleImages[view] != null
              ? Image.memory(vehicleImages[view]!, fit: BoxFit.cover)
              : const Icon(Icons.image, color: Colors.white),
        ),
      ],
    );
  }
}
