import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_schedule/pages/reservation_details_page.dart';
import 'package:tennis_court_schedule/providers/schedule_data_provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/HomePage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = false;
  late ScheduleDataProvider _dataProvider;
  List<List<String>> _reservations = [];

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });

    _dataProvider = Provider.of<ScheduleDataProvider>(
      context,
      listen: false,
    );

    await _dataProvider.getReservations();

    setState(() {
      _reservations = _dataProvider.reservations;
    });

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _reservations.sort(((a, b) => a[2].compareTo(b[2])));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reserva tu cancha de tennis APP"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, ReservationsDetailsPage.routeName)
                .then((value) => getData());
          },
          child: const Icon(Icons.add)),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: const Text(
                "Reservaciones",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            _reservations.isEmpty
                ? const Text("No hay reservaciones en este momento.")
                : Expanded(
                    child: ListView.builder(
                        itemCount: _reservations.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            minLeadingWidth: 15,
                            trailing: Container(
                              width: 90,
                              height: 55,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        " ${_dataProvider.getRainPosibility()}%",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.thunderstorm,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                      padding: const EdgeInsets.all(0),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext ctx) {
                                              return AlertDialog(
                                                title: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.error,
                                                      size: 55,
                                                      color: Theme.of(context)
                                                          .errorColor,
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    const Text(
                                                        'Eliminar Reservación'),
                                                  ],
                                                ),
                                                content: const Text(
                                                    'Esta seguro de que desea eliminar esta reservación?\n\nEsta informacion no podra ser recuperada.'),
                                                actions: [
                                                  // The "Yes" button
                                                  TextButton(
                                                      onPressed: () async {
                                                        setState(() {
                                                          _isLoading = true;
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                        await _dataProvider
                                                            .deleteReservation(
                                                                _reservations[
                                                                    index][0]);
                                                        // Close the dialog

                                                        await getData();
                                                      },
                                                      child: const Text('Yes')),
                                                  TextButton(
                                                      onPressed: () {
                                                        // Close the dialog
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text('No'))
                                                ],
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Theme.of(context).errorColor,
                                      )),
                                ],
                              ),
                            ),
                            leading: Container(
                              constraints: const BoxConstraints(
                                maxHeight: 45,
                                maxWidth: 15,
                              ),
                              alignment: Alignment.center,
                              child: FittedBox(
                                child: Text(
                                  _reservations[index][1],
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            title: FittedBox(
                              child: Text(
                                "Fecha: ${DateFormat('dd/MM/yyyy hh:mm a').format(
                                  DateTime.parse(_reservations[index][2]),
                                )}",
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            subtitle:
                                Text("Usuario: ${_reservations[index][3]}"),
                          );
                        }),
                  ),
          ],
        ),
      )),
    );
  }
}
