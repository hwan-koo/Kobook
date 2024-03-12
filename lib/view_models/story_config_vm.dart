import 'package:crepas/models/story_config_model.dart';
import 'package:crepas/repos/story_config_repo.dart';
import 'package:flutter/material.dart';

class StoryConfigViewModel extends ChangeNotifier {
  final StoryConfigRepository _repository;

  late final StoryConfigModel _model = StoryConfigModel(
      story: _repository.isStory(),
      thema: _repository.isThema(),
      imaginePlus: _repository.isImaginePlus(),
      age: _repository.isAge(),
      cloth: _repository.isCloth(),
      faceUrl: _repository.isFaceUrl(),
      name: _repository.isName(),
      paintingStyle: _repository.isPaintingStyle());

  StoryConfigViewModel(this._repository);

  String get story => _model.story;

//디스크에 persist
  void setStory(String story) {
    _repository.setStory(story);
    _model.story = story;
    notifyListeners();
  }
}
