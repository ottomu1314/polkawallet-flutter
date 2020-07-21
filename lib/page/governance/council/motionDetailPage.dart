import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:polka_wallet/common/components/roundedCard.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/store/gov/types/treasuryOverviewData.dart';
import 'package:polka_wallet/utils/format.dart';
import 'package:polka_wallet/utils/i18n/index.dart';

class MotionDetailPage extends StatefulWidget {
  MotionDetailPage(this.store);

  static const String route = '/gov/council/motion';

  final AppStore store;

  @override
  _MotionDetailPageState createState() => _MotionDetailPageState();
}

class _MotionDetailPageState extends State<MotionDetailPage> {
  SpendProposalDetailData _treasuryProposal;

  Future<SpendProposalDetailData> _fetchTreasuryProposal(String id) async {
    if (_treasuryProposal != null) return _treasuryProposal;

    final Map data =
        await webApi.evalJavascript('api.query.treasury.proposals($id)');
    if (data != null) {
      final SpendProposalDetailData proposal =
          SpendProposalDetailData.fromJson(data);
      setState(() {
        _treasuryProposal = proposal;
      });
    }
    return _treasuryProposal;
  }

  @override
  Widget build(BuildContext context) {
    final Map dic = I18n.of(context).gov;
    final CouncilMotionData motion = ModalRoute.of(context).settings.arguments;
    return Observer(
      builder: (BuildContext context) {
        int blockTime = 6000;
        if (widget.store.settings.networkConst['treasury'] != null) {
          blockTime =
              widget.store.settings.networkConst['babe']['expectedBlockTime'];
        }
        List<List<String>> params = [];
        motion.proposal.meta.args.asMap().forEach((k, v) {
          params.add(
              ['${v.name}: ${v.type}', motion.proposal.args[k].toString()]);
        });
        bool isTreasury = motion.proposal.section == 'treasury';
        bool isExternal = motion.proposal.section == 'democracy';
        return Scaffold(
          appBar: AppBar(
            title: Text(dic['council.motion']),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView(
              children: <Widget>[
                RoundedCard(
                  padding: EdgeInsets.all(16),
                  margin: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        motion.proposal.meta.name,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(motion.proposal.meta.documentation.trim()),
                      Divider(),
                      Text('params'),
                      ProposalArgsList(params),
                      isTreasury
                          ? FutureBuilder(
                              future: _fetchTreasuryProposal(
                                  motion.proposal.args[0]),
                              builder: (_,
                                  AsyncSnapshot<SpendProposalDetailData>
                                      snapshot) {
                                return snapshot.hasData
                                    ? ProposalArgsItem(
                                        label: Text('rpop'),
                                        content: Text('xx'),
                                      )
                                    : CupertinoActivityIndicator();
                              },
                            )
                          : Container(),
                      isExternal
                          ? FutureBuilder(
                              future: _fetchTreasuryProposal(
                                  motion.proposal.args[0]),
                              builder: (_,
                                  AsyncSnapshot<SpendProposalDetailData>
                                      snapshot) {
                                return snapshot.hasData
                                    ? ProposalArgsItem(
                                        label: Text('rpop'),
                                        content: Text('xx'),
                                      )
                                    : CupertinoActivityIndicator();
                              },
                            )
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(dic['treasury.proposal']),
                          Expanded(
                            child: Text(
                              motion.proposal.meta.documentation,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text('end'),
                          Text(
                            Fmt.blockToTime(
                              motion.votes.end - widget.store.gov.bestNumber,
                              blockTime,
                            ),
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class ProposalArgsList extends StatelessWidget {
  ProposalArgsList(this.args);

  final List<List<String>> args;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
          border: Border(
              left:
                  BorderSide(color: Theme.of(context).dividerColor, width: 3))),
      child: Column(
        children: args.map((e) {
          return ProposalArgsItem(
            label: Text(e[0]),
            content: Text(
              e[1],
              style: Theme.of(context).textTheme.headline4,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ProposalArgsItem extends StatelessWidget {
  ProposalArgsItem({this.label, this.content});

  final Widget label;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(8, 4, 4, 4),
      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
      decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.all(Radius.circular(4))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[label, content],
            ),
          )
        ],
      ),
    );
  }
}
