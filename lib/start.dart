import 'package:ffi/ffi.dart' as ffi;
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'kernel.dart';
import 'scl_interface.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    if (GKernel.instance.scl.SCL_queryStep() < step.colorSetReady) {
      return ScaffoldPage(
        header: const PageHeader(
          title: Text('手动导入颜色表'),
        ),
        content: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Card(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '自动查找颜色表文件失败',
                    style: typography.display,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: FilledButton(
                      child: Row(
                        children: const [Icon(FluentIcons.explore_content), Text(' 手动导入颜色表 - 选择颜色表文件夹')],
                      ),
                      onPressed: () async {
                        String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

                        if (selectedDirectory == null) {
                          return;
                        }
                        GKernel.instance.loadColorSet(selectedDirectory);
                        setState(() {});
                        return;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return ScaffoldPage(
      header: const PageHeader(title: Text('开始')),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'SlopeCraft ${GKernel.instance.scl.SCL_getSCLVersion().cast<ffi.Utf8>().toDartString()}',
                    style: typography.display,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Copyright © 2022 TokiNoBug',
                    style: typography.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Card(
                child: ListView(
                  children: [
                    if (GKernel.instance.mapType == mapTypes.Slope)
                      (Text(
                        '立体地图画',
                        style: typography.title,
                      )),
                    if (GKernel.instance.mapType == mapTypes.Flat)
                      (Text(
                        '平板地图画',
                        style: typography.title,
                      )),
                    if (GKernel.instance.mapType == mapTypes.FileOnly)
                      (Text(
                        '纯文件地图画',
                        style: typography.title,
                      )),
                    if (GKernel.instance.mapType == mapTypes.Slope)
                      (Text(
                        '原版生存中画质最高的地图画。183种颜色是坡度起伏的馈赠，也是智慧的灵光闪现。',
                        style: typography.bodyLarge,
                      )),
                    if (GKernel.instance.mapType == mapTypes.Flat)
                      (Text(
                        '最传统的像素画样式，建造起来轻松自如。不过，代价是只有61色的画质。',
                        style: typography.bodyLarge,
                      )),
                    if (GKernel.instance.mapType == mapTypes.FileOnly)
                      (Text(
                        '这是地图画质的极限！244种颜色竭力为你呈现自定义的画面。可惜的是，它需要修改存档。',
                        style: typography.bodyLarge,
                      )),
                    if (GKernel.instance.mapType == mapTypes.FileOnly) (const SizedBox(height: 20.0)),
                    if (GKernel.instance.mapType == mapTypes.FileOnly)
                      (Text(
                        'Not Vanilla!',
                        style: typography.apply(displayColor: Colors.yellow).subtitle,
                        textAlign: TextAlign.center,
                      )),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
            child: RepaintBoundary(
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: RepaintBoundary(
                        child: ToggleButton(
                          child: Row(
                            children: const [Icon(FluentIcons.increase_indent_arrow), Text('创建立体地图画')],
                          ),
                          checked: GKernel.instance.mapType == mapTypes.Slope,
                          onChanged: (value) async {
                            if (value) {
                              GKernel.instance.mapType = mapTypes.Slope;
                              GKernel.instance.index.value = 1;
                              bool cvready = GKernel.instance.scl.SCL_queryStep() >= step.convertionReady;
                              if (GKernel.instance.scl.SCL_queryStep() >= step.wait4Image) {
                                await GKernel.instance.setType(context, true);
                                GKernel.instance.index.value = 2;
                                if (cvready) {
                                  await GKernel.instance.setRawImage(context, true);
                                  GKernel.instance.index.value = 3;
                                }
                              }
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: RepaintBoundary(
                        child: ToggleButton(
                          child: Row(
                            children: const [Icon(FluentIcons.increase_indent_arrow), Text('创建平板地图画')],
                          ),
                          checked: GKernel.instance.mapType == mapTypes.Flat,
                          onChanged: (value) async {
                            if (value) {
                              GKernel.instance.mapType = mapTypes.Flat;
                              GKernel.instance.index.value = 1;
                              bool cvready = GKernel.instance.scl.SCL_queryStep() >= step.convertionReady;
                              if (GKernel.instance.scl.SCL_queryStep() >= step.wait4Image) {
                                await GKernel.instance.setType(context, true);
                                GKernel.instance.index.value = 2;
                                if (cvready) {
                                  await GKernel.instance.setRawImage(context, true);
                                  GKernel.instance.index.value = 3;
                                }
                              }
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: RepaintBoundary(
                        child: ToggleButton(
                          child: Row(
                            children: const [Icon(FluentIcons.increase_indent_arrow), Text('创建纯文件地图画')],
                          ),
                          checked: GKernel.instance.mapType == mapTypes.FileOnly,
                          onChanged: (value) async {
                            if (value) {
                              GKernel.instance.mapType = mapTypes.FileOnly;
                              GKernel.instance.exportType = ExportType.file;
                              GKernel.instance.index.value = 1;
                              bool cvready = GKernel.instance.scl.SCL_queryStep() >= step.convertionReady;
                              if (GKernel.instance.scl.SCL_queryStep() >= step.wait4Image) {
                                await GKernel.instance.setType(context, true);
                                GKernel.instance.index.value = 2;
                                if (cvready) {
                                  await GKernel.instance.setRawImage(context, true);
                                  GKernel.instance.index.value = 3;
                                }
                              }
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
