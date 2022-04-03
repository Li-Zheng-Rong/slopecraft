import 'dart:ffi';
import 'dart:io';

import 'package:enough_convert/enough_convert.dart';
import 'package:ffi/ffi.dart' as ffi;
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:worker_manager/worker_manager.dart' as tp;
import 'package:image/image.dart' as img;

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
    if (GKernel.instance.multiMode) {
      return ScaffoldPage(
        header: PageHeader(
          title: const Text('导出地图文件-批量模式'),
          commandBar: Row(
            children: [
              SizedBox(
                width: 100,
                child: Checkbox(
                  checked: GKernel.instance.verbose,
                  content: const Text('进度显示'),
                  onChanged: (val) {
                    GKernel.instance.verbose = val!;
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 200,
                child: Checkbox(
                  checked: !GKernel.instance.multiSingleThread,
                  content: const Text('启用多线程（实验性）'),
                  onChanged: (val) {
                    GKernel.instance.multiSingleThread = !(val!);
                    setState(() {});
                  },
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 100,
                child: RepaintBoundary(
                  child: Combobox<int>(
                    placeholder: const Text('线程数'),
                    isExpanded: true,
                    items: [1, 2, 3, 4, 5, 6, 7, 8]
                        .map(
                          (e) => ComboboxItem<int>(
                            value: e,
                            child: Text('$e'),
                          ),
                        )
                        .toList(),
                    value: GKernel.instance.threads,
                    onChanged: (value) {
                      if (value != null) setState(() => GKernel.instance.threads = value);
                    },
                  ),
                ),
              ),
            ],
          ),
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
                      Text('地图文件的文件名形如map_3.dat，是minecraft用于存储地图内容的文件。其中3表示地图文件的序号,地图的序号从0开始。', style: typography.bodyLarge),
                      Text('地图文件存储于存档中的data文件夹下，你需要一定的权限才能修改它们。如果你既不是单机游戏，又不是服主，那你应该选择导出为投影，而不是地图文件。', style: typography.bodyLarge),
                      Text('每张地图只能显示128×128的画面，大图片可能会有多个地图，对应多个地图文件。它们会占用连续的一段序号。', style: typography.bodyLarge),
                      Text('例如，你可以使用/give @s filled_map{map:3}来获得map_3.dat的地图。', style: typography.bodyLarge),
                      Text('1.12版请使用/give @p filled_map 1 3', style: typography.bodyLarge),
                      Text('这种方法适合以最高画质展示大图片，但不适合服务器。', style: typography.bodyLarge),
                      const SizedBox(height: 5),
                      Text('文件将会导出到图片所在路径与文件同名的文件夹下。', style: typography.bodyLarge),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder(
                      valueListenable: GKernel.instance.multiProgress,
                      builder: (context, value, child) {
                        return RepaintBoundary(
                          child: Card(
                            child: ProgressBar(
                              value: GKernel.instance.multiProgress.value,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: RepaintBoundary(
                      child: ValueListenableBuilder(
                          valueListenable: GKernel.instance.multiProgress,
                          builder: (context, value, child) {
                            return FilledButton(
                                child: const Text('导出！'),
                                onPressed: GKernel.instance.building.value
                                    ? null
                                    : () async {
                                        GKernel.instance.building.value = true;
                                        setState(() {});
                                        // var t0 = DateTime.now();
                                        String? selectedDirectory = await file_picker.FilePicker.platform.getDirectoryPath();

                                        if (selectedDirectory == null) {
                                          return;
                                        }
                                        GKernel.instance.mapdir = selectedDirectory;
                                        if (GKernel.instance.multiSingleThread) {
                                          GKernel.instance.mapid = 0;
                                          if (!GKernel.instance.verbose) {
                                            GKernel.instance.multiProgress.value = null;
                                          }
                                          int total = GKernel.instance.multiRaw.length + GKernel.instance.multiDir.length;
                                          for (int i = 0; i < GKernel.instance.multiRaw.length; i++) {
                                            int id = GKernel.instance.mapid;
                                            int wid = 0, hei = 0;
                                            if (GKernel.instance.exportType == ExportType.file) {
                                              String p = GKernel.instance.multiRaw[i];
                                              List<int> f = File(p).readAsBytesSync();
                                              img.Image? r = img.decodeNamedImage(f, path.extension(p));
                                              if (r != null) {
                                                hei = (r.height / 128).ceil();
                                                wid = (r.width / 128).ceil();
                                                GKernel.instance.mapid += hei * wid;
                                              } else {
                                                GKernel.instance.multiFail.add(p);
                                              }
                                            }
                                            var r = await tp.Executor().execute(
                                                fun1: exportMultiSingle,
                                                arg1: ExportMultiArgs(
                                                    cpuid: -1,
                                                    convertMethod: GKernel.instance.convertMethod,
                                                    p: GKernel.instance.multiRaw[i],
                                                    scl_halfTpPixelSt: GKernel.instance.scl_halfTpPixelSt,
                                                    scl_pureTpPixelSt: GKernel.instance.scl_pureTpPixelSt,
                                                    dithering: GKernel.instance.dithering,
                                                    liteName: GKernel.instance.liteName.text,
                                                    liteAuthor: GKernel.instance.liteAuthor.text,
                                                    liteRegionName: GKernel.instance.liteRegionName.text,
                                                    bI: int.parse(GKernel.instance.maH.text),
                                                    bridge: GKernel.instance.bridge,
                                                    compress: GKernel.instance.compress,
                                                    endermanProof: GKernel.instance.endermanProof,
                                                    exportType: GKernel.instance.exportType,
                                                    fireProof: GKernel.instance.fireProof,
                                                    maH: int.parse(GKernel.instance.maH.text),
                                                    backgroundColor: GKernel.instance.backgroundColor,
                                                    exportDir: GKernel.instance.mapdir,
                                                    mapId: id));
                                            if (!r.s) {
                                              GKernel.instance.multiFail.add(r.p);
                                            }
                                            if (GKernel.instance.verbose) {
                                              GKernel.instance.multiProgress.value = i / (total) * 100;
                                            }
                                          }
                                          for (int i = 0; i < GKernel.instance.multiDir.length; i++) {
                                            Directory dir = Directory(GKernel.instance.multiDir[i]);
                                            Stream<FileSystemEntity> entityList = dir.list(recursive: false, followLinks: false);
                                            await for (FileSystemEntity entity in entityList) {
                                              if (entity.statSync().type == FileSystemEntityType.file &&
                                                  ['.png', '.bmp', '.jpeg', '.jpg', '.tga', '.webp', '.tiff'].contains(path.extension(entity.path))) {
                                                int id = GKernel.instance.mapid;
                                                int wid = 0, hei = 0;
                                                if (GKernel.instance.exportType == ExportType.file) {
                                                  String p = entity.path;
                                                  List<int> f = File(p).readAsBytesSync();
                                                  img.Image? r = img.decodeNamedImage(f, path.extension(p));
                                                  if (r != null) {
                                                    hei = (r.height / 128).ceil();
                                                    wid = (r.width / 128).ceil();
                                                    GKernel.instance.mapid += hei * wid;
                                                  } else {
                                                    GKernel.instance.multiFail.add(p);
                                                  }
                                                }
                                                var r = await tp.Executor().execute(
                                                    fun1: exportMultiSingle,
                                                    arg1: ExportMultiArgs(
                                                        cpuid: -1,
                                                        convertMethod: GKernel.instance.convertMethod,
                                                        p: entity.path,
                                                        scl_halfTpPixelSt: GKernel.instance.scl_halfTpPixelSt,
                                                        scl_pureTpPixelSt: GKernel.instance.scl_pureTpPixelSt,
                                                        dithering: GKernel.instance.dithering,
                                                        liteName: GKernel.instance.liteName.text,
                                                        liteAuthor: GKernel.instance.liteAuthor.text,
                                                        liteRegionName: GKernel.instance.liteRegionName.text,
                                                        bI: int.parse(GKernel.instance.maH.text),
                                                        bridge: GKernel.instance.bridge,
                                                        compress: GKernel.instance.compress,
                                                        endermanProof: GKernel.instance.endermanProof,
                                                        exportType: GKernel.instance.exportType,
                                                        fireProof: GKernel.instance.fireProof,
                                                        maH: int.parse(GKernel.instance.maH.text),
                                                        backgroundColor: GKernel.instance.backgroundColor,
                                                        exportDir: GKernel.instance.mapdir,
                                                        mapId: id));
                                                if (!r.s) {
                                                  GKernel.instance.multiFail.add(r.p);
                                                }
                                                if (GKernel.instance.verbose) {
                                                  GKernel.instance.multiProgress.value = i / (total) * 100;
                                                }
                                              }
                                            }
                                          }
                                        } else {
                                          GKernel.instance.finished = 0;
                                          GKernel.instance.mapid = 0;
                                          if (!GKernel.instance.verbose) {
                                            GKernel.instance.multiProgress.value = null;
                                          }
                                          GKernel.instance.multiProgress.value = 0;
                                          GKernel.instance.multiDirFiles.clear();
                                          GKernel.instance.multiFail.clear();
                                          for (int i = 0; i < GKernel.instance.multiDir.length; i++) {
                                            Directory dir = Directory(GKernel.instance.multiDir[i]);
                                            Stream<FileSystemEntity> entityList = dir.list(recursive: false, followLinks: false);
                                            await for (FileSystemEntity entity in entityList) {
                                              if (entity.statSync().type == FileSystemEntityType.file &&
                                                  ['.png', '.bmp', '.jpeg', '.jpg', '.tga', '.webp', '.tiff'].contains(path.extension(entity.path))) {
                                                if (!GKernel.instance.multiDirFiles.contains(entity.path)) {
                                                  GKernel.instance.multiDirFiles.add(entity.path);
                                                }
                                              }
                                            }
                                          }
                                          int threads = GKernel.instance.threads;
                                          List<Future<void>?> t = List.filled(threads, null);
                                          for (int i = 0; i < threads; i++) {
                                            t[i] = export(i, i);
                                          }
                                          for (int i = 0; i < threads; i++) {
                                            if (t[i] != null) {
                                              await t[i];
                                            }
                                          }
                                        }
                                        GKernel.instance.setType(context, true);
                                        GKernel.instance.building.value = false;
                                        GKernel.instance.multiProgress.value = 100.0;
                                        setState(() {});
                                        // var t1 = DateTime.now();
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ContentDialog(
                                              title: const Text('完成'),
                                              // content: Text('${t1.difference(t0).inMilliseconds}ms'),
                                              content: const Text('导出完成'),
                                              actions: [
                                                Button(
                                                  child: const Text('确定'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        if (GKernel.instance.multiFail.isNotEmpty) {
                                          await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return ContentDialog(
                                                title: const Text('以下文件转换失败：'),
                                                constraints: const BoxConstraints(maxHeight: 600, maxWidth: 1000),
                                                content: ListView.builder(
                                                  padding: const EdgeInsets.only(right: 16.0),
                                                  itemCount: GKernel.instance.multiFail.length,
                                                  itemBuilder: (context, index) {
                                                    return ListTile(
                                                      title: Text(
                                                        GKernel.instance.multiFail[index],
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    );
                                                  },
                                                ),
                                                actions: [
                                                  Button(
                                                    child: const Text('确定'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      });
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
                          String? outputFile = await file_picker.FilePicker.platform.saveFile(
                            dialogTitle: '导出',
                            fileName: 'map_${int.parse(GKernel.instance.mapIndex.text)}.dat',
                          );

                          if (outputFile == null) {
                            return;
                          }
                          if (GKernel.instance.mapIndex.text.isEmpty) {
                            GKernel.instance.mapIndex.text = '0';
                          }
                          int indexStart = int.parse(GKernel.instance.mapIndex.text);
                          bool ignoreRewrite = false;
                          bool stop = false;
                          for (int i = indexStart; i <= indexStart + mapRows * mapCols - 1; i++) {
                            if (File('map_$i.dat').existsSync() && !ignoreRewrite) {
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
                          final gbk = const GbkCodec().encode(path.dirname(outputFile));

                          Pointer<Int8> pg = ffi.calloc.call(gbk.length + 1);
                          for (int i = 0; i < gbk.length; i++) {
                            pg.elementAt(i).value = gbk[i];
                          }
                          pg.elementAt(gbk.length).value = 0;

                          GKernel.instance.scl.SCL_exportAsData(pg, int.parse(GKernel.instance.mapIndex.text), nullptr, nullptr);

                          ffi.calloc.free(pg);
                          showDialog(
                            builder: (context) {
                              return ContentDialog(
                                title: const Text('导出完成'),
                                content: const Text('已导出地图文件'),
                                actions: [
                                  SizedBox(
                                    width: 150,
                                    child: FilledButton(
                                      child: const Text('确定'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                            context: context,
                          );
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
