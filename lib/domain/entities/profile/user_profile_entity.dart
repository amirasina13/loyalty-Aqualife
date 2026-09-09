import '../entities.dart';
import '../entity.dart';

// User profile entity

class UserProfileEntity extends Entity<int> {
  final ProfileEntity? profile;

  const UserProfileEntity({
    required int id,
    this.profile,
  }) : super(id);

  @override
  List<Object?> get props => [id, profile];
}
