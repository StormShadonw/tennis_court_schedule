import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_court_schedule/helpers/helpers.dart';

class ScheduleDataProvider with ChangeNotifier {
  List<String> _courts = ["A", "B", "C"];
  List<String> get courts => _courts;

  List<String> _reservations = [];
  List<List<String>> get reservations {
    List<List<String>> result = [];
    for (var reservation in _reservations) {
      var split = reservation.split("%");
      result.add([split[0], split[1], split[2], split[3]]);
    }
    return result;
  }

  Future<void> getReservations() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? reservations = prefs.getStringList('reservations');
    if (reservations == null || reservations.isEmpty) {
      return;
    }
    _reservations = reservations;
    print(_reservations);
    notifyListeners();
  }

  Future<void> insertNewReservation(List<String> reservation) async {
    print("Reservation: $reservation");
    final prefs = await SharedPreferences.getInstance();
    await getReservations();
    _reservations.add(
        "${reservation[0]}%${reservation[1]}%${reservation[2]}%${reservation[3]}");
    await prefs.setStringList('reservations', _reservations);
  }

  Future<void> deleteReservation(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await getReservations();
    _reservations.removeWhere((element) => element.split("%")[0] == id);
    print("Deleting reservations: $_reservations");
    await prefs.setStringList('reservations', _reservations);
  }

  Future<bool> isDateAvaliable(String court, DateTime datetime) async {
    final prefs = await SharedPreferences.getInstance();
    await getReservations();
    for (var reservation in _reservations) {
      var myCourt = reservation.split("%")[1];
      var myDateTime = DateTime.parse(reservation.split("%")[2].toString());
      if (myDateTime.year == datetime.year &&
          myDateTime.month == datetime.month &&
          myDateTime.day == datetime.day &&
          myDateTime.hour == datetime.hour &&
          myDateTime.minute == datetime.minute &&
          myCourt == court) {
        return false;
      }
    }
    return true;
  }

  int getRainPosibility() {
    return Random().nextInt(100);
  }
}
