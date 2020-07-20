import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/common/components/addressFormItem.dart';
import 'package:polka_wallet/common/components/currencyWithIcon.dart';
import 'package:polka_wallet/common/components/roundedButton.dart';
import 'package:polka_wallet/common/consts/settings.dart';
import 'package:polka_wallet/common/regInputFormatter.dart';
import 'package:polka_wallet/page/account/scanPage.dart';
import 'package:polka_wallet/page/account/txConfirmPage.dart';
import 'package:polka_wallet/page/assets/asset/assetPage.dart';
import 'package:polka_wallet/page/assets/transfer/currencySelectPage.dart';
import 'package:polka_wallet/page/profile/contacts/contactListPage.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/store/account/types/accountData.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/utils/UI.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class TransferPageParams {
  TransferPageParams({
    this.symbol,
    this.address,
    this.redirect,
  });
  final String address;
  final String redirect;
  final String symbol;
}

class TransferPage extends StatefulWidget {
  const TransferPage(this.store);

  static final String route = '/assets/transfer';
  final AppStore store;

  @override
  _TransferPageState createState() => _TransferPageState(store);
}

class _TransferPageState extends State<TransferPage> {
  _TransferPageState(this.store);

  final AppStore store;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _addressCtrl = new TextEditingController();
  final TextEditingController _amountCtrl = new TextEditingController();

  String _tokenSymbol;

  bool _crossChain = false;

  Future<void> _selectCurrency() async {
    List<String> symbolOptions =
        List<String>.from(store.settings.networkConst['currencyIds']);

    var currency = await Navigator.of(context)
        .pushNamed(CurrencySelectPage.route, arguments: symbolOptions);

    if (currency != null) {
      if (_crossChain &&
          (_tokenSymbol == acala_stable_coin_view ||
              _tokenSymbol == acala_stable_coin) &&
          _tokenSymbol != currency) {
        setState(() {
          _addressCtrl.text = '';
        });
      }
      setState(() {
        _tokenSymbol = currency;
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState.validate()) {
      String symbol = _tokenSymbol ?? store.settings.networkState.tokenSymbol;
      int decimals = store.settings.networkState.tokenDecimals;
      var args = {
        "title": I18n.of(context).assets['transfer'] + ' $symbol',
        "txInfo": {
          "module": 'balances',
          "call": 'transfer',
        },
        "detail": jsonEncode({
          "destination": _addressCtrl.text.trim(),
          "currency": symbol,
          "amount": _amountCtrl.text.trim(),
        }),
        "params": [
          // params.to
          _addressCtrl.text.trim(),
          // params.amount
          Fmt.tokenInt(_amountCtrl.text.trim(), decimals: decimals).toString(),
        ],
      };
      bool isAcala = store.settings.endpoint.info == networkEndpointAcala.info;
      bool isLaminar =
          store.settings.endpoint.info == networkEndpointLaminar.info;
      if (isAcala || isLaminar) {
        args['txInfo'] = {
          "module": 'currencies',
          "call": 'transfer',
        };
        args['params'] = [
          // params.to
          _addressCtrl.text.trim(),
          // params.currencyId
          symbol.toUpperCase(),
          // params.amount
          Fmt.tokenInt(_amountCtrl.text.trim(), decimals: decimals).toString(),
        ];
      }
      args['onFinish'] = (BuildContext txPageContext, Map res) {
        final TransferPageParams routeArgs =
            ModalRoute.of(context).settings.arguments;
        if (isAcala) {
          store.acala.setTransferTxs([res]);
        }
        Navigator.popUntil(
            txPageContext, ModalRoute.withName(routeArgs.redirect));
        // user may route to transfer page from asset page
        // or from home page with QRCode Scanner
        if (routeArgs.redirect == AssetPage.route) {
          globalAssetRefreshKey.currentState.show();
        }
        if (routeArgs.redirect == '/') {
          globalBalanceRefreshKey.currentState.show();
        }
      };
      Navigator.of(context).pushNamed(TxConfirmPage.route, arguments: args);
    }
  }

  void _onSwitch(res) {
    final bool isAcala =
        store.settings.endpoint.info == networkEndpointAcala.info;
    if (res) {
      setState(() {
        _crossChain = res;
        _addressCtrl.text = isAcala
            ? cross_chain_transfer_address_laminar
            : cross_chain_transfer_address_acala;
      });
    } else {
      setState(() {
        _crossChain = res;
        _addressCtrl.text = '';
      });
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final TransferPageParams args = ModalRoute.of(context).settings.arguments;
      if (args.address != null) {
        setState(() {
          _addressCtrl.text = args.address;
        });
      }
      setState(() {
        _tokenSymbol = args.symbol ?? store.settings.networkState.tokenSymbol;
      });

      webApi.assets.fetchBalance();
    });
  }

  @override
  void dispose() {
    _addressCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final Map<String, String> dic = I18n.of(context).assets;
        String baseTokenSymbol = store.settings.networkState.tokenSymbol;
        String symbol = _tokenSymbol ?? baseTokenSymbol;
        final bool isBaseToken = _tokenSymbol == baseTokenSymbol;
        List symbolOptions = store.settings.networkConst['currencyIds'];

        int decimals = store.settings.networkState.tokenDecimals;

        BigInt available = isBaseToken
            ? store.assets.balances[symbol.toUpperCase()].transferable
            : Fmt.balanceInt(store.assets.tokenBalances[symbol.toUpperCase()]);

        final Map pubKeyAddressMap =
            store.account.pubKeyAddressMap[store.settings.endpoint.ss58];

        final bool isAcala =
            store.settings.endpoint.info == networkEndpointAcala.info;
        final bool isLaminar =
            store.settings.endpoint.info == networkEndpointLaminar.info;
        final bool canCrossChain = (_tokenSymbol == acala_stable_coin ||
                _tokenSymbol == acala_stable_coin_view) &&
            (isAcala || isLaminar);
        final bool isCrossChain = (_tokenSymbol == acala_stable_coin ||
                _tokenSymbol == acala_stable_coin_view) &&
            _crossChain;

        return Scaffold(
          appBar: AppBar(
            title: Text(dic['transfer']),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Image.asset('assets/images/assets/Menu_scan.png'),
                onPressed: isCrossChain
                    ? null
                    : () async {
                        final to = await Navigator.of(context)
                            .pushNamed(ScanPage.route);
                        if (to == null) return;
                        setState(() {
                          _addressCtrl.text =
                              (to as QRCodeAddressResult).address;
                        });
                      },
              )
            ],
          ),
          body: SafeArea(
            child: Builder(
              builder: (BuildContext context) {
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                          children: <Widget>[
                            isCrossChain
                                ? Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: AddressFormItem(
                                      store.account.currentAccount,
                                      label: dic['address'],
                                    ),
                                  )
                                : TextFormField(
                                    decoration: InputDecoration(
                                      hintText: dic['address'],
                                      labelText: dic['address'],
                                      suffix: GestureDetector(
                                        child: Image.asset(
                                            'assets/images/profile/address.png'),
                                        onTap: () async {
                                          var to = await Navigator.of(context)
                                              .pushNamed(ContactListPage.route);
                                          if (to != null) {
                                            AccountData acc = to as AccountData;
                                            setState(() {
                                              _addressCtrl.text =
                                                  acc.encoded == null
                                                      ? acc.address
                                                      : pubKeyAddressMap[
                                                          acc.pubKey];
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                    controller: _addressCtrl,
                                    validator: (v) {
                                      return Fmt.isAddress(v.trim())
                                          ? null
                                          : dic['address.error'];
                                    },
                                  ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: dic['amount'],
                                labelText:
                                    '${dic['amount']} (${dic['balance']}: ${Fmt.token(available, decimals: decimals)})',
                              ),
                              inputFormatters: [
                                RegExInputFormatter.withRegex(
                                    '^[0-9]{0,6}(\\.[0-9]{0,$decimals})?\$')
                              ],
                              controller: _amountCtrl,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              validator: (v) {
                                if (v.isEmpty) {
                                  return dic['amount.error'];
                                }
                                if (double.parse(v.trim()) >=
                                    available / BigInt.from(pow(10, decimals)) -
                                        0.001) {
                                  return dic['amount.low'];
                                }
                                return null;
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                color: Theme.of(context).canvasColor,
                                margin: EdgeInsets.only(top: 16, bottom: 16),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          dic['currency'],
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .unselectedWidgetColor),
                                        ),
                                        CurrencyWithIcon(
                                            _tokenSymbol ?? baseTokenSymbol),
                                      ],
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
                                    )
                                  ],
                                ),
                              ),
                              onTap: symbolOptions != null
                                  ? () => _selectCurrency()
                                  : null,
                            ),
                            canCrossChain
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          isAcala
                                              ? dic['cross.laminar']
                                              : dic['cross.acala'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                        ),
                                      ),
                                      CupertinoSwitch(
                                        value: _crossChain,
                                        onChanged: _onSwitch,
                                      )
                                    ],
                                  )
                                : Container(),
                            Divider(),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                  'existentialDeposit: ${store.settings.existentialDeposit} $baseTokenSymbol',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54)),
                            ),
//                            Padding(
//                              padding: EdgeInsets.only(top: 16),
//                              child: Text(
//                                  'TransferFee: ${store.settings.transactionBaseFee} $baseTokenSymbol',
//                                  style: TextStyle(
//                                      fontSize: 16, color: Colors.black54)),
//                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(
                                  'transactionByteFee: ${store.settings.transactionByteFee} $baseTokenSymbol',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: RoundedButton(
                        text: I18n.of(context).assets['make'],
                        onPressed: _handleSubmit,
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
