import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../main.dart';
import 'flights_page.dart';
import 'accommodation_details_page.dart';
import 'profile_page.dart';

class MyReservationsPage extends StatefulWidget {
  @override
  _MyReservationsPageState createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  bool showFlights = true; // Variable para alternar entre vuelos y alojamientos

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
      body: Column(
        children: [
          Image.asset(
            'assets/perro_amor.jpg', // Ruta de la imagen del perro amoroso
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.red, // Cambia el color de fondo a rojo
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      showFlights = true;
                    });
                  },
                  child: Text(
                    'VUELOS',
                    style: TextStyle(
                      color: showFlights ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: showFlights ? Colors.black : Colors.red,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      showFlights = false;
                    });
                  },
                  child: Text(
                    'ALOJAMIENTO',
                    style: TextStyle(
                      color: showFlights ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: showFlights ? Colors.red : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Mis Reservas',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.brown,
            ),
          ),
          Expanded(
            child: showFlights ? _buildFlightReservations() : _buildAccommodationReservations(),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightReservations() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('vuelo_reservas').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No hay reservas de vuelos.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var reservation = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            var docId = snapshot.data!.docs[index].id;

            return ReservationCard(
              from: reservation['from'] ?? 'N/A',
              to: reservation['to'] ?? 'N/A',
              date: reservation['fecha'] ?? 'N/A',
              time: reservation['hora'] ?? 'N/A',
              flightNumber: reservation['num'] ?? 'N/A',
              docId: docId,
            );
          },
        );
      },
    );
  }

  Widget _buildAccommodationReservations() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('alojamiento_reservas').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No hay reservas de alojamiento.'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var reservation = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            var docId = snapshot.data!.docs[index].id;

            return AccommodationReservationCard(
              dateRange: reservation['fecha'] ?? 'N/A',
              hotelName: reservation['nombre_hotel'] ?? 'N/A',
              location: reservation['ubicacion'] ?? 'N/A',
              reservationId: docId,
            );
          },
        );
      },
    );
  }
}

class ReservationCard extends StatelessWidget {
  final String from;
  final String to;
  final String date;
  final String time;
  final String flightNumber;
  final String docId;

  ReservationCard({
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.flightNumber,
    required this.docId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    date,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  time,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text(
                  'Solo ida',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$from ➤ $to',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    cancelarReserva(context, docId, 'vuelo_reservas');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text('Cancelar'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Vuelo: $flightNumber',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }
}

class AccommodationReservationCard extends StatelessWidget {
  final String dateRange;
  final String hotelName;
  final String location;
  final String reservationId;

  AccommodationReservationCard({
    required this.dateRange,
    required this.hotelName,
    required this.location,
    required this.reservationId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateRange,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              hotelName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              location,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'ID: $reservationId',
              style: TextStyle(color: Colors.blue),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                cancelarReserva(context, reservationId, 'alojamiento_reservas');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Cancelar'),
            ),
          ],
        ),
      ),
    );
  }
}

void cancelarReserva(BuildContext context, String docId, String collection) async {
  try {
    await FirebaseFirestore.instance.collection(collection).doc(docId).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Reserva cancelada exitosamente.'),
    ));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Error al cancelar la reserva: $e'),
    ));
  }
}
