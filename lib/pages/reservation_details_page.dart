import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tennis_court_schedule/helpers/helpers.dart';
import 'package:tennis_court_schedule/providers/schedule_data_provider.dart';

class ReservationsDetailsPage extends StatefulWidget {
  static const String routeName = "/ReservationsDetailsPage";

  @override
  State<ReservationsDetailsPage> createState() =>
      _ReservationsDetailsPageState();
}

class _ReservationsDetailsPageState extends State<ReservationsDetailsPage> {
  bool _isLoading = false;
  List<String> _courts = [];
  late ScheduleDataProvider _dataProvider;
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  String _court = "";
  DateTime _date = DateTime.now();
  TextEditingController _user = TextEditingController();

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });

    _dataProvider = Provider.of<ScheduleDataProvider>(
      context,
      listen: false,
    );

    _courts = _dataProvider.courts;
    _court = _courts.first;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> saveData() async {
    if (_form.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      var isDateAvaliable = await _dataProvider.isDateAvaliable(_court, _date);

      if (isDateAvaliable) {
        _dataProvider.insertNewReservation([
          Helper.generateId(8),
          _court,
          _date.toIso8601String(),
          _user.value.text
        ]);

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: const Text(
                  "La fecha elegida no esta disponible para reservaciones. Por favor eliga otra fecha."),
              backgroundColor: Theme.of(context).errorColor),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear nueva reservación"),
        actions: [
          IconButton(
            onPressed: () {
              saveData();
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: const EdgeInsets.all(10),
                  child: Form(
                      key: _form,
                      child: Column(
                        children: [
                          Container(
                            child: DropdownButtonFormField(
                              menuMaxHeight: size.height * 0.45,
                              decoration: const InputDecoration(
                                label: Text("Eliga la cancha."),
                              ),
                              value: _courts.first,
                              items: _courts.isEmpty
                                  ? []
                                  : List.generate(
                                      _courts.length,
                                      (index) => DropdownMenuItem(
                                            value: "${_courts[index]}",
                                            child: Text(
                                              _courts[index],
                                            ),
                                          )),
                              onChanged: (value) {
                                setState(() {
                                  _court = value.toString();
                                });
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 25),
                            child: Column(
                              children: [
                                Text(
                                    "Probabilidad de lluvia: ${_dataProvider.getRainPosibility()}%"),
                                TextButton(
                                    onPressed: () {
                                      DatePicker.showDateTimePicker(
                                        context,
                                        showTitleActions: true,
                                        onChanged: (date) {
                                          setState(() {
                                            _date = date;
                                          });
                                        },
                                        onConfirm: (date) {
                                          setState(() {
                                            _date = date;
                                          });
                                        },
                                        currentTime: _date,
                                        locale: LocaleType.es,
                                      );
                                    },
                                    child: Text(
                                      'Elegir fecha de reserva: ${DateFormat('dd/MM/yyyy hh:mm a').format(_date)}',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          Container(
                            child: TextFormField(
                              maxLength: 35,
                              controller: _user,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Por favor proveer un valor valido.";
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: "Usuario",
                                label: Text("Usuario"),
                              ),
                            ),
                          )
                        ],
                      )),
                )),
    );
  }
}
