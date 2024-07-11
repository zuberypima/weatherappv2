import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:weather_app_tutorial/screens/emergency_contact.dart';
import 'package:weather_app_tutorial/screens/safety_tips.dart';
import '/constants/app_colors.dart';
import '/screens/forecast_report_screen.dart';
import '/screens/search_screen.dart';
import 'weather_screen/weather_screen.dart';
import '/services/api_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    ApiHelper.getCurrentWeather();

    // Initialize the plugin.
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  int _currentPageIndex = 0;

  final _screens = [
    WeatherScreen(),
    SearchScreen(),
    ForecastReportScreen(),
    SafetyTips(),
    // FeedsScreen(),
  ];

  // @override
  // void initState() {
  //   ApiHelper.getCurrentWeather();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height / 5,
                child: DrawerHeader(child: drawerProfile())),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EmergenceContactPage()));
                },
                child: Text("Emergency")),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SafetyTips()));
                },
                child: Text("Safety Tips")),
            Divider(),
            TextButton(
                onPressed: () {
                  showNotification();
                },
                child: Text("Notification ")),
          ],
        ),
      ),
      body: _screens[_currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color.fromRGBO(4, 138, 138, 0.766),
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentPageIndex,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: AppColors.grey,
          onTap: ontapScreen,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_max), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cities'),
            BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Report'),
            BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined), label: 'Tips'),
          ]),
      // ),
    );
  }

  ontapScreen(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await FlutterLocalNotificationsPlugin().show(
      0,
      'Abnormal Weather Detected',
      'It seesm the  Weather condition in your area,',
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}

Widget drawerProfile() {
  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection('UserDetails')
        .doc(FirebaseAuth.instance.currentUser?.email.toString())
        .get(),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text("Something went wrong");
      }

      if (snapshot.connectionState == ConnectionState.done) {
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Icon(Icons.person),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("User: ${data['FullName']}"),
                    Text("Emaile: ${data['Email']}"),
                  ],
                ),
              ],
            ),
          ],
        );
      }

      return Text("loading");
    },
  );
}
