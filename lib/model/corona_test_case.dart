import 'package:flutter/cupertino.dart';

enum CoronaStatus {
  NOT_TESTED,
  IN_PROGRESS,
  POSITIVE,
  NEGATIVE
}

CoronaStatus getCoronaStatusFromString(String status) {
  status = 'CoronaStatus.$status';
  return CoronaStatus.values.firstWhere((f)=> f.toString() == status, orElse: () => null);
}

class CoronaTestCase {
  String nickname;
  final CoronaStatus infected;
  final String date;
  String url;

  CoronaTestCase({
    @required this.nickname,
    @required this.infected,
    @required this.date,
    @required this.url
  });

  factory CoronaTestCase.fromJson(Map<String, dynamic> json) {
    return new CoronaTestCase(
        nickname: json['nickname'] ?? "Test",
        url: json["url"] ?? "",
        infected: getCoronaStatusFromString(json["infected"]),
        date: json["date"]
    );
  }

  Map<String, dynamic> toJson() => {
    "nickname": this.nickname,
    "infected": this.infected.toString().split(".").last,
    "date": this.date,
    "url": this.url
  };
}