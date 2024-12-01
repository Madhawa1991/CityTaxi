import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart'; // For Places API
import 'package:location/location.dart' as loc; // Aliasing location package
import 'package:geolocator/geolocator.dart'; // For distance calculation
import 'package:url_launcher/url_launcher.dart';

import 'createBooking.dart';

class SearchLocationPage extends StatefulWidget {
  final String searchQuery;

  SearchLocationPage({required this.searchQuery});

  @override
  _SearchLocationPageState createState() => _SearchLocationPageState();
}

class _SearchLocationPageState extends State<SearchLocationPage> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(6.9271, 79.8612); // Default to Colombo
  LatLng? _pickupLocation; // Store pickup location
  LatLng? _dropOffLocation; // Store drop-off location
  final _places = GoogleMapsPlaces(
      apiKey: "AIzaSyCrTqJOEyNjvKHmYhVxOTtlH7FcTFBYfUA"); // API key
  late loc.Location _location; // Use 'loc' alias for Location
  Marker? _pickupMarker; // Pickup location marker
  Marker? _dropOffMarker; // Drop-off location marker
  Marker? _currentLocationMarker; // Current location marker
  final TextEditingController _pickupController = TextEditingController();
  final TextEditingController _dropOffController = TextEditingController();
  LatLng? _currentLocation; // Store current location
  bool isPickupSelected = false; // To toggle pickup or drop-off selection

  @override
  void initState() {
    super.initState();
    _location = loc.Location();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      final loc.LocationData location = await _location.getLocation();
      setState(() {
        _currentLocation = LatLng(location.latitude!, location.longitude!);
        _currentLocationMarker = Marker(
          markerId: MarkerId('currentLocation'),
          position: _currentLocation!,
          infoWindow: InfoWindow(title: "Current Location"),
        );
      });
      mapController
          .animateCamera(CameraUpdate.newLatLngZoom(_currentLocation!, 14.0));
    } catch (e) {
      _showErrorDialog("Could not get current location: $e");
    }
  }

  Future<void> _searchAndNavigate(String query, bool isPickup) async {
    try {
      PlacesSearchResponse response = await _places.searchByText(query);
      if (response.status == "OK" && response.results.isNotEmpty) {
        var place = response.results.first;
        double newLatitude = place.geometry?.location.lat ?? 0.0;
        double newLongitude = place.geometry?.location.lng ?? 0.0;

        setState(() {
          if (isPickup) {
            _pickupLocation = LatLng(newLatitude, newLongitude);
            _pickupMarker = Marker(
              markerId: MarkerId('pickup'),
              position: _pickupLocation!,
              infoWindow: InfoWindow(title: "Pickup Location"),
            );
            _pickupController.text =
                place.formattedAddress ?? ""; // Populate pickup box
          } else {
            _dropOffLocation = LatLng(newLatitude, newLongitude);
            _dropOffMarker = Marker(
              markerId: MarkerId('dropOff'),
              position: _dropOffLocation!,
              infoWindow: InfoWindow(title: "Drop-off Location"),
            );
            _dropOffController.text =
                place.formattedAddress ?? ""; // Populate drop-off box
          }
        });

        mapController.animateCamera(CameraUpdate.newLatLngZoom(
            isPickup ? _pickupLocation! : _dropOffLocation!, 14.0));
      } else {
        _showErrorDialog("Place not found.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred: $e");
    }
  }

  double _calculateDistance() {
    if (_pickupLocation != null && _dropOffLocation != null) {
      return Geolocator.distanceBetween(
            _pickupLocation!.latitude,
            _pickupLocation!.longitude,
            _dropOffLocation!.latitude,
            _dropOffLocation!.longitude,
          ) /
          1000; // Convert to kilometers
    }
    return 0.0;
  }

  Future<void> _confirmBooking() async {
    if (_pickupLocation != null && _dropOffLocation != null) {
      double distance = _calculateDistance();

      // Open Google Maps with directions
      String url =
          "https://www.google.com/maps/dir/?api=1&origin=${_pickupLocation!.latitude},${_pickupLocation!.longitude}&destination=${_dropOffLocation!.latitude},${_dropOffLocation!.longitude}&travelmode=driving";

      // Create a Uri from the url
      Uri uri = Uri.parse(url);

      // This will open the Google Maps app if available
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _showErrorDialog("Could not open Google Maps.");
      }

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CreateBooking(
              picKUp: '${_pickupLocation!.latitude}, ${_pickupLocation!.longitude}',
              dropOff: '${_dropOffLocation!.latitude}, ${_dropOffLocation!.longitude}',
              distance: '${distance.toStringAsFixed(2)} km',
              picKUpLat: _pickupLocation!.latitude,
              picKUpLong: _pickupLocation!.longitude,
              dropOffLat: _dropOffLocation!.latitude,
              dropOffLong: _dropOffLocation!.longitude,
            )),
      );
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: Text("Booking Confirmed"),
      //     content: Text(
      //         "Pickup: ${_pickupController.text}\nDrop-off: ${_dropOffController.text}\nDistance: ${distance.toStringAsFixed(2)} km"),
      //     actions: [
      //       TextButton(
      //         onPressed: () => Navigator.of(context).pop(),
      //         child: Text("OK"),
      //       ),
      //     ],
      //   ),
      // );
    } else {
      _showErrorDialog("Please select both pickup and drop-off locations.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _setPickupToCurrentLocation() {
    if (_currentLocation != null) {
      setState(() {
        _pickupLocation =
            _currentLocation; // Set pickup location to current location
        _pickupMarker = Marker(
          markerId: MarkerId('pickup'),
          position: _pickupLocation!,
          infoWindow: InfoWindow(title: "Pickup Location"),
        );
        _pickupController.text =
            "${_currentLocation!.latitude}, ${_currentLocation!.longitude}"; // Populate pickup box
      });
      mapController
          .animateCamera(CameraUpdate.newLatLngZoom(_pickupLocation!, 14.0));
    } else {
      _showErrorDialog("Current location is not available.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Your Destination'),
        backgroundColor: Colors.yellow[700],
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed:
                _setPickupToCurrentLocation, // Set pickup location to current location
            tooltip: "Set Pickup to Current Location",
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
            markers: {
              if (_pickupMarker != null) _pickupMarker!,
              if (_dropOffMarker != null) _dropOffMarker!,
              if (_currentLocationMarker != null) _currentLocationMarker!,
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: (position) {
              setState(() {
                if (isPickupSelected) {
                  _pickupLocation = position;
                  _pickupMarker = Marker(
                    markerId: MarkerId('pickup'),
                    position: _pickupLocation!,
                    infoWindow: InfoWindow(title: "Pickup Location"),
                  );
                  _pickupController.text =
                      "${position.latitude}, ${position.longitude}"; // Populate pickup box
                } else {
                  _dropOffLocation = position;
                  _dropOffMarker = Marker(
                    markerId: MarkerId('dropOff'),
                    position: _dropOffLocation!,
                    infoWindow: InfoWindow(title: "Drop-off Location"),
                  );
                  _dropOffController.text =
                      "${position.latitude}, ${position.longitude}"; // Populate drop-off box
                }
              });
            },
          ),
          Positioned(
            top: 10,
            right: 10,
            child: FloatingActionButton(
              onPressed: _setPickupToCurrentLocation,
              child: Icon(Icons.my_location),
              backgroundColor: Colors.yellow[700],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 100,
            right: 100,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _pickupController,
                      decoration: InputDecoration(
                        hintText: 'Search Pickup Location...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                      onTap: () {
                        setState(() {
                          isPickupSelected = true; // Set pickup selected
                        });
                      },
                      onSubmitted: (value) {
                        _searchAndNavigate(value, true); // Search for pickup
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _dropOffController,
                      decoration: InputDecoration(
                        hintText: 'Search Drop-off Location...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                      onTap: () {
                        setState(() {
                          isPickupSelected = false; // Set drop-off selected
                        });
                      },
                      onSubmitted: (value) {
                        _searchAndNavigate(value, false); // Search for drop-off
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed:
                      (_pickupLocation != null && _dropOffLocation != null)
                          ? _confirmBooking
                          : null, // Disable button if locations are not set
                  icon: Icon(Icons.check_circle,
                      color: Colors.white), // Add an icon
                  label: Text(
                    "Confirm Booking",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700],
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    shadowColor: Colors.black, // Adds shadow to the button
                    elevation: 5, // Elevation for depth
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
