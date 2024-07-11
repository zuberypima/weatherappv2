import 'package:flutter/material.dart';

class EmergenceContactPage extends StatefulWidget {
  const EmergenceContactPage({super.key});

  @override
  State<EmergenceContactPage> createState() => _EmergenceContactPageState();
}

class _EmergenceContactPageState extends State<EmergenceContactPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          detaildeContainer('Normal Call', '0755 000 888', Icons.phone),
          detaildeContainer('Email', 'weatherhelp@gmail.com', Icons.email),
          detaildeContainer('Normal Message', '0755 000 777', Icons.sms)
        ],
      ),
    );
  }
}

Widget detaildeContainer(String category, phoneNumber, IconData icondata) {
  return Card(
    child: ListTile(
      leading: Icon(icondata),
      title: Text(category),
      subtitle: Text(phoneNumber),
    ),
  );
}
