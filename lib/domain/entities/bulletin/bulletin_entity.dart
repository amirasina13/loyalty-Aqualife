import '../entity.dart';

// Bulletin/ IF News list entity. Also will call in home_page_entity.dart

class BulletinEntity extends Entity<int> {
  final String? name;
  final String? image;

  const BulletinEntity({
    required int id,
    this.name,
    this.image,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        name,
        image,
      ];
}
