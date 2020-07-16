import 'package:flutter_test/flutter_test.dart';
import 'package:polka_wallet/store/app.dart';
import 'package:polka_wallet/store/gov/governance.dart';
import 'package:polka_wallet/store/gov/types/treasuryOverviewData.dart';

import 'localStorage_mock.dart';
import 'mock/mockTreasuryData.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GovernanceStore test', () {
    final AppStore root = AppStore();
    root.localStorage = getMockLocalStorage();
    final store = GovernanceStore(root);

    test('gov store created', () {
      expect(store.cacheCouncilKey, 'council');
    });
    test('set treasury overview properly', () {
      store.setTreasuryOverview(treasuryOverview);
      expect(store.treasuryOverview.balance, treasuryBalance);
      expect(store.treasuryOverview.proposalCount, treasuryCount);
      // check proposal data
      expect(store.treasuryOverview.proposals.length, 1);
      expect(store.treasuryOverview.proposals[0].id, 36);
      final CouncilMotionData councilProposal =
          store.treasuryOverview.proposals[0].council[0];
      expect(councilProposal.hash, councilProposalOf36['hash']);
      expect(councilProposal.proposal.callIndex,
          councilProposalOf36['proposal']['callIndex']);
      expect(councilProposal.proposal.args,
          councilProposalOf36['proposal']['args']);
      expect(councilProposal.proposal.meta.name,
          councilProposalOf36['proposal']['meta']['name']);
      expect(councilProposal.proposal.meta.documentation,
          councilProposalOf36['proposal']['meta']['documentation']);
      expect(
          councilProposal.votes.index, councilProposalOf36['votes']['index']);
      expect(councilProposal.votes.threshold,
          councilProposalOf36['votes']['threshold']);
      expect(councilProposal.votes.end, councilProposalOf36['votes']['end']);
      expect(councilProposal.votes.ayes.length,
          List.of(councilProposalOf36['votes']['ayes']).length);
      expect(councilProposal.votes.nays.length,
          List.of(councilProposalOf36['votes']['nays']).length);

      // check approval data
      expect(store.treasuryOverview.approvals.length, 3);
      expect(store.treasuryOverview.approvals[0].id, 33);
      final SpendProposalDetailData approval =
          store.treasuryOverview.approvals[0].proposal;
      expect(approval.value, treasuryProposal33['value']);
      expect(approval.bond, treasuryProposal33['bond']);
      expect(approval.proposer, treasuryProposal33['proposer']);
      expect(approval.beneficiary, treasuryProposal33['beneficiary']);
    });
    test('set treasury tips properly', () {
      final List tips = [tip0x58, tip0xf2];
      store.setTreasuryTips(tips);
      expect(store.treasuryTips.length, 2);
      expect(store.treasuryTips[0].hash, tip0x58['hash']);
      expect(store.treasuryTips[0].who, tip0x58['who']);
      expect(store.treasuryTips[0].reason, tip0x58['reason']);
      expect(
          store.treasuryTips[0].finder.address, tip0x58['finder']['address']);
      expect(store.treasuryTips[0].finder.value, tip0x58['finder']['value']);
      expect(
          store.treasuryTips[0].tips.length, List.of(tip0x58['tips']).length);
      expect(store.treasuryTips[0].tips[0].value,
          List.of(tip0x58['tips'])[0]['value']);
      expect(store.treasuryTips[0].tips[0].address,
          List.of(tip0x58['tips'])[0]['address']);
    });
    test('set council motions properly', () {
      store.setCouncilMotions(councilMotions);
      expect(store.councilMotions.length, 2);
      expect(store.councilMotions[0].hash, councilMotion0['hash']);
      final CouncilProposalData proposal = store.councilMotions[0].proposal;
      expect(proposal.callIndex, councilMotion0['proposal']['callIndex']);
      expect(proposal.args.length,
          List.of(councilMotion0['proposal']['args']).length);
      expect(proposal.args[0], councilMotion0['proposal']['args'][0]);
      expect(proposal.meta.name, councilMotion0['proposal']['meta']['name']);
      expect(proposal.meta.documentation,
          councilMotion0['proposal']['meta']['documentation']);
      expect(proposal.meta.args.length,
          List.of(councilMotion0['proposal']['meta']['args']).length);
      expect(proposal.meta.args[0].name,
          councilMotion0['proposal']['meta']['args'][0]['name']);
      expect(proposal.meta.args[0].type,
          councilMotion0['proposal']['meta']['args'][0]['type']);
      final CouncilProposalVotesData votesData = store.councilMotions[0].votes;
      expect(votesData.index, councilMotion0['votes']['index']);
      expect(votesData.threshold, councilMotion0['votes']['threshold']);
      expect(votesData.end, councilMotion0['votes']['end']);
      expect(votesData.nays.length,
          List.of(councilMotion0['votes']['nays']).length);
      expect(votesData.ayes.length,
          List.of(councilMotion0['votes']['ayes']).length);
    });
  });
}
