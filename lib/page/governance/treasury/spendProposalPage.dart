import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/common/components/BorderedTitle.dart';
import 'package:polka_wallet/common/components/addressFormItem.dart';
import 'package:polka_wallet/common/components/addressIcon.dart';
import 'package:polka_wallet/common/components/infoItem.dart';
import 'package:polka_wallet/common/components/roundedCard.dart';
import 'package:polka_wallet/store/account/types/accountData.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/store/gov/types/treasuryOverviewData.dart';
import 'package:polka_wallet/store/gov/types/treasuryTipData.dart';
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
                    title: Text(Fmt.accountDisplayName(
                        proposal.proposal.proposer, accInfoProposer)),
                    subtitle: Text(dic['treasury.proposer']),
                  ),
                  ListTile(
                    leading: AddressIcon(proposal.proposal.beneficiary),
                    title: Text(Fmt.accountDisplayName(
                        proposal.proposal.beneficiary, accInfoBeneficiary)),
                    subtitle: Text(dic['treasury.beneficiary']),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
