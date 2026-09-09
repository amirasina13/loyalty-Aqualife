import '../../entity.dart';

// Reward/ IF Perks details entity

class SearchListEntity extends Entity<int> {
  final String? type;
  final String? name;
  final String? image;
  final String? isMuslim;
  final String? muslimCategory;

  const SearchListEntity(
      {required int id,
      this.type,
      this.name,
      this.image,
      this.isMuslim,
      this.muslimCategory})
      : super(id);

  @override
  List<Object?> get props => [id, type, name, image, isMuslim, muslimCategory];
}
