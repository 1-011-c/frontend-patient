import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_patient/event/storage_event.dart';
import 'package:frontend_patient/model/corona_test_case.dart';
import 'package:frontend_patient/service/storage_service.dart';
import 'package:frontend_patient/state/storage_state.dart';
class StorageBloc extends Bloc<StorageEvent, StorageState> {

  @override
  Stream<StorageState> mapEventToState(StorageEvent event) async* {
    if (event is GetAllStorageEvent) {
      yield StorageFetching();

      final List<CoronaTestCase> testCases = StorageService.getAll();

      yield StorageFetched(testCases: testCases);
    }

    if (event is UpdateNicknameStorageEvent) {
      yield StorageUpdating();

      StorageService.storeOrUpdate(event.nickname, event.testCase);

      yield StorageUpdated();
    }
  }

  @override
  StorageState get initialState => StorageInit();

}