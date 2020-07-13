import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/service/substrateApi/api.dart';
import 'package:polka_wallet/store/gov/types/treasuryOverviewData.dart';

class ApiGovernance {
  ApiGovernance(this.apiRoot);

  final Api apiRoot;
  final store = globalAppStore;

  Future<Map> fetchCouncilInfo() async {
    Map info = await apiRoot.evalJavascript('api.derive.elections.info()');
    if (info != null) {
      List all = [];
      all.addAll(info['members'].map((i) => i[0]));
      all.addAll(info['runnersUp'].map((i) => i[0]));
      all.addAll(info['candidates']);
      store.gov.setCouncilInfo(info);
      apiRoot.account.fetchAccountsIndex(all);
      apiRoot.account.getAddressIcons(all);
    }
    return info;
  }

  Future<Map> fetchCouncilVotes() async {
    Map votes = await apiRoot.evalJavascript('gov.fetchCouncilVotes()');
    if (votes != null) {
      store.gov.setCouncilVotes(votes);
    }
    return votes;
  }

  Future<Map> fetchUserCouncilVote() async {
    Map votes = await apiRoot.evalJavascript(
        'api.derive.council.votesOf("${store.account.currentAddress}")');
    if (votes != null) {
      store.gov.setUserCouncilVotes(votes);
    }
    return votes;
  }

  Future<Map> fetchReferendums() async {
    Map data = await apiRoot.evalJavascript(
        'gov.fetchReferendums("${store.account.currentAddress}")');
    if (data != null) {
      List list = data['referendums'];
      list.asMap().forEach((k, v) {
        v['detail'] = data['details'][k];
      });
      store.gov.setReferendums(List<Map<String, dynamic>>.from(list));
    }
    return data;
  }

  Future<Map> fetchTreasuryOverview() async {
//    Map data = await apiRoot.evalJavascript('gov.getTreasuryOverview()');

    const Map<String, dynamic> treasuryProposal33 = {
      "proposer": "DfyDF9aumWDoF6FhUEsw6LJVvCfv3eCV8EnM3zunEkoiwSG",
      "value": 2300000000000000,
      "beneficiary": "DfyDF9aumWDoF6FhUEsw6LJVvCfv3eCV8EnM3zunEkoiwSG",
      "bond": 115000000000000
    };
    final Map<String, dynamic> treasuryOverview = {
      "approvals": [
        {"council": [], "id": 33, "proposal": treasuryProposal33},
        {
          "council": [],
          "id": 34,
          "proposal": {
            "proposer": "FyLYnuNoMAVkz1VZMMGZFHDPghQQm1916fCon1CqNt2aXbX",
            "value": 2500000000000000,
            "beneficiary": "FyLYnuNoMAVkz1VZMMGZFHDPghQQm1916fCon1CqNt2aXbX",
            "bond": 125000000000000
          }
        },
        {
          "council": [],
          "id": 35,
          "proposal": {
            "proposer": "D3akXZ5Aawj7ZQMsvL5oTcxaWpJTLXQPJxhnG5HsBQSswBs",
            "value": 4400000000000000,
            "beneficiary": "D3akXZ5Aawj7ZQMsvL5oTcxaWpJTLXQPJxhnG5HsBQSswBs",
            "bond": 220000000000000
          }
        }
      ],
      "proposalCount": 36,
      "proposals": [],
      "balance": '210216858000000000',
    };
    Map data = treasuryOverview;
    store.gov.setTreasuryOverview(data);
    List<String> addresses = [];
    List<SpendProposalData> allProposals =
        store.gov.treasuryOverview.proposals.toList();
    allProposals.addAll(store.gov.treasuryOverview.approvals);
    allProposals.forEach((e) {
      addresses.add(e.proposal.proposer);
      addresses.add(e.proposal.beneficiary);
    });
    await apiRoot.account.getAddressIcons(addresses);
    await apiRoot.account.fetchAccountsIndex(addresses);
    return data;
  }

  Future<List> fetchTreasuryTips() async {
    List data = await apiRoot.evalJavascript('gov.getTreasuryTips()');
    store.gov.setTreasuryTips(data);
    List<String> addresses = [];
    store.gov.treasuryTips.toList().forEach((e) {
      addresses.add(e.who);
      if (e.finder != null) {
        addresses.add(e.finder.address);
      }
    });
    await apiRoot.account.getAddressIcons(addresses);
    await apiRoot.account.fetchAccountsIndex(addresses);
    return data;
  }
}
