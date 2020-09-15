import 'package:moneywheel/domain/Codable.dart';

class SavedData extends Codable {
  SavedData(data) : super(data);

  bool get room => get("room");
       set room(bool room) => put("room", room);
  bool get site => get("site");
       set site(bool site) => put("site", site);
  bool get vip => get("vip");
       set vip(bool vip) => put("vip", vip);
  String get uid => get("uid");
         set uid(String uid) => put("uid", uid);
}