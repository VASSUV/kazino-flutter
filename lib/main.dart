import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneywheel/domain/AppModel.dart';
import 'package:moneywheel/page/MainPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Money Wheel',
      home: ValueListenableBuilder(
        valueListenable: AppModel.I.loading,
        builder: (context, value, child) {
          return Stack(
            children: [
              MainPage(),
              if(value == LoadState.LOAD) Loader()
              else if(value == LoadState.ERROR) PlaceHolder()
            ],
          );
        }
      ),
    );
  }
}

class PlaceHolder extends StatefulWidget {
  @override
  _PlaceHolderState createState() => _PlaceHolderState();
}

class _PlaceHolderState extends State<PlaceHolder> {
  @override
  Widget build(BuildContext context) => Container(
    alignment: AlignmentDirectional.center,
    decoration: BoxDecoration(color: Colors.white70),
    child: MaterialButton(
      onPressed: () {
        AppModel.I.init();
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            borderRadius: BorderRadius.circular(10.0)
        ),
        width: 120.0,
        height: 52.0,
        alignment: AlignmentDirectional.center,
        child: Text("Повторить"),
      ),
    ),
  );
}

class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return Container( 
      alignment: AlignmentDirectional.center,
      decoration: BoxDecoration(color: Colors.white70),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            borderRadius: BorderRadius.circular(10.0)
        ),
        width: 300.0,
        height: 200.0,
        alignment: AlignmentDirectional.center,
        child: Material(
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator(
                    value: null,
                    strokeWidth: 7.0,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 25.0),
                child: Center(
                  child: Text(
                    "Подключение, ждите...",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
