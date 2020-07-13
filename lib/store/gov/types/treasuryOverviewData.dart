import 'package:json_annotation/json_annotation.dart';

part 'treasuryOverviewData.g.dart';

@JsonSerializable()
class TreasuryOverviewData extends _TreasuryOverviewData {
  static TreasuryOverviewData fromJson(Map<String, dynamic> json) =>
      _$TreasuryOverviewDataFromJson(json);
}

abstract class _TreasuryOverviewData {
  String balance;
  int proposalCount;
  List<SpendProposalData> proposals;
  List<SpendProposalData> approvals;
}

@JsonSerializable()
class SpendProposalData extends _SpendProposalData {
  static SpendProposalData fromJson(Map<String, dynamic> json) =>
      _$SpendProposalDataFromJson(json);
}

abstract class _SpendProposalData {
  int id;
  SpendProposalDetailData proposal;
}

@JsonSerializable()
class SpendProposalDetailData extends _SpendProposalDetailData {
  static SpendProposalDetailData fromJson(Map<String, dynamic> json) =>
      _$SpendProposalDetailDataFromJson(json);
}

abstract class _SpendProposalDetailData {
  String proposer;
  String beneficiary;
  int value;
  int bond;
}
