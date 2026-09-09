import '../../../../../domain/entities/entities.dart';
import '../../models.dart';

// Reward data details model

class SearchDataModel extends SearchDataEntity {
  const SearchDataModel({
    super.title,
    List<SearchListsModel>? super.lists,
  });

  factory SearchDataModel.fromJson(Map<String, dynamic> json) {
    List<SearchListsModel> lists = [];
    if (json['lists'] != null) {
      for (var s in (json['lists'] as List)) {
        {
          lists.add(SearchListsModel.fromJson(s));
        }
      }
    }

    return SearchDataModel(title: json['title'], lists: lists);
  }
}
