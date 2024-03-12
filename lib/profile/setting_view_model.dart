import 'package:crepas/profile/setting_model.dart';
import 'package:crepas/profile/setting_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  final PlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  void setMuted(bool value) {
    _repository.setMuted(value);
    state = PlaybackConfigModel(muted: value, noti: value);
  }

  @override
  PlaybackConfigModel build() {
    return PlaybackConfigModel(
        muted: _repository.isMuted(), noti: _repository.isNoti());
  }
}

final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () => throw UnimplementedError(),
);
