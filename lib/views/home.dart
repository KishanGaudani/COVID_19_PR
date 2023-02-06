// ignore_for_file: import_of_legacy_library_into_null_safe, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, avoid_unnecessary_containers

import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_country_picker/flutter_country_picker.dart';

class Corona extends StatefulWidget {
  const Corona({super.key});

  @override
  _CoronaState createState() => _CoronaState();
}

class _CoronaState extends State<Corona> {
  Country? selected;
  Future getData(iso) async {
    var url = 'https://thevirustracker.com/free-api?countryTotal=$iso';
    http.Response response = await http.get(Uri.parse(url));

    var data = jsonDecode(response.body);

    return data;
  }

  Future getGlobalData() async {
    var url = 'https://thevirustracker.com/free-api?global=stats';
    http.Response response = await http.get(Uri.parse(url));

    var data = jsonDecode(response.body);

    if (kDebugMode) {
      print(data["results"][0]);
    }
    return data;
  }

  Future gettimelineData(iso) async {
    var url = 'https://thevirustracker.com/free-api?countryTimeline=$iso';
    http.Response timelineresponse = await http.get(Uri.parse(url));

    var timelinedata = jsonDecode(timelineresponse.body);

    Map total = {
      "new_daily_cases": 0,
      "new_daily_deaths": 0,
      "total_cases": 0,
      "total_recoveries": 0,
      "total_deaths": 0
    };
    Map days = timelinedata["timelineitems"][0];

    var _dayList = days.keys;
    List<double> newcaseslist = [];
    List<double> newdeathslist = [];
    List<double> totalcaseslist = [];
    List<double> totaldeathslist = [];
    List<double> totalrecoverylist = [];
    for (var day in _dayList) {
      total['new_daily_cases'] += days[day]['new_daily_cases'];
      total['new_daily_deaths'] += days[day]['new_daily_deaths'];
      total['total_cases'] += days[day]['total_cases'];
      total['total_recoveries'] += days[day]['total_recoveries'];
      total['total_deaths'] += days[day]['new_daily_deaths'];
      totalcaseslist.add((days[day]["total_cases"]) / 1.0);
      totaldeathslist.add((days[day]["total_deaths"]) / 1.0);
      totalrecoverylist.add((days[day]["total_recoveries"]) / 1.0);
      newcaseslist.add((days[day]["new_daily_cases"]) / 1.0);
      newdeathslist.add((days[day]["new_daily_deaths"]) / 1.0);
    }
    return [
      totalcaseslist,
      totaldeathslist,
      totalrecoverylist,
      newcaseslist,
      newdeathslist
    ];
  }

  _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showDialog('No internet', "You're not connected to a network");
    }
  }

  _showDialog(title, text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(text),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getData("US");
    gettimelineData("US");
    getGlobalData();
    _checkInternetConnectivity();
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
        actions: <Widget>[
          CountryPicker(
            showName: false,
            showDialingCode: false,
            onChanged: (Country country) {
              setState(() {
                selected = country;
                getData(selected?.isoCode);
                gettimelineData(selected?.isoCode);
                _checkInternetConnectivity();
              });
            },
            selectedCountry: selected,
          ),
        ],
        title: const Text("CovidMate"),
        centerTitle: true,
      ),
      body: ListView(
        physics: const ClampingScrollPhysics(),
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
                            future: getData(
                                selected == null ? "US" : selected?.isoCode),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (kDebugMode) {
                                  print(snapshot.data.toString());
                                }
                                return Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          snapshot.data["countrydata"][0]
                                              ["info"]["title"],
                                          style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              snapshot.data["countrydata"][0]
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
                                          Container(
                                            child: const Text(
                                              "Serious Cases",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5),
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
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
                      height: screenheight / 4.3,
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
                                future: getData(selected == null
                                    ? "US"
                                    : selected?.isoCode),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (kDebugMode) {
                                      print(snapshot.data.toString());
                                    }
                                    return Container(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              snapshot.data["countrydata"][0]
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
                                          Container(
                                            child: const Text(
                                              "Infected",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5),
                                                  fontSize: 15),
                                            ),
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
                              FutureBuilder(
                                future: gettimelineData(selected == null
                                    ? "US"
                                    : selected?.isoCode),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (kDebugMode) {
                                      print(snapshot.data[0]);
                                    }
                                    return Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Sparkline(
                                        data: snapshot.data[0],
                                        lineColor: Colors.blue[900],
                                        fillMode: FillMode.below,
                                        fillColor: Colors.blue[400],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Container(
                                        margin: const EdgeInsets.all(15),
                                        child: const Text(
                                          "Loading Graph",
                                          style: TextStyle(color: Colors.white),
                                        ),
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
                      height: screenheight / 4.3,
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
                                future: getData(selected == null
                                    ? "US"
                                    : selected?.isoCode),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (kDebugMode) {
                                      print(snapshot.data.toString());
                                    }
                                    return Container(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "+${snapshot.data["countrydata"][0]["total_new_cases_today"]}",
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 25),
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenheight / 220,
                                          ),
                                          Container(
                                            child: const Text(
                                              "New Cases Today",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5),
                                                  fontSize: 15),
                                            ),
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
                              FutureBuilder(
                                future: gettimelineData(selected == null
                                    ? "US"
                                    : selected?.isoCode),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (kDebugMode) {
                                      print(snapshot.data[0]);
                                    }
                                    return Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Sparkline(
                                        data: snapshot.data[3],
                                        lineColor: Colors.blue[900],
                                        fillMode: FillMode.below,
                                        fillColor: Colors.blue[400],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Container(
                                        margin: const EdgeInsets.all(15),
                                        child: const Text(
                                          "Loading Graph",
                                          style: TextStyle(color: Colors.white),
                                        ),
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
                      height: screenheight / 4.3,
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
                                future: getData(selected == null
                                    ? "US"
                                    : selected?.isoCode),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (kDebugMode) {
                                      print(snapshot.data.toString());
                                    }
                                    return Container(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              snapshot.data["countrydata"][0]
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
                                          Container(
                                            child: const Text(
                                              "Deaths",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5),
                                                  fontSize: 15),
                                            ),
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
                              FutureBuilder(
                                future: gettimelineData(selected == null
                                    ? "US"
                                    : selected?.isoCode),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (kDebugMode) {
                                      print(snapshot.data[0]);
                                    }
                                    return Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Sparkline(
                                        data: snapshot.data[1],
                                        lineColor: Colors.red[900],
                                        fillMode: FillMode.below,
                                        fillColor: Colors.red[400],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Container(
                                        margin: const EdgeInsets.all(15),
                                        child: const Text(
                                          "Loading Graph",
                                          style: TextStyle(color: Colors.white),
                                        ),
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
                      height: screenheight / 4.3,
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
                                future: getData(selected == null
                                    ? "US"
                                    : selected?.isoCode),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (kDebugMode) {
                                      print(snapshot.data.toString());
                                    }
                                    return Container(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              "+${snapshot.data["countrydata"][0]["total_new_deaths_today"]}",
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 25),
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenheight / 220,
                                          ),
                                          Container(
                                            child: const Text(
                                              "Deaths Today",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5),
                                                  fontSize: 15),
                                            ),
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
                              FutureBuilder(
                                future: gettimelineData(selected == null
                                    ? "US"
                                    : selected?.isoCode),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (kDebugMode) {
                                      print(snapshot.data[0]);
                                    }
                                    return Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Sparkline(
                                        data: snapshot.data[4],
                                        lineColor: Colors.red[900],
                                        fillMode: FillMode.below,
                                        fillColor: Colors.red[400],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Container(
                                        margin: const EdgeInsets.all(15),
                                        child: const Text(
                                          "Loading Graph",
                                          style: TextStyle(color: Colors.white),
                                        ),
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
                    margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    color: const Color.fromRGBO(18, 18, 18, 1),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(18, 0, 13, 0),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      height: screenheight / 4.3,
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
                                future: getData(selected == null
                                    ? "US"
                                    : selected?.isoCode),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (kDebugMode) {
                                      print(snapshot.data.toString());
                                    }
                                    return Container(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Text(
                                              snapshot.data["countrydata"][0]
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
                                          Container(
                                            child: const Text(
                                              "Recovered",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5),
                                                  fontSize: 15),
                                            ),
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
                              FutureBuilder(
                                future: gettimelineData(selected == null
                                    ? "US"
                                    : selected?.isoCode),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (kDebugMode) {
                                      print(snapshot.data[2]);
                                    }
                                    return Container(
                                      padding: const EdgeInsets.all(15),
                                      child: Sparkline(
                                        data: snapshot.data[0],
                                        lineColor: Colors.green[900],
                                        fillMode: FillMode.below,
                                        fillColor: Colors.green[400],
                                      ),
                                    );
                                  } else {
                                    return Center(
                                      child: Container(
                                        margin: const EdgeInsets.all(15),
                                        child: const Text(
                                          "Loading Graph",
                                          style: TextStyle(color: Colors.white),
                                        ),
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
                                return Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Center(
                                        child: Text(
                                          "Global",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
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
                                          Container(
                                            child: const Text(
                                              "Serious Cases",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5),
                                                  fontSize: 15),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
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
                                      padding: const EdgeInsets.only(top: 25),
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
                                          Container(
                                            child: const Text(
                                              "Infected Worldwide",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5),
                                                  fontSize: 15),
                                            ),
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
                                      padding: const EdgeInsets.only(top: 25),
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
                                      padding: const EdgeInsets.only(top: 25),
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
                                          Container(
                                            child: const Text(
                                              "Deaths Worldwide",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5),
                                                  fontSize: 15),
                                            ),
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
                                      padding: const EdgeInsets.only(top: 25),
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
                                          Container(
                                            child: const Text(
                                              "Deaths Today",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5),
                                                  fontSize: 15),
                                            ),
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
                    margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                    color: const Color.fromRGBO(18, 18, 18, 1),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 13, 0),
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
                                          Container(
                                            child: const Text(
                                              "Recovered Worldwide",
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.5),
                                                  fontSize: 15),
                                            ),
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
