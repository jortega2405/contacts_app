

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase client
final supabase = Supabase.instance.client;
const url = "https://qkoxnwsdylpctsmtpsxp.supabase.co";
const anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFrb3hud3NkeWxwY3RzbXRwc3hwIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODIwMDQ2MjgsImV4cCI6MTk5NzU4MDYyOH0.TGKthDUrJDoZEGHylCpSAt22Qi8U2azBcQ9Detiny8k";

const appColor = Color.fromRGBO(48, 79, 254, 1);

/// Simple preloader inside a Center widget
const preloader =
    Center(child: CircularProgressIndicator(color: Colors.orange));

/// Simple sized box to space out form elements
const formSpacer = SizedBox(width: 16, height: 16);

/// Some padding for all the forms to use
const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);

/// Error message to display the user when unexpected error occurs.
const unexpectedErrorMessage = 'Unexpected error occurred.';

/// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}