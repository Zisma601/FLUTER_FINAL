import 'package:flutter/material.dart';
import 'FlightDetailsPage.dart';
import '../main.dart';
import 'accommodation_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profile_page.dart';
import 'my_reservations_page.dart';

class FlightsPage extends StatefulWidget {
  @override
  _FlightsPageState createState() => _FlightsPageState();
}

class _FlightsPageState extends State<FlightsPage> {
  List<Map<String, dynamic>> flights = [
    {
      'imageUrl': 'assets/air_adolfo_suarez.jpg',
      'destination': 'Madrid - Barcelona',
      'date': '26-04-2024',
      'time': '13:40H',
      'airport': 'Aeropuerto Adolfo Suarez',
      'flightNumber': 'G6 5632',
      'price': '30€',
      'averageRating': 0.0,
    },
    {
      'imageUrl': 'assets/aeropuerto_milan.jpg',
      'destination': 'Madrid - Valencia',
      'date': '27-04-2024',
      'time': '14:40H',
      'airport': 'Aeropuerto Adolfo Suarez',
      'flightNumber': 'G6 5633',
      'price': '35€',
      'averageRating': 0.0,
    },
    {
      'imageUrl': 'assets/air_rumania.jpg',
      'destination': 'Madrid - Sevilla',
      'date': '28-04-2024',
      'time': '15:40H',
      'airport': 'Aeropuerto Adolfo Suarez',
      'flightNumber': 'G6 5634',
      'price': '40€',
      'averageRating': 0.0,
    },
    {
      'imageUrl': 'assets/air_singapur.jpg',
      'destination': 'Madrid - Málaga',
      'date': '29-04-2024',
      'time': '16:40H',
      'airport': 'Aeropuerto Adolfo Suarez',
      'flightNumber': 'G6 5635',
      'price': '45€',
      'averageRating': 0.0,
    },
    {
      'imageUrl': 'assets/airport.jpg',
      'destination': 'Madrid - Bilbao',
      'date': '30-04-2024',
      'time': '17:40H',
      'airport': 'Aeropuerto Adolfo Suarez',
      'flightNumber': 'G6 5636',
      'price': '50€',
      'averageRating': 0.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchAllAverageRatings();
  }

  Future<void> fetchAllAverageRatings() async {
    for (var flight in flights) {
      double averageRating = await fetchAverageRating(flight['flightNumber'] as String);
      setState(() {
        flight['averageRating'] = averageRating;
      });
    }
  }

  Future<double> fetchAverageRating(String flightNumber) async {
    final ratingsSnapshot = await FirebaseFirestore.instance
        .collection('flight_ratings')
        .doc(flightNumber)
        .collection('ratings')
        .get();

    if (ratingsSnapshot.docs.isEmpty) {
      return 0.0;
    }

    final totalRating = ratingsSnapshot.docs.fold<double>(
      0.0,
      (sum, doc) => sum + (doc['rating'] as double? ?? 0.0),
    );
    return totalRating / ratingsSnapshot.docs.length;
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
        actions: [
          IconButton(
            icon: Image.asset('assets/calendar.png'), // Ícono de calendario
            onPressed: () {
              Navigator.pushNamed(context, '/date_selection'); // Navegar a la pantalla de selección de fecha
            },
          ),
        ],
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
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/perro_amor.jpg',
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
          ),
          Container(
            color: Colors.red[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'VUELOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red[700],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AccommodationPage()),
                    ); // Navegar a la pantalla de alojamientos
                  },
                  child: Text(
                    'ALOJAMIENTO',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red[100],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: flights.length, // Número de vuelos en la lista
              itemBuilder: (context, index) {
                final flight = flights[index];

                return FlightCard(
                  imageUrl: flight['imageUrl'] as String,
                  destination: flight['destination'] as String,
                  date: flight['date'] as String,
                  time: flight['time'] as String,
                  airport: flight['airport'] as String,
                  flightNumber: flight['flightNumber'] as String,
                  price: flight['price'] as String,
                  averageRating: flight['averageRating'] as double,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FlightCard extends StatelessWidget {
  final String imageUrl;
  final String destination;
  final String date;
  final String time;
  final String airport;
  final String flightNumber;
  final String price;
  final double averageRating;

  FlightCard({
    required this.imageUrl,
    required this.destination,
    required this.date,
    required this.time,
    required this.airport,
    required this.flightNumber,
    required this.price,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlightDetailsPage(
              imageUrl: imageUrl,
              destination: destination,
              date: date,
              time: time,
              airport: airport,
              flightNumber: flightNumber,
              price: price,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red[200]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  height: 150,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      destination,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[900],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(date),
                    Text(time),
                    Text(airport),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 5),
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
