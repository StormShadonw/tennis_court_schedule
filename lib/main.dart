import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_schedule/pages/home_page.dart';
import 'package:tennis_court_schedule/pages/reservation_details_page.dart';
import 'package:tennis_court_schedule/providers/schedule_data_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ScheduleDataProvider()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomePage(),
          routes: {
            HomePage.routeName: (context) => HomePage(),
            ReservationsDetailsPage.routeName: (context) =>
                ReservationsDetailsPage(),
          }),
    );
  }
}
