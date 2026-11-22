library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum TitleBarStyle { normal, hidden }

enum WindowEffect { none, blur, mica, glass }

enum WindowSignal {
  close,
  maximize,
  unmaximize,
  minimize,
  restore,
  geometryChanged,
  enterFullScreen,
  leaveFullScreen,
  shouldTerminate,
  activate,
  lifecycleHidden,
  lifecycleInactive,
  lifecycleResumed,
}

enum WindowEvent {
  close,
  maximize,
  unmaximize,
  minimize,
  restore,
  geometryChanged,
  enterFullScreen,
  leaveFullScreen,
  shouldTerminate,
  activate,
}

@immutable
class DesktopDisplay {
  const DesktopDisplay({
    required this.bounds,
    required this.workArea,
    this.scaleFactor = 1,
    this.isPrimary = false,
  });

  final Rect bounds;
  final Rect workArea;
  final double scaleFactor;
  final bool isPrimary;
}

abstract mixin class WindowListener {
  void onWindowClose() {}
  void onWindowMaximize() {}
  void onWindowUnmaximize() {}
  void onWindowMinimize() {}
  void onWindowRestore() {}
  void onWindowGeometryChanged() {}
  void onWindowEnterFullScreen() {}
  void onWindowLeaveFullScreen() {}
  void onWindowShouldTerminate() {}
  void onWindowActivate() {}
  void onWindowEvent(WindowEvent event) {}
}

abstract class DesktopWindow {
  DesktopWindow();

  static DesktopWindow _instance = _WebDesktopWindow();
  static DesktopWindow get instance => _instance;
  static set instance(DesktopWindow value) => _instance = value;

  final List<WindowListener> _listeners = [];

  void addListener(WindowListener listener) {
    if (!_listeners.contains(listener)) {
      _listeners.add(listener);
    }
  }

  void removeListener(WindowListener listener) {
    _listeners.remove(listener);
  }

  @protected
  void dispatch(WindowEvent event) {
    for (final listener in List<WindowListener>.from(_listeners)) {
      listener.onWindowEvent(event);
      switch (event) {
        case WindowEvent.close:
          listener.onWindowClose();
          break;
        case WindowEvent.maximize:
          listener.onWindowMaximize();
          break;
        case WindowEvent.unmaximize:
          listener.onWindowUnmaximize();
          break;
        case WindowEvent.minimize:
          listener.onWindowMinimize();
          break;
        case WindowEvent.restore:
          listener.onWindowRestore();
          break;
        case WindowEvent.geometryChanged:
          listener.onWindowGeometryChanged();
          break;
        case WindowEvent.enterFullScreen:
          listener.onWindowEnterFullScreen();
          break;
        case WindowEvent.leaveFullScreen:
          listener.onWindowLeaveFullScreen();
          break;
        case WindowEvent.shouldTerminate:
          listener.onWindowShouldTerminate();
          break;
        case WindowEvent.activate:
          listener.onWindowActivate();
          break;
      }
    }
  }

  Future<void> ensureInitialized();
  Future<void> show();
  Future<void> hide();
  Future<bool> isVisible();
  Future<void> focus();
  Future<void> close();
  Future<void> setPreventClose(bool value);
  Future<bool> isMaximized();
  Future<void> maximize();
  Future<void> unmaximize();
  Future<bool> isMinimized();
  Future<void> minimize();
  Future<bool> isFullScreen();
  Future<void> setFullScreen(bool value);
  Future<Rect> getBounds();
  Future<void> setBounds({Offset? position, Size? size});
  Future<void> setSize(Size size) => setBounds(size: size);
  Future<void> setPosition(Offset position) => setBounds(position: position);
  Future<List<DesktopDisplay>> getDisplays();
  Future<DesktopDisplay?> getPrimaryDisplay() async {
    final displays = await getDisplays();
    if (displays.isEmpty) return null;
    return displays.firstWhere(
      (d) => d.isPrimary,
      orElse: () => displays.first,
    );
  }

  Future<Offset> getCursorPosition();
  Future<bool> isPositionSupported();
  Future<void> setMinimumSize(Size size);
  Future<bool> isAlwaysOnTop();
  Future<void> setAlwaysOnTop(bool value);
  Future<void> setTitleBarStyle(TitleBarStyle style);
  Future<void> setSkipTaskbar(bool value);
  Future<void> setRoundedCorners(bool value);
  Future<bool> isEffectSupported(WindowEffect effect);
  Future<void> setEffect(
    WindowEffect effect, {
    Color? tint,
    Brightness? brightness,
  });
  Future<void> startDragging();
}

DesktopWindow get desktopWindow => DesktopWindow.instance;

class _WebDesktopWindow extends DesktopWindow {
  @override
  Future<void> ensureInitialized() async {}

  @override
  Future<void> show() async {}

  @override
  Future<void> hide() async {}

  @override
  Future<bool> isVisible() async => true;

  @override
  Future<void> focus() async {}

  @override
  Future<void> close() async {}

  @override
  Future<void> setPreventClose(bool value) async {}

  @override
  Future<bool> isMaximized() async => false;

  @override
  Future<void> maximize() async {}

  @override
  Future<void> unmaximize() async {}

  @override
  Future<bool> isMinimized() async => false;

  @override
  Future<void> minimize() async {}

  @override
  Future<bool> isFullScreen() async => false;

  @override
  Future<void> setFullScreen(bool value) async {}

  @override
  Future<Rect> getBounds() async => Rect.zero;

  @override
  Future<void> setBounds({Offset? position, Size? size}) async {}

  @override
  Future<List<DesktopDisplay>> getDisplays() async => const [];

  @override
  Future<Offset> getCursorPosition() async => Offset.zero;

  @override
  Future<bool> isPositionSupported() async => false;

  @override
  Future<void> setMinimumSize(Size size) async {}

  @override
  Future<bool> isAlwaysOnTop() async => false;

  @override
  Future<void> setAlwaysOnTop(bool value) async {}

  @override
  Future<void> setTitleBarStyle(TitleBarStyle style) async {}

  @override
  Future<void> setSkipTaskbar(bool value) async {}

  @override
  Future<void> setRoundedCorners(bool value) async {}

  @override
  Future<bool> isEffectSupported(WindowEffect effect) async => false;

  @override
  Future<void> setEffect(
    WindowEffect effect, {
    Color? tint,
    Brightness? brightness,
  }) async {}

  @override
  Future<void> startDragging() async {}
}
