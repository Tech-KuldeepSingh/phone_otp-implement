import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String verificationId = '';

  Future<void> verifyPhoneNumber() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    void verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
      await auth.signInWithCredential(phoneAuthCredential);
      if (kDebugMode) {
        print('Phone Verification Completed');
      }
      // Phone authentication successful, navigate to the next screen
      // For example, you can navigate to the home screen or a profile screen
    }

    void verificationFailed(FirebaseAuthException error) {
      // Handle verification failure
      if (kDebugMode) {
        print('Verification Failed: ${error.message}');
      }
    }

    void codeSent(String verificationId, int? resendToken) {
      setState(() {
        verificationId = verificationId;
      });
      if (kDebugMode) {
        print('SMS Code Sent');
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            phoneNumber: '+918221946822', // Replace with the user's phone number
            verificationId: verificationId, // Pass the verificationId to the OTPVerificationScreen
          ),
        ),
      );
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      // This callback will be triggered when the automatic SMS code
      // detection has timed out. You can implement custom logic here if needed.
      if (kDebugMode) {
        print('SMS Code Auto Retrieval Timeout');
      }
    }

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: '+918221946822', // Replace with the user's phone number
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        timeout: const Duration(seconds: 60), // Adjust the timeout duration as needed
      );
    } catch (e) {
      if (kDebugMode) {
        if (kDebugMode) {
          print('Error: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Authentication'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: verifyPhoneNumber,
          child: const Text('Verify Phone Number'),
        ),
      ),
    );
  }
}
