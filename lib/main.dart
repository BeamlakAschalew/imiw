// ignore_for_file: unused_catch_clause

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:imiw/model/fetch.dart';
import 'package:imiw/model/ip_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'styles/style_constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const IMIW());
}

class IMIW extends StatelessWidget {
  const IMIW({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const IMIWHomePage(title: 'Is my internet working?'),
    );
  }
}

class IMIWHomePage extends StatefulWidget {
  const IMIWHomePage({super.key, required this.title});

  final String title;

  @override
  State<IMIWHomePage> createState() => _IMIWHomePageState();
}

class _IMIWHomePageState extends State<IMIWHomePage> {
  bool? isConnectionSuccessful;
  IPModel? ipModel;
  DateTimeRange? ping;
  int interval = 3600;

  Future<void> connectionTest(bool comingFromTap) async {
    int refreshes = 0;

    if (!comingFromTap && interval != 3600) {
      while (refreshes <= 1000) {
        await Future.delayed(Duration(seconds: interval));
        setState(() {
          isConnectionSuccessful = null;
        });
        try {
          DateTime start = DateTime.now();
          final response = await InternetAddress.lookup('google.com');

          setState(() {
            isConnectionSuccessful = response.isNotEmpty;
          });

          DateTime end = DateTime.now();
          ping = DateTimeRange(start: start, end: end);
        } on SocketException catch (e) {
          setState(() {
            isConnectionSuccessful = false;
          });
        }
      }
    } else {
      setState(() {
        isConnectionSuccessful = null;
      });
      try {
        DateTime start = DateTime.now();
        final response = await InternetAddress.lookup('google.com');

        setState(() {
          isConnectionSuccessful = response.isNotEmpty;
        });

        DateTime end = DateTime.now();
        ping = DateTimeRange(start: start, end: end);
      } on SocketException catch (e) {
        setState(() {
          isConnectionSuccessful = false;
        });
      }
    }
  }

  @override
  void initState() {
    connectionTest(false);
    ipDetails().then((value) {
      setState(() {
        ipModel = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('auto-test'),
              const SizedBox(
                width: 15,
              ),
              DropdownButton(
                  value: interval,
                  items: const [
                    DropdownMenuItem(value: 3600, child: Text('Disabled')),
                    DropdownMenuItem(value: 2, child: Text('2 seconds')),
                    DropdownMenuItem(
                      value: 5,
                      child: Text('5 seconds'),
                    ),
                    DropdownMenuItem(
                      value: 10,
                      child: Text('10 seconds'),
                    ),
                    DropdownMenuItem(
                      value: 15,
                      child: Text('15 seconds'),
                    )
                  ],
                  onChanged: (value) {
                    setState(() {
                      interval = value!;
                    });
                    connectionTest(false);
                  })
            ],
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: (() {
                    connectionTest(true);
                  }),
                  child: Text(
                    isConnectionSuccessful == null
                        ? 'MAYBE'
                        : isConnectionSuccessful!
                            ? 'YES!'
                            : 'NO!',
                    style: statusStyle(isConnectionSuccessful),
                  ),
                ),
                Text(
                  isConnectionSuccessful == null
                      ? 'Hold on I\'m checking!'
                      : isConnectionSuccessful!
                          ? 'Your internet is working!'
                          : 'Something is wrong :(',
                  style: statusMessageStyle,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Your IP address:',
                  style: mediumFontSize,
                ),
                Text(
                  ipModel?.ip ?? '-',
                  style: mediumFontSize,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Estimated location:',
                  style: mediumFontSize,
                ),
                Text(
                  ipModel == null
                      ? '-'
                      : '${ipModel?.countryName!}, ${ipModel?.cityName} (Latitude: ${ipModel!.latitude}, Longitude: ${ipModel!.longitude})',
                  style: mediumFontSize,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Ping: ',
                  style: mediumFontSize,
                ),
                Text(ping == null
                    ? '0 ms'
                    : '${ping?.duration.inMilliseconds.toString()} ms')
              ],
            ),
          ),
          Column(
            children: [
              const Text('Made with ❤ By Beamlak Aschalew'),
              GestureDetector(
                  onTap: () {
                    launchUrl(
                        Uri.parse('https://github.com/BeamlakAschalew/imiw'));
                  },
                  child: const Text('github.com/BeamlakAschalew/imiw'))
            ],
          ),
        ],
      ),
    );
  }
}
