import 'package:equatable/equatable.dart';
import 'package:frontend_patient/model/corona_test_case.dart';
import 'package:meta/meta.dart';

abstract class StorageEvent extends Equatable {
  const StorageEvent();

  @override
  List<Object> get props => [];
}

class GetAllStorageEvent extends StorageEvent {}

class UpdateNicknameStorageEvent extends StorageEvent {
  final CoronaTestCase testCase;
  final String nickname;

  const UpdateNicknameStorageEvent({@required this.testCase, @required this.nickname});
}