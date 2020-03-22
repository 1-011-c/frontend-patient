import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class APIEvent extends Equatable {
  const APIEvent();

  @override
  List<Object> get props => [];
}

class GetAPIEvent extends APIEvent {
  final String url;

  const GetAPIEvent({@required this.url});
}

class RequestCompleteEvent extends APIEvent {}
