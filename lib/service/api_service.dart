import 'package:dio/dio.dart';
import 'package:frontend_patient/model/corona_response.dart';
import 'package:frontend_patient/model/corona_test_case.dart';

class APIService {
  static const API_BASE_URL = 'https://blffmaku9b.execute-api.eu-central-1.amazonaws.com/Prod';

  /// Used to test if data in barcode is valid
  static const API_BASE_PATH = "/corona-test-case";
  static const API_TIMEOUT = 3000;
  static Dio dio = new Dio(BaseOptions(connectTimeout: API_TIMEOUT));

  static Future<CoronaResponse> get(final String url) async {
    print('Try to fetch from QR code');
    if (!url.startsWith(API_BASE_PATH))
      return CoronaResponse(
          coronaTestCase: null,
          errorMessage: 'QR Code ist ungültig. Eventuell haben Sie einen falschen eingescannt.'
      );

    print('URL: $API_BASE_URL$url');

    final Response response = await dio.get('$API_BASE_URL$url');

    print('response: $response');

    if (response.statusCode != 200)
      return CoronaResponse(
          coronaTestCase: null,
          errorMessage: 'Code konnte nicht verarbeitet werden.'
      );

    final testCase = CoronaTestCase.fromJson(response.data);
    testCase.url = url;
    print('Testcase: ${testCase.toJson()}');
    return CoronaResponse(
        coronaTestCase: testCase
    );
  }
}