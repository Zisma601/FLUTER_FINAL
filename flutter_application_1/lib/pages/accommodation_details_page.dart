import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccommodationDetailsPage extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String location;
  final int stars;
  final String price;
  final String date;

  AccommodationDetailsPage({
    required this.imageUrl,
    required this.name,
    required this.location,
    required this.stars,
    required this.price,
    required this.date,
  });

  @override
  _AccommodationDetailsPageState createState() => _AccommodationDetailsPageState();
}

class _AccommodationDetailsPageState extends State<AccommodationDetailsPage> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0.0;

  final Map<String, List<Map<String, String>>> hotelActivities = {
    'Hotel Barcelona Princess': [
      {
        'title': 'Spa para Mascotas',
        'schedule': 'Horario: 9:00 AM - 6:00 PM',
        'petType': 'Tipo de Mascotas: Perros y gatos',
        'price': 'Precio: 100 por sesión',
        'description': 'Descripción: Tratamientos de spa incluyendo masajes, baños y peluquería.',
      },
      {
        'title': 'Parque de Juegos',
        'schedule': 'Horario: 7:00 AM - 9:00 PM',
        'petType': 'Tipo de Mascotas: Perros',
        'price': 'Precio: Gratis para huéspedes',
        'description': 'Descripción: Área de juegos al aire libre con obstáculos y zonas de entrenamiento.',
      },
    ],
    'Hotel Madrid Centro': [
      {
        'title': 'Clases de Adiestramiento',
        'schedule': 'Horario: 10:00 AM y 4:00 PM',
        'petType': 'Tipo de Mascotas: Perros',
        'price': 'Precio: 50 por clase',
        'description': 'Descripción: Clases de adiestramiento impartidas por profesionales.',
      },
      {
        'title': 'Cine al Aire Libre',
        'schedule': 'Horario: 8:00 PM',
        'petType': 'Tipo de Mascotas: Perros y gatos',
        'price': 'Precio: Gratis para huéspedes',
        'description': 'Descripción: Proyección de películas al aire libre donde las mascotas son bienvenidas.',
      },
    ],
    'Hotel Sevilla Deluxe': [
      {
        'title': 'Piscina para Mascotas',
        'schedule': 'Horario: 10:00 AM - 5:00 PM',
        'petType': 'Tipo de Mascotas: Perros',
        'price': 'Precio: Gratis para huéspedes',
        'description': 'Descripción: Piscina especialmente diseñada para que los perros se diviertan nadando.',
      },
      {
        'title': 'Fotografía Profesional',
        'schedule': 'Horario: Bajo reserva',
        'petType': 'Tipo de Mascotas: Todas',
        'price': 'Precio: 150 por sesión',
        'description': 'Descripción: Sesiones de fotografía profesional para crear recuerdos inolvidables con tu mascota.',
      },
    ],
  };

  Future<void> submitRating() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ratingData = {
        'userId': user.uid,
        'rating': _rating,
        'comment': _commentController.text,
        'timestamp': Timestamp.now(),
      };

      await FirebaseFirestore.instance
          .collection('accommodation_ratings')
          .doc(widget.name)
          .collection('ratings')
          .add(ratingData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Rating submitted successfully'),
      ));

      setState(() {
        _commentController.clear();
        _rating = 0.0;
      });
    }
  }

  Future<void> reservarAlojamiento() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Verificar si la reserva ya existe
      final existingReservation = await FirebaseFirestore.instance
          .collection('alojamiento_reservas')
          .where('userId', isEqualTo: user.uid)
          .where('nombre_hotel', isEqualTo: widget.name)
          .limit(1)
          .get();

      if (existingReservation.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ya has reservado este alojamiento.'),
        ));
        return;
      }

      // Detalles de la reserva
      final reservationData = {
        'userId': user.uid,
        'nombre_hotel': widget.name,
        'ubicacion': widget.location,
        'fecha': widget.date,
        'estrellas': widget.stars,
        'precio': widget.price,
        'timestamp': Timestamp.now(),
      };

      // Guardar en Firestore
      await FirebaseFirestore.instance.collection('alojamiento_reservas').add(reservationData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reserva realizada con éxito'),
      ));
    }
  }

  List<Widget> _getAccommodationActivities() {
    final activities = hotelActivities[widget.name] ?? [];

    return activities.map((activity) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Card(
          child: ListTile(
            leading: Icon(Icons.pets, color: Colors.red[700]),
            title: Text(activity['title'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              'Horario: ${activity['schedule']}\n'
              'Tipo de Mascotas: ${activity['petType']}\n'
              'Precio: ${activity['price']}\n'
              'Descripción: ${activity['description']}',
            ),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.red[700]),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.red[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                widget.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
            SizedBox(height: 20),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red[900],
              ),
            ),
            SizedBox(height: 10),
            Text('Ubicación: ${widget.location}'),
            Text('Estrellas: ${widget.stars}'),
            Text('Fecha: ${widget.date}'),
            Text(widget.price),
            Text('Tiempo: Jacuzzi y Piscina'),
            SizedBox(height: 20),
            Text(
              'Detalles Adicionales',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
            ),
            SizedBox(height: 10),
            ..._getAccommodationActivities(),
            SizedBox(height: 20),
            Text(
              'Rating',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                  ),
                  color: Colors.blue,
                  onPressed: () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                  },
                );
              }),
            ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: submitRating,
                child: Text('Submit Rating'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  backgroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.purple,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: reservarAlojamiento,
                child: Text('Reservar'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  backgroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 18,
                    color: Colors.purple,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
