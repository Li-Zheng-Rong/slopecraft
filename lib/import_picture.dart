import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart' as path;
import 'package:desktop_drop/desktop_drop.dart';
import 'package:cross_file/cross_file.dart';

import 'kernel.dart';
import 'scl_interface.dart';

class ImportPicture extends StatefulWidget {
  const ImportPicture({Key? key}) : super(key: key);

  @override
  State<ImportPicture> createState() => _ImportPictureState();
}

class _ImportPictureState extends State<ImportPicture> {
  int _voidPRadioButtons = 0;
  final List<String> voidPRadioButtons = <String>[
    '替换为背景色',
    '替换为空气',
  ];
  int _voidARadioButtons = 1;
  final List<String> voidARadioButtons = <String>[
    '替换为背景色',
    '与背景色叠加',
    '保留颜色',
  ];
  // ignore: non_constant_identifier_names
  int _BGCCurrentIndex = 1;
  // ignore: non_constant_identifier_names
  final List<String> BGCRadioButtons = <String>[
    '纯白 #FFFFFF',
    '高级灰 #DCDCDC',
    // '自定义',
  ];
  final List<XFile> _list = [];
  bool _dragging = false;

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    if (GKernel.instance.scl.SCL_queryStep() < step.wait4Image) {
      return ScaffoldPage(
        header: const PageHeader(
          title: Text('导入图片'),
        ),
        content: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Card(
              child: Center(
            child: Text(
              '无法跳步操作',
              style: typography.display,
            ),
          )),
        ),
      );
    }
    if (GKernel.instance.scl_pureTpPixelSt == SCL_PureTpPixelSt.ReplaceWithBackGround) {
      _voidPRadioButtons = 0;
    } else if (GKernel.instance.scl_pureTpPixelSt == SCL_PureTpPixelSt.ReserveAsAir) {
      _voidPRadioButtons = 1;
    }

    if (GKernel.instance.scl_halfTpPixelSt == SCL_HalfTpPixelSt.ReplaceWithBackGround_) {
      _voidARadioButtons = 0;
    } else if (GKernel.instance.scl_halfTpPixelSt == SCL_HalfTpPixelSt.ComposeWithBackGround) {
      _voidARadioButtons = 1;
    } else if (GKernel.instance.scl_halfTpPixelSt == SCL_HalfTpPixelSt.IgnoreAlpha) {
      _voidARadioButtons = 2;
    }
    if (GKernel.instance.backgroundColor == const Color.fromARGB(255, 255, 255, 255)) {
      _BGCCurrentIndex = 0;
    } else if (GKernel.instance.backgroundColor == const Color.fromARGB(255, 220, 220, 220)) {
      _BGCCurrentIndex = 1;
    }
    return ScaffoldPage(
      header: const PageHeader(title: Text('导入图片')),
      content: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Card(
                child: DropTarget(
                  onDragDone: (detail) async {
                    setState(() {
                      // _list.addAll(detail.files);
                      if (detail.files.length == 1) {
                        if (['.png', '.bmp', '.jpeg', '.jpg', '.tga', '.webp', '.tiff'].contains(path.extension(detail.files[0].path))) {
                          GKernel.instance.importImage(context, detail.files[0].path);
                        } else {
                          showDialog(
                            builder: (context) {
                              return ContentDialog(
                                title: const Text('导入图片'),
                                content: const Text('请选择一个图片'),
                                actions: [
                                  SizedBox(
                                    width: 150,
                                    child: Button(
                                        child: const Text('确定'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        }),
                                  ),
                                ],
                              );
                            },
                            context: context,
                          );
                        }
                      } else {
                        showDialog(
                          builder: (context) {
                            return ContentDialog(
                              title: const Text('导入图片'),
                              content: const Text('请选择一个图片'),
                              actions: [
                                SizedBox(
                                  width: 150,
                                  child: Button(
                                      child: const Text('确定'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                ),
                              ],
                            );
                          },
                          context: context,
                        );
                      }
                    });
                  },
                  onDragUpdated: (details) {
                    setState(() {});
                  },
                  onDragEntered: (detail) {
                    setState(() {
                      _dragging = true;
                    });
                  },
                  onDragExited: (detail) {
                    setState(() {
                      _dragging = false;
                    });
                  },
                  child: GKernel.instance.picture.existsSync()
                      ? Image(
                          image: FileImage(GKernel.instance.picture),
                          fit: BoxFit.contain,
                        )
                      : (_dragging
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(FluentIcons.open_file),
                                Text('导入'),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(FluentIcons.add),
                                Text('拖放或点击"导入图片"'),
                              ],
                            )),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '第二步，点击“导入图片“按钮，选择你要制作为地图画的图片。',
                            style: typography.bodyLarge,
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            '图片的长宽（以像素为单位）最好是128的整倍数。',
                            style: typography.bodyLarge,
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            '如果要生存实装，那么图片不要太大，我推荐128×128或者256×256。',
                            style: typography.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RepaintBoundary(
                          child: FilledButton(
                            child: Row(
                              children: const [Icon(FluentIcons.explore_content), Text(' 导入图片')],
                            ),
                            onPressed: () async {
                              FilePickerResult? result = await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  dialogTitle: '选择图片',
                                  lockParentWindow: true,
                                  allowedExtensions: ['png', 'bmp', 'jpeg', 'jpg', 'tga', 'webp', 'tiff']);
                              //if user cancelled
                              if (result == null) return;
                              GKernel.instance.importImage(context, result.files.single.path.toString());
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        RepaintBoundary(
                          child: Button(
                            child: Row(
                              children: const [
                                Icon(FluentIcons.settings),
                                Text(' 设置'),
                              ],
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return ContentDialog(
                                        constraints: const BoxConstraints(maxWidth: 600),
                                        title: const Text('纯透明像素处理策略'),
                                        content: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: RepaintBoundary(
                                                      child: Card(
                                                        child: SizedBox(
                                                          height: 110.0,
                                                          child: InfoLabel(
                                                            label: '纯透明像素',
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: List.generate(voidPRadioButtons.length, (index) {
                                                                return SizedBox(
                                                                  height: 27.0,
                                                                  child: RadioButton(
                                                                    checked: _voidPRadioButtons == index,
                                                                    onChanged: (value) {
                                                                      setState(() => _voidPRadioButtons = index);
                                                                    },
                                                                    content: Text(voidPRadioButtons[index]),
                                                                  ),
                                                                );
                                                              }),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10.0),
                                                  Expanded(
                                                    child: RepaintBoundary(
                                                      child: Card(
                                                        child: SizedBox(
                                                          height: 110.0,
                                                          child: InfoLabel(
                                                            label: '半透明像素',
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: List.generate(voidARadioButtons.length, (index) {
                                                                return SizedBox(
                                                                  height: 27.0,
                                                                  child: RadioButton(
                                                                    checked: _voidARadioButtons == index,
                                                                    onChanged: (value) {
                                                                      setState(() => _voidARadioButtons = index);
                                                                    },
                                                                    content: Text(voidARadioButtons[index]),
                                                                  ),
                                                                );
                                                              }),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10.0),
                                                  Expanded(
                                                    child: RepaintBoundary(
                                                      child: Card(
                                                        child: SizedBox(
                                                          height: 110.0,
                                                          child: InfoLabel(
                                                            label: '背景色',
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                              children: List.generate(BGCRadioButtons.length, (index) {
                                                                return SizedBox(
                                                                  height: 27.0,
                                                                  child: RadioButton(
                                                                    checked: _BGCCurrentIndex == index,
                                                                    onChanged: (value) {
                                                                      setState(() => _BGCCurrentIndex = index);
                                                                    },
                                                                    content: Text(BGCRadioButtons[index]),
                                                                  ),
                                                                );
                                                              }),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 10.0),
                                              Card(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '地图画中几乎不能使用透明像素。立体地图画和平板地图画都不能实现纯透明像素，纯文件地图画虽然理论上支持透明像素，但只会透出地图/物品展示框的背景色。因此有必要对透明/半透明像素进行处理。',
                                                      style: typography.body,
                                                    ),
                                                    const SizedBox(height: 4.0),
                                                    Text(
                                                      '“替换为背景色”会将像素替换为背景色；“替换为空气”将像素替换为空气。',
                                                      style: typography.body,
                                                    ),
                                                    const SizedBox(height: 4.0),
                                                    Text(
                                                      '“与背景色叠加”会按照像素的透明度与背景色叠加；“保留颜色”会忽视半透明像素的透明度，直接使用它们的颜色。',
                                                      style: typography.body,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 10.0),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: RepaintBoundary(
                                                  child: FilledButton(
                                                    child: const Text('确定'),
                                                    onPressed: () async {
                                                      if (_voidPRadioButtons == 0) {
                                                        GKernel.instance.scl_pureTpPixelSt = SCL_PureTpPixelSt.ReplaceWithBackGround;
                                                      } else if (_voidPRadioButtons == 1) {
                                                        GKernel.instance.scl_pureTpPixelSt = SCL_PureTpPixelSt.ReserveAsAir;
                                                      }

                                                      if (_voidARadioButtons == 0) {
                                                        GKernel.instance.scl_halfTpPixelSt = SCL_HalfTpPixelSt.ReplaceWithBackGround_;
                                                      } else if (_voidARadioButtons == 1) {
                                                        GKernel.instance.scl_halfTpPixelSt = SCL_HalfTpPixelSt.ComposeWithBackGround;
                                                      } else if (_voidARadioButtons == 2) {
                                                        GKernel.instance.scl_halfTpPixelSt = SCL_HalfTpPixelSt.IgnoreAlpha;
                                                      }

                                                      if (_BGCCurrentIndex == 0) {
                                                        GKernel.instance.backgroundColor = const Color.fromARGB(255, 255, 255, 255);
                                                      } else if (_BGCCurrentIndex == 1) {
                                                        GKernel.instance.backgroundColor = const Color.fromARGB(255, 220, 220, 220);
                                                      }
                                                      if (GKernel.instance.rawImage != null) {
                                                        await GKernel.instance.setRawImage(context, false);
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Expanded(
                                                child: RepaintBoundary(
                                                  child: Button(
                                                    child: const Text('取消'),
                                                    onPressed: () {
                                                      if (GKernel.instance.scl_pureTpPixelSt == SCL_PureTpPixelSt.ReplaceWithBackGround) {
                                                        _voidPRadioButtons = 0;
                                                      } else if (GKernel.instance.scl_pureTpPixelSt == SCL_PureTpPixelSt.ReserveAsAir) {
                                                        _voidPRadioButtons = 1;
                                                      }

                                                      if (GKernel.instance.scl_halfTpPixelSt == SCL_HalfTpPixelSt.ReplaceWithBackGround_) {
                                                        _voidARadioButtons = 0;
                                                      } else if (GKernel.instance.scl_halfTpPixelSt == SCL_HalfTpPixelSt.ComposeWithBackGround) {
                                                        _voidARadioButtons = 1;
                                                      } else if (GKernel.instance.scl_halfTpPixelSt == SCL_HalfTpPixelSt.IgnoreAlpha) {
                                                        _voidARadioButtons = 2;
                                                      }

                                                      if (GKernel.instance.backgroundColor == const Color.fromARGB(255, 255, 255, 255)) {
                                                        _BGCCurrentIndex = 0;
                                                      } else if (GKernel.instance.backgroundColor == const Color.fromARGB(255, 220, 220, 220)) {
                                                        _BGCCurrentIndex = 1;
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Expanded(
                                                child: RepaintBoundary(
                                                  child: Button(
                                                    child: const Text('恢复默认设定'),
                                                    onPressed: () {
                                                      setState(() {
                                                        _voidPRadioButtons = 0;
                                                        _voidARadioButtons = 1;
                                                        _BGCCurrentIndex = 1;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
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
