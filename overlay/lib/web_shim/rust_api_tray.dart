library;

import 'dart:async';
import 'dart:typed_data';

enum TrayIconPlacement { leading, trailing }

class TrayImage {
  final String path;
  final List<Uint8List> pngs;
  final bool template;
  final int size;
  final TrayIconPlacement placement;

  const TrayImage({
    required this.path,
    required this.pngs,
    required this.template,
    required this.size,
    required this.placement,
  });
}

enum TrayItemKind { action, checkbox, submenu, separator }

class TrayItem {
  final int id;
  final TrayItemKind kind;
  final String label;
  final String? detail;
  final bool enabled;
  final bool checked;
  final List<TrayItem> items;

  const TrayItem({
    required this.id,
    required this.kind,
    required this.label,
    this.detail,
    required this.enabled,
    required this.checked,
    required this.items,
  });
}

class TrayContent {
  final String id;
  final TrayImage image;
  final String toolTip;
  final String title;
  final List<TrayItem> menu;

  const TrayContent({
    required this.id,
    required this.image,
    required this.toolTip,
    required this.title,
    required this.menu,
  });
}

enum TraySignalKind { iconActivated, menuRequested, itemSelected }

class TraySignal {
  final TraySignalKind kind;
  final int itemId;

  const TraySignal({required this.kind, required this.itemId});
}

enum TrayIconPosition { leading, trailing }

final class TrayIcon {
  const TrayIcon.asset(
    this.asset, {
    this.isTemplate = false,
    this.size = 18,
    this.position = TrayIconPosition.leading,
  });

  final String asset;
  final bool isTemplate;
  final int size;
  final TrayIconPosition position;
}

typedef TrayMenuItemSelectedCallback = void Function();

sealed class TrayMenuItem {
  const TrayMenuItem();
}

final class TrayMenuAction extends TrayMenuItem {
  const TrayMenuAction({
    required this.label,
    this.detail,
    this.enabled = true,
    this.onSelected,
  });

  final String label;
  final String? detail;
  final bool enabled;
  final TrayMenuItemSelectedCallback? onSelected;
}

final class TrayMenuCheckbox extends TrayMenuItem {
  const TrayMenuCheckbox({
    required this.label,
    required this.checked,
    this.detail,
    this.enabled = true,
    this.onSelected,
  });

  final String label;
  final bool checked;
  final String? detail;
  final bool enabled;
  final TrayMenuItemSelectedCallback? onSelected;
}

final class TrayMenuSubmenu extends TrayMenuItem {
  const TrayMenuSubmenu({
    required this.label,
    required this.items,
    this.detail,
    this.enabled = true,
  });

  final String label;
  final List<TrayMenuItem> items;
  final String? detail;
  final bool enabled;
}

final class TrayMenuSeparator extends TrayMenuItem {
  const TrayMenuSeparator();
}

final class TraySpec {
  const TraySpec({required this.icon, this.toolTip = '', this.menu = const []});

  final TrayIcon icon;
  final String toolTip;
  final List<TrayMenuItem> menu;
}

sealed class TrayEvent {
  const TrayEvent();
}

final class TrayIconActivated extends TrayEvent {
  const TrayIconActivated();
}

final class TrayMenuRequested extends TrayEvent {
  const TrayMenuRequested();
}

final class TrayMenuItemSelected extends TrayEvent {
  const TrayMenuItemSelected(this.item);

  final TrayMenuItem item;
}

final class TrayCapabilities {
  const TrayCapabilities({
    required this.supported,
    required this.title,
    required this.toolTip,
    required this.iconEvents,
    required this.menuControl,
  });

  final bool supported;
  final bool title;
  final bool toolTip;
  final bool iconEvents;
  final bool menuControl;

  static const TrayCapabilities none = TrayCapabilities(
    supported: false,
    title: false,
    toolTip: false,
    iconEvents: false,
    menuControl: false,
  );

  static TrayCapabilities of(dynamic platform) => none;
}

final class Tray {
  Tray._();

  static final Tray instance = Tray._();

  Stream<TrayEvent> get events => const Stream<TrayEvent>.empty();
  TrayCapabilities get capabilities => TrayCapabilities.none;
  bool get isVisible => false;

  Future<void> show(TraySpec spec) async {}
  Future<void> setTitle(String title) async {}
  Future<void> hide() async {}
  Future<void> openMenu() async {}
  void resetForTesting([dynamic host]) {}
}
