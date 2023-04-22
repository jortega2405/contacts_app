import 'package:contacts_app/src/screens/home_page.dart';
import 'package:contacts_app/src/screens/register_screen.dart';
import 'package:contacts_app/src/screens/user_screen.dart';
import 'package:contacts_app/src/utils/constants.dart';
import 'package:contacts_app/src/widgets/app_button.dart';
import 'package:contacts_app/src/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../utils/global.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController pwdController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;



  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese un correo electrónico';
    }if (!RegExp(r"^[a-zA-Z0-9._%+-]+\@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)){
      return 'Por favor, ingrese un correo electronico valido';
    }if (value.contains(' ')) {
    return 'el correo no debe contener espacios en blanco';
    }
    return null;
    
  }

  String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, ingrese una contraseña';
  }
  if (value.length < 10 || value.length > 60) {
    return 'La contraseña debe tener entre 10 y 60 caracteres';
  }
  if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{10,60}$').hasMatch(value)) {
    return 'Must have at least 1 Capital letter, 1 lowercase, 1 number and 1 special character';
  }
  if (value.contains(' ')) {
    return 'No spaces allowed';
  }
  return null;
  }

  Future<void> _signIn() async {
  setState(() {
    _isLoading = true;
  });
  try {
    await supabase.auth.signInWithPassword(
      email: emailController.text,
      password: pwdController.text,
    );

    final user = await supabase
    .from('users')
    .select('user_name,avatar,id').match(
        {'user_email': emailController.text});

    globalUser = user[0];
   
    Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomePage())   , (route) => false);
  } on AuthException catch (error) {
    context.showErrorSnackBar(message: error.message);
    setState(() {
      _isLoading = false;
    });
  } catch (_) {
    context.showErrorSnackBar(message: unexpectedErrorMessage);
    setState(() {
      _isLoading = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
               Image.asset('assets/images/logo.png'),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                      )
                    ],
                  ),
                ),
               ),
              Container(
                margin: const EdgeInsets.fromLTRB(20,20,20,20),
                child: Column(
                  children: [
                    const Text('You dont have an account?'),
                    TextButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen())
                        );
                      },
                      child: const Text('Sing Up'),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signIn,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent.withOpacity(0.1)),
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(300, 70),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(width: 1, color: Colors.grey), 
                      ),
                    ),
                  ),
                  child: const Text("SUBMIT"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}