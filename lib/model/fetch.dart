import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '/model/ip_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/constants/api_constants.dart';

Future<IPModel> ipDetails() async {
  IPModel? ipModel;

  var response = await retryOptions.retry(
    () => http
        .get(Uri.parse('${ipAPI}key=${dotenv.env['IP_TO_LOCATION_API_KEY']}'))
        .timeout(timeOut),
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );
  var responseDecode = jsonDecode(response.body);
  ipModel = IPModel.fromJson(responseDecode);

  return ipModel;
}
