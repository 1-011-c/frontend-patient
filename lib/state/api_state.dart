import 'package:equatable/equatable.dart';

abstract class APIState extends Equatable {

  @override
  List<Object> get props => [];

}

/// User will scan barcode
class APIWaiting extends APIState {}

/// Send barcode data to server
class APILoading extends APIState {}

/// The barcode was successfully sent to the server
class APILoaded extends APIState {}

/// There was an error while sending data to server
class APIError extends APIState {}