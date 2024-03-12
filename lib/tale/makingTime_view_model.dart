import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'makingTime_model.dart';
import 'makingTime_repo.dart';

class MakingTimeViewModel extends Notifier<MakingTimeModel> {
  final MakingTimeRepository _repository;

  MakingTimeViewModel(this._repository);

  void setMakingTime(String value) {
    _repository.setMakingTime(value);
    state = MakingTimeModel(completeTime: value);
  }

  @override
  MakingTimeModel build() {
    return MakingTimeModel(
      completeTime: _repository.isMakingTime(),
    );
  }
}

final makingTimeProvider =
    NotifierProvider<MakingTimeViewModel, MakingTimeModel>(
  () => throw UnimplementedError(),
);
