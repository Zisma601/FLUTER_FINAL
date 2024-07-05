import 'package:flutter/material.dart';

class DateSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Color(0xFFECECEC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Calendar Widget
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFF1D1B5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Nov 2022", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Icon(Icons.calendar_today, color: Colors.black),
                    ],
                  ),
                  SizedBox(height: 10),
                  TableCalendar(),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Flight Search Box
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Ida y Vuelta"),
                      Switch(value: true, onChanged: (val) {}, activeColor: Color(0xFFA7630A)),
                      Text("Solo ida"),
                    ],
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Desde"),
                    subtitle: Text("Madrid, España"),
                    trailing: Icon(Icons.swap_vert, color: Color(0xFFA7630A)),
                  ),
                  ListTile(
                    title: Text("Destino"),
                    subtitle: Text("Barcelona, España"),
                    trailing: Icon(Icons.swap_vert, color: Color(0xFFA7630A)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text("Ida"),
                          Text("02-04-2024", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Icon(Icons.arrow_forward, color: Color(0xFFA7630A)),
                      Column(
                        children: [
                          Text("Vuelta"),
                          Text("04-05-2024", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Buscar vuelos"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      backgroundColor: Color(0xFFA7630A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TableCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        TableRow(
          children: [
            TableCell(child: Center(child: Text('D'))),
            TableCell(child: Center(child: Text('L'))),
            TableCell(child: Center(child: Text('M'))),
            TableCell(child: Center(child: Text('X'))),
            TableCell(child: Center(child: Text('J'))),
            TableCell(child: Center(child: Text('V'))),
            TableCell(child: Center(child: Text('S'))),
          ],
        ),
        // Repeat the TableRow for each week of the month
        // Add TableCells for each day of the month
      ],
    );
  }
}
