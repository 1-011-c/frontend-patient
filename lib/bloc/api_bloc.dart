import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_patient/bloc/storage_bloc.dart';
import 'package:frontend_patient/event/api_event.dart';
import 'package:frontend_patient/event/storage_event.dart';
import 'package:frontend_patient/model/corona_response.dart';
import 'package:frontend_patient/service/api_service.dart';
import 'package:frontend_patient/service/storage_service.dart';
import 'package:frontend_patient/state/api_state.dart';

class APIBloc extends Bloc<APIEvent, APIState> {
  @override
  Stream<APIState> mapEventToState(APIEvent event) async* {
    print('Entering APIBloc');
    if (event is GetAPIEvent) {
      print('Loading');
      yield APILoading();

      final CoronaResponse apiResponse = await APIService.get(event.url);
      
      if (apiResponse.coronaTestCase != null) {
        print('GOTCHA');
        if(await StorageService.storeOrUpdate(apiResponse.coronaTestCase)) {
          yield APILoaded(response: apiResponse.coronaTestCase);
          event.context.bloc<StorageBloc>().add(GetAllStorageEvent());
        }
        else {
          yield APIError(message: 'Could not store test-case');
        }
      }
      else {
        yield APIError(message: apiResponse.errorMessage);
      }
    } else if (event is RequestCompleteEvent) {
      yield APIWaiting();
    }
  }

  @override
  APIState get initialState => APIWaiting();

}