import 'package:bootcamp_app_18/pages/profil_page.dart';
import 'package:bootcamp_app_18/pages/register_page.dart';
import 'package:bootcamp_app_18/service/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _firebaseService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text("Login", style: Theme.of(context).textTheme.displayLarge),
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
                    'Hesabınıza Giriş Yapın',
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
                          onPressed: loginWithGoogle,
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
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text('Giriş Yap',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                        ),
                  const SizedBox(height: 1),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()));
                    },
                    child: Text('Hesabınız yok mu? Buradan kayıt olun',
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

  void loginWithGoogle() async {
    User? user = await _firebaseService.signInWithGoogle();
    if (user != null) {
      print('Signed in: ${user.displayName}');
      successLogin();
    } else {
      showDialogWarning();
      print('Sign in failed');
    }
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      User? user =
          await _firebaseService.signInWithEmailAndPassword(email, password);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (user != null) {
          // Giriş başarılı olduğunda gerçekleştirmek istediğimiz işlemler buraya eklenebilir.
          successLogin();
        } else {
          // Kayıt başarısız
          showDialogWarning();
        }
      }
    }
  }

  void successLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const ProfilPage();
      },
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Giriş Başarılı'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<dynamic> showDialogWarning() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login failed'),
        content: const Text('Failed to login. Please try again.'),
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
