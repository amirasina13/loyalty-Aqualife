import '../../entity.dart';

// Upcoming event list entity

class UpcomingEntity extends Entity<int> {
  final String? name;
  final String? image;
  final String? filterBy;
  final bool? isClickable;

  const UpcomingEntity({
    required int id,
    this.name,
    this.image,
    this.filterBy,
    this.isClickable,
  }) : super(id);

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        filterBy,
        isClickable,
      ];
}
