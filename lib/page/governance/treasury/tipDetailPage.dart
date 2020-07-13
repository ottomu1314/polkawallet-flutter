import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/common/components/BorderedTitle.dart';
import 'package:polka_wallet/common/components/addressIcon.dart';
import 'package:polka_wallet/common/components/roundedButton.dart';
import 'package:polka_wallet/common/components/roundedCard.dart';
import 'package:polka_wallet/page/account/txConfirmPage.dart';
import 'package:polka_wallet/store/account/types/accountData.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/store/gov/types/treasuryTipData.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class TipDetailPage extends StatefulWidget {
  TipDetailPage(this.store);

  static const String route = '/gov/treasury/tip';

  final AppStore store;

  @override
  _TipDetailPageState createState() => _TipDetailPageState();
}

class _TipDetailPageState extends State<TipDetailPage> {
  final TextEditingController _tipInputCtrl = TextEditingController();

  String _errorMsg;

  Future<void> _onEndorse() async {
    print('click');
    final String symbol = widget.store.settings.networkState.tokenSymbol;
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        final Map<String, String> dic = I18n.of(context).home;
        return CupertinoAlertDialog(
          title: Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(I18n.of(context).gov['treasury.tip']),
          ),
          content: Column(
            children: <Widget>[
              CupertinoTextField(
                controller: _tipInputCtrl,
                suffix: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text(symbol),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              Text(_errorMsg ?? '', style: TextStyle(color: Colors.red))
            ],
          ),
          actions: <Widget>[
            CupertinoButton(
              child: Text(dic['cancel']),
              onPressed: () {
                setState(() {
                  _tipInputCtrl.text = '';
                });
                Navigator.of(context).pop();
              },
            ),
            CupertinoButton(
              child: Text(dic['ok']),
              onPressed: () {
                if (_tipInputCtrl.text.isNotEmpty &&
                    double.parse(_tipInputCtrl.text) > 0) {
                  setState(() {
                    _errorMsg = null;
                  });
                  Navigator.of(context).pop();
                  _onEndorseSubmit();
                } else {
                  setState(() {
                    _errorMsg = dic['input.invalid'];
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onEndorseSubmit() async {
    var dic = I18n.of(context).gov;
    int decimals = widget.store.settings.networkState.tokenDecimals;
    final TreasuryTipData tipData = ModalRoute.of(context).settings.arguments;
    String amt = _tipInputCtrl.text.trim();
    var args = {
      "title": dic['treasury.tip'],
      "txInfo": {
        "module": 'treasury',
        "call": 'tip',
      },
      "detail": jsonEncode({
        "hash": Fmt.address(tipData.hash, pad: 16),
        "tipValue": amt,
      }),
      "params": [
        // "hash"
        tipData.hash,
        // "tipValue"
        Fmt.tokenInt(amt, decimals: decimals).toString(),
      ],
      'onFinish': (BuildContext txPageContext, Map res) {
        Navigator.popUntil(txPageContext, ModalRoute.withName('/'));
      }
    };
    setState(() {
      _tipInputCtrl.text = '';
    });
    Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
  }

  Future<void> _onCancel() async {
    var dic = I18n.of(context).gov;
    final TreasuryTipData tipData = ModalRoute.of(context).settings.arguments;
    var args = {
      "title": dic['treasury.retract'],
      "txInfo": {
        "module": 'treasury',
        "call": 'retractTip',
      },
      "detail": jsonEncode({"hash": Fmt.address(tipData.hash, pad: 16)}),
      "params": [tipData.hash],
      'onFinish': (BuildContext txPageContext, Map res) {
        Navigator.popUntil(txPageContext, ModalRoute.withName('/'));
      }
    };
    Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Map dic = I18n.of(context).gov;
    final String symbol = widget.store.settings.networkState.tokenSymbol;
    final int decimals = widget.store.settings.networkState.tokenDecimals;
    final TreasuryTipData tipData = ModalRoute.of(context).settings.arguments;
    final AccountData who = AccountData();
    final AccountData finder = AccountData();
    who.address = tipData.who;
    final Map accInfo = widget.store.account.accountIndexMap[who.address];
    Map accInfoFinder;
    if (tipData.finder != null) {
      finder.address = tipData.finder.address;
      accInfoFinder = widget.store.account.accountIndexMap[finder.address];
    }
    bool isFinder = false;
    if (widget.store.account.currentAddress == finder.address) {
      isFinder = true;
    }
    bool isCouncil = false;
    widget.store.gov.council.members.forEach((e) {
      if (widget.store.account.currentAddress == e[0]) {
        isCouncil = true;
      }
    });
    return Scaffold(
      appBar: AppBar(title: Text(dic['treasury.tip']), centerTitle: true),
      body: SafeArea(
        child: Observer(
          builder: (BuildContext context) {
            return ListView(
              children: <Widget>[
                RoundedCard(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: AddressIcon(who.address),
                        title:
                            Text(Fmt.accountDisplayName(who.address, accInfo)),
                        subtitle: Text(dic['treasury.who']),
                      ),
                      tipData.finder != null
                          ? ListTile(
                              leading: AddressIcon(finder.address),
                              title: Text(Fmt.accountDisplayName(
                                  finder.address, accInfoFinder)),
                              subtitle: Text(dic['treasury.finder']),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${Fmt.balance(
                                      tipData.finder.value.toString(),
                                      decimals: decimals,
                                    )} $symbol',
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                  Text(dic['treasury.bond']),
                                ],
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Row(
                          children: <Widget>[
                            Text(dic['treasury.reason']),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(tipData.reason),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Divider(height: 24),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: RoundedButton(
                                    color: Colors.orange,
                                    text: I18n.of(context).home['cancel'],
                                    onPressed: isFinder ? _onCancel : null,
                                  ),
                                ),
                                Container(width: 16),
                                Expanded(
                                  child: RoundedButton(
                                    text: dic['treasury.endorse'],
                                    onPressed: !isCouncil ? _onEndorse : null,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Theme.of(context).cardColor,
                  margin: EdgeInsets.only(top: 8),
                  padding: EdgeInsets.only(top: 8, bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: BorderedTitle(title: dic['treasury.tip']),
                      ),
                      Column(
                        children: tipData.tips.map((e) {
                          final Map accInfo =
                              widget.store.account.accountIndexMap[e.address];
                          return ListTile(
                            leading: AddressIcon(e.address),
                            title: Text(
                                Fmt.accountDisplayName(e.address, accInfo)),
                            trailing: Text(
                              '${Fmt.balance(
                                e.value.toString(),
                                decimals: decimals,
                              )} $symbol',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
