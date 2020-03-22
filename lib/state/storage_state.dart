import 'package:equatable/equatable.dart';
import 'package:frontend_patient/model/corona_test_case.dart';
import 'package:meta/meta.dart';

abstract class StorageState extends Equatable {
  const StorageState();

  @override
  List<Object> get props => [];

}

class StorageInit extends StorageState {}

class StorageUpdating extends StorageState {}

class StorageUpdated extends StorageState {}

class StorageFetching extends StorageState {}

class StorageFetched extends StorageState {
  final List<CoronaTestCase> testCases;

  const StorageFetched({@required this.testCases});
}