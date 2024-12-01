import 'package:citytaxi1/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
// Import this package for launching maps
// Aliasing location package
import 'package:geolocator/geolocator.dart'; // For distance calculation

class DriverDashboardPage extends StatefulWidget {
  @override
  _DriverDashboardPageState createState() => _DriverDashboardPageState();
}

class _DriverDashboardPageState extends State<DriverDashboardPage> {
  bool isOnline = false;
  bool hasRideRequest = true; // Simulating a ride request for demonstration
  bool rideAccepted = false;
  bool tripStarted = false; // Track if the trip has started
  String status = "Offline"; // Driver status

  GoogleMapController? _mapController;
  Marker? driverMarker;
  LatLng? driverLocation;
  final Color busyColor = Color(0xFFE6B300); // Busy color

  // Mock customer details for demo purposes
  final String customerName = "Sheleena Johnson";
  final String customerPhone = "0774777294";
  final String pickupLocation = "123 Main St.";
  final String dropoffLocation = "456 Elm St.";

  // Fare calculation
  double distanceInKm = 0.0; // Assume this will be calculated
  double farePerKm = 30.0; // Fare per km
  double totalFare = 0.0; // Total fare calculated
  final _places =
      GoogleMapsPlaces(apiKey: "AIzaSyCrTqJOEyNjvKHmYhVxOTtlH7FcTFBYfUA");

  final Authentication authProvider = Authentication();

  // Get the driver's current location
  Future<void> _getDriverLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    authProvider.updateDriverLocation(isOnline, position.latitude.toString(), position.longitude.toString(), '5');
    setState(() {
      driverLocation = LatLng(position.latitude, position.longitude);
      driverMarker = Marker(
        markerId: MarkerId('driver'),
        position: driverLocation!,
        infoWindow: InfoWindow(title: 'Driver Location'),
      );
    });
  }

  // Toggle the online/offline status
  void toggleOnlineStatus() async {
    setState(() {
      isOnline = !isOnline;
      status = isOnline ? "Online" : "Offline";
    });

    if (isOnline) {
      await _getDriverLocation();
    } else {
      await _getDriverLocation();
    }
  }

  // Handle ride acceptance
  void acceptRide() {
    setState(() {
      rideAccepted = true;
      hasRideRequest = false;
      status = "Busy"; // Change status to busy when ride is accepted
    });
    _sendSMSToPassenger();
  }

  // Handle ride rejection
  void rejectRide() {
    setState(() {
      hasRideRequest = false;
    });
  }

  // Simulate sending SMS to passenger
  void _sendSMSToPassenger() {
    print(
        "SMS sent to passenger at $customerPhone: 'Driver has accepted your ride request.'");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Passenger notified via SMS")),
    );
  }

  // Start trip
  void startTrip() {
    setState(() {
      tripStarted = true;
      totalFare = distanceInKm * farePerKm; // Calculate fare based on distance
    });
  }

  // End trip
  void endTrip() {
    // Calculate the total fare based on distance traveled
    // Here we assume distanceInKm is updated during the trip
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Trip Ended"),
          content: Text("Total Fare: Rs. $totalFare"),
          actions: [
            TextButton(
              onPressed: () {
                // Handle payment received
                Navigator.pop(context);
                _showRatingDialog();
              },
              child: Text("Received Payment"),
            ),
            TextButton(
              onPressed: () {
                // Handle payment not received
                Navigator.pop(context);
                _showRatingDialog();
              },
              child: Text("Not Received Payment"),
            ),
          ],
        );
      },
    );
  }

  // Show Rating Dialog
  void _showRatingDialog() {
    double rating = 0; // Initialize rating
    String comment = ""; // Initialize comment

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Rate Customer"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Star rating input
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      setState(() {
                        rating = index + 1; // Set rating based on star clicked
                      });
                    },
                  );
                }),
              ),
              TextField(
                onChanged: (value) {
                  comment = value; // Capture comment
                },
                decoration: InputDecoration(hintText: "Comment"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Submit rating and comment
                print("Rating: $rating, Comment: $comment");
                // Change driver status to online after rating
                setState(() {
                  status = "Online";
                });
                Navigator.pop(context);
              },
              child: Text("Submit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        backgroundColor: rideAccepted ? busyColor : const Color(0xFFE6B300),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Driver's online/offline status toggle button
          ElevatedButton(
            onPressed: toggleOnlineStatus,
            style: ElevatedButton.styleFrom(
              backgroundColor: isOnline ? Colors.red : Colors.green,
            ),
            child: Text(isOnline ? 'Go Offline' : 'Go Online'),
          ),
          const SizedBox(height: 10),
          // Display driver status
          Text(
            "Status: $status",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold, // Change fontWeight to bold
              color: rideAccepted ? busyColor : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // Stack to overlay the map and the navigation button
          Expanded(
            child: Stack(
              children: [
                // Google Map showing the driver's location
                isOnline && driverLocation != null
                    ? GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: driverLocation!,
                          zoom: 14,
                        ),
                        markers: driverMarker != null ? {driverMarker!} : {},
                        onMapCreated: (controller) {
                          _mapController = controller;
                        },
                      )
                    : Center(
                        child: Text(
                          "Go online to show your location on the map\nAccept this place when accepted, locate to the passenger's start point and navigate in Google Maps.",
                          textAlign: TextAlign.center,
                        ),
                      ),

                // Navigation button at the top right corner
                Positioned(
                  top: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      if (driverLocation != null && _mapController != null) {
                        _mapController!.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(target: driverLocation!, zoom: 14),
                          ),
                        );
                      }
                    },
                    backgroundColor: Colors.yellow[700],
                    child: Icon(Icons.my_location, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Ride request section
          if (hasRideRequest && isOnline)
            _buildRideRequestCard()
          else if (rideAccepted)
            _buildCustomerInfoCard()
          else
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "No ride requests at the moment.",
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  // Ride Request Card (Accept/Reject buttons)
  Widget _buildRideRequestCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Ride Request from $customerName"),
            const SizedBox(height: 10),
            Text("Pickup: $pickupLocation"),
            const SizedBox(height: 10),
            Text("Dropoff: $dropoffLocation"),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: acceptRide,
                  child: const Text(
                    "Accept",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Make text bold
                      fontSize: 16, // Increase font size
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: rejectRide,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text(
                    "Reject",
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Make text bold
                      fontSize: 16, // Increase font size
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Customer Info Card (Start/End Trip buttons)
  Widget _buildCustomerInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Customer: $customerName",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text("Pickup: $pickupLocation"),
            const SizedBox(height: 10),
            Text("Dropoff: $dropoffLocation"),
            const SizedBox(height: 20),
            if (!tripStarted)
              ElevatedButton(
                onPressed: startTrip, // Start trip and open Google Maps
                child: const Text(
                  "Start Trip",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // Increase font size
                  ),
                ),
              )
            else
              ElevatedButton(
                onPressed: endTrip,
                child: const Text(
                  "End Trip",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // Increase font size
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
