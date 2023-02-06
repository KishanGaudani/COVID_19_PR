// Screen isn;t used yet idk
// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CoronaGlobal extends StatefulWidget {
  @override
  _CoronaGlobalState createState() => _CoronaGlobalState();
}

class _CoronaGlobalState extends State<CoronaGlobal> {
  Future getGlobalData() async {
    var url = 'https://thevirustracker.com/free-api?global=stats';
    http.Response response = await http.get(Uri.parse(url));

    var data = jsonDecode(response.body);

    if (kDebugMode) {
      print(data["results"][0]);
    }
    return data;
  }

  @override
  void initState() {
    super.initState();
    getGlobalData();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    double screenwidth = queryData.size.width;
    double screenheight = queryData.size.height;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 18, 18, 0.8),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(18, 18, 18, 0.8),
        elevation: 0,
        title: const Text("CovidMate"),
        centerTitle: true,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.fromLTRB(22, 15, 0, 8),
                    color: const Color.fromRGBO(18, 18, 18, 1),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(22, 15, 13, 15),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      width: screenwidth / 1.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FutureBuilder(
                            future: getGlobalData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Center(
                                      child: Text(
                                        "Global",
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            snapshot.data["results"][0]
                                                    ["total_serious_cases"]
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 25),
                                          ),
                                        ),
                                        SizedBox(
                                          height: screenheight / 220,
                                        ),
                                        const Text(
                                          "Serious Cases",
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  255, 255, 255, 0.5),
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                throw snapshot.error!;
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.fromLTRB(15, 15, 7.5, 15),
                    color: const Color.fromRGBO(18, 18, 18, 1),
                    child: Container(
                      height: screenheight / 8,
                      width: screenwidth / 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FutureBuilder(
                                future: getGlobalData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Container(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              snapshot.data["results"][0]
                                                      ["total_cases"]
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 25),
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenheight / 220,
                                          ),
                                          const Text(
                                            "Infected",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.5),
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    throw snapshot.error!;
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.fromLTRB(7.5, 15, 15, 15),
                    color: const Color.fromRGBO(18, 18, 18, 1),
                    child: Container(
                      height: screenheight / 8,
                      width: screenwidth / 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FutureBuilder(
                                future: getGlobalData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Container(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              snapshot.data["results"][0]
                                                      ["total_new_cases_today"]
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 25),
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenheight / 220,
                                          ),
                                          const Text(
                                            "New Cases Today",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.5),
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    throw snapshot.error!;
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.fromLTRB(15, 15, 7.5, 15),
                    color: const Color.fromRGBO(18, 18, 18, 1),
                    child: Container(
                      height: screenheight / 8,
                      width: screenwidth / 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FutureBuilder(
                                future: getGlobalData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Container(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              snapshot.data["results"][0]
                                                      ["total_deaths"]
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 25),
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenheight / 220,
                                          ),
                                          const Text(
                                            "Deaths",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.5),
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    throw snapshot.error!;
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.fromLTRB(7.5, 15, 15, 15),
                    color: const Color.fromRGBO(18, 18, 18, 1),
                    child: Container(
                      height: screenheight / 8,
                      width: screenwidth / 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FutureBuilder(
                                future: getGlobalData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Container(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "+${snapshot.data["results"][0]["total_new_deaths_today"]}",
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 25),
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenheight / 220,
                                          ),
                                          const Text(
                                            "Deaths Today",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.5),
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    throw snapshot.error!;
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                    color: const Color.fromRGBO(18, 18, 18, 1),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 13, 0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      height: screenheight / 8,
                      width: screenwidth / 1.25,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: ListView(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FutureBuilder(
                                future: getGlobalData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Container(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              snapshot.data["results"][0]
                                                      ["total_recovered"]
                                                  .toString(),
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 25),
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenheight / 220,
                                          ),
                                          const Text(
                                            "Recovered",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    255, 255, 255, 0.5),
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    throw snapshot.error!;
                                  } else {
                                    return const Center(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
