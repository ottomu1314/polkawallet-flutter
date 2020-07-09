import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/store/app.dart';

class Motions extends StatefulWidget {
  Motions(this.store);

  final AppStore store;

  @override
  _MotionsState createState() => _MotionsState();
}

class _MotionsState extends State<Motions> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Observer(
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            Text('Motions'),
          ],
        );
      },
    );
  }
}
