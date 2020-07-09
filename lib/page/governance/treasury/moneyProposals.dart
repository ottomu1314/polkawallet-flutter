import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/common/components/BorderedTitle.dart';
import 'package:polka_wallet/common/components/infoItem.dart';
import 'package:polka_wallet/common/components/roundedCard.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class MoneyProposals extends StatefulWidget {
  MoneyProposals(this.store);

  final AppStore store;

  @override
  _ProposalsState createState() => _ProposalsState();
}

class _ProposalsState extends State<MoneyProposals> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Map dic = I18n.of(context).gov;
    return Observer(
      builder: (BuildContext context) {
        return ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            RoundedCard(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 24),
              child: Row(
                children: <Widget>[
                  InfoItem(
                    title: 'xxx',
                    content: 'xx',
                  ),
                  InfoItem(
                    title: 'xxx',
                    content: 'xx',
                  ),
                  InfoItem(
                    title: 'xxx',
                    content: 'xx',
                  ),
                ],
              ),
            ),
            BorderedTitle(title: dic['treasury.proposal']),
            Text('MoneyProposals'),
            BorderedTitle(title: 'agreed'),
          ],
        );
      },
    );
  }
}
