import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spor Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.indigo,
          accentColor: Colors.deepPurpleAccent,
          backgroundColor: Colors.grey[200],
          cardColor: Colors.white,
          errorColor: Colors.red,
          brightness: Brightness.light,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static List<Widget> _pages = <Widget>[
    ExercisePage(),
    AssistantPage(),
    DietAssistantPage(),
    ProfileMainPage(), // Profil sayfası
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Egzersizler',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.food_bank),
            label: 'Diyet Asistan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ExercisePage extends StatelessWidget {
  final List<Map<String, dynamic>> exercises = [
    {"name": "Göğüs", "images": [
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
    ]},
    {"name": "Arka Kol", "images": [
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
    ]},
    {"name": "Ön Kol", "images": [
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
    ]},
    {"name": "Omuz", "images": [
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
    ]},
    {"name": "Sırt", "images": [
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
    ]},
    {"name": "Bacak", "images": [
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
      "https://via.placeholder.com/150",
    ]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hedef Bölge'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseDetailPage(
                    exerciseName: exercises[index]["name"],
                    images: exercises[index]["images"],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.indigo, width: 2.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    exercises[index]["images"][0],
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 8),
                  Text(
                    exercises[index]["name"],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ExerciseDetailPage extends StatelessWidget {
  final String exerciseName;
  final List<String> images;

  ExerciseDetailPage({required this.exerciseName, required this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exerciseName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.0,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: images.length,
          itemBuilder: (context, index) {
            return Image.network(images[index]);
          },
        ),
      ),
    );
  }
}

class DietAssistantPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Üstte bir fotoğraf ekleyin:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: NetworkImage(
                'https://via.placeholder.com/150',
              ),
            ),
            SizedBox(height: 16),
            ProfileDetailsForm(),
          ],
        ),
      ),
    );
  }
}

class ProfileDetailsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Kilo'),
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText: 'Boy'),
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText: 'Yaş'),
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(labelText: 'Cinsiyet'),
          ),
        ],
      ),
    );
  }
}

class AssistantPage extends StatefulWidget {
  @override
  _AssistantPageState createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  String _response = '';

  final Map<String, String> responses = {
    "Merhaba": "Merhaba! Size nasıl yardımcı olabilirim?",
    "Nasılsın?": "Teşekkürler, ben bir yapay zekayım ve her zaman iyiyim!",
    "Hava nasıl?": "Ben sanal bir asistanım, hava durumunu bilemiyorum.",
    "Spor hakkında bilgi ver": "Spor, fiziksel aktivite yaparak vücudun zinde kalmasını sağlar.",
    "Diyet önerisi verir misin?": "Sağlıklı bir diyet için bol sebze ve meyve tüketin, işlenmiş gıdalardan kaçının."
  };

  void getResponse(String query) {
    setState(() {
      _response = responses[query] ?? "Üzgünüm, bu soruya yanıtım yok.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asistan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Size hangi konuda yardımcı olabilirim?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                getResponse("Merhaba");
              },
              child: Text('Merhaba'),
            ),
            ElevatedButton(
              onPressed: () {
                getResponse("Nasılsın?");
              },
              child: Text('Nasılsın?'),
            ),
            ElevatedButton(
              onPressed: () {
                getResponse("Hava nasıl?");
              },
              child: Text('Hava nasıl?'),
            ),
            ElevatedButton(
              onPressed: () {
                getResponse("Spor hakkında bilgi ver");
              },
              child: Text('Spor hakkında bilgi ver'),
            ),
            ElevatedButton(
              onPressed: () {
                getResponse("Diyet önerisi verir misin?");
              },
              child: Text('Diyet önerisi verir misin?'),
            ),
            SizedBox(height: 16),
            Text(_response),
          ],
        ),
      ),
    );
  }
}

class ProfileMainPage extends StatefulWidget {
  @override
  _ProfileMainPageState createState() => _ProfileMainPageState();
}

class _ProfileMainPageState extends State<ProfileMainPage> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: isLoggedIn ? ProfilePage() : LoginPage(onLoginSuccess: () {
        setState(() {
          isLoggedIn = true;
        });
      }),
    );
  }
}

class LoginPage extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  LoginPage({required this.onLoginSuccess});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onLoginSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-posta',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen e-posta adresinizi girin';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Şifre',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Lütfen şifrenizi girin';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: Text('Giriş Yap'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              'https://via.placeholder.com/150',
            ),
          ),
          SizedBox(height: 20),
          ProfileDetailsForm(),
        ],
      ),
    );
  }
}
