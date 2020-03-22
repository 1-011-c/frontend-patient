import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_patient/event/api_event.dart';
import 'package:frontend_patient/model/corona_response.dart';
import 'package:frontend_patient/service/api_service.dart';
import 'package:frontend_patient/state/api_state.dart';

class APIBloc extends Bloc<APIEvent, APIState> {

  static const API_ERROR_TIME = 2;

  @override
  Stream<APIState> mapEventToState(APIEvent event) async* {
    if (event is GetAPIEvent) {
      yield APILoading();

      final CoronaResponse apiResult = await APIService.get(event.url);

      if (apiResult.coronaTestCase != null) {
        yield APILoaded();
      }
      else {
        yield APIError();
      }
    } else if (event is RequestCompleteEvent) {
      yield APIWaiting();
    }
  }

  @override
  APIState get initialState => APIWaiting();

}