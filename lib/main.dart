import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';

import 'about.dart';
import 'convert_map.dart';
import 'cut_tool.dart';
import 'export.dart';
import 'import_picture.dart';
import 'kernel.dart';
import 'set_block_list.dart';
import 'settings.dart';
import 'start.dart';
import 'theme.dart';

const String appTitle = 'SlopeCraft';

/// Checks if the current environment is a desktop environment.
bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (TargetPlatform.windows == defaultTargetPlatform) {
    SystemTheme.accentInstance;
  }

  if (isDesktop) {
    await flutter_acrylic.Window.initialize();
    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      // await windowManager.setTitleBarStyle(TitleBarStyle.hidden, windowButtonVisibility: false);
      await windowManager.setSize(const Size(1000, 610));
      await windowManager.setMinimumSize(const Size(1000, 610));
      await windowManager.center();
      // await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
      await windowManager.show();
    });
  }
  //create kernel
  await GKernel.instance.loadColorSet(path.join(GKernel.instance.current, dataPrefix));
  File fb = File(path.join(GKernel.instance.current, dataPrefix, 'Blocks.json'));
  await fb.readAsString().then((value) {
    GKernel.instance.blockListManager.importBlocks(value);
    GKernel.instance.blockListManager.uesPreset(blocklists[2].set);
  });
  GKernel.instance.blockListManager.loadTexture(folderPath: path.join(GKernel.instance.current, dataPrefix, 'Texture'));
  GKernel.instance.blockListManager.select(baseColor: 0, block: GKernel.instance.blockListManager.blocks[0]![0]);

  // if (DateTime.now().month == DateTime.april && DateTime.now().day == 1) {
  //   Random random = Random(DateTime.now().millisecondsSinceEpoch);
  //   if (random.nextInt(3) == 0) {
  //     Timer(const Duration(seconds: 10), () {
  //       runCmd(ProcessCmd('imageCutter_tricky/imageCutter.exe', ['a']));
  //     });
  //   }
  // }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp(
          title: appTitle,
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {'/': (_) => const MyHomePage()},
          color: appTheme.color,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          theme: ThemeData(
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          builder: (context, child) {
            return Directionality(
              textDirection: appTheme.textDirection,
              child: NavigationPaneTheme(
                data: NavigationPaneThemeData(
                  backgroundColor: appTheme.windowEffect != flutter_acrylic.WindowEffect.disabled ? Colors.transparent : null,
                ),
                child: child!,
              ),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowFocus() {
    // Make sure to call once.
    setState(() {});
    // do something
  }

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    final appTheme = context.watch<AppTheme>();
    return ValueListenableBuilder(
      valueListenable: GKernel.instance.index,
      builder: (context, value, child) {
        return NavigationView(
          appBar: const NavigationAppBar(
            height: 25,
            automaticallyImplyLeading: false,
          ),
          pane: NavigationPane(
            selected: GKernel.instance.index.value,
            onChanged: (i) => setState(() => GKernel.instance.index.value = i),
            size: const NavigationPaneSize(
              openMinWidth: 150,
              openMaxWidth: 200,
            ),
            displayMode: appTheme.displayMode,
            header: Container(
              height: kOneLineTileHeight,
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Text('SlopeCraft BETA', style: typography.title),
              ),
            ),
            items: [
              PaneItem(
                icon: const Icon(FluentIcons.task_add),
                title: const Text('开始'),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.registry_editor),
                title: const Text('方块列表'),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.picture_center),
                title: const Text('导入图片'),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.blur),
                title: const Text('调整颜色'),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.view_in_a_r),
                title: const Text('导出'),
              ),
              PaneItemSeparator(),
              PaneItem(
                icon: const Icon(FluentIcons.toolbox),
                title: const Text('图像工具'),
              ),
            ],
            footerItems: [
              PaneItemSeparator(),
              PaneItem(
                icon: const Icon(FluentIcons.settings),
                title: const Text('设置'),
              ),
              PaneItem(
                icon: const Icon(FluentIcons.info),
                title: const Text('关于'),
              ),
            ],
          ),
          content: NavigationBody(
            transitionBuilder: (child, animation) {
              return DrillInPageTransition(child: child, animation: animation);
            },
            index: GKernel.instance.index.value,
            children: const [
              Start(),
              SetBlockList(),
              ImportPicture(),
              ConvertMap(),
              Export(),
              CutTool(),
              Settings(),
              About(),
            ],
          ),
        );
      },
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 10,
      // child: RepaintBoundary(
      //   child: WindowCaption(
      //     brightness: theme.brightness,
      //     backgroundColor: Colors.transparent,
      //   ),
      // ),
    );
  }
}
