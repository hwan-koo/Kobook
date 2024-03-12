import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayingStatusModel {
  bool isPlaying;

  PlayingStatusModel({required this.isPlaying});
}

class PlayingStatusRepository {
  static const String _isPlaying = "isPlaying";

  final SharedPreferences _preferences;

  PlayingStatusRepository(this._preferences);

  Future<void> setPlayingStatus(bool value) async {
    _preferences.setBool(_isPlaying, value);
  }

  bool isMuted() {
    return _preferences.getBool(_isPlaying) ?? false;
  }
}

class PlayingStatusViewModel extends Notifier<PlayingStatusModel> {
  final PlayingStatusRepository _repository;

  PlayingStatusViewModel(this._repository);

  void setIsPlaying(bool value) {
    _repository.setPlayingStatus(value);
    state = PlayingStatusModel(isPlaying: value);
  }

  @override
  PlayingStatusModel build() {
    return PlayingStatusModel(isPlaying: _repository.isMuted());
  }
}

final playingStatusProvider =
    NotifierProvider<PlayingStatusViewModel, PlayingStatusModel>(
  () => throw UnimplementedError(),
);
