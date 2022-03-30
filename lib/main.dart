import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:system_theme/system_theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';
import 'package:ffi/ffi.dart' as ffi;
import 'package:worker_manager/worker_manager.dart' as tp;

import 'about.dart';
import 'convert_map.dart';
import 'cut_tool.dart';
import 'export.dart';
import 'import_picture.dart';
import 'kernel.dart';
import 'set_block_list.dart';
import 'start.dart';
import 'theme.dart';

import 'package:win32/win32.dart';

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

const ID_TEXT = 200;
const ID_EDITTEXT = 201;
const ID_PROGRESS = 202;
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

final hInstance = GetModuleHandle(nullptr);
String textEntered = '';
int dialogReturnProc(int hwndDlg, int message, int wParam, int lParam) {
  switch (message) {
    case WM_INITDIALOG:
      {
        SendDlgItemMessage(hwndDlg, ID_PROGRESS, PBM_SETPOS, 35, 0);
        break;
      }
    case WM_COMMAND:
      {
        EndDialog(hwndDlg, wParam);
        return LOWORD(wParam);
      }
  }

  return FALSE;
}

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  if (TargetPlatform.windows == defaultTargetPlatform) {
    SystemTheme.accentInstance;
  }
  if (isDesktop) {
    await windowManager.ensureInitialized();
    await flutter_acrylic.Window.initialize();

    if (isWindowsVersionOrGreater(10, 0, 22000)) {
      GKernel.instance.osversion = OSVersion.win11;
    } else if (IsWindows10OrGreater() == 1) {
      GKernel.instance.osversion = OSVersion.win10;
    } else {
      GKernel.instance.osversion = OSVersion.win7;
    }
    if (GKernel.instance.osversion == OSVersion.win11) {
      await flutter_acrylic.Window.setEffect(effect: flutter_acrylic.WindowEffect.acrylic, dark: await SystemTheme.darkMode);
    } else if (GKernel.instance.osversion == OSVersion.win10) {
      await flutter_acrylic.Window.setEffect(effect: flutter_acrylic.WindowEffect.disabled, dark: await SystemTheme.darkMode);
    } else {
      await flutter_acrylic.Window.setEffect(effect: flutter_acrylic.WindowEffect.aero, dark: await SystemTheme.darkMode);
    }

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
  for (int i = 0; i < 8; i++) {
    await GKernel.instance.loadColorSetCPU(path.join(GKernel.instance.current, dataPrefix), i);
  }
  File fb = File(path.join(GKernel.instance.current, dataPrefix, 'Blocks.json'));
  await fb.readAsString().then((value) {
    GKernel.instance.blockListManager.importBlocks(value);
    GKernel.instance.blockListManager.uesPreset(blocklists[2].set);
  });
  GKernel.instance.blockListManager.loadTexture(folderPath: path.join(GKernel.instance.current, dataPrefix, 'Texture'));
  GKernel.instance.blockListManager.select(baseColor: 0, block: GKernel.instance.blockListManager.blocks[0]![0]);

  if (DateTime.now().month == DateTime.april && DateTime.now().day == 1) {
    Random random = Random(DateTime.now().millisecondsSinceEpoch);
    if (random.nextInt(3) == 0) {
      Timer(const Duration(seconds: 10), () {
        // Allocate 8KB, which is more than enough space for the dialog in memory.
        final ptr = ffi.calloc<Uint16>(4096);
        var idx = 0;
        Pointer<RECT> rect = ffi.calloc.call();
        GetWindowRect(hInstance, rect);

        idx += ptr.elementAt(idx).cast<DLGTEMPLATE>().setDialog(
            style: WS_POPUP | WS_BORDER | WS_SYSMENU | DS_MODALFRAME | DS_SETFONT | WS_CAPTION,
            title: 'SlopeCraft Compile time error',
            cdit: 4,
            cx: 360,
            cy: 80,
            x: (GetSystemMetrics(SM_CXSCREEN) ~/ 2 - (rect.ref.right - rect.ref.left)) ~/ 2,
            y: (GetSystemMetrics(SM_CYSCREEN) ~/ 2 - (rect.ref.bottom - rect.ref.top)) ~/ 2,
            fontName: 'MS Shell Dlg',
            fontSize: 8);
        idx += ptr.elementAt(idx).cast<DLGITEMTEMPLATE>().setDialogItem(
            style: WS_CHILD | WS_VISIBLE | WS_TABSTOP | BS_DEFPUSHBUTTON,
            x: 80,
            y: 60,
            cx: 50,
            cy: 14,
            id: IDOK,
            windowSystemClass: 0x0080, // button
            text: 'ReportErr');
        idx += ptr.elementAt(idx).cast<DLGITEMTEMPLATE>().setDialogItem(
            style: WS_CHILD | WS_VISIBLE | WS_TABSTOP | BS_PUSHBUTTON,
            x: 145,
            y: 60,
            cx: 50,
            cy: 14,
            id: IDCONTINUE,
            windowSystemClass: 0x0080, // button
            text: 'OK');
        idx += ptr.elementAt(idx).cast<DLGITEMTEMPLATE>().setDialogItem(
            style: WS_CHILD | WS_VISIBLE | WS_TABSTOP | BS_PUSHBUTTON,
            x: 210,
            y: 60,
            cx: 50,
            cy: 14,
            id: IDCANCEL,
            windowSystemClass: 0x0080, // button
            text: 'Exit');
        idx += ptr.elementAt(idx).cast<DLGITEMTEMPLATE>().setDialogItem(
            style: WS_CHILD | WS_VISIBLE,
            x: 30,
            y: 10,
            cx: 350,
            cy: 40,
            id: ID_TEXT,
            windowSystemClass: 0x0082, // static
            text:
                'Cannot find handx128.dll: Hardware not invented.\n\nSLOPECRAFT_FAILED_TO HAVE_A_HANDSHAKE_WITH_YOU\nHAVE_A_NICE_DAY_DONT_REPORT_THIS_AS_AN_ERROR_ITS_JUST_A_JOKE.');

        final lpDialogFunc = Pointer.fromFunction<DlgProc>(dialogReturnProc, 0);

        final nResult = DialogBoxIndirectParam(hInstance, ptr.cast<DLGTEMPLATE>(), NULL, lpDialogFunc, 0);

        if (nResult == IDOK) {
          launch('https://github.com/ToKiNoBug/SlopeCraft/issues');
        }
        free(ptr);
      });
    }
  }

  tp.Executor().warmUp(isolatesCount: 8);
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
                  // backgroundColor: Colors.transparent,
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

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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

    return const SizedBox(
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
