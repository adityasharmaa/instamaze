import 'package:flutter/foundation.dart';
import 'package:insta/models/story_model.dart';

class StoriesProvider with ChangeNotifier{
  List<StoryModel> _stories = [
    StoryModel(
      id: "id",
      images: [],
      userId: "userId",
    ),
    StoryModel(
      id: "id",
      images: [],
      userId: "userId",
    ),
    StoryModel(
      id: "id",
      images: [],
      userId: "userId",
    ),
  ];

  List<StoryModel> get stories{
    return [..._stories];
  }

  Future<void> fetchStories() async{
    
  }
}