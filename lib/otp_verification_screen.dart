import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OTPVerificationScreen(
      {super.key, required this.phoneNumber, required this.verificationId});

  @override
  OTPVerificationScreenState createState() => OTPVerificationScreenState();
}

class OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isVerifying = false;

  void verifyOTP() {
    setState(() {
      isVerifying = true;
    });

    // Create a PhoneAuthCredential using the verificationId and the OTP entered by the user
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otpController.text,
    );

    // Sign in with the credential to complete the phone authentication
    FirebaseAuth.instance
        .signInWithCredential(phoneAuthCredential)
        .then((value) {
      // Phone authentication successful, navigate to the next screen
      // Pass the userId as an argument to the UserProfileHomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UserProfileHomePage(
              userId: value.user!.uid), // Pass the userId here
        ),
      );
    }).catchError((error) {
      // Handle verification failure
      if (kDebugMode) {
        print('Verification Failed: ${error.message}');
      }
      // Show an error dialog or handle the error as needed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Phone verification failed. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }).whenComplete(() {
      setState(() {
        isVerifying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Enter OTP',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isVerifying ? null : verifyOTP,
                child: const Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Replace this with your actual screen that you want to navigate to after successful verification

class UserProfileHomePage extends StatelessWidget {
  final String userId;

  const UserProfileHomePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile Home Page'),
      ),
      body: const Center(
        child: Text(
          'Welcome, User!',
          style: TextStyle(fontSize: 25, color: Colors.blue),
        ), // You can customize this screen as needed
      ),
    );
  }
}
