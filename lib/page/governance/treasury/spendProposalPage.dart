import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:polka_wallet/common/components/JumpToBrowserLink.dart';
import 'package:polka_wallet/common/components/addressIcon.dart';
import 'package:polka_wallet/common/components/infoItem.dart';
import 'package:polka_wallet/common/components/roundedButton.dart';
import 'package:polka_wallet/common/components/roundedCard.dart';
import 'package:polka_wallet/page/account/txConfirmPage.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/service/substrateApi/types/genExternalLinksParams.dart';
import 'package:polka_wallet/store/account/types/accountData.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/store/gov/types/treasuryOverviewData.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class SpendProposalPage extends StatefulWidget {
  SpendProposalPage(this.store);

  static const String route = '/gov/treasury/proposal';

  final AppStore store;

  @override
  _SpendProposalPageState createState() => _SpendProposalPageState();
}

class _SpendProposalPageState extends State<SpendProposalPage> {
  Future<void> _onResolve(bool approve) async {
    var dic = I18n.of(context).gov;
    final SpendProposalData proposal =
        ModalRoute.of(context).settings.arguments;
    var args = {
      "title": approve ? dic['treasury.approve'] : dic['treasury.reject'],
      "txInfo": {
        "module": 'treasury',
        "call": approve ? 'approveProposal' : 'rejectProposal',
      },
      "detail": jsonEncode({"id": proposal.id}),
      "params": [proposal.id],
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
    final SpendProposalData proposal =
        ModalRoute.of(context).settings.arguments;
    final AccountData proposer = AccountData();
    final AccountData beneficiary = AccountData();
    proposer.address = proposal.proposal.proposer;
    beneficiary.address = proposal.proposal.beneficiary;
    final Map accInfoProposer =
        widget.store.account.accountIndexMap[proposer.address];
    final Map accInfoBeneficiary =
        widget.store.account.accountIndexMap[beneficiary.address];
    bool isCouncil = false;
    widget.store.gov.council.members.forEach((e) {
      if (widget.store.account.currentAddress == e[0]) {
        isCouncil = true;
      }
    });
    bool isApproval = proposal.isApproval ?? false;
    return Scaffold(
      appBar: AppBar(
        title: Text('${dic['treasury.proposal']} #${proposal.id}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            RoundedCard(
              margin: EdgeInsets.all(16),
              padding: EdgeInsets.fromLTRB(0, 24, 0, 8),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: <Widget>[
                        InfoItem(
                          title: dic['treasury.value'],
                          content: '${Fmt.balance(
                            proposal.proposal.value.toString(),
                            decimals: decimals,
                          )} $symbol',
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                        InfoItem(
                          title: dic['treasury.bond'],
                          content: '${Fmt.balance(
                            proposal.proposal.bond.toString(),
                            decimals: decimals,
                          )} $symbol',
                          crossAxisAlignment: CrossAxisAlignment.center,
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: AddressIcon(proposal.proposal.proposer),
                    title: Fmt.accountDisplayName(
                        proposal.proposal.proposer, accInfoProposer),
                    subtitle: Text(dic['treasury.proposer']),
                  ),
                  ListTile(
                    leading: AddressIcon(proposal.proposal.beneficiary),
                    title: Fmt.accountDisplayName(
                        proposal.proposal.beneficiary, accInfoBeneficiary),
                    subtitle: Text(dic['treasury.beneficiary']),
                  ),
                  FutureBuilder(
                    future: webApi.getExternalLinks(
                        GenExternalLinksParams.fromJson({
                      'data': proposal.id.toString(),
                      'type': 'treasury'
                    })),
                    builder: (_, AsyncSnapshot<List> snapshot) {
                      if (snapshot.hasData) {
                        final List links = snapshot.data;
                        return Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  JumpToBrowserLink(
                                    links[0]['link'],
                                    text: links[0]['name'],
                                  ),
                                  JumpToBrowserLink(
                                    links[1]['link'],
                                    text: links[1]['name'],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  JumpToBrowserLink(
                                    links[2]['link'],
                                    text: links[2]['name'],
                                  ),
                                  JumpToBrowserLink(
                                    links[3]['link'],
                                    text: links[3]['name'],
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16, right: 16),
                    child: Divider(),
                  ),
                  !isApproval
                      ? Container()
                      : Padding(
                          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: RoundedButton(
                                  color: Colors.orange,
                                  text: dic['treasury.reject'],
                                  onPressed: isCouncil
                                      ? () => _onResolve(false)
                                      : null,
                                ),
                              ),
                              Container(width: 16),
                              Expanded(
                                child: RoundedButton(
                                  color: Colors.orange,
                                  text: dic['treasury.approve'],
                                  onPressed:
                                      isCouncil ? () => _onResolve(true) : null,
                                ),
                              ),
                            ],
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
