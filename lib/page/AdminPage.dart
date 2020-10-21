import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moneywheel/domain/AppModel.dart';
import 'package:moneywheel/domain/Codable.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Админ панель")),
      body: FutureBuilder(
        future: AppModel.I.users.once(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          var hashMap = ((snapshot.requireData as DataSnapshot)
              .value as LinkedHashMap);
          var data = Users(hashMap);
          var users = data.toJson();
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, position) => buildItem(users, position),
          );
        },
      ),
    );
  }

  Widget buildItem(Map users, int position) {
    var id = users.keys.elementAt(position);
    final user = User(users[id]);
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.20,
      child: ListTile(
        title: Text(user.name),
        subtitle: Text("${user.email}\n$id"),
        trailing: Switch(
          value: user.isPayed,
          onChanged: (bool value) {
            setState(() {
              AppModel.I.users.child(id).child("isPayed").set(value);
            });
          },
        ),
      ),
      actions: <Widget>[
        SlideAction(
          color: Colors.grey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("room"),
              Switch(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, value: user.room, onChanged: (value) {
                setState(() {
                  AppModel.I.users.child(id).child("room").set(value);
                });
              })
            ],
          ),
        ),

        SlideAction(
          color: Colors.blue,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("site"),
              Switch(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, value: user.site, onChanged: (value) {
                setState(() {
                  AppModel.I.users.child(id).child("site").set(value);
                });
              })
            ],
          ),
        ),

        SlideAction(
          color: Colors.amber,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("vip"),
              Switch(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, value: user.vip, onChanged: (value) {
                setState(() {
                  AppModel.I.users.child(id).child("vip").set(value);
                });
              })
            ],
          ),
        ),
      ],
      secondaryActions: <Widget>[

      ],
    );
  }
}

class User extends Codable {
  User(data) : super(data);

  String get name => get("name") ?? "";
  String get email => get("email") ?? "";
  bool get isPayed => get("isPayed") ?? false;
  bool get room => get("room") ?? false;
  bool get site => get("site") ?? false;
  bool get vip => get("vip") ?? false;

}

class Users extends Codable {
  Users(data) : super(data);
}

