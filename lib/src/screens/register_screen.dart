import 'package:contacts_app/src/screens/login_screen.dart';
import 'package:contacts_app/src/utils/constants.dart';
import 'package:contacts_app/src/widgets/app_button.dart';
import 'package:contacts_app/src/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController confirmPwd = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }


  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }if (!RegExp(r"^[a-zA-Z0-9._%+-]+\@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)){
      return 'Plase, enter a valid email';
    }
    return null;
  }

  String? validateUser(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }if (value.length < 4) {
      return 'Must have at least 4 Characters';
    }
    return null;
  }

  String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  if (value.length < 10 || value.length > 60) {
    return 'Must have between 10 and 60 Characters';
  }
  if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{10,60}$').hasMatch(value)) {
    return 'Must have at least 1 Capital letter, 1 lowercase, 1 number and 1 special character';
  }
  return null;
  }

  String? validateConfirmPassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  } else if (value.compareTo(pwdController.text) != 0) {
    return "Password doesn't match";
  }
  return null;
}

Future<void> _signUp() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    final email = emailController.text;
    final password = pwdController.text;
    final username = userNameController.text;
    try {
      await supabase.auth.signUp(
          email: email,
          password: password,
          data: {'username': username}
      );

      final List<Map<String, dynamic>> data =
        await supabase.from('users').insert([
      {'user_name': username, 'user_email': email},
      
    ]).select();


      Navigator.of(context)
          .pushAndRemoveUntil(LoginScreen.route(), (route) => false);
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
                 Image.asset(
                  'assets/images/logo.png',
                  scale: 2,  
                ),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        keyboardType: TextInputType.text,
                        validator: validateUser,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        label: 'User Name',
                        controller: userNameController,
                        regexp: r"^[a-zA-Z ]{4,50}$",
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]+')),
                        ],
                        maxLength: 50,
                      ),
                      CustomTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validateEmail,
                        label: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        regexp: r"^[a-zA-Z0-9._%+-]+\@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s")),
                        ],
                        maxLength: 50,
                      ),
                      CustomTextField(
                        
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validatePassword,
                        obscureText: true,
                        label: "Password",
                        keyboardType: TextInputType.text,
                        controller: pwdController,
                        regexp: r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{10,60}$',
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s")),
                        ],
                        maxLength: 60,
                      ),
                      CustomTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: validateConfirmPassword,
                        obscureText: true,
                        label: "Confirm your password",
                        keyboardType: TextInputType.text,
                        controller: confirmPwd,
                        regexp: r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{10,60}$',
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r"\s")),
                        ],
                        maxLength: 60,
                      ),
                    ],
                  ),
                ),
               ),
              Container(
                margin: const EdgeInsets.fromLTRB(20,20,20,20),
                child: Column(
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>const LoginScreen())
                        );
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: AppButton(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: double.infinity,
                  backgroundColor: Colors.transparent.withOpacity(0.1),
                  text: 'Submit',
                  onPressed: _signUp
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}