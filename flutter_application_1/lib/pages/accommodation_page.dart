import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'accommodation_details_page.dart';
import 'flights_page.dart';
import '../main.dart';

class AccommodationPage extends StatefulWidget {
  @override
  _AccommodationPageState createState() => _AccommodationPageState();
}

class _AccommodationPageState extends State<AccommodationPage> {
  List<Map<String, dynamic>> accommodations = [
    {
      'imageUrl': 'assets/hotel_barcelona_princess.jpg',
      'name': 'Hotel Barcelona Princess',
      'location': 'Av. Diagonal, 1, Sant Martí',
      'stars': 4,
      'price': 'Desde 134€/Noche Por Persona',
      'date': '26-04-2024',
      'averageRating': 0.0,
    },
    {
      'imageUrl': 'assets/hotel_madrid_centro.jpg',
      'name': 'Hotel Madrid Centro',
      'location': 'Gran Via, 20, Centro',
      'stars': 5,
      'price': 'Desde 150€/Noche Por Persona',
      'date': '27-04-2024',
      'averageRating': 0.0,
    },
    {
      'imageUrl': 'assets/hotel_sevilla_deluxe.jpg',
      'name': 'Hotel Sevilla Deluxe',
      'location': 'Calle San Fernando, 2, Nervion',
      'stars': 4,
      'price': 'Desde 120€/Noche Por Persona',
      'date': '28-04-2024',
      'averageRating': 0.0,
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchAllAverageRatings();
  }

  Future<void> fetchAllAverageRatings() async {
    for (var accommodation in accommodations) {
      double averageRating = await fetchAverageRating(accommodation['name'] as String);
      setState(() {
        accommodation['averageRating'] = averageRating;
      });
    }
  }

  Future<double> fetchAverageRating(String accommodationName) async {
    final ratingsSnapshot = await FirebaseFirestore.instance
        .collection('accommodation_ratings')
        .doc(accommodationName)
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
        backgroundColor: Colors.red[300],
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Image.asset('assets/menu.png'), // Ícono de menú
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Abrir el Drawer
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
                Navigator.pushNamed(context, '/my_reservations');
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Perfil',
                style: TextStyle(color: Colors.red[700]),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
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
              color: Colors.blue.shade700,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FlightsPage()),
                    );
                  },
                  child: Text(
                    'VUELOS',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red[100],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'ALOJAMIENTO',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red[700],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: accommodations.length, // Número de alojamientos en la lista
              itemBuilder: (context, index) {
                final accommodation = accommodations[index];

                return AccommodationCard(
                  imageUrl: accommodation['imageUrl'] as String,
                  name: accommodation['name'] as String,
                  location: accommodation['location'] as String,
                  stars: accommodation['stars'] as int,
                  price: accommodation['price'] as String,
                  date: accommodation['date'] as String,
                  averageRating: accommodation['averageRating'] as double,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AccommodationCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;
  final int stars;
  final String price;
  final String date;
  final double averageRating;

  AccommodationCard({
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.stars,
    required this.price,
    required this.date,
    required this.averageRating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AccommodationDetailsPage(
              imageUrl: imageUrl,
              name: name,
              location: location,
              stars: stars,
              price: price,
              date: date,
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
                      name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[900],
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(location),
                    Text('Estrellas: $stars'),
                    Text(price),
                    Text(date),
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
