import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'profile_page.dart';
import 'my_reservations_page.dart';
import 'flights_page.dart';
import 'accommodation_page.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: Icon(Icons.person, size: 50, color: Colors.red[700]),
              title: Text('Ajustes de Cuenta', style: TextStyle(fontSize: 20)),
            ),
            Divider(),
            ListTile(
              title: Text('Cambiar contraseña'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.pushNamed(context, '/change_password');
              },
            ),
            SwitchListTile(
              title: Text('Notificaciones'),
              value: notificationsEnabled,
              onChanged: (val) {
                setState(() {
                  notificationsEnabled = val;
                });
              },
              activeColor: Colors.red[700],
            ),
            Divider(),
            ListTile(
              title: Text('Más'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MoreSettingsPage()),
                );
              },
            ),
            ListTile(
              title: Text('Seguridad'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SecuritySettingsPage()),
                );
              },
            ),
            ListTile(
              title: Text('Privacidad'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrivacySettingsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SecuritySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seguridad'),
        backgroundColor: Colors.red[100],
        elevation: 0,
      ),
      backgroundColor: Colors.red[50],
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Autenticación en Dos Pasos (2FA)'),
            subtitle: Text('Protege tu cuenta con una capa adicional de seguridad.'),
            onTap: () {
              // Navegar a la página de configuración de 2FA
            },
          ),
          ListTile(
            title: Text('Historial de Inicios de Sesión'),
            subtitle: Text('Ve los dispositivos y ubicaciones donde has iniciado sesión.'),
            onTap: () {
              // Navegar a la página de historial de inicios de sesión
            },
          ),
          ListTile(
            title: Text('Cambiar Contraseña'),
            subtitle: Text('Actualiza tu contraseña actual.'),
            onTap: () {
              // Navegar a la página de cambio de contraseña
            },
          ),
          ListTile(
            title: Text('Alertas de Seguridad'),
            subtitle: Text('Recibe notificaciones sobre actividades sospechosas.'),
            onTap: () {
              // Navegar a la página de alertas de seguridad
            },
          ),
        ],
      ),
    );
  }
}

class MoreSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Más'),
        backgroundColor: Colors.red[100],
        elevation: 0,
      ),
      backgroundColor: Colors.red[50],
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Información de la Aplicación'),
            subtitle: Text('Versión, notas de la versión y créditos.'),
            onTap: () {
              // Navegar a la página de información de la aplicación
            },
          ),
          ListTile(
            title: Text('Ayuda y Soporte'),
            subtitle: Text('FAQ, soporte por correo electrónico y guías de usuario.'),
            onTap: () {
              // Navegar a la página de ayuda y soporte
            },
          ),
          ListTile(
            title: Text('Idioma'),
            subtitle: Text('Cambia el idioma de la aplicación.'),
            onTap: () {
              // Navegar a la página de configuración de idioma
            },
          ),
          ListTile(
            title: Text('Temas y Apariencia'),
            subtitle: Text('Personaliza el tema y los colores de la aplicación.'),
            onTap: () {
              // Navegar a la página de configuración de temas
            },
          ),
        ],
      ),
    );
  }
}

class PrivacySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacidad'),
        backgroundColor: Colors.red[100],
        elevation: 0,
      ),
      backgroundColor: Colors.red[50],
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Gestión de Datos'),
            subtitle: Text('Descarga una copia de tus datos o solicita la eliminación de tu cuenta.'),
            onTap: () {
              // Navegar a la página de gestión de datos
            },
          ),
          ListTile(
            title: Text('Permisos'),
            subtitle: Text('Gestiona los permisos de la aplicación.'),
            onTap: () {
              // Navegar a la página de permisos
            },
          ),
          ListTile(
            title: Text('Preferencias de Publicidad'),
            subtitle: Text('Gestiona tus preferencias de publicidad personalizada.'),
            onTap: () {
              // Navegar a la página de preferencias de publicidad
            },
          ),
          ListTile(
            title: Text('Configuración de Perfil'),
            subtitle: Text('Gestiona la visibilidad de tu información personal.'),
            onTap: () {
              // Navegar a la página de configuración de perfil
            },
          ),
        ],
      ),
    );
  }
}
