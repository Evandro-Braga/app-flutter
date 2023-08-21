import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Drivers.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  void initState() {
    super.initState();
    getApiData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('',
              style: TextStyle(
                color: Colors.red,
                fontSize: 32,
                fontStyle: FontStyle.italic,
              )),
          backgroundColor: Colors.blueGrey[900],
        ),
        body: Column(
          children: [getList()],
        ));
  }

  Future<drivers> getApiData() async {
    String url = 'http://ergast.com/api/f1/current/driverStandings.json';
    final ress = await http.get(Uri.parse(url));
    var data = jsonDecode(ress.body.toString());
    if (ress.statusCode == 200) {
      return drivers.fromJson(data);
    } else {
      return drivers.fromJson(data);
    }
  }

  Widget getList() {
    return Expanded(
        child: FutureBuilder<drivers>(
            future: getApiData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data?.mRData!.standingsTable!
                        .standingsLists![0].driverStandings!.length,
                    itemBuilder: (context, index) {
                      return Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
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
                                                horizontal: 10, vertical: 5),
                                            child: Text(
                                              snapshot
                                                  .data!
                                                  .mRData!
                                                  .standingsTable!
                                                  .standingsLists![0]
                                                  .driverStandings![index]
                                                  .position
                                                  .toString(),
                                              style: const TextStyle(
                                                color: Colors.teal,
                                                fontSize: 36,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Image.asset(
                                                'assets/${snapshot.data!.mRData!.standingsTable!.standingsLists![0].driverStandings![index].driver!.givenName}.png'),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                snapshot
                                                    .data!
                                                    .mRData!
                                                    .standingsTable!
                                                    .standingsLists![0]
                                                    .driverStandings![index]
                                                    .driver!
                                                    .givenName
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              Text(
                                                snapshot
                                                    .data!
                                                    .mRData!
                                                    .standingsTable!
                                                    .standingsLists![0]
                                                    .driverStandings![index]
                                                    .driver!
                                                    .familyName
                                                    .toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        child: Text(
                                          snapshot
                                              .data!
                                              .mRData!
                                              .standingsTable!
                                              .standingsLists![0]
                                              .driverStandings![index]
                                              .points
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 22),
                                        ),
                                      )
                                    ],
                                  ))));
                    });
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }
}
