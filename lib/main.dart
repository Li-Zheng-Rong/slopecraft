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
import 'export.dart';
import 'import_picture.dart';
import 'kernel.dart';
import 'set_block_list.dart';
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
  SystemTheme.accentInstance;

  if (isDesktop) {
    await flutter_acrylic.Window.initialize();
    await WindowManager.instance.ensureInitialized();
    windowManager.waitUntilReadyToShow().then((_) async {
      await windowManager.setTitleBarStyle('hidden', windowButtonVisibility: false);
      await windowManager.setSize(const Size(755, 545));
      await windowManager.setMinimumSize(const Size(755, 545));
      await windowManager.center();
      await windowManager.show();
      // await windowManager.setPreventClose(true);
      await windowManager.setSkipTaskbar(false);
    });
  }
  //create kernel
  GKernel.instance.loadColorSet(path.join(GKernel.instance.current, dataPrefix));
  File fb = File(path.join(GKernel.instance.current, dataPrefix, 'Blocks.json'));
  await fb.readAsString().then((value) {
    GKernel.instance.blockListManager.importBlocks(value);
  });
  await GKernel.instance.blockListManager.loadTexture(folderPath: path.join(GKernel.instance.current, dataPrefix, 'Texture'));
  GKernel.instance.blockListManager.select(baseColor: 0, block: GKernel.instance.blockListManager.blocks[0]![0]);

  GKernel.instance.blockListManager.uesPreset(blocklists[2].set);
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
              child: child!,
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
  int index = 0;

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
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    final appTheme = context.watch<AppTheme>();
    return NavigationView(
      appBar: NavigationAppBar(
        title: () {
          if (kIsWeb) return const Text(appTitle);
          return const DragToMoveArea(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(appTitle),
            ),
          );
        }(),
        actions: kIsWeb
            ? null
            : DragToMoveArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [Spacer(), WindowButtons()],
                ),
              ),
        automaticallyImplyLeading: true,
      ),
      pane: NavigationPane(
        selected: index,
        onChanged: (i) => setState(() => index = i),
        size: const NavigationPaneSize(
          openMinWidth: 200,
          openMaxWidth: 250,
        ),
        displayMode: appTheme.displayMode,
        header: Container(
          height: kOneLineTileHeight,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text('SlopeCraft', style: typography.title),
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
        ],
        footerItems: [
          PaneItemSeparator(),
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
        index: index,
        children: const [
          Start(),
          SetBlockList(),
          ImportPicture(),
          ConvertMap(),
          Export(),
          About(),
        ],
      ),
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
      height: 50,
      child: RepaintBoundary(
        child: WindowCaption(
          brightness: theme.brightness,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
