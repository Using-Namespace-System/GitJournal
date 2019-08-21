import 'package:shared_preferences/shared_preferences.dart';

enum NoteViewerFontSize { Normal, Small, ExtraSmall, Large, ExtraLarge }

class Settings {
  static List<Function> changeObservers;

  // singleton
  static final Settings _singleton = Settings._internal();
  factory Settings() => _singleton;
  Settings._internal();
  static Settings get instance => _singleton;

  // Properties
  String gitAuthor = "GitJournal";
  String gitAuthorEmail = "app@gitjournal.io";

  NoteViewerFontSize noteViewerFontSize = NoteViewerFontSize.Normal;

  void load(SharedPreferences pref) {
    gitAuthor = pref.getString("gitAuthor") ?? gitAuthor;
    gitAuthorEmail = pref.getString("gitAuthorEmail") ?? gitAuthorEmail;

    var str =
        pref.getString("noteViewerFontSize") ?? noteViewerFontSize.toString();
    print(NoteViewerFontSize.values);
    noteViewerFontSize =
        NoteViewerFontSize.values.firstWhere((e) => e.toString() == str);
  }

  Future save() async {
    var pref = await SharedPreferences.getInstance();
    pref.setString("gitAuthor", gitAuthor);
    pref.setString("gitAuthorEmail", gitAuthorEmail);

    // Shouldn't we check if something has actually changed?
    for (var f in changeObservers) {
      f();
    }
  }

  double getNoteViewerFontSize() {
    switch (noteViewerFontSize) {
      case NoteViewerFontSize.Normal:
        return 18.0;
      case NoteViewerFontSize.Small:
        return 15.0;
      case NoteViewerFontSize.ExtraSmall:
        return 12.0;
      case NoteViewerFontSize.Large:
        return 22.0;
      case NoteViewerFontSize.ExtraLarge:
        return 26.0;
    }

    assert(false, "getNoteViewerFontSize: We should never be here");
    return 50000.0;
  }
}
