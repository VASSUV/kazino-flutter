
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moneywheel/domain/Progressives.dart';
import 'package:moneywheel/domain/Settings.dart';
import 'package:path_provider/path_provider.dart';

enum LoadState {
  LOAD, ERROR, NOTHING
}

class AppModel {
  static AppModel _instance;


  static AppModel get I => AppModel();

  AppModel._();

  var connected = false;
  final loading = ValueNotifier(LoadState.LOAD);
  final admin = ValueNotifier(false);

  final site = ValueNotifier(false);
  final vip = ValueNotifier(false);
  final room = ValueNotifier(false);

  final availableTypes = ValueNotifier<List<ProgressionType>>([ProgressionType.DEFAULT]);

  factory AppModel() {
    if(_instance == null) {
      _instance = AppModel._();
      _instance.init();
      return _instance;
    }
    return _instance;
  }
  FirebaseApp app;

  User firebaseUser;
  DatabaseReference databaseReference;
  DatabaseReference get users => databaseReference.child("users");
  DatabaseReference get userReference => users.child(firebaseUser.uid);

  void init() {
    Future.delayed(Duration(seconds: 1), () async {
      try {
        loading.value = LoadState.LOAD;
        if(app == null) {
          app = await Firebase.initializeApp(
              name: "manywheel-dd0f8", options: FirebaseOptions.fromMap({
            "apiKey": "AIzaSyCgQSSvilDK81dFZMF6i-0w0rcyP4VZ3uU",
            "appId": "1:487051704352:android:0cecbeae6fdcec40ef2445",
            "projectId": "manywheel-dd0f8",
            "messagingSenderId": "487051704352",
            "databaseURL": "https://manywheel-dd0f8.firebaseio.com"
          }));
        }
        await firebaseOfflineAuth();

        GoogleSignIn _googleSignIn = GoogleSignIn();
        final result = await _googleSignIn.signIn();
        final googleUser = await result.authentication;

        final authResult =  await FirebaseAuth.instanceFor(app: app).signInWithCredential(
           GoogleAuthProvider.credential(idToken: googleUser.idToken, accessToken: googleUser.idToken)
        );
        if(authResult != null) {
          firebaseUser = authResult.user;
          final database = FirebaseDatabase(app: app);
          database.setPersistenceEnabled(true);
          databaseReference = database.reference();
          var uid = users.child(authResult.user.uid);

          await uid.child("email").set(authResult.user.email);
          await uid.child("name").set(authResult.user.displayName);

          connected = (await uid.child("isPayed").once()).value ?? false;
          uid.child("isPayed").onValue.listen((event) async {
            var value = event.snapshot.value;
            connected = value ?? false;
            writeUid(getSavedData());
            if(connected) {
              loading.value = LoadState.NOTHING;
            } else {
              loading.value = LoadState.LOAD;
            }
          });
          uid.child("room").onValue.listen((event) {
            room.value = event.snapshot.value ?? false;
            checkAvailable();
          });
          uid.child("site").onValue.listen((event) {
            site.value = event.snapshot.value ?? false;
            checkAvailable();
          });
          uid.child("vip").onValue.listen((event) {
            vip.value = event.snapshot.value ?? false;
            checkAvailable();
          });
          uid.child("admin").onValue.listen((event) {
            admin.value = event.snapshot.value ?? false;
          });
        }
      } catch (error) {
        print(error);
        if(!connected) loading.value = LoadState.ERROR;
      }
    });
  }

  void checkAvailable() {
    availableTypes.value = [
      if(room.value) ProgressionType.DEFAULT,
      if(site.value) ProgressionType.SITE,
      if(vip.value) ProgressionType.VIP,
    ];
    if(availableTypes.value.length == 0) availableTypes.value.add(ProgressionType.DEFAULT);
    if(!availableTypes.value.contains(Settings().progressionType)) {
      Settings().progressionType = availableTypes.value.first ?? ProgressionType.DEFAULT;
    }
    writeUid(getSavedData());
  }

  Future<String> get _path async => (await getApplicationSupportDirectory()).path;

  Future<File> get _localFile async => File('${await _path}/settings.txt');

  Future<File> writeUid(SavedData data) async => (await _localFile).writeAsString(jsonEncode(data.toJson()));

  Future<SavedData> readUid() async {
    try {
      final file = await _localFile;
      var data = await file.readAsString();
      var jsonDecodeValue = jsonDecode(data);
      return SavedData(jsonDecodeValue);
    } catch (e) {
      return SavedData(Map());
    }
  }

  Future<void> firebaseOfflineAuth() async {
    final user = FirebaseAuth.instanceFor(app: app).currentUser;
    if(user != null) {
      firebaseUser = user;

      final data = await readUid();

      connected = data.uid == user.uid;
      room.value = data.room ?? false;
      site.value = data.site ?? false;
      vip.value = data.vip ?? false;
      checkAvailable();
      if(connected) {
        loading.value = LoadState.NOTHING;
      } else {
        loading.value = LoadState.LOAD;
      }
    }
  }

  SavedData getSavedData() {
    return SavedData(Map())
        ..room = room.value
        ..site = site.value
        ..vip = vip.value
        ..uid = connected == true ? firebaseUser.uid : "";
  }
}
