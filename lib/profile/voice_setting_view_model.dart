import 'package:crepas/profile/voice_repo.dart';
import 'package:crepas/profile/voice_setting_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VoiceSettingViewModel extends Notifier<VocieSettingModel> {
  final VoiceSettingRepository _repository;

  VoiceSettingViewModel(this._repository);

  void setSpeed(int value) {
    _repository.setSpeed(value);
    state = VocieSettingModel(
        speed: value,
        emotion: _repository.getEmotion(),
        gender: _repository.getGender());
  }

  void setEmotion(int value) {
    _repository.setEmotion(value);
    state = VocieSettingModel(
        speed: _repository.getSpeed(),
        emotion: value,
        gender: _repository.getGender());
  }

  void setGender(int value) {
    _repository.setGender(value);
    state = VocieSettingModel(
        speed: _repository.getSpeed(),
        emotion: _repository.getEmotion(),
        gender: value);
  }

  @override
  VocieSettingModel build() {
    return VocieSettingModel(
        speed: _repository.getSpeed(),
        emotion: _repository.getEmotion(),
        gender: _repository.getGender());
  }
}

final voiceSettingProvider =
    NotifierProvider<VoiceSettingViewModel, VocieSettingModel>(
  () => throw UnimplementedError(),
);
