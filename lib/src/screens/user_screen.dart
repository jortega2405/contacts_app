// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';
import 'dart:math';

import 'package:contacts_app/src/screens/login_screen.dart';
import 'package:contacts_app/src/utils/constants.dart';
import 'package:contacts_app/src/utils/global.dart';
import 'package:contacts_app/src/widgets/app_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class UserScreen extends StatefulWidget {
  Map<String, dynamic>? user;
  
  UserScreen({
    Key? key,
    this.user,
  }) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => UserScreen(),
    );
  }

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String? signedUrl ='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSI252CkZrVaMr_A-5z8qfs4NbWEd7trcGc4uMSJ_j&s' ;
  String userAvatarUrl = "";

  @override
  initState()  {
    super.initState();
    getAvatar(globalUser['avatar']);
  }

  @override
  void didUpdateWidget(UserScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user!['avatar'] != widget.user!['avatar']) {
      getAvatar(widget.user!['avatar']);
    }
  }

  getAvatar(avatarName) async {
   var img = await supabase.storage
        .from('avatars2')
        .createSignedUrl(avatarName, 60);
      var random = Random().nextInt(10000);

     setState(() {
        userAvatarUrl = '$img?$random';
     });
  }



  Future<void> _signOut() async {
    await supabase.auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);
  }

  FilePickerResult? imagen;

  Future<FilePickerResult?> selectImage() async {
    FilePickerResult? resultado = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    return resultado;
  }

  void uploadImage() async {
    imagen = await selectImage();
    if (imagen == null) return;
    final storage = supabase.storage;
    const ruta = 'avatars2';

    PlatformFile file = imagen!.files.first;
    String filePath = file.path!;

    final f =  File(filePath);
    var uuid = const Uuid().v4();
    final fileName = 'avatar_${uuid}';

    final result = await storage.from(ruta).upload(
          fileName,
          f,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    await supabase.from('users').update({'avatar': fileName}).match(
        {'user_email': globalUser['user_email']});

      var img = await supabase.storage
          .from('avatars2')
          .createSignedUrl(fileName, 60);
      
      setState(() {
          userAvatarUrl = img;
      });
      globalUser['avatar'] = fileName;
      getAvatar(result.split("/")[1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(globalUser["user_name"]),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child:userAvatarUrl.isNotEmpty ? CircleAvatar(
                maxRadius: 100,
                backgroundImage: NetworkImage(userAvatarUrl),
              ): const CircleAvatar(
                maxRadius: 100,
                backgroundImage: AssetImage('assets/images/user.png') ,
              )
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: AppButton(
                text: "EDIT",
                onPressed: uploadImage,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.07,
                backgroundColor: Colors.transparent.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
