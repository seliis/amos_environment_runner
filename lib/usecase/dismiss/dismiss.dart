import "package:shared_preferences/shared_preferences.dart";
import "package:flutter_bloc/flutter_bloc.dart";

final class DismissSetting extends Cubit<bool> {
  DismissSetting() : super(false);

  void init() async {
    await SharedPreferences.getInstance().then((prefs) {
      emit(prefs.getBool("dismiss") ?? false);
    });
  }

  void set(bool value) async {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("dismiss", value);
      emit(value);
    });
  }
}
