import 'package:equatable/equatable.dart';

class UserPlanModel extends Equatable {
  final int? time;
  final String? type;
  final String? location;

  const UserPlanModel({
    this.time,
    this.type,
    this.location,
  });

  @override
  List<Object?> get props => [
    time,
    type,
    location,
  ];
}

class UserExtModel extends Equatable {
  final UserPlanModel? plan;
  final double? amountSaved;
  final double? housePrice;
  final double? loanAmount;

  const UserExtModel({
    this.plan,
    this.amountSaved,
    this.housePrice,
    this.loanAmount,
  });

  @override
  List<Object?> get props => [
    plan,
    amountSaved,
    housePrice,
    loanAmount,
  ];
}