import 'package:citytaxi1/DriverDashboardPage.dart';
import 'package:citytaxi1/DriverHomePage.dart';
import 'package:citytaxi1/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:image_picker/image_picker.dart';
import 'CustomerHome.dart';
import 'Globle.dart'; //imge picker
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    bool status = GlobalData().loginStatus;
    print(status);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'City Taxi Pvt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFE6B300)),
        scaffoldBackgroundColor: Color.fromARGB(255, 153, 153, 153),
        useMaterial3: true,
      ),
      home: status ? DriverDashboardPage() : LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _telephoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true; // Toggle for password visibility
  final Authentication authProvider = Authentication();

  String get currentDate =>
      DateFormat('yyyy-MMMM-dd, EEEE').format(DateTime.now());


  onLogin() async {

    authProvider.loginUser(_telephoneController.text, _passwordController.text).then((onValue) async {
      final parsedJson = jsonDecode(onValue);
      if(parsedJson["user"] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Login Successful!', style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.green,
            elevation: 10,
          ),
        );

        print(parsedJson['user']["role"]);
        if(parsedJson["user"]["role"] == "Passenger") {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('currentUser', onValue);
          prefs.setString('currentUserId', parsedJson["user"]["id"].toString());
          prefs.setString('userRole', parsedJson["user"]["role"]);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CustomerHomePage(
                  customerName: parsedJson['user']["first_name"],
                )),
          );
        } else {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('currentUser', onValue);
          prefs.setString('currentUserId', parsedJson["user"]["id"].toString());
          prefs.setString('userRole', parsedJson["user"]["role"]);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DriverHomePage(
                  driverName: parsedJson['user']["first_name"],
                )),
          );
        }

      } else if(parsedJson["message"] == 'Invalid credentials'){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials!!!', style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.red,
            elevation: 10,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong!!!', style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.red,
            elevation: 10,
          ),
        );
      }

    });

    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'City Taxi Login',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFE6B300),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Today is: $currentDate',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 10),
            Center(
              child: Image.asset('assets/logo.png', height: 80),
            ),
            const SizedBox(height: 1),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _telephoneController,
                      decoration: InputDecoration(
                        labelText: 'Telephone',
                        border: const OutlineInputBorder(),
                        prefixIcon:
                            const Icon(Icons.phone, color: Color(0xFFE6B300)),
                        labelStyle: const TextStyle(color: Colors.white),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE6B300)),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your telephone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        prefixIcon:
                            const Icon(Icons.lock, color: Color(0xFFE6B300)),
                        labelStyle: const TextStyle(color: Colors.white),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE6B300)),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFFE6B300),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          onLogin();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: const Color(0xFFE6B300),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20, // Set font size to 20
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to the Register page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: const Color(0xFFE6B300),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 20, // Set font size to 20
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DriverHomePage(
                                    driverName: '',
                                  )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: const Color(0xFFE6B300),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 20, // Set font size to 20
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    ElevatedButton(
                      onPressed: () {
                        // Exit the app
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xFFE6B300),
                        backgroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Exit',
                        style: TextStyle(
                          fontSize: 20, // Set font size to 20
                          fontWeight: FontWeight.bold, // Make the text bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment:
                          Alignment.centerRight, // Align text to the right
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.end, // Align text to the end
                        children: [
                          Text(
                            'HotLine : 119 \n'
                            'For bookings',
                            style: TextStyle(
                              color: const Color(0xFFE6B300), // Highlight color
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 2.0, // Gap between letters
                              wordSpacing: 4.0, // Space between words
                              decoration: TextDecoration
                                  .none, // Remove default underline
                            ),
                          ),
                          const SizedBox(
                              height: 1), // Space between text and underline
                          /* Container(
                            height: 3, // Thickness of the underline
                            width: 150, // Adjust width as needed
                            color: Colors.red, // Color of the underline
                          ),*/
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'LMU-CSE Advanced Software Eng, Group Project',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'City Taxi Register',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: const Color(0xFFE6B300),
      ),
      body: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 8.0), // Shorter side padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            Center(
                //  child: Image.asset('assets/logo.png', height: 80,),
                ),
            const SizedBox(height: 25),
            const Text(
              'Welcome to City Taxi (PVT) Ltd!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Image.asset('assets/logo.png', height: 50),
            ),
            const SizedBox(height: 20),
            const Text(
              'We are committed to ensuring you reach your destination safely and efficiently, '
              'or that you drive with ease and support. Register now to start your journey with City Taxi!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: 400,
                      margin: const EdgeInsets.only(
                          right: 4.0), // Smaller margin on the right
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 10.0), // Adjust padding inside
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Register as Passenger',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Experience convenience and comfort with our easy-to-use system. Register to:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '* Reserve taxis with just a few clicks.\n'
                            '* Get real-time updates on driver and vehicle details.\n'
                            '* Enjoy seamless payment options and receive instant confirmations.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PassengerRegisterPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: const Color(0xFFE6B300),
                              minimumSize: const Size(double.infinity,
                                  45), // Button with full width
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Passenger Register',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 400,
                      margin: const EdgeInsets.only(
                          left: 4.0), // Smaller margin on the left
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 10.0), // Adjust padding inside
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'Register as Driver',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 25),
                          const Text(
                            'Join our team and be part of a company that values your time. Register now to:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '* Manage availability and receive trip requests.\n'
                            '* Stay connected with our mobile-friendly platform.\n'
                            '* Receive timely payments for completed trips.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                //nasviogsate to driver regisor
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DriverBasicInfoPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: const Color(0xFFE6B300),
                              minimumSize: const Size(double.infinity,
                                  45), // Button with full width
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Driver Register',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PassengerRegisterPage extends StatefulWidget {
  @override
  _PassengerRegisterPageState createState() => _PassengerRegisterPageState();
}

class _PassengerRegisterPageState extends State<PassengerRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _nicController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNoController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _zipController;
  late TextEditingController _districtController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _birthdayController;

  String? _gender; //Defalult male
  String? _district; // Default district
  bool _passwordVisible = false;

  final Authentication authProvider = Authentication();

  onRegister() {
    authProvider.registerUser(_firstNameController.text, _lastNameController.text, _nicController.text, _emailController.text, _passwordController.text,
        _confirmPasswordController.text, _phoneNoController.text, _birthdayController.text,
        _address1Controller.text, _district!, _address2Controller.text, _zipController.text, _gender!, "Passenger").then((onValue) async {
          print("passwenger register ====> " + onValue);
          final parsedJson = jsonDecode(onValue);
          if(parsedJson["user"] != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login Successful!', style: TextStyle(color: Colors.white),),
                backgroundColor: Colors.green,
                elevation: 10,
              ),
            );

            final SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('currentUser', onValue);
            prefs.setString('userRole', parsedJson["user"]["role"]);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CustomerHomePage(
                    customerName: parsedJson['user']["first_name"],
                  )),
            );

          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Something went wrong!!!', style: TextStyle(color: Colors.white),),
                backgroundColor: Colors.red,
                elevation: 10,
              ),
            );
          }

    });
  }


  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _nicController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNoController = TextEditingController();
    _address1Controller = TextEditingController();
    _address2Controller = TextEditingController();
    _zipController = TextEditingController();
    _districtController = TextEditingController();
    _emergencyContactController = TextEditingController();
    _birthdayController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _zipController.dispose();
    _districtController.dispose();
    _emergencyContactController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    return null;
  }

  String? _validateNIC(String? value) {
    if (value == null || (value.length != 10 && value.length != 12)) {
      return 'NIC must be either 10 or 12 characters long';
    }
    if (value.length == 10) {
      if (!RegExp(r'^\d{9}[VX]$').hasMatch(value)) {
        return 'NIC must be 9 digits followed by V or X';
      }
    } else if (value.length == 12) {
      if (!RegExp(r'^\d{12}$').hasMatch(value)) {
        return 'NIC must be 12 digits';
      }
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(value)) {
      return 'Password must include uppercase, lowercase, and a number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null ||
        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhoneNo(String? value) {
    if (value == null ||
        value.length != 10 ||
        !RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  String? _validateBirthday(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your birthday';
    }

    // Attempt to parse the date
    final DateTime? date = DateFormat('yyyy-MM-dd').parseStrict(value);

    if (date == null) {
      return 'Invalid date format';
    }

    final DateTime today = DateTime.now();
    if (date.isAfter(today)) {
      return 'Future dates are not allowed';
    }

    // Calculate the minimum date (18 years ago from today)
    final DateTime minDate = DateTime(today.year - 18, today.month, today.day);
    if (date.isAfter(minDate)) {
      return 'You must be 18 years old or older';
    }

    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.length < 3) {
      return 'Address and City must be at least 3 characters long';
    }
    return null;
  }

  String? _validateZipCode(String? value) {
    if (value == null ||
        value.length != 5 ||
        !RegExp(r'^\d{5}$').hasMatch(value)) {
      return 'ZIP Code must be 5 digits';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger Registration'),
        backgroundColor: const Color(0xFFE6B300),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20),
                Center(
                  child: Image.asset('assets/logo.png', height: 80),
                ),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    labelStyle:
                        TextStyle(color: Colors.white), // Label text color
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFE6B300)), // Border color on focus
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // Text color
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    labelStyle:
                        TextStyle(color: Colors.white), // Label text color
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFE6B300)), // Border color on focus
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // Text color
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nicController,
                  decoration: const InputDecoration(
                    labelText: 'NIC',
                    labelStyle:
                        TextStyle(color: Colors.white), // Label text color
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFE6B300)), // Border color on focus
                    ),
                  ),
                  style: TextStyle(color: Colors.white), // Text color
                  validator: _validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle:
                        TextStyle(color: Colors.white), // Label text color
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFE6B300)), // Border color on focus
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneNoController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle:
                        TextStyle(color: Colors.white), // Label text color
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFE6B300)), // Border color on focus
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: _validatePhoneNo,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  //user must enter BD
                  controller: _birthdayController,
                  decoration: const InputDecoration(
                    labelText: 'Birthday (yyyy-MM-dd)',
                    labelStyle:
                        TextStyle(color: Colors.white), // Label text color
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFE6B300)), // Border color on focus
                    ),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: _validateBirthday,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _gender,
                  items: ['male', 'female', 'other']
                      .map((gender) => DropdownMenuItem(
                            value: gender,
                            child: Text(gender,
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255))), //dropdown color
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE6B300)),
                    ),
                  ),
                  dropdownColor: Color.fromARGB(
                      255, 0, 0, 0), // Set dropdown menu background color
                  style: const TextStyle(
                      color: Color.fromARGB(
                          255, 143, 142, 142)), // Text color in the dropdown
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _address1Controller,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    labelStyle:
                        TextStyle(color: Colors.white), // Label text color
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFE6B300)), // Border color on focus
                    ),
                  ),
                  validator: _validateAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _address2Controller,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    labelStyle:
                        TextStyle(color: Colors.white), // Label text color
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFE6B300)), // Border color on focus
                    ),
                  ),
                  validator: _validateAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _zipController,
                  decoration: const InputDecoration(
                    labelText: 'ZIP Code',
                    labelStyle:
                        TextStyle(color: Colors.white), // Label text color
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFE6B300)), // Border color on focus
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: _validateZipCode,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _district,
                  items: [
                    'Colombo',
                    'Gampaha',
                    'Kalutara',
                    'Kandy',
                    'Matale',
                    'Nuwara Eliya',
                    'Galle',
                    'Matara',
                    'Hambantota',
                    'Jaffna',
                    'Kilinochchi',
                    'Mannar',
                    'Vavuniya',
                    'Mullaitivu',
                    'Batticaloa',
                    'Ampara',
                    'Trincomalee',
                    'Kurunegala',
                    'Puttalam',
                    'Anuradhapura',
                    'Polonnaruwa',
                    'Badulla',
                    'Moneragala',
                    'Ratnapura',
                    'Kegalle',
                  ]
                      .map((district) => DropdownMenuItem(
                            value: district,
                            child: Text(district,
                                style: TextStyle(
                                    color: const Color.fromARGB(
                                        //dropdown font colour
                                        255,
                                        255,
                                        255,
                                        255))),
                          ))
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'District',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE6B300)),
                    ),
                  ),
                  dropdownColor: Color.fromARGB(
                      255, 0, 0, 0), // Set dropdown menu background color
                  style: const TextStyle(
                      color: Color.fromARGB(
                          255, 143, 142, 142)), // Text color in the dropdown
                  onChanged: (value) {
                    setState(() {
                      _district = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emergencyContactController,
                  decoration: const InputDecoration(
                    labelText: 'Emergency Contact',
                    labelStyle:
                        TextStyle(color: Colors.white), // Label text color
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Color(0xFFE6B300)), // Border color on focus
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: _validatePhoneNo,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE6B300)),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white, //icon colour
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  style: const TextStyle(color: Colors.white), //pw colour
                  obscureText: !_passwordVisible,
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE6B300)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  obscureText: !_passwordVisible,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE6B300),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process the registration
                      // You can handle your registration logic here
                      onRegister();
                    }
                  },
                  child: const Text(
                    'Register',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DriverBasicInfoPage extends StatefulWidget {
  @override
  _DriverBasicInfoPageState createState() => _DriverBasicInfoPageState();
}

class _DriverBasicInfoPageState extends State<DriverBasicInfoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final Authentication authProvider = Authentication();

  bool _passwordVisible = false;
  DateTime? _selectedDate;
  int? _age;
  String? _district;
  String _gender = 'male'; //defalut male, most drivers are male

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicController.dispose();
    _emailController.dispose();
    _phoneNoController.dispose();
    _address1Controller.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  onRegister() {
    authProvider.registerUser(_firstNameController.text, _lastNameController.text, _nicController.text, _emailController.text, _passwordController.text,
        _confirmPasswordController.text, _phoneNoController.text, _selectedDate.toString(), _address1Controller.text,
        _district!, _cityController.text, _zipController.text, _gender, "Driver").then((onValue) async {


      final parsedJson = jsonDecode(onValue);
      if(parsedJson["user"] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful!', style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.green,
            elevation: 10,
          ),
        );

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('currentUser', onValue);
        prefs.setString('userRole', parsedJson["user"]["role"]);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DriverHomePage(
                driverName: parsedJson['user']["first_name"],
              )),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong!!!', style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.red,
            elevation: 10,
          ),
        );
      }

    });
  }

  String? _validateName(String? value) {
    if (value == null || value.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    return null;
  }

  String? _validateNIC(String? value) {
    if (value == null || (value.length != 10 && value.length != 12)) {
      return 'NIC must be either 10 or 12 characters long';
    }
    if (value.length == 10) {
      if (!RegExp(r'^\d{9}[VX]$').hasMatch(value)) {
        return 'NIC must be 9 digits followed by V or X';
      }
    } else if (value.length == 12) {
      if (!RegExp(r'^\d{12}$').hasMatch(value)) {
        return 'NIC must be 12 digits';
      }
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$')
        .hasMatch(value)) {
      return 'Password must include uppercase, lowercase, and a number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null ||
        !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
            .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePhoneNo(String? value) {
    if (value == null ||
        value.length != 10 ||
        !RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Phone number must be 10 digits';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an address';
    }
    return null;
  }

  String? _validateZipCode(String? value) {
    if (value == null || value.isEmpty || !RegExp(r'^\d{5}$').hasMatch(value)) {
      return 'Enter a valid ZIP code';
    }
    return null;
  }

  String? _validateDistrict(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a district';
    }
    return null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _age = DateTime.now().year - picked.year;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Basic Information'),
        backgroundColor: const Color(0xFFE6B300),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 20),
              Center(
                child: Image.asset('assets/logo.png', height: 80),
              ),
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  labelStyle:
                      TextStyle(color: Colors.white), // Label text color
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFE6B300)), // Border color on focus
                  ),
                ),
                style: TextStyle(color: Colors.white), // Text color
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  labelStyle:
                      TextStyle(color: Colors.white), // Label text color
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFE6B300)), // Border color on focus
                  ),
                ),
                style: TextStyle(color: Colors.white), // Text color
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nicController,
                decoration: const InputDecoration(
                  labelText: 'NIC',
                  labelStyle:
                      TextStyle(color: Colors.white), // Label text color
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFE6B300)), // Border color on focus
                  ),
                ),
                style: TextStyle(color: Colors.white), // Text color
                validator: _validateNIC,
              ),
              const SizedBox(height: 16),
              TextFormField(
                //driver has to pic from dropdown
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Birthday',
                  labelStyle:
                      TextStyle(color: Colors.white), // Label text color
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFE6B300)), // Border color on focus
                  ),
                ),
                style: TextStyle(color: Colors.white), // Text color
                onTap: () => _selectDate(context),
                controller: TextEditingController(
                  text: _selectedDate != null
                      ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                      : '',
                ),
              ),
              const SizedBox(height: 16),
              if (_age != null)
                Text('Age: $_age', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              if (_age != null && (_age! < 25 || _age! > 55))
                const Text(
                  'Driver age must be between 25 and 55',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gender,
                items: ['male', 'female', 'other']
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender,
                              style: TextStyle(
                                  color: const Color.fromARGB(
                                      255, 255, 255, 255))), //dropdown color
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE6B300)),
                  ),
                ),
                dropdownColor: Color.fromARGB(
                    255, 0, 0, 0), // Set dropdown menu background color
                style: const TextStyle(
                    color: Color.fromARGB(
                        255, 143, 142, 142)), // Text color in the dropdown
                onChanged: (value) {
                  setState(() {
                    _gender = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _address1Controller,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  labelStyle:
                      TextStyle(color: Colors.white), // Label text color
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFE6B300)), // Border color on focus
                  ),
                ),
                validator: _validateAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'City',
                  labelStyle:
                      TextStyle(color: Colors.white), // Label text color
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFE6B300)), // Border color on focus
                  ),
                ),
                validator: _validateAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _zipController,
                decoration: const InputDecoration(
                  labelText: 'ZIP Code',
                  labelStyle:
                      TextStyle(color: Colors.white), // Label text color
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFE6B300)), // Border color on focus
                  ),
                ),
                validator: _validateZipCode,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _district,
                items: [
                  'Colombo',
                  'Gampaha',
                  'Kalutara',
                  'Kandy',
                  'Matale',
                  'Nuwara Eliya',
                  'Galle',
                  'Matara',
                  'Hambantota',
                  'Jaffna',
                  'Kilinochchi',
                  'Mannar',
                  'Vavuniya',
                  'Mullaitivu',
                  'Batticaloa',
                  'Ampara',
                  'Trincomalee',
                  'Kurunegala',
                  'Puttalam',
                  'Anuradhapura',
                  'Polonnaruwa',
                  'Badulla',
                  'Moneragala',
                  'Ratnapura',
                  'Kegalle',
                ]
                    .map((district) => DropdownMenuItem(
                          value: district,
                          child: Text(district,
                              style: TextStyle(
                                  color: const Color.fromARGB(
                                      //dropdown font colour
                                      255,
                                      255,
                                      255,
                                      255))),
                        ))
                    .toList(),
                decoration: const InputDecoration(
                  labelText: 'District',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE6B300)),
                  ),
                ),
                dropdownColor: Color.fromARGB(
                    255, 0, 0, 0), // Set dropdown menu background color
                style: const TextStyle(
                    color: Color.fromARGB(
                        255, 143, 142, 142)), // Text color in the dropdown
                onChanged: (value) {
                  setState(() {
                    _district = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle:
                      TextStyle(color: Colors.white), // Label text color
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFE6B300)), // Border color on focus
                  ),
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneNoController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle:
                      TextStyle(color: Colors.white), // Label text color
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color(0xFFE6B300)), // Border color on focus
                  ),
                ),
                validator: _validatePhoneNo,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.white),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.white, //icon colour
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(color: Colors.white), //Pw colour

                validator: _validatePassword,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE6B300)),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
                obscureText: !_passwordVisible,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color(0xFFE6B300), // Button color
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {

                  if (_formKey.currentState!.validate()) {
                    onRegister();
                  }

                  //   ScaffoldMessenger.of(context).showSnackBar(
                  //     const SnackBar(content: Text('Processing Data')),
                  //   );
                  //
                  //   onRegister();
                  //   // Navigate to Driving License Page
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           DrivingLicensePage(), // Change here to DrivingLicensePage
                  //     ),
                  //   );
                  // } else {
                  //   print("in the else part");
                  // }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class DrivingLicensePage extends StatefulWidget {
  @override
  _DrivingLicensePageState createState() => _DrivingLicensePageState();
}

class _DrivingLicensePageState extends State<DrivingLicensePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final List<Map<String, String>> _vehicleCategories = [
    {'category': 'A1: Light motor cycles', 'image': 'assets/A1.png'},
    {'category': 'A: Motorcycles', 'image': 'assets/A.png'},
    {'category': 'B1: Motorcycles', 'image': 'assets/B1.png'},
    {'category': 'B: Dual purpose light vehicle', 'image': 'assets/B.png'},
    {'category': 'C1: Light Motor Lorry', 'image': 'assets/C1.png'},
    {'category': 'C: Motor Lorry', 'image': 'assets/C.png'},
    {'category': 'CE: Heavy Motor Lorry', 'image': 'assets/CE.png'},
    {'category': 'D1: Light Motor Coach', 'image': 'assets/D1.png'},
    {'category': 'D: Motor Coach', 'image': 'assets/D.png'},
    {'category': 'DE: Heavy Motor Coach', 'image': 'assets/DE.png'},
    {'category': 'G1: Hand Tractors', 'image': 'assets/G1.png'},
    {'category': 'G: Land Vehicle', 'image': 'assets/G.png'},
    {'category': 'J: Special purpose Vehicle', 'image': 'assets/J.png'},
  ];
  final Set<String> _selectedCategories = {};
  final _formKey = GlobalKey<FormState>();

  // Image picker variables
  final ImagePicker _picker = ImagePicker();
  XFile? _frontImage;
  XFile? _backImage;

  Future<void> _pickImage(bool isFrontImage) async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        if (isFrontImage) {
          _frontImage = pickedImage;
        } else {
          _backImage = pickedImage;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Your \nDriving License Details',
          textAlign: TextAlign.center,
        ),
        backgroundColor: const Color(0xFFE6B300),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/logo.png', // Path to your logo
                    height: 100,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name Of the license',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE6B300)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    } else if (value.length < 3) {
                      return 'Full name must be at least 3 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _licenseNumberController,
                  decoration: const InputDecoration(
                    labelText: 'License Number',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFE6B300)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your license number';
                    } else if (value.length < 6 || value.length > 12) {
                      return 'License number must be between 6 and 12 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Categories of Vehicles:',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 8),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3 / 2,
                  ),
                  itemCount: _vehicleCategories.length,
                  itemBuilder: (context, index) {
                    final category = _vehicleCategories[index];
                    final isSelected =
                        _selectedCategories.contains(category['category']);

                    return Card(
                      color: isSelected ? Colors.yellow : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedCategories.remove(category['category']);
                            } else {
                              _selectedCategories.add(category['category']!);
                            }
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              category['image']!,
                              height: 50,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              category['category']!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Upload License Images:',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _pickImage(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE6B300),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          _frontImage == null
                              ? 'Upload Front Image'
                              : 'Front Image Selected',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _pickImage(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE6B300),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: Text(
                          _backImage == null
                              ? 'Upload Back Image'
                              : 'Back Image Selected',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        if (_selectedCategories.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please select at least one vehicle category.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (_frontImage == null || _backImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please upload both front and back images.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          // Handle form submission
                          // Add your submission logic here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Driving license details submitted!'),
                              backgroundColor: Colors.green,
                            ),
                          );

                          // Navigate to BankDetailsPage after successful submission
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BankAccountDetailsPage()),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFFE6B300),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BankAccountDetailsPage extends StatefulWidget {
  @override
  _BankAccountDetailsPageState createState() => _BankAccountDetailsPageState();
}

class _BankAccountDetailsPageState extends State<BankAccountDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountBranchController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  String? _selectedBank;

  final List<String> _banks = [
    'Bank of Ceylon',
    'People\'s Bank',
    'Commercial Bank of Ceylon',
    'Hatton National Bank',
    'Sampath Bank',
    'National Savings Bank',
    'Seylan Bank',
    'Nations Trust Bank',
    'DFCC Bank',
    'Pan Asia Bank',
    'Amana Bank',
    'Union Bank',
    'HSBC',
    'Standard Chartered Bank',
    'Cargills Bank',
    'National Development Bank (NDB)',
    'LB Finance PLC',
    'SANASA Development Bank',
    'Citizens Development Business Finance (CDB)',
    'Regional Development Bank',
    'Primary Dealer Unit (Central Bank of Sri Lanka)',
  ];

  void _sendSMSAndValidatePin() async {
    // Logic to send SMS
    String enteredPin = await _showPinEntryDialog(context) ?? '';

    // Example PIN for validation
    const String correctPin = '123456';

    if (enteredPin == correctPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Registration successful! You are now registered as a driver.'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect PIN. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _showPinEntryDialog(BuildContext context) async {
    String pin = '';
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter SMS Code'),
          content: TextField(
            maxLength: 6,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter the 6-digit PIN',
            ),
            onChanged: (value) {
              pin = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(pin);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _confirmRegistration() {
    if (_formKey.currentState?.validate() ?? false) {
      // Show snackbar and proceed to send SMS and validate the PIN
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('SMS sent! Please enter the PIN to confirm.'),
          backgroundColor: Colors.green,
        ),
      );
      _sendSMSAndValidatePin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Account Details'),
        backgroundColor: const Color(0xFFE6B300),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bank Name:',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              DropdownButtonFormField<String>(
                value: _selectedBank,
                items: _banks.map((String bank) {
                  return DropdownMenuItem<String>(
                    value: bank,
                    child: Text(bank),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBank = value;
                  });
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null ? 'Please select a bank' : null,
              ),
              const SizedBox(height: 16),
              const Text(
                'Account Name:',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              TextFormField(
                controller: _accountNameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the account name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Account Branch:',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              TextFormField(
                controller: _accountBranchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the account branch';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Account Number:',
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                maxLength: 20,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the account number';
                  } else if (value.length > 20) {
                    return 'Account number cannot be more than 20 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _confirmRegistration,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: const Color(0xFFE6B300),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text(
                    'Submit and Validate',
                    style: TextStyle(
                      fontSize: 20,
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
