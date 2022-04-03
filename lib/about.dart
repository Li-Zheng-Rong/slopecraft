import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';
import 'theme.dart';
import 'kernel.dart';

bool get kIsWindowEffectsSupported {
  return !kIsWeb &&
      [
        TargetPlatform.windows,
        TargetPlatform.linux,
        TargetPlatform.macOS,
      ].contains(defaultTargetPlatform);
}

const _LinuxWindowEffects = [
  WindowEffect.disabled,
  WindowEffect.transparent,
];

const _WindowsWindowEffects = [
  WindowEffect.disabled,
  WindowEffect.solid,
  WindowEffect.transparent,
  WindowEffect.aero,
  WindowEffect.acrylic,
  WindowEffect.mica,
  WindowEffect.tabbed,
];

const _MacosWindowEffects = [
  WindowEffect.disabled,
  WindowEffect.titlebar,
  WindowEffect.selection,
  WindowEffect.menu,
  WindowEffect.popover,
  WindowEffect.sidebar,
  WindowEffect.headerView,
  WindowEffect.sheet,
  WindowEffect.windowBackground,
  WindowEffect.hudWindow,
  WindowEffect.fullScreenUI,
  WindowEffect.toolTip,
  WindowEffect.contentBackground,
  WindowEffect.underWindowBackground,
  WindowEffect.underPageBackground,
];

List<WindowEffect> get currentWindowEffects {
  if (kIsWeb) return [];

  if (defaultTargetPlatform == TargetPlatform.windows) {
    return _WindowsWindowEffects;
  } else if (defaultTargetPlatform == TargetPlatform.linux) {
    return _LinuxWindowEffects;
  } else if (defaultTargetPlatform == TargetPlatform.macOS) {
    return _MacosWindowEffects;
  }

  return [];
}

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    assert(debugCheckHasMediaQuery(context));
    final appTheme = context.watch<AppTheme>();
    return ScaffoldPage(
      header: const PageHeader(title: Text('关于')),
      content: Padding(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '感谢你使用 SlopeCraft。',
                    style: typography.body,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '我是开发者 TokiNoBug 。 SlopeCraft 是由我开发的一款立体地图画生成器，主要用于在 Minecraft 中制造可以生存实装的立体地图画（同样支持传统的平板地图画）。立体地图画的优势在于拥有更高的“画质”，此处不再详述。\n我是开发者 PopChrono ，这一代 SlopeCraft 的界面由我制作。感谢 TokiNoBug 对我的支持和帮助，使这个项目成为可能。 SlopeCraft 是一个强大的工具，耗费了大量时间进行开发，而我只是给这个工具锦上添花而已。',
                    style: typography.body,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '你正在使用的是 SlopeCraft 的第四代版本，在开发时使用了 zlib 和 Eigen ，对上述库的开发者表示感谢。也感谢 Mojang ，整个软件就是为 Minecraft 而设计的。\nSlopeCraft 遵循 GPL-3.0 及以后版本 (GPL-3.0 or later) 协议开放源代码。',
                    style: typography.body,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '窗口效果',
                      style: FluentTheme.of(context).typography.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    RadioButton(
                      checked: appTheme.windowEffect == WindowEffect.disabled,
                      onChanged: (val) {
                        if (val) {
                          appTheme.windowEffect = WindowEffect.disabled;
                          appTheme.setEffect(WindowEffect.disabled, context);
                        }
                      },
                      content: const Text('无效果'),
                    ),
                    const SizedBox(height: 8),
                    RadioButton(
                      checked: appTheme.windowEffect == WindowEffect.acrylic,
                      onChanged: GKernel.instance.osversion == OSVersion.win11
                          ? (val) {
                              if (val) {
                                appTheme.windowEffect = WindowEffect.acrylic;
                                appTheme.setEffect(WindowEffect.acrylic, context);
                              }
                            }
                          : null,
                      content: const Text('Acrylic   (Windows 11)'),
                    ),
                    const SizedBox(height: 8),
                    RadioButton(
                      checked: appTheme.windowEffect == WindowEffect.mica,
                      onChanged: GKernel.instance.osversion == OSVersion.win11
                          ? (val) {
                              if (val) {
                                appTheme.windowEffect = WindowEffect.mica;
                                appTheme.setEffect(WindowEffect.mica, context);
                              }
                            }
                          : null,
                      content: const Text('Mica      (Windows 11)'),
                    ),
                    const SizedBox(height: 8),
                    RadioButton(
                      checked: appTheme.windowEffect == WindowEffect.tabbed,
                      onChanged: GKernel.instance.osversion == OSVersion.win11
                          ? (val) {
                              if (val) {
                                appTheme.windowEffect = WindowEffect.tabbed;
                                appTheme.setEffect(WindowEffect.tabbed, context);
                              }
                            }
                          : null,
                      content: const Text('Tabbed  (Windows 11)'),
                    ),
                    const SizedBox(height: 8),
                    RadioButton(
                      checked: appTheme.windowEffect == WindowEffect.aero,
                      onChanged: GKernel.instance.osversion == OSVersion.win7
                          ? (val) {
                              if (val) {
                                appTheme.windowEffect = WindowEffect.aero;
                                appTheme.setEffect(WindowEffect.aero, context);
                              }
                            }
                          : null,
                      content: const Text('Aero      (Windows 7) 可能无效'),
                    ),
                    const SizedBox(height: 8),
                    RadioButton(
                      checked: appTheme.windowEffect == WindowEffect.transparent,
                      onChanged: (val) {
                        if (val) {
                          appTheme.windowEffect = WindowEffect.transparent;
                          appTheme.setEffect(WindowEffect.transparent, context);
                        }
                      },
                      content: const Text('Transparent'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            RepaintBoundary(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Button(
                      child: const Text('联系作者'),
                      onPressed: () async {
                        launch('https://github.com/ToKiNoBug/SlopeCraft');
                        launch('https://space.bilibili.com/351429231');
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Button(
                      child: const Text('退出'),
                      onPressed: () {
                        Navigator.pop(context);
                        windowManager.destroy();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
