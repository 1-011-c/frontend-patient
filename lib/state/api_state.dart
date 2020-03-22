import 'package:equatable/equatable.dart';
import 'package:frontend_patient/model/corona_test_case.dart';
import 'package:meta/meta.dart';

abstract class APIState extends Equatable {
  const APIState();

  @override
  List<Object> get props => [];
}

/// User will scan barcode
class APIWaiting extends APIState {}

/// Send barcode data to server
class APILoading extends APIState {}

/// The barcode was successfully sent to the server
class APILoaded extends APIState {
  final CoronaTestCase response;

  const APILoaded({@required this.response});
}

/// The barcode was successfully sent to the server
class APILoadedMultiple extends APIState {
  final List<CoronaTestCase> responses;

  const APILoadedMultiple({@required this.responses});
}

/// There was an error while sending data to server
class APIError extends APIState {
  final String message;

  const APIError({
    @required this.message
  });
}