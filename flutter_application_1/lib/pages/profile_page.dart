import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'settings_page.dart';
import 'my_reservations_page.dart';
import 'flights_page.dart';
import 'accommodation_page.dart';
import '../main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'Desconocido';
  String userEmail = 'Desconocido';
  List<Map<String, dynamic>> userPets = [];

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  void fetchUserInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('usuario').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc.get('nombre') ?? 'Desconocido';
          userEmail = userDoc.get('email') ?? 'Desconocido';
          userPets = List<Map<String, dynamic>>.from(userDoc.get('mascotas') ?? []);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[100],
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Image.asset('assets/menu.png'),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: Colors.red[200],
              padding: EdgeInsets.only(top: 40, bottom: 20),
              child: Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                'Inicio',
                style: TextStyle(color: Colors.red[700]),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FlightsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text(
                'Mis Reservas',
                style: TextStyle(color: Colors.red[700]),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyReservationsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Perfil',
                style: TextStyle(color: Colors.red[700]),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Ajustes',
                style: TextStyle(color: Colors.red[700]),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
            Spacer(),
            Container(
              color: Colors.red[700],
              child: ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  // Acción de cerrar sesión y redirigir al login
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.red, // Cambia el color de fondo a rojo
                backgroundImage: AssetImage('assets/profile_placeholder.png'),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  userName,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  userEmail,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Mis Mascotas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ...userPets.map((pet) => Card(
                    child: ListTile(
                      title: Text(pet['nombre'] ?? 'Desconocido'),
                      subtitle: Text('Tipo: ${pet['tipo']}, Alergias: ${pet['alergias']}, Edad: ${pet['edad']}, Necesidades Especiales: ${pet['necesidades_especiales']}'),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
