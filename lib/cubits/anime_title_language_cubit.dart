import 'package:flutter_bloc/flutter_bloc.dart';

import '/database_helper/database_helper.dart';

typedef IsEnglish = bool;

class AnimeTitleLanguageCubit extends Cubit<IsEnglish> {
  AnimeTitleLanguageCubit() : super(false) {
    _fetchAnimeTitleLanguage();
  }

  bool get isEnglish => state;

  // inisialisasi language
  Future _fetchAnimeTitleLanguage() async {
    final isEnglish = await DatabaseHelper.instance.isEnglish;
    emit(isEnglish);
  }

  // mengubah anime title language
  Future changeAnimeTitleLanguage({required bool isEnglish}) async {
    await DatabaseHelper.instance.setIsEnglish(isEnglish);
    emit(isEnglish);
  }
}
