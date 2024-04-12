import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prueba_mobx_y_supabase/main.dart';
import 'package:prueba_mobx_y_supabase/utils/DefaultTextField.dart';
import 'package:prueba_mobx_y_supabase/utils/my_avatar.dart';
import 'package:prueba_mobx_y_supabase/utils/my_shared_preference.dart';
import 'package:prueba_mobx_y_supabase/utils/my_snackbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:animate_do/animate_do.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  MySharedPreference mySharedPreference = MySharedPreference();
  String email = '';
  String password = '';
  String nombre = '';
  String apellidos = '';
  String telefono = '';
  bool isLoading = false;
  XFile? pickedFile;
  File? imageFile;
  String _avatarUrl = '';

  //ProgressDialog? _progressDialog;

  /*void showAlertDialog() {
    Widget galleryButton = ElevatedButton(
      child: const Text("GALERIA"),
      onPressed: () {
        selectImage(ImageSource.gallery);
      },
    );

    Widget camaraButton = ElevatedButton(
      child: const Text("CAMARA"),
      onPressed: () {
        selectImage(ImageSource.camera);
      },
    );

    AlertDialog alert =
        AlertDialog(title: const Text("Elija una imagen"), actions: [
      galleryButton,
      camaraButton,
    ]);

    showDialog(context: context!, builder: (BuildContext context) => alert);
  }

  Future selectImage(ImageSource imageSource) async {
    pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile!.path);
    }
    Navigator.pop(context!);
    setState(() {});
  }*/

  void _register() async {
    try {
      /*final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': nombre,
          'apellidos': apellidos,
          'telefono': telefono,
          'avatar_url': _avatarUrl
        },
      );*/

      await supabase.from('users').insert({
        //'id': supabase.auth.currentUser!.id,
        'email': email,
        'password': password,
        'name': nombre,
        'lastname': apellidos,
        'phone': telefono,
        'image': _avatarUrl,
        'created_at': DateTime.now().toString(),
        'updated_at': DateTime.now().toString(),

        //'session_token': res.session!.accessToken,
      });

      Navigator.of(context).pushReplacementNamed('/login');

      /*final User? user = res.user;
      

      if (user != null) {
        mySharedPreference.save('user', user);
        mySharedPreference.save('token', res.session!.accessToken);
      }*/
    } catch (e) {
      print(e);
      if (e is AuthApiException) {
        MySnackbar.show(context, e.message);
      } else {
        MySnackbar.show(context, 'Error desconocido');
      }
    }
  }

  Future<void> _onUpload(String imageUrl) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase.from('profiles').upsert({
        'id': userId,
        'avatar_url': imageUrl,
      });
      if (mounted) {
        const SnackBar(
          content: Text('Updated your profile image!'),
        );
      }
    } on PostgrestException catch (error) {
      SnackBar(
        content: Text(error.message),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _avatarUrl = imageUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        child: Stack(
          alignment: Alignment.center,
          children: [
            _imageBackground(context),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.3),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // VERTICAL
                  crossAxisAlignment: CrossAxisAlignment.center, // HORIZANTAL
                  children: [
                    Avatar(
                      imageUrl: _avatarUrl,
                      onUpload: _onUpload,
                    ),
                    _iconPerson(),
                    //_textLogin(),
                    _textFieldNombre(),
                    _textFieldApellidos(),
                    _textFieldTelefono(),
                    _textFieldEmail(),
                    _textFieldPassword(),
                    _buttonLogin(context),
                    _textDontHaveAccount(),
                    _buttonGoToRegister(context)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* Widget _imagePerfil() {
    return GestureDetector(
      onTap: () {
        showAlertDialog();
      },
      child: FadeIn(
        duration: const Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.03),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: imageFile != null
                  ? FileImage(imageFile!)
                  : const AssetImage("assets/img/user_profile_2.png")
                      as ImageProvider,
            ),
          ),
        ),
      ),
    );
  }*/

  Widget _iconPerson() {
    return Icon(
      Icons.person,
      color: Colors.white,
      size: 125,
    );
  }

  Widget _textLogin() {
    return Text(
      'REGISTRASE',
      style: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _textFieldNombre() {
    return Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        child: DefaultTextField(
          label: 'Nombre',
          icon: Icons.email,
          // errorText: snapshot.error?.toString(),
          onChanged: (text) {
            nombre = text;
          },
        ));
  }

  Widget _textFieldApellidos() {
    return Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        child: DefaultTextField(
          label: 'Apellidos',
          icon: Icons.email,
          // errorText: snapshot.error?.toString(),
          onChanged: (text) {
            apellidos = text;
          },
        ));
  }

  Widget _textFieldTelefono() {
    return Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        child: DefaultTextField(
          label: 'Telefono',
          icon: Icons.email,
          // errorText: snapshot.error?.toString(),
          onChanged: (text) {
            telefono = text;
          },
        ));
  }

  Widget _textFieldEmail() {
    return Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        child: DefaultTextField(
          label: 'Correo electronico',
          icon: Icons.email,
          // errorText: snapshot.error?.toString(),
          onChanged: (text) {
            email = text;
          },
        ));
  }

  Widget _textFieldPassword() {
    return Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        child: DefaultTextField(
          label: 'Contraseña',
          icon: Icons.lock,
          // errorText: snapshot.error?.toString(),
          onChanged: (text) {
            password = text;
          },
          obscureText: true,
        ));
  }

  Widget _buttonGoToRegister(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 55,
      margin: EdgeInsets.only(left: 25, right: 25, top: 15),
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, 'register');
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
        child: Text(
          'REGISTRATE',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _textDontHaveAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // HORIZANTAL
      children: [
        Container(
          width: 62,
          height: 1,
          color: Colors.white,
          margin: EdgeInsets.only(right: 5),
        ),
        Text(
          '¿No tienes cuenta?',
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
        Container(
          width: 62,
          height: 1,
          color: Colors.white,
          margin: EdgeInsets.only(left: 5),
        ),
      ],
    );
  }

  Widget _buttonLogin(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 55,
        margin: EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 15),
        child: ElevatedButton(
          onPressed: () {
            if (email.isEmpty) {
              MySnackbar.show(
                  context, 'Por favor, introduce tu correo electronico');
            } else if (password.isEmpty) {
              MySnackbar.show(context, 'Por favor, introduce tu contraseña');
            } else if (password.length < 6) {
              MySnackbar.show(
                  context, 'La contraseña debe ser de al menos 6 caracteres');
            } else if (nombre.isEmpty ||
                apellidos.isEmpty ||
                telefono.isEmpty) {
              MySnackbar.show(context, 'Por favor, rellena todos los campos');
            } else {
              _register();
            }
            //
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: isLoading
              ? CircularProgressIndicator()
              : Text(
                  'REGISTRARSE',
                  style: TextStyle(color: Colors.black),
                ),
        ));
  }

  Widget _imageBackground(BuildContext context) {
    return Image.asset(
      'assets/img/background.jpg',
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      fit: BoxFit.cover,
      color: Color.fromRGBO(0, 0, 0, 0.7),
      colorBlendMode: BlendMode.darken,
    );
  }
}
