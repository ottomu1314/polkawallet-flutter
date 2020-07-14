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
    ..proposal = json['proposal'] == null
        ? null
        : SpendProposalDetailData.fromJson(
            json['proposal'] as Map<String, dynamic>);
}

Map<String, dynamic> _$SpendProposalDataToJson(SpendProposalData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isApproval': instance.isApproval,
      'proposal': instance.proposal,
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
