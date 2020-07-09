import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/store/app.dart';

class MoneyTips extends StatefulWidget {
  MoneyTips(this.store);

  final AppStore store;

  @override
  _ProposalsState createState() => _ProposalsState();
}

class _ProposalsState extends State<MoneyTips> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Observer(
      builder: (BuildContext context) {
        return ListView(
          children: <Widget>[
            Text('MoneyTips'),
          ],
        );
      },
    );
  }
}
