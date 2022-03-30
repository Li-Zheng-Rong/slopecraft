import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:system_theme/system_theme.dart';
import 'package:win32/win32.dart';
import 'package:ffi/ffi.dart' as ffi;
import 'dart:ffi';

bool isWindowsVersionOrGreater(int dwMajor, int dwMinor, int dwBuild) {
  Pointer<OSVERSIONINFOEX> osvi = ffi.malloc.call();
  osvi.ref.dwOSVersionInfoSize = sizeOf<OSVERSIONINFOEX>();
  osvi.ref.dwMajorVersion = dwMajor;
  osvi.ref.dwMinorVersion = dwMinor;
  osvi.ref.dwBuildNumber = dwBuild;
  int dwlConditionMask = 0;
  var op = VER_GREATER_EQUAL;
  dwlConditionMask = VerSetConditionMask(dwlConditionMask, VER_MAJORVERSION, op);
  dwlConditionMask = VerSetConditionMask(dwlConditionMask, VER_MINORVERSION, op);
  dwlConditionMask = VerSetConditionMask(dwlConditionMask, VER_BUILDNUMBER, op);
  return (VerifyVersionInfo(osvi, VER_MAJORVERSION | VER_MINORVERSION | VER_BUILDNUMBER, dwlConditionMask) != FALSE);
}

enum NavigationIndicators { sticky, end }

class AppTheme extends ChangeNotifier {
  AccentColor _color = systemAccentColor;
  AccentColor get color => _color;
  set color(AccentColor color) {
    _color = color;
    notifyListeners();
  }

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  set mode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }

  PaneDisplayMode _displayMode = PaneDisplayMode.open;
  PaneDisplayMode get displayMode => _displayMode;
  set displayMode(PaneDisplayMode displayMode) {
    _displayMode = displayMode;
    notifyListeners();
  }

  NavigationIndicators _indicator = NavigationIndicators.sticky;
  NavigationIndicators get indicator => _indicator;
  set indicator(NavigationIndicators indicator) {
    _indicator = indicator;
    notifyListeners();
  }

  WindowEffect _windowEffect = isWindowsVersionOrGreater(10, 0, 22000)
      ? WindowEffect.acrylic
      : IsWindows10OrGreater() == 1
          ? WindowEffect.acrylic
          : WindowEffect.aero;

  WindowEffect get windowEffect => _windowEffect;
  set windowEffect(WindowEffect windowEffect) {
    _windowEffect = windowEffect;
    notifyListeners();
  }

  void setEffect(WindowEffect effect, BuildContext context) {
    Window.setEffect(
      effect: effect,
      color: [
        WindowEffect.solid,
        WindowEffect.acrylic,
      ].contains(effect)
          ? FluentTheme.of(context).micaBackgroundColor.withOpacity(0.05)
          : Colors.transparent,
      dark: FluentTheme.of(context).brightness.isDark,
    );
  }

  TextDirection _textDirection = TextDirection.ltr;
  TextDirection get textDirection => _textDirection;
  set textDirection(TextDirection direction) {
    _textDirection = direction;
    notifyListeners();
  }
}

AccentColor get systemAccentColor {
  if (defaultTargetPlatform == TargetPlatform.windows || defaultTargetPlatform == TargetPlatform.android || kIsWeb) {
    return AccentColor('normal', {
      'darkest': SystemTheme.accentInstance.darkest,
      'darker': SystemTheme.accentInstance.darker,
      'dark': SystemTheme.accentInstance.dark,
      'normal': SystemTheme.accentInstance.accent,
      'light': SystemTheme.accentInstance.light,
      'lighter': SystemTheme.accentInstance.lighter,
      'lightest': SystemTheme.accentInstance.lightest,
    });
  }
  return Colors.blue;
}
