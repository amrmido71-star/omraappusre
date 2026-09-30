import 'package:flutter/foundation.dart';

/// Selected bottom-nav tab of [AppShell]. Lives outside the shell so pushed
/// screens that also show the bottom bar (e.g. search results) can switch
/// tabs: set the index, then pop back to the shell.
class NavState {
  static final tab = ValueNotifier<int>(0);
}
