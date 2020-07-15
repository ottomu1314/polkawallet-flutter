// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treasuryOverviewData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TreasuryOverviewData _$TreasuryOverviewDataFromJson(Map<String, dynamic> json) {
  return TreasuryOverviewData()
    ..balance = json['balance'] as String
    ..proposalCount = json['proposalCount'] as int
    ..proposals = (json['proposals'] as List)
        ?.map((e) => e == null
            ? null
            : SpendProposalData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..approvals = (json['approvals'] as List)
        ?.map((e) => e == null
            ? null
            : SpendProposalData.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TreasuryOverviewDataToJson(
        TreasuryOverviewData instance) =>
    <String, dynamic>{
      'balance': instance.balance,
      'proposalCount': instance.proposalCount,
      'proposals': instance.proposals,
      'approvals': instance.approvals,
    };

SpendProposalData _$SpendProposalDataFromJson(Map<String, dynamic> json) {
  return SpendProposalData()
    ..id = json['id'] as int
    ..isApproval = json['isApproval'] as bool
    ..council = (json['council'] as List)
        ?.map((e) => e == null
            ? null
            : SpendProposalCouncilData.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..proposal = json['proposal'] == null
        ? null
        : SpendProposalDetailData.fromJson(
            json['proposal'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SpendProposalDataToJson(SpendProposalData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isApproval': instance.isApproval,
      'council': instance.council,
      'proposal': instance.proposal,
    };

SpendProposalCouncilData _$SpendProposalCouncilDataFromJson(
    Map<String, dynamic> json) {
  return SpendProposalCouncilData()
    ..hash = json['hash'] as String
    ..proposal = json['proposal'] == null
        ? null
        : CouncilProposalData.fromJson(json['proposal'] as Map<String, dynamic>)
    ..votes = json['votes'] == null
        ? null
        : CouncilProposalVotesData.fromJson(
            json['votes'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SpendProposalCouncilDataToJson(
        SpendProposalCouncilData instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'proposal': instance.proposal,
      'votes': instance.votes,
    };

CouncilProposalData _$CouncilProposalDataFromJson(Map<String, dynamic> json) {
  return CouncilProposalData()
    ..callIndex = json['callIndex'] as String
    ..args = json['args'] as Map<String, dynamic>;
}

Map<String, dynamic> _$CouncilProposalDataToJson(
        CouncilProposalData instance) =>
    <String, dynamic>{
      'callIndex': instance.callIndex,
      'args': instance.args,
    };

CouncilProposalVotesData _$CouncilProposalVotesDataFromJson(
    Map<String, dynamic> json) {
  return CouncilProposalVotesData()
    ..index = json['index'] as int
    ..threshold = json['threshold'] as int
    ..ayes = (json['ayes'] as List)?.map((e) => e as String)?.toList()
    ..nays = (json['nays'] as List)?.map((e) => e as String)?.toList()
    ..end = json['end'] as int;
}

Map<String, dynamic> _$CouncilProposalVotesDataToJson(
        CouncilProposalVotesData instance) =>
    <String, dynamic>{
      'index': instance.index,
      'threshold': instance.threshold,
      'ayes': instance.ayes,
      'nays': instance.nays,
      'end': instance.end,
    };

SpendProposalDetailData _$SpendProposalDetailDataFromJson(
    Map<String, dynamic> json) {
  return SpendProposalDetailData()
    ..proposer = json['proposer'] as String
    ..beneficiary = json['beneficiary'] as String
    ..value = json['value'] as int
    ..bond = json['bond'] as int;
}

Map<String, dynamic> _$SpendProposalDetailDataToJson(
        SpendProposalDetailData instance) =>
    <String, dynamic>{
      'proposer': instance.proposer,
      'beneficiary': instance.beneficiary,
      'value': instance.value,
      'bond': instance.bond,
    };
