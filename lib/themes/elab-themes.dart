import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/themes/alt-theme.dart';
import 'package:flutter_app/themes/doc-theme.dart';
import 'package:bloc/bloc.dart';

enum ThemeKeys { SELF, ALT}

class ElabThemes with ChangeNotifier {
  // ChangeNotifier : will provide a notifier for any changes in the value to all it's listeners
  bool isDarkMode = false;
  getDarkMode() => this.isDarkMode;
  void changeDarkMode(isDarkMode) {
    this.isDarkMode = isDarkMode;
    notifyListeners(); // Notify all it's listeners about update. If you comment this line then you will see that new added items will not be reflected in the list.
  }

  static ThemeData getThemeFromKey(ThemeKeys themeKey) {
    switch (themeKey) {
      case ThemeKeys.SELF:
        return myTheme;
      case ThemeKeys.ALT:
        return altTheme;
      default:
        return myTheme;
    }
  }
}

@immutable
abstract class ThemeEvent extends Equatable {
  // Passing class fields in a list to the Equatable super class
  ThemeEvent([List props = const []]) : super(props);
}

class ThemeChanged extends ThemeEvent {
  final ThemeKeys theme;

  ThemeChanged({
    @required this.theme,
  }) : super([theme]);
}

@immutable
class ThemeState extends Equatable {
  final ThemeData themeData;

  ThemeState({
    @required this.themeData,
  }) : super([themeData]);
}

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  @override
  ThemeState get initialState =>
      // Everything is accessible from the appThemeData Map.
  ThemeState(themeData: ElabThemes.getThemeFromKey(ThemeKeys.SELF));

  @override
  Stream<ThemeState> mapEventToState(
      ThemeEvent event,
      ) async* {
    if (event is ThemeChanged) {
      yield ThemeState(themeData: ElabThemes.getThemeFromKey(event.theme));
    }
  }
}