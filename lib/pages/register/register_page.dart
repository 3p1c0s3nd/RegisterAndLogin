import 'package:flutter/material.dart';
import 'package:prueba_mobx_y_supabase/main.dart';
import 'package:prueba_mobx_y_supabase/utils/DefaultTextField.dart';
import 'package:prueba_mobx_y_supabase/utils/my_shared_preference.dart';
import 'package:prueba_mobx_y_supabase/utils/my_snackbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  MySharedPreference mySharedPreference = MySharedPreference();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String nombre = '';
  String apellidos = '';
  String telefono = '';
  bool isLoading = false;

  void _register() async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'name': nombre, 'apellidos': apellidos, 'telefono': telefono},
      );

      Navigator.of(context).pushReplacementNamed('/login');

      /*final User? user = res.user;
      

      if (user != null) {
        mySharedPreference.save('user', user);
        mySharedPreference.save('token', res.session!.accessToken);
      }*/
    } catch (e) {
      if (e is AuthApiException) {
        MySnackbar.show(context, e.message);
      } else {
        MySnackbar.show(context, 'Error desconocido');
      }
    }
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
                    _iconPerson(),
                    _textLogin(),
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

  Widget _iconPerson() {
    return Icon(
      Icons.person,
      color: Colors.white,
      size: 125,
    );
  }

  Widget _textLogin() {
    return Text(
      'LOGIN',
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
