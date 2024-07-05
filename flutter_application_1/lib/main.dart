import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/register.dart';
import 'pages/change_password.dart';
import 'pages/flights_page.dart';
import 'pages/FlightDetailsPage.dart';
import 'pages/date_selection_page.dart';
import 'pages/my_reservations_page.dart';
import 'pages/settings_page.dart';
import 'pages/profile_page.dart';
import 'pages/login.dart';
import 'pages/accommodation_page.dart';
import 'pages/accommodation_details_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/register': (context) => RegisterPage(),
        '/change_password': (context) => ChangePasswordPage(),
        '/flights': (context) => FlightsPage(),
        '/date_selection': (context) => DateSelectionPage(),
        '/accommodation': (context) => AccommodationPage(),
        '/my_reservations': (context) => MyReservationsPage(),
        '/settings': (context) => SettingsPage(),
        '/profile': (context) => ProfilePage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/details') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return FlightDetailsPage(
                imageUrl: args['imageUrl'],
                destination: args['destination'],
                date: args['date'],
                time: args['time'],
                airport: args['airport'],
                flightNumber: args['flightNumber'],
                price: args['price'],
              );
            },
          );
        } else if (settings.name == '/accommodation_details') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) {
              return AccommodationDetailsPage(
                imageUrl: args['imageUrl'],
                name: args['name'],
                location: args['location'],
                stars: args['stars'],
                price: args['price'],
                date: args['date'],
              );
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}
