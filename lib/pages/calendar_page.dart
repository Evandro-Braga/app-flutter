import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/Calendar.dart';
import 'dart:convert';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

Future<Calendar> getApiData() async {
  String url = 'http://ergast.com/api/f1/current.json';
  final ress = await http.get(Uri.parse(url));
  var data = jsonDecode(ress.body.toString());
  if (ress.statusCode == 200) {
    return Calendar.fromJson(data);
  } else {
    return Calendar.fromJson(data);
  }
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Calendar>(
        future: getApiData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.mRData!.raceTable!.races!.length,
                itemBuilder: (context, index) {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Card(
                          elevation: 0,
                          color: Colors.black12,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 25, vertical: 5),
                                          child: Text(
                                            snapshot.data!.mRData!.raceTable!
                                                .races![index].round
                                                .toString(),
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 26,
                                              fontFamily: 'RacingSansOne',
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              snapshot.data!.mRData!.raceTable!
                                                  .races![index].raceName
                                                  .toString(),
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 18,
                                              ),
                                            ),
                                            Text(
                                              snapshot.data!.mRData!.raceTable!
                                                  .races![index].date
                                                  .toString(),
                                              style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 15,
                                                color: Colors.green,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ]))));
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
