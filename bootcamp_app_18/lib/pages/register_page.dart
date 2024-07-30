import 'package:bootcamp_app_18/pages/login_page.dart';
import 'package:bootcamp_app_18/pages/profil_page.dart';
import 'package:bootcamp_app_18/provider/app_provider.dart';
import 'package:bootcamp_app_18/service/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _firebaseService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title:
            Text("Register", style: Theme.of(context).textTheme.displayLarge),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Geri tuşuna basıldığında yapılacak işlemler
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(50),
                ),
              ),
              child: const Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('lib/assets/images/logo.png'),
                  backgroundColor: Colors.transparent,
                  child: ClipOval(
                    child: Image(
                      image: AssetImage('lib/assets/images/logo.png'),
                      fit: BoxFit.cover,
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Yeni̇ Hesap Oluştur',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const FaIcon(FontAwesomeIcons.google),
                          onPressed: _registerWithGoogle,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('veya e-posta hesabınızı kullanın'),
                  const SizedBox(height: 10),
                  Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        TextFormField(
                          controller: _nameController,
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          validator: (value) =>
                              value!.isEmpty ? "Enter an name" : null,
                          decoration: InputDecoration(
                            hintText: "Name",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          validator: (value) =>
                              value!.isEmpty ? "Enter an email" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          validator: (value) =>
                              value!.isEmpty ? "Enter an password" : null,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock),
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ])),
                  const SizedBox(height: 16),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text('Kayıt Ol',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                        ),
                  const SizedBox(height: 1),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: Text(
                        'Zaten bir hesabınız var mı? Buradan giriş yapın',
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registerWithGoogle() async {
    User? user = await _firebaseService.signInWithGoogle();
    if (user != null) {
      print('Signed in: ${user.displayName}');
      successRegister();
    } else {
      showDialogWarning();
      print('Sign in failed');
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      //  String name = _nameController.text.trim();

      User? user =
          await _firebaseService.registerWithEmailAndPassword(email, password);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (user != null) {
          // Kayıt başarılı olduğunda gerçekleştirmek istediğimiz işlemler buraya eklenebilir.

          successRegister();
        } else {
          // Kayıt başarısız
          showDialogWarning();
        }
      }
    }
  }

  void successRegister() {
    Provider.of<AppProvider>(context, listen: false).login();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const ProfilPage();
      },
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kayıt Başarılı'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<dynamic> showDialogWarning() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Failed'),
        content: const Text('Failed to register. Please try again.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Alert dialog kapat
            },
            child: Text(
              'OK',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
