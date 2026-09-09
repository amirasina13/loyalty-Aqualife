import '../entity.dart';

// Receiver entity. Will call in verify_transfer_entity.dart

class ReceiverEntity extends Entity<int> {
  final String? name;
  final String? contact;
  final String? code;
  final String? image;
  final String? push;

  const ReceiverEntity({
    required int id,
    this.name,
    this.contact,
    this.code,
    this.image,
    this.push,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        name,
        contact,
        code,
        image,
      ];
}
