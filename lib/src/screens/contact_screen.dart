import 'package:contacts_app/src/utils/constants.dart';
import 'package:contacts_app/src/utils/global.dart';
import 'package:contacts_app/src/widgets/app_button.dart';
import 'package:contacts_app/src/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final nameController = TextEditingController();
  final idController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late Future<List<dynamic>> contacts;
  String searchTerm = '';


  @override
  void initState() {
    setState(() {
      contacts = fetchContacts();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('My Contacts'),
          centerTitle: true,
          leading: const Icon(Icons.arrow_back),
        ),
      body: Center(
          child: FutureBuilder<List<dynamic>>(
              future: fetchContacts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Text('No contacts added yet!');
                  }
                  return Visibility(
                    visible: snapshot.data!.isNotEmpty,
                    child: ListView.builder(

                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                snapshot.data![index]['contact_name'],
                                style: TextStyle( fontSize: 24),
                              ),
                              subtitle: Text(snapshot.data![index]['contact_id']),
                            ),
                            const Divider(),
                          ],
                        );
                      },                                          
                    ),
                    
                  );
                }else{
                  return const CircularProgressIndicator();
                }
              
              }
            )
          ),
      floatingActionButton: AppButton(
          text: 'Add Contact',
          onPressed: () {
            _showAddContactDialog(context);
          },
          width:  MediaQuery.of(context).size.width * 0.30,
          height: MediaQuery.of(context).size.height * 0.07,
          backgroundColor: Colors.transparent.withOpacity(0.1),
        ),
          
    );
  }

  String? validateContactName(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length < 2) {
      return 'Must have at least 2 Characters';
    }
    return null;
  }

  String? validateContactId(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (value.length < 6) {
      return 'Must have at least 6 Characters';
    }
    return null;
  }

  Future<void> onSave() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
     var contactName = nameController.text;
     var contactId = idController.text;
    try {

       
      final List<Map<String, dynamic>> data =
          await supabase.from('contacts').insert([
        {'contact_name': contactName, 'contact_id': contactId, 'user_id': globalUser['id']},
      ]).select();
      setState(() {
      contacts = fetchContacts();
      nameController.clear();
      idController.clear();
    });
    
      Navigator.pop(context);
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }

  Future<List<dynamic>> fetchContacts() async {
    try {
      final data = await supabase.from('contacts').select('contact_name,contact_id').eq('user_id', globalUser['id']);;
      return data;
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
      return [];
    } catch (error) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
      return [];
    }
  }

  Future<void> _showAddContactDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('TextField in Dialog'),
            content: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      keyboardType: TextInputType.text,
                      validator: validateContactName,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      label: 'Contact Name',
                      controller: nameController,
                      regexp: r"^[a-zA-Z ]{2,50}$",
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]+')),
                      ],
                      maxLength: 50,
                    ),
                    CustomTextField(
                      keyboardType: TextInputType.number,
                      validator: validateContactId,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      label: 'Contact Id',
                      controller: idController,
                      regexp: r'^[0-9]{6,10}$',
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'[^\d]')),
                      ],
                      maxLength: 10,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.transparent.withOpacity(0.2),
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  onPressed: onSave,
                  child: const Text('SAVE')),
            ],
          );
        });
  }
}
