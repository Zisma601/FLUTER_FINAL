import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final List<Pet> _pets = [];
  bool _obscureText = true;

  Future<void> _login(BuildContext context) async {
    final String name = _nameController.text;
    final String password = _passwordController.text;

    if (name.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, complete todos los campos.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      // Fetch the user document using the provided name
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('usuario')
          .where('nombre', isEqualTo: name)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        String email = userQuery.docs.first['email'];

        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Update user info with pets if any
        if (_pets.isNotEmpty) {
          await FirebaseFirestore.instance.collection('usuario').doc(userCredential.user?.uid).update({
            'mascotas': _pets.map((pet) => pet.toJson()).toList(),
          });

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Mascotas añadidas exitosamente'),
          ));
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Inicio de sesión exitoso'),
        ));
        Navigator.pushNamed(context, '/flights');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Usuario no encontrado'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al iniciar sesión: $e'),
      ));
    }
  }

  bool _allPetsValid() {
    for (var pet in _pets) {
      if (!pet.isValid()) {
        return false;
      }
    }
    return true;
  }

  void _addPet() {
    setState(() {
      _pets.add(Pet());
    });
  }

  void _removePet(int index) {
    setState(() {
      _pets.removeAt(index);
    });
  }

  void _savePet(Pet pet) {
    if (!pet.isValid()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, complete todos los campos de la mascota correctamente.'),
        backgroundColor: Colors.red,
      ));
      return;
    }
    setState(() {
      pet.saved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              width: double.infinity,
              child: Stack(
                children: [
                  CustomPaint(
                    painter: WavePainter(),
                    child: Container(),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/perro_amor.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Iniciar Sesión',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Nombre de Usuario',
                            prefixIcon: Icon(Icons.person, color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(Icons.lock, color: Colors.red),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/change_password');
                            },
                            child: Text(
                              '¿Has Olvidado Tu Contraseña?',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _pets.length,
                          itemBuilder: (context, index) {
                            return PetForm(
                              pet: _pets[index],
                              onRemove: () => _removePet(index),
                              onSave: () => _savePet(_pets[index]),
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _addPet,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Añadir Mascota',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => _login(context),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: Text(
                            '¿No tienes cuenta? Regístrate',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
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

class Pet {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController allergiesController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController specialNeedsController = TextEditingController();
  bool saved = false;

  Map<String, dynamic> toJson() {
    return {
      'nombre': nameController.text,
      'tipo': typeController.text,
      'alergias': allergiesController.text,
      'edad': int.tryParse(ageController.text) ?? 0,
      'necesidades_especiales': specialNeedsController.text,
    };
  }

  bool isValid() {
    if (nameController.text.isEmpty) {
      return false;
    }
    if (typeController.text.isEmpty) {
      return false;
    }
    if (allergiesController.text.isEmpty) {
      return false;
    }
    if (ageController.text.isEmpty || int.tryParse(ageController.text) == null) {
      return false;
    }
    if (specialNeedsController.text.isEmpty) {
      return false;
    }
    return true;
  }
}

class PetForm extends StatefulWidget {
  final Pet pet;
  final VoidCallback onRemove;
  final VoidCallback onSave;

  PetForm({required this.pet, required this.onRemove, required this.onSave});

  @override
  _PetFormState createState() => _PetFormState();
}

class _PetFormState extends State<PetForm> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: widget.pet.nameController,
              decoration: InputDecoration(
                labelText: 'Nombre de la Mascota',
                prefixIcon: Icon(Icons.pets, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: widget.pet.nameController.text.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: widget.pet.typeController.text.isEmpty ? null : widget.pet.typeController.text,
              items: ['Perro', 'Gato', 'Reptil']
                  .map((type) => DropdownMenuItem(
                        child: Text(type),
                        value: type,
                      ))
                  .toList(),
              onChanged: (value) {
                widget.pet.typeController.text = value ?? '';
                setState(() {});
              },
              decoration: InputDecoration(
                labelText: 'Tipo',
                prefixIcon: Icon(Icons.category, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: widget.pet.typeController.text.isEmpty ? 'Este campo es obligatorio' : null,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: widget.pet.allergiesController,
              decoration: InputDecoration(
                labelText: 'Alergias',
                prefixIcon: Icon(Icons.warning, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: widget.pet.allergiesController.text.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: widget.pet.ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Edad',
                prefixIcon: Icon(Icons.cake, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: widget.pet.ageController.text.isEmpty
                    ? 'Este campo es obligatorio'
                    : (int.tryParse(widget.pet.ageController.text) == null ? 'Por favor, ingrese un número válido para la edad' : null),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 10),
            TextField(
              controller: widget.pet.specialNeedsController,
              decoration: InputDecoration(
                labelText: 'Necesidades Especiales',
                prefixIcon: Icon(Icons.local_hospital, color: Colors.red),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                errorText: widget.pet.specialNeedsController.text.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: widget.onRemove,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Eliminar Mascota',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: widget.pet.isValid() && !widget.pet.saved ? widget.onSave : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Guardar Mascota',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    paint.color = Colors.red[700]!;
    var path = Path();
    path.lineTo(0, size.height * 0.5);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.55,
      size.width * 0.5, size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.45,
      size.width, size.height * 0.5,
    );
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);

    paint.color = Colors.red[600]!;
    path = Path();
    path.lineTo(0, size.height * 0.55);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.6,
      size.width * 0.5, size.height * 0.55,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.5,
      size.width, size.height * 0.55,
    );
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);

    paint.color = Colors.red[500]!;
    path = Path();
    path.lineTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.65,
      size.width * 0.5, size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.55,
      size.width, size.height * 0.6,
    );
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);

    paint.color = Colors.red[400]!;
    path = Path();
    path.lineTo(0, size.height * 0.65);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.7,
      size.width * 0.5, size.height * 0.65,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.6,
      size.width, size.height * 0.65,
    );
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);

    paint.color = Colors.red[300]!;
    path = Path();
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.75,
      size.width * 0.5, size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.65,
      size.width, size.height * 0.7,
    );
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);

    paint.color = Colors.red[200]!;
    path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.8,
      size.width * 0.5, size.height * 0.75,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.7,
      size.width, size.height * 0.75,
    );
    path.lineTo(size.width, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
