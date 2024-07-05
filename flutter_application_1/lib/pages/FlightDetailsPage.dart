import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FlightDetailsPage extends StatefulWidget {
  final String imageUrl;
  final String destination;
  final String date;
  final String time;
  final String airport;
  final String flightNumber;
  final String price;

  FlightDetailsPage({
    required this.imageUrl,
    required this.destination,
    required this.date,
    required this.time,
    required this.airport,
    required this.flightNumber,
    required this.price,
  });

  @override
  _FlightDetailsPageState createState() => _FlightDetailsPageState();
}

class _FlightDetailsPageState extends State<FlightDetailsPage> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  final Map<String, List<Map<String, String>>> flightActivities = {
    'G6 5632': [
      {
        'title': 'Viaje Tranquilo',
        'Horario': 'Disponible en todos los vuelos.',
        'Tipo de Mascotas': 'Perros y gatos.',
        'Precio': '\$50 por mascota',
        'Descripción': 'Ofrecemos un ambiente tranquilo y cómodo para tu mascota durante el vuelo con áreas designadas para descanso.'
      },
      {
        'title': 'Servicio de Comida a Bordo',
        'Horario': 'Durante el vuelo.',
        'Tipo de Mascotas': 'Perros, gatos, aves.',
        'Precio': '\$20 por comida',
        'Descripción': 'Comida especialmente preparada para tu mascota, incluyendo opciones hipoalergénicas.'
      },
      {
        'title': 'Kit de Bienvenida',
        'Horario': 'Al abordar.',
        'Tipo de Mascotas': 'Perros y gatos.',
        'Precio': 'Incluido en el costo del billete',
        'Descripción': 'Recibe un kit con juguetes, golosinas y una manta para tu mascota.'
      },
    ],
    'G6 5633': [
      {
        'title': 'Asistencia Veterinaria',
        'Horario': 'Disponible durante el vuelo.',
        'Tipo de Mascotas': 'Todas.',
        'Precio': '\$100 por consulta',
        'Descripción': 'Asistencia veterinaria en caso de emergencias médicas durante el vuelo.'
      },
      {
        'title': 'Comida Gourmet para Mascotas',
        'Horario': 'Durante el vuelo.',
        'Tipo de Mascotas': 'Perros y gatos.',
        'Precio': '\$30 por comida',
        'Descripción': 'Platos gourmet preparados por chefs para tu mascota.'
      },
    ],
    'G6 5634': [
      {
        'title': 'Servicio de Entrenamiento',
        'Horario': 'Durante el vuelo.',
        'Tipo de Mascotas': 'Perros.',
        'Precio': '\$40 por sesión',
        'Descripción': 'Sesiones de entrenamiento básicas para tu perro durante el vuelo.'
      },
      {
        'title': 'Zona de Juegos',
        'Horario': 'Disponible en vuelos largos.',
        'Tipo de Mascotas': 'Perros y gatos.',
        'Precio': 'Gratis',
        'Descripción': 'Área de juegos para que tu mascota se divierta durante el vuelo.'
      },
    ],
    'G6 5635': [
      {
        'title': 'Consultoría de Comportamiento',
        'Horario': 'Disponible durante el vuelo.',
        'Tipo de Mascotas': 'Perros y gatos.',
        'Precio': '\$60 por sesión',
        'Descripción': 'Consultoría sobre comportamiento de mascotas para mejorar la convivencia.'
      },
      {
        'title': 'Sesión de Fotos',
        'Horario': 'Disponible en vuelos largos.',
        'Tipo de Mascotas': 'Todas.',
        'Precio': '\$50 por sesión',
        'Descripción': 'Sesión de fotos profesionales para tu mascota.'
      },
    ],
    'G6 5636': [
      {
        'title': 'Baño y Peluquería',
        'Horario': 'Disponible durante el vuelo.',
        'Tipo de Mascotas': 'Perros y gatos.',
        'Precio': '\$70 por servicio',
        'Descripción': 'Servicio de baño y peluquería para que tu mascota viaje limpia y cómoda.'
      },
      {
        'title': 'Juguetes Interactivos',
        'Horario': 'Disponible en vuelos largos.',
        'Tipo de Mascotas': 'Todas.',
        'Precio': 'Incluido en el costo del billete',
        'Descripción': 'Juguetes interactivos para mantener a tu mascota entretenida durante el vuelo.'
      },
    ],
  };

  void _submitRating() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ratingData = {
        'userId': user.uid,
        'rating': _rating,
        'comment': _commentController.text,
        'timestamp': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('flight_ratings')
          .doc(widget.flightNumber)
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

  List<Widget> _getFlightActivities() {
    final activities = flightActivities[widget.flightNumber] ?? [];

    return activities.map((activity) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Card(
          child: ListTile(
            leading: Icon(Icons.pets, color: Colors.red[700]),
            title: Text(activity['title'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(
              'Horario: ${activity['Horario']}\n'
              'Tipo de Mascotas: ${activity['Tipo de Mascotas']}\n'
              'Precio: ${activity['Precio']}\n'
              'Descripción: ${activity['Descripción']}',
            ),
          ),
        ),
      );
    }).toList();
  }

  void reservarVuelo(BuildContext context) async {
    try {
      // Extraer el destino final del string completo
      String destinoFinal = widget.destination.split(' - ').last;

      // Detalles del vuelo
      Map<String, dynamic> vuelo = {
        'fecha': widget.date,
        'nombre_aer': widget.airport,
        'num': widget.flightNumber,
        'from': 'Madrid',
        'to': destinoFinal,  // Aquí se asegura de que solo se guarde el destino final
        'hora': widget.time,
        'precio': widget.price,
      };

      // Verificar si la reserva ya existe
      final existingReservation = await FirebaseFirestore.instance
          .collection('vuelo_reservas')
          .where('num', isEqualTo: widget.flightNumber)
          .limit(1)
          .get();

      if (existingReservation.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Ya has reservado este vuelo.'),
        ));
        return;
      }

      // Guardar en Firestore
      await FirebaseFirestore.instance.collection('vuelo_reservas').add(vuelo);

      // Mostrar mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Reserva realizada con éxito'),
      ));
      Navigator.pop(context); // Volver a la página anterior
    } catch (e) {
      // Mostrar mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al realizar la reserva'),
      ));
    }
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(widget.imageUrl, fit: BoxFit.cover, width: double.infinity, height: 200),
              ),
              SizedBox(height: 20),
              Text(
                widget.destination,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[900],
                ),
              ),
              SizedBox(height: 10),
              Text('Vuelo: ${widget.flightNumber}'),
              Text('Aeropuerto: ${widget.airport}'),
              Text('Fecha: ${widget.date}'),
              Text('Hora: ${widget.time}'),
              Text('Precio: ${widget.price}'),
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
              ..._getFlightActivities(),
              SizedBox(height: 20),
              Text(
                'Rating',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                    ),
                    color: Colors.blue, // Cambia este color para las estrellas
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
                  onPressed: _submitRating,
                  child: Text('Submit Rating'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    backgroundColor: Colors.white, // Cambia este color para el botón "Submit Rating"
                    textStyle: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    reservarVuelo(context);
                  },
                  child: Text('Reservar'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    backgroundColor: Colors.white, // Cambia este color para el botón "Reservar"
                    textStyle: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
