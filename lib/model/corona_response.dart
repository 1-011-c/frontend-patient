import 'package:flutter/cupertino.dart';

import 'corona_test_case.dart';

/// This is a response that will be
class CoronaResponse {

  final String errorMessage;
  final CoronaTestCase coronaTestCase;

  CoronaResponse({
    this.errorMessage = '',
    @required this.coronaTestCase
  });

}