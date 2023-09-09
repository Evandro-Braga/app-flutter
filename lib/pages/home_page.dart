import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/Drivers.dart';
import 'package:flutter_app/pages/calendar_page.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    super.initState();
    pc = PageController(initialPage: paginaAtual);
    getApiData();
  }

  setPaginaAtual(pagina) {
    setState(() {
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: SizedBox(
          width: 90,
          child: Image.asset('assets/logof1.png'),
        ),
      ),
      body: PageView(
        controller: pc,
        onPageChanged: setPaginaAtual,
        children: [
          getList(),
          const CalendarPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        selectedItemColor: Colors.redAccent,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.list), label: 'Classificação'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Calendario')
        ],
        onTap: (pagina) {
          pc.animateToPage(pagina,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear);
        },
      ),
    );
  }

  Future<Drivers> getApiData() async {
    String url = 'http://ergast.com/api/f1/current/driverStandings.json';
    final ress = await http.get(Uri.parse(url));
    var data = jsonDecode(ress.body.toString());
    if (ress.statusCode == 200) {
      return Drivers.fromJson(data);
    } else {
      return Drivers.fromJson(data);
    }
  }

  Widget getList() {
    return FutureBuilder<Drivers>(
        future: getApiData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.mRData!.standingsTable!
                    .standingsLists![0].driverStandings!.length,
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
                                            color: Colors.red,
                                            fontSize: 26,
                                            fontFamily: 'Montserrat',
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
                                                fontFamily: 'Montserrat'),
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
                                                color: Colors.red,
                                                fontFamily: 'Montserrat',
                                                fontSize: 18),
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
                                      "${snapshot.data!.mRData!.standingsTable!.standingsLists![0].driverStandings![index].points} pts",
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 18),
                                    ),
                                  )
                                ],
                              ))));
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
