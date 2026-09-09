import '../entities.dart';
import '../entity.dart';

// Transfer entity

class VerifyTransferEntity extends Entity<int> {
  final SenderEntity? profile;
  final ReceiverEntity? receiver;

  const VerifyTransferEntity({
    required int id,
    this.profile,
    this.receiver,
  }) : super(id);

  @override
  List<Object?> get props => [id, profile, receiver];
}
