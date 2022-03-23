import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart' as ffi;
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

import 'kernel.dart';
import 'scl_interface.dart';

class ExportMap extends StatefulWidget {
  const ExportMap({Key? key}) : super(key: key);

  @override
  State<ExportMap> createState() => _ExportMapState();
}

class _ExportMapState extends State<ExportMap> {
  final TextEditingController _showDataRows = TextEditingController();
  final TextEditingController _showDataFileName = TextEditingController();
  final TextEditingController _showDataCounts = TextEditingController();
  final TextEditingController _showDataCols = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    if (GKernel.instance.scl.SCL_queryStep() < step.converted) {
      return ScaffoldPage(
        header: const PageHeader(
          title: Text('导出地图文件'),
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
    if (GKernel.instance.mapIndex.text.isEmpty) {
      GKernel.instance.mapIndex.text = '0';
    }
    int indexStart = int.parse(GKernel.instance.mapIndex.text);
    int mapRows = (GKernel.instance.scl.SCL_getImageRows() / 128).ceil();
    int mapCols = (GKernel.instance.scl.SCL_getImageCols() / 128).ceil();
    _showDataRows.text = mapRows.toString();
    _showDataCols.text = mapCols.toString();
    _showDataCounts.text = (mapRows * mapCols).toString();
    _showDataFileName.text = 'map_$indexStart.dat~map_${indexStart + mapRows * mapCols - 1}.dat';
    return ScaffoldPage(
      header: const PageHeader(
        title: Text('导出地图文件'),
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('地图文件的文件名形如map_3.dat，是minecraft用于存储地图内容的文件。其中3表示地图文件的序号,地图的序号从0开始。', style: typography.body),
                    Text('地图文件存储于存档中的data文件夹下，你需要一定的权限才能修改它们。如果你既不是单机游戏，又不是服主，那你应该选择导出为投影，而不是地图文件。', style: typography.body),
                    Text('每张地图只能显示128×128的画面，大图片可能会有多个地图，对应多个地图文件。它们会占用连续的一段序号。', style: typography.body),
                    Text('例如，你可以使用/give @s filled_map{map:3}来获得map_3.dat的地图。', style: typography.body),
                    Text('1.12版请使用/give @p filled_map 1 3', style: typography.body),
                    Text('这种方法适合以最高画质展示大图片，但不适合服务器。', style: typography.body),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 60,
                    child: RepaintBoundary(
                      child: Row(
                        children: [
                          const Text('地图文件起始序列号'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextBox(
                              controller: GKernel.instance.mapIndex,
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              maxLength: 9,
                              onChanged: (String string) {
                                if (GKernel.instance.mapIndex.text.isEmpty) {
                                  GKernel.instance.mapIndex.text = '0';
                                }
                                int indexStart = int.parse(GKernel.instance.mapIndex.text);
                                int mapRows = (GKernel.instance.scl.SCL_getImageRows() / 128).ceil();
                                int mapCols = (GKernel.instance.scl.SCL_getImageCols() / 128).ceil();
                                _showDataRows.text = mapRows.toString();
                                _showDataCols.text = mapCols.toString();
                                _showDataCounts.text = (mapRows * mapCols).toString();
                                _showDataFileName.text = 'map_$indexStart.dat~map_${indexStart + mapRows * mapCols - 1}.dat';
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Text('地图画行数'),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextBox(
                                controller: _showDataRows,
                                placeholder: '',
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Row(
                          children: [
                            const Text('地图画列数'),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextBox(
                                controller: _showDataCols,
                                placeholder: '',
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                        children: [
                          const Text('地图文件数量'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextBox(
                              controller: _showDataCounts,
                              placeholder: '',
                              readOnly: true,
                            ),
                          ),
                        ],
                      )),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Row(
                        children: [
                          const Text('导出的文件名'),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextBox(
                              controller: _showDataFileName,
                              placeholder: '',
                              readOnly: true,
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(
                  child: Text(''),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 200,
                  child: RepaintBoundary(
                    child: FilledButton(
                        child: const Text('导出！'),
                        onPressed: () async {
                          String? selectedDirectory = await file_picker.FilePicker.platform.getDirectoryPath();

                          if (selectedDirectory == null) {
                            return;
                          }
                          if (GKernel.instance.mapIndex.text.isEmpty) {
                            GKernel.instance.mapIndex.text = '0';
                          }
                          int indexStart = int.parse(GKernel.instance.mapIndex.text);
                          bool ignoreRewrite = false;
                          bool stop = false;
                          for (int i = indexStart; i <= indexStart + mapRows * mapCols - 1; i++) {
                            if (File(path.join(selectedDirectory, 'map_$i.dat')).existsSync() && !ignoreRewrite) {
                              await showDialog(
                                builder: (context) {
                                  return ContentDialog(
                                    title: const Text('警告'),
                                    content: const Text('你要导出的路径下已经存在同名文件。是否要覆盖？(可能导致存档中已绘制的地图被覆盖）'),
                                    actions: [
                                      Button(
                                        child: const Text('确定导出'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          ignoreRewrite = true;
                                        },
                                      ),
                                      FilledButton(
                                        child: const Text('取消导出'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          stop = true;
                                        },
                                      ),
                                    ],
                                  );
                                },
                                context: context,
                              );
                              if (stop) {
                                return;
                              }
                            }
                          }
                          print(path.current);
                          GKernel.instance.scl.SCL_exportAsData('.'.toNativeUtf8().cast(), int.parse(GKernel.instance.mapIndex.text), nullptr, nullptr);
                        }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
