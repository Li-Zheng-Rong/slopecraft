import 'dart:ffi';
import 'dart:io';

import 'package:excel/excel.dart';
import 'package:ffi/ffi.dart' as ffi;
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;

import 'kernel.dart';
import 'scl_interface.dart';

class BuildArgs {
  BuildArgs({required this.compress, required this.maH, required this.bridge, required this.bI, required this.fireProof, required this.endermanProof});
  int compress;
  int maH;
  int bridge;
  int bI;
  bool fireProof;
  bool endermanProof;
}

bool build3D(BuildArgs args) {
  return GKernel.instance.scl.SCL_build(args.compress, args.maH, args.bridge, args.bI, args.fireProof, args.endermanProof);
}

class ExportLitematica extends StatefulWidget {
  const ExportLitematica({Key? key}) : super(key: key);

  @override
  State<ExportLitematica> createState() => _ExportLitematicaState();
}

class _ExportLitematicaState extends State<ExportLitematica> {
  final _optiFlyoutController = FlyoutController();
  final _bridgeFlyoutController = FlyoutController();
  final _otherFlyoutController = FlyoutController();

  @override
  void dispose() {
    _optiFlyoutController.dispose();
    super.dispose();
  }

  final _controllerl = ScrollController();
  final _controllerr = ScrollController();
  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    if (GKernel.instance.scl.SCL_queryStep() < step.converted) {
      return ScaffoldPage(
        header: const PageHeader(
          title: Text('导出为投影文件'),
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
        title: Text('导出为投影文件'),
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Row(
          children: [
            Expanded(
              child: RepaintBoundary(
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextBox(
                        header: '投影名称',
                        placeholder: 'Pixel Paint by SlopeCraft',
                        controller: GKernel.instance.liteName,
                      ),
                      const SizedBox(height: 8),
                      TextBox(
                        header: '投影作者',
                        placeholder: 'SlopeCraft',
                        controller: GKernel.instance.liteAuthor,
                      ),
                      const SizedBox(height: 8),
                      TextBox(
                        header: '投影区域名称',
                        placeholder: 'Pixel Paint by SlopeCraft',
                        controller: GKernel.instance.liteRegionName,
                      ),
                      const SizedBox(height: 8),
                      const Divider(),
                      const SizedBox(height: 8),
                      Flyout(
                        controller: _optiFlyoutController,
                        contentWidth: 300,
                        content: StatefulBuilder(
                          builder: (context, setState) {
                            return FlyoutContent(
                              child: InfoLabel(
                                label: '压缩高度',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Checkbox(
                                      checked: GKernel.instance.compress == compressSettings.Both || GKernel.instance.compress == compressSettings.NaturalOnly,
                                      onChanged: (value) => setState(() {
                                        if (value == true) {
                                          if (GKernel.instance.compress == compressSettings.noCompress) {
                                            GKernel.instance.compress = compressSettings.NaturalOnly;
                                          } else {
                                            GKernel.instance.compress = compressSettings.Both;
                                          }
                                        } else {
                                          if (GKernel.instance.compress == compressSettings.Both) {
                                            GKernel.instance.compress = compressSettings.ForcedOnly;
                                          } else {
                                            GKernel.instance.compress = compressSettings.noCompress;
                                          }
                                        }
                                      }),
                                      content: const Text('无损压缩'),
                                    ),
                                    Checkbox(
                                      checked: GKernel.instance.compress == compressSettings.Both || GKernel.instance.compress == compressSettings.ForcedOnly,
                                      onChanged: (value) => setState(() {
                                        if (value == true) {
                                          if (GKernel.instance.compress == compressSettings.noCompress) {
                                            GKernel.instance.compress = compressSettings.ForcedOnly;
                                          } else {
                                            GKernel.instance.compress = compressSettings.Both;
                                          }
                                        } else {
                                          if (GKernel.instance.compress == compressSettings.Both) {
                                            GKernel.instance.compress = compressSettings.NaturalOnly;
                                          } else {
                                            GKernel.instance.compress = compressSettings.noCompress;
                                          }
                                        }
                                      }),
                                      content: const Text('智能有损压缩'),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Text('最大允许高度'),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: TextBox(
                                            placeholder: '255',
                                            controller: GKernel.instance.maH,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            maxLength: 4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        child: RepaintBoundary(
                          child: Button(
                            child: const Text('更多配置：压缩高度'),
                            onPressed: () {
                              _optiFlyoutController.open = true;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Flyout(
                        controller: _bridgeFlyoutController,
                        contentWidth: 300,
                        content: StatefulBuilder(
                          builder: (context, setState) {
                            return FlyoutContent(
                              child: InfoLabel(
                                label: '搭桥',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Checkbox(
                                      checked: GKernel.instance.bridge == glassBridgeSettings.withBridge,
                                      onChanged: (value) => setState(() {
                                        if (value == true) {
                                          GKernel.instance.bridge = glassBridgeSettings.withBridge;
                                        } else {
                                          GKernel.instance.bridge = glassBridgeSettings.noBridge;
                                        }
                                      }),
                                      content: const Text('允许搭桥'),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Text('搭桥间隔'),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: TextBox(
                                            placeholder: '4',
                                            controller: GKernel.instance.bI,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                            maxLength: 4,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        child: RepaintBoundary(
                          child: Button(
                            child: const Text('更多配置：搭桥'),
                            onPressed: () {
                              _bridgeFlyoutController.open = true;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Flyout(
                        controller: _otherFlyoutController,
                        contentWidth: 300,
                        content: StatefulBuilder(
                          builder: (context, setState) {
                            return FlyoutContent(
                              child: InfoLabel(
                                label: '其他选项',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Checkbox(
                                      checked: GKernel.instance.fireProof,
                                      onChanged: (value) => setState(() => GKernel.instance.fireProof = value!),
                                      content: const Text('防火'),
                                    ),
                                    Checkbox(
                                      checked: GKernel.instance.endermanProof,
                                      onChanged: (value) => setState(() => GKernel.instance.endermanProof = value!),
                                      content: const Text('防末影人'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        child: RepaintBoundary(
                          child: Button(
                            child: const Text('更多配置：其他选项'),
                            onPressed: () {
                              _otherFlyoutController.open = true;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              flex: 2,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RepaintBoundary(
                child: Column(
                  children: [
                    Expanded(
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('最后一步，将立体地图画导出为投影文件，这很方便生存实装，是不是？', style: typography.body),
                            const SizedBox(height: 5),
                            Text('左侧的三个栏是投影文件的一些属性，空着不填也完全没问题。', style: typography.body),
                            const SizedBox(height: 5),
                            Text('如果您启用了“允许压缩高度”，SlopeCraft会在构建三维结构时尝试依据地图绘制的规律压缩立体地图画的高度，这可以有效避免超过限高（但未必能成功）。', style: typography.body),
                            const SizedBox(height: 5),
                            Text('下面的两个栏显示了立体地图画的信息，以供参考。', style: typography.body),
                            const SizedBox(height: 5),
                            Text('这个过程可能会很慢', style: typography.bodyLarge),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                              '投影尺寸：${GKernel.instance.scl.SCL_queryStep() >= step.builded ? 'X(${GKernel.instance.dx})/Y(${GKernel.instance.dy})/Z(${GKernel.instance.dz})方块' : ''} ',
                              style: typography.bodyLarge),
                          const SizedBox(height: 5),
                          Text('方块总数：${GKernel.instance.scl.SCL_queryStep() >= step.builded ? GKernel.instance.scl.SCL_getBlockCounts() : ''}',
                              style: typography.bodyLarge),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: RepaintBoundary(
                                  child: Button(
                                    child: const Text('构建三维结构'),
                                    onPressed: () {
                                      if (GKernel.instance.bI.text.isEmpty) {
                                        GKernel.instance.bI.text = '4';
                                      }
                                      if (GKernel.instance.maH.text.isEmpty) {
                                        GKernel.instance.maH.text = '255';
                                      }
                                      if (int.parse(GKernel.instance.maH.text) < 14) {
                                        GKernel.instance.maH.text = '14';
                                      }
                                      if (GKernel.instance.liteAuthor.text.isEmpty) {
                                        GKernel.instance.liteAuthor.text = 'SlopeCraft';
                                      }
                                      if (GKernel.instance.liteName.text.isEmpty) {
                                        GKernel.instance.liteName.text = 'Pixel Paint by SlopeCraft';
                                      }
                                      if (GKernel.instance.liteRegionName.text.isEmpty) {
                                        GKernel.instance.liteRegionName.text = 'Pixel Paint by SlopeCraft';
                                      }
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ContentDialog(
                                            title: const Text('构建'),
                                            content: Center(
                                              child: FutureBuilder<void>(
                                                future: compute(
                                                    build3D,
                                                    BuildArgs(
                                                        compress: GKernel.instance.compress,
                                                        maH: int.parse(GKernel.instance.maH.text),
                                                        bridge: GKernel.instance.bridge,
                                                        bI: int.parse(GKernel.instance.bI.text),
                                                        fireProof: GKernel.instance.fireProof,
                                                        endermanProof: GKernel.instance.endermanProof)),
                                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                                  if (snapshot.connectionState == ConnectionState.done) {
                                                    if (snapshot.hasError) {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            '构建失败： ${snapshot.error}',
                                                            style: typography.bodyLarge,
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Row(
                                                            children: [
                                                              const Expanded(child: Text('')),
                                                              SizedBox(
                                                                width: 150,
                                                                child: FilledButton(
                                                                  child: const Text('确定'),
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      );
                                                    } else {
                                                      return Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            '构建${snapshot.data ? '成功' : '失败：未知'}',
                                                            style: typography.bodyLarge,
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Row(
                                                            children: [
                                                              const Expanded(child: Text('')),
                                                              SizedBox(
                                                                width: 150,
                                                                child: FilledButton(
                                                                  child: const Text('确定'),
                                                                  onPressed: () {
                                                                    Navigator.pop(context);
                                                                    if (snapshot.data) {
                                                                      Pointer<Int32> x, y, z;
                                                                      x = ffi.malloc.call(1);
                                                                      y = ffi.malloc.call(1);
                                                                      z = ffi.malloc.call(1);
                                                                      GKernel.instance.scl.SCL_get3DSize(x, y, z);
                                                                      GKernel.instance.dx = x.value;
                                                                      GKernel.instance.dy = y.value;
                                                                      GKernel.instance.dz = z.value;
                                                                      ffi.malloc.free(x);
                                                                      ffi.malloc.free(y);
                                                                      ffi.malloc.free(z);
                                                                    }
                                                                    GKernel.instance.getConvertedImage();
                                                                    GKernel.instance.getBlockCounts();
                                                                    setState(() {});
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          )
                                                        ],
                                                      );
                                                    }
                                                  } else {
                                                    return Row(
                                                      children: const [
                                                        ProgressRing(),
                                                        SizedBox(width: 10),
                                                        Text('正在构建三维模型'),
                                                      ],
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RepaintBoundary(
                                  child: Button(
                                      child: const Text('地图画预览'),
                                      onPressed: GKernel.instance.scl.SCL_queryStep() >= step.builded && GKernel.instance.convertedImage != null
                                          ? () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return StatefulBuilder(
                                                    builder: (context, setState) {
                                                      return ContentDialog(
                                                        title: const Text('地图画预览'),
                                                        content: AspectRatio(
                                                          aspectRatio: 1,
                                                          child: GKernel.instance.convertedImage!,
                                                        ),
                                                        actions: [
                                                          SizedBox(
                                                            width: 150,
                                                            child: Button(
                                                              child: const Text('确定'),
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            }
                                          : null),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: RepaintBoundary(
                                  child: Button(
                                    child: const Text('材料列表'),
                                    onPressed: GKernel.instance.scl.SCL_queryStep() >= step.builded
                                        ? () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return ContentDialog(
                                                      constraints: const BoxConstraints(maxWidth: 700, maxHeight: 600),
                                                      title: Row(
                                                        children: [
                                                          const Text('材料列表'),
                                                          const Expanded(child: Text('')),
                                                          Checkbox(
                                                            checked: GKernel.instance.showString,
                                                            onChanged: (val) {
                                                              if (val != null) {
                                                                GKernel.instance.showString = val;
                                                              }
                                                              setState(() {});
                                                            },
                                                            content: const Text(
                                                              '转换单位',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      content: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                                        children: [
                                                          Text(
                                                            '投影尺寸：${GKernel.instance.dx} X ${GKernel.instance.dy} X ${GKernel.instance.dz}方块',
                                                            style: typography.bodyLarge,
                                                          ),
                                                          Text(
                                                            '总方块数：${GKernel.instance.scl.SCL_getBlockCounts()}方块',
                                                            style: typography.bodyLarge,
                                                          ),
                                                          Text(
                                                            '总体积：${GKernel.instance.dx * GKernel.instance.dy * GKernel.instance.dz}方块',
                                                            style: typography.bodyLarge,
                                                          ),
                                                          const SizedBox(height: 10),
                                                          Container(
                                                            constraints: const BoxConstraints(maxHeight: 290),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child: ListView.builder(
                                                                    controller: _controllerl,
                                                                    itemCount: GKernel.instance.blocksLeft.length,
                                                                    itemBuilder: (context, index) {
                                                                      Item item = GKernel.instance.blocksLeft[index];
                                                                      return ListTile(
                                                                        title: Row(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 16,
                                                                              width: 16,
                                                                              child: item.image,
                                                                            ),
                                                                            const SizedBox(width: 10),
                                                                            Text('${item.name}：'),
                                                                            const Expanded(child: Text('')),
                                                                            Text('${GKernel.instance.showString ? item.countb : item.count}'),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: ListView.builder(
                                                                    controller: _controllerr,
                                                                    itemCount: GKernel.instance.blocksRight.length,
                                                                    itemBuilder: (context, index) {
                                                                      Item item = GKernel.instance.blocksRight[index];
                                                                      return ListTile(
                                                                        title: Row(
                                                                          children: [
                                                                            SizedBox(
                                                                              height: 16,
                                                                              width: 16,
                                                                              child: item.image,
                                                                            ),
                                                                            const SizedBox(width: 10),
                                                                            Text('${item.name}：'),
                                                                            const Expanded(child: Text('')),
                                                                            Text('${GKernel.instance.showString ? item.countb : item.count}'),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      actions: [
                                                        Button(
                                                          child: const Text('导出到Excel'),
                                                          onPressed: () async {
                                                            String? outputFile = await file_picker.FilePicker.platform.saveFile(
                                                              dialogTitle: '导出',
                                                              fileName: '材料列表.xlsx',
                                                            );

                                                            if (outputFile == null) {
                                                              return;
                                                            }

                                                            var excel = Excel.createExcel();
                                                            Sheet sheetObject = excel['Sheet1'];
                                                            sheetObject.merge(CellIndex.indexByString("A1"), CellIndex.indexByString("C1"),
                                                                customValue: "Generated By SlopeCraft");
                                                            sheetObject.insertRowIterables(['方块种类', '个数', '换算'], 1);
                                                            for (int i = 0; i < GKernel.instance.blocks.length; i++) {
                                                              sheetObject.insertRowIterables([
                                                                GKernel.instance.blocks[i].name,
                                                                '${GKernel.instance.blocks[i].count}个',
                                                                GKernel.instance.blocks[i].countb
                                                              ], i + 2);
                                                            }

                                                            var fileBytes = excel.save();

                                                            File(outputFile)
                                                              ..createSync(recursive: true)
                                                              ..writeAsBytes(fileBytes!);
                                                          },
                                                        ),
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
                                              },
                                            );
                                          }
                                        : null,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: RepaintBoundary(
                                  child: FilledButton(
                                    child: const Text('导出！'),
                                    onPressed: () async {
                                      if (GKernel.instance.scl.SCL_queryStep() < step.builded) {
                                        showDialog(
                                          builder: (context) {
                                            return ContentDialog(
                                              title: const Text('无法跳步操作'),
                                              content: const Text('未构建三维结构'),
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
                                        return;
                                      }

                                      String? outputFile = await file_picker.FilePicker.platform.saveFile(
                                        dialogTitle: '导出',
                                        fileName: '${GKernel.instance.liteName.text}.litematic',
                                      );

                                      if (outputFile == null) {
                                        return;
                                      }
                                      GKernel.instance.scl.SCL_exportAsLitematic(
                                          path.basename(outputFile).toNativeUtf8().cast(),
                                          GKernel.instance.liteName.text.toNativeUtf8().cast(),
                                          GKernel.instance.liteAuthor.text.toNativeUtf8().cast(),
                                          GKernel.instance.liteRegionName.text.toNativeUtf8().cast(),
                                          nullptr);
                                      showDialog(
                                        builder: (context) {
                                          return ContentDialog(
                                            title: const Text('导出完成'),
                                            content: const Text('已导出投影文件'),
                                            actions: [
                                              SizedBox(
                                                width: 150,
                                                child: FilledButton(
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
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
