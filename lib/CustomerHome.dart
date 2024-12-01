import 'package:flutter/material.dart';
import 'package:citytaxi1/SearchLocationpage.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class CustomerHomePage extends StatefulWidget {

  final String customerName;
  const CustomerHomePage({Key? key, required this.customerName}) : super(key: key);

  @override
  State<CustomerHomePage> createState() => _CustomerhomePageState();
}

class _CustomerhomePageState extends State<CustomerHomePage> {

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Get the current date
    String currentDate =
    DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hi ${widget.customerName}\nWelcome to City Taxi Pvt',
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Where do you want to go?',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              controller: _textController,
              onSubmitted: (value) {
                // Navigate to the SearchLocationPage with the search query
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchLocationPage(searchQuery: value),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Add content related to the user's profile
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'About our services...',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                  // Additional profile information or content can be added here
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'City Taxi’s focus is on providing low to mid-income passengers with a convenient and high-quality service across island-wide city areas. The main criteria for City Taxi passengers include:',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                            '- Performance: Get passengers to their destination safely, promptly, and comfortably.\n'),
                        Text(
                            '- Superior Service: Ensure timely pickups with excellent customer care.\n'),
                        Text(
                            '- Quality: Provide courteous service with clean and well-maintained vehicles.\n'),
                      ],
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
          // _buildVerticalButton(
          //   context,
          //   icon: Icons.car_repair,
          //   label: 'Add Vehicle',
          //   onPressed: () {
          //     // Handle Add Vehicle button press
          //   },
          // ),
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
        Text(
          label,
          style: const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ],
    );
  }
}
