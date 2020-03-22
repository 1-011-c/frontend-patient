import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

abstract class APIEvent extends Equatable {
  const APIEvent();

  @override
  List<Object> get props => [];
}

class GetAPIEvent extends APIEvent {
  final BuildContext context;
  final String url;

  const GetAPIEvent({@required this.url, @required this.context});
}

class RequestCompleteEvent extends APIEvent {}
