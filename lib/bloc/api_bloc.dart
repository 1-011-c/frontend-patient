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
    }
    else if (event is RequestCompleteEvent) {
      yield APIWaiting();
    }
    else if (event is UpdateAPIEvent) {
        print('Update Event is triggered');
        yield APILoading();

        final List<Future<CoronaResponse>> futures = [];

        event.testCases.forEach((testCase) {
          print('URL FOR: ${testCase.url}');
          futures.add(APIService.get(testCase.url));
        });

        final List<CoronaResponse> responses = await Future.wait(futures);
        bool error = false;
        for(final CoronaResponse response in responses) {
          if(response.coronaTestCase != null) {
            if(!await StorageService.storeOrUpdate(response.coronaTestCase)) {
              error = true;
            }
          }
          else {
            print('ERROR 2');
            error = true;
          }
        }

        if(error) {
          print('ERROR');
          yield APIError(message: 'ERROR');
        }
        else {
          print('KEIN ERROR');
          var res = responses.map((o) {
            return o.coronaTestCase;
          }).toList();
          print('RES: $res');
          yield APILoadedMultiple(responses: res);
          print('YIELD');
          event.context.bloc<StorageBloc>().add(GetAllStorageEvent());
          print('UPDATED');
        }
    }
  }

  @override
  APIState get initialState => APIWaiting();

}