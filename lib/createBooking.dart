import 'dart:convert';
import 'package:citytaxi1/provider/auth.dart';
import 'package:citytaxi1/provider/booking.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'CustomerHome.dart';

class CreateBooking extends StatefulWidget {

  final String picKUp;
  final double picKUpLat;
  final double picKUpLong;
  final String dropOff;
  final double dropOffLat;
  final double dropOffLong;
  final String distance;

  const CreateBooking({Key? key, required this.picKUp, required this.dropOff,
    required this.distance, required this.picKUpLat, required this.picKUpLong,
    required this.dropOffLat, required this.dropOffLong}) : super(key: key);

  @override
  State<CreateBooking> createState() => _CreateBookingState();
}

class _CreateBookingState extends State<CreateBooking> {

  final Authentication authProvider = Authentication();
  final Booking bookingProvider = Booking();
  late List driverList = [];
  late String selectedDriver = "";
  late bool bookingSuccess = false;


  @override
  void initState() {
    super.initState();

    getDrivers();
  }
  
  onPressed() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var uuid = Uuid();
    bookingProvider.createBooking(uuid.v1(), widget.picKUpLat, widget.picKUpLong,
        widget.dropOffLat, widget.dropOffLong, selectedDriver, prefs.getString("currentUserId")!).then((onValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Booking placed successful!!', style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.green,
          elevation: 10,
        ),
      );
    });
  }

  onCancel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final parsedJson = jsonDecode(prefs.getString("currentUser")!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking canceled!!!', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.red,
        elevation: 10,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => CustomerHomePage(
            customerName: parsedJson['user']["first_name"],
          )),
    );
  }

  getDrivers() {
    authProvider.getOnlineDrivers().then((onValue) {
      final parsedJson = jsonDecode(onValue);
      print(parsedJson["drivers"]);
      setState(() {
        driverList = parsedJson["drivers"];
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Your vehicle'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pick-up Location : ${widget.picKUp}',
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      Text(
                        'Drop-off Location : ${widget.dropOff}',
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      Text(
                        'Distance : ${widget.distance}',
                        style: const TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50),
              Card(
                elevation: 10,
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: driverList.length,
                        itemBuilder: (BuildContext context, int index) {

                          return Container(
                            margin: EdgeInsets.all(5.0),
                            height: 80,
                            color: Colors.amber,
                            child: ListTile(
                                title: Text('${driverList[index]["first_name"]} ${driverList[index]["last_name"]}', style: TextStyle(color: Colors.white),),
                              subtitle: Text('${driverList[index]["mobile_number"]}', style: TextStyle(color: Colors.white)),
                              leading: Icon(Icons.car_crash_outlined, size: 20, color: Colors.black,),
                              trailing: Container(
                                child: Text('3.7', style: TextStyle(color: Colors.black)),
                              ),
                              onTap: () {
                                setState(() {
                                  selectedDriver == driverList[index]["id"];
                                });
                              },
                            ),
                          );
                        }
                    ),
                    SizedBox(height: 200,),
                    bookingSuccess? ElevatedButton.icon(
                      onPressed: null, // Disable button if locations are not set
                      icon: Icon(Icons.check_circle,
                          color: Colors.white), // Add an icon
                      label: Text(
                        bookingSuccess ? "Confirmed" : "Confirm Booking",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bookingSuccess? Colors.green[700] : Colors.yellow[700],
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        shadowColor: Colors.black, // Adds shadow to the button
                        elevation: 5, // Elevation for depth
                      ),
                    ) : ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          bookingSuccess = true;
                        });
                        onPressed();
                      }, // Disable button if locations are not set
                      icon: Icon(Icons.check_circle,
                          color: Colors.white), // Add an icon
                      label: Text(
                        bookingSuccess ? "Confirmed" : "Confirm Booking",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: bookingSuccess? Colors.green[700] : Colors.yellow[700],
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        shadowColor: Colors.black, // Adds shadow to the button
                        elevation: 5, // Elevation for depth
                      ),
                    ),
                    SizedBox(height: 10,),
                    ElevatedButton.icon(
                      onPressed: () {
                        onCancel();
                      }, // Disable button if locations are not set
                      icon: Icon(Icons.cancel,
                          color: Colors.white), // Add an icon
                      label: Text(
                        "Cancel Booking",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners
                        ),
                        shadowColor: Colors.black, // Adds shadow to the button
                        elevation: 5, // Elevation for depth
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
