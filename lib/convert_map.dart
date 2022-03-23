import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';

import 'kernel.dart';
import 'scl_interface.dart';

class ConvertArgs {
  ConvertArgs({required this.convertmethod, required this.dithering});
  String convertmethod;
  bool dithering;
}

bool convert(ConvertArgs args) {
  switch (args.convertmethod) {
    case 'RGB':
      return GKernel.instance.scl.SCL_convert(convertAlgo.RGB, args.dithering);
    case 'RGB+':
      return GKernel.instance.scl.SCL_convert(convertAlgo.RGB_Better, args.dithering);
    case 'HSV':
      return GKernel.instance.scl.SCL_convert(convertAlgo.HSV, args.dithering);
    case 'Lab94':
      return GKernel.instance.scl.SCL_convert(convertAlgo.Lab94, args.dithering);
    case 'Lab00':
      return GKernel.instance.scl.SCL_convert(convertAlgo.Lab00, args.dithering);
    case 'XYZ':
      return GKernel.instance.scl.SCL_convert(convertAlgo.XYZ, args.dithering);
    case 'AiCvter':
      return GKernel.instance.scl.SCL_convert(convertAlgo.AiCvter, false);
    default:
      return false;
  }
}

class ConvertMap extends StatefulWidget {
  const ConvertMap({Key? key}) : super(key: key);

  @override
  State<ConvertMap> createState() => _ConvertMapState();
}

class _ConvertMapState extends State<ConvertMap> {
  final List<String> _methods = <String>[
    'RGB',
    'RGB+',
    'HSV',
    'Lab94',
    'Lab00',
    'XYZ',
    'AiCvter',
  ];
  bool candi = GKernel.instance.convertMethod != 'AiCvter';
  @override
  Widget build(BuildContext context) {
    GKernel.instance.show = GKernel.instance.showraw ? GKernel.instance.raw : GKernel.instance.convertedImage;
    Typography typography = FluentTheme.of(context).typography;
    if (GKernel.instance.scl.SCL_queryStep() < step.convertionReady) {
      return ScaffoldPage(
        header: const PageHeader(
          title: Text('调整颜色'),
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
        header: PageHeader(
          title: const Text('调整颜色'),
          commandBar: RepaintBoundary(
            child: Row(
              children: [
                RepaintBoundary(
                  child: FilledButton(
                      child: const Text('转换为地图画'),
                      onPressed: GKernel.instance.converting
                          ? null
                          : () async {
                              if (GKernel.instance.rawneedreset) {
                                await GKernel.instance.setRawImage(context, true);
                                GKernel.instance.rawneedreset = false;
                              }
                              if (GKernel.instance.convertMethod == 'AiCvter') {
                                GKernel.instance.rawneedreset = true;
                              }
                              GKernel.instance.converting = true;
                              setState(() {});
                              compute(convert, ConvertArgs(convertmethod: GKernel.instance.convertMethod, dithering: GKernel.instance.dithering)).then((val) {
                                GKernel.instance.converting = false;
                                setState(() {});
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ContentDialog(
                                      title: const Text('转换'),
                                      content: Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '转换${val ? '成功' : '失败：未知'}',
                                              style: typography.bodyLarge,
                                            ),
                                            if (val) const SizedBox(height: 5),
                                            if (val)
                                              Text(
                                                '可以进行下一步了',
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
                                                      if (val) {
                                                        GKernel.instance.getConvertedImage();
                                                        GKernel.instance.show = GKernel.instance.convertedImage;
                                                        GKernel.instance.showraw = false;
                                                        setState(() {});
                                                      }
                                                    },
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              });
                            }),
                ),
                const SizedBox(width: 8.0),
                SizedBox(
                  width: 100,
                  child: RepaintBoundary(
                    child: Combobox<String>(
                      placeholder: const Text('选择算法'),
                      isExpanded: true,
                      items: _methods
                          .map((e) => ComboboxItem<String>(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      value: GKernel.instance.convertMethod,
                      onChanged: (value) {
                        // print(value);
                        candi = value != 'AiCvter';
                        GKernel.instance.dithering = value == 'AiCvter' ? false : GKernel.instance.dithering;
                        if (value != null) setState(() => GKernel.instance.convertMethod = value);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                RepaintBoundary(
                  child: Checkbox(
                    checked: GKernel.instance.dithering,
                    onChanged: candi ? (value) => setState(() => GKernel.instance.dithering = value!) : null,
                    content: const Text('抖动仿色'),
                  ),
                ),
              ],
            ),
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RepaintBoundary(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Card(
                          child: GKernel.instance.show!,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Expanded(
                      child: RepaintBoundary(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RepaintBoundary(
                                    child: ToggleButton(
                                      child: const Text('导出投影'),
                                      onChanged: GKernel.instance.mapType == mapTypes.FileOnly
                                          ? null
                                          : GKernel.instance.converting
                                              ? null
                                              : (val) {
                                                  if (val) {
                                                    GKernel.instance.exportType = ExportType.litematica;
                                                    setState(() {});
                                                  }
                                                },
                                      checked: GKernel.instance.exportType == ExportType.litematica,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  RepaintBoundary(
                                    child: ToggleButton(
                                      child: const Text('导出结构文件'),
                                      onChanged: GKernel.instance.mapType == mapTypes.FileOnly
                                          ? null
                                          : GKernel.instance.converting
                                              ? null
                                              : (val) {
                                                  if (val) {
                                                    GKernel.instance.exportType = ExportType.structure;
                                                    setState(() {});
                                                  }
                                                },
                                      checked: GKernel.instance.exportType == ExportType.structure,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  RepaintBoundary(
                                    child: ToggleButton(
                                      child: const Text('导出地图文件'),
                                      onChanged: GKernel.instance.converting
                                          ? null
                                          : (val) {
                                              if (val) {
                                                GKernel.instance.exportType = ExportType.file;
                                                setState(() {});
                                              }
                                            },
                                      checked: GKernel.instance.exportType == ExportType.file,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RepaintBoundary(
                                          child: ToggleButton(
                                            checked: GKernel.instance.showraw,
                                            child: const Text('显示原图'),
                                            onChanged: GKernel.instance.converting
                                                ? null
                                                : (val) {
                                                    if (val) {
                                                      GKernel.instance.show = GKernel.instance.raw;
                                                      GKernel.instance.showraw = true;
                                                    }

                                                    setState(() {});
                                                  },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Expanded(
                                        child: RepaintBoundary(
                                          child: ToggleButton(
                                            checked: !GKernel.instance.showraw,
                                            child: const Text('显示地图画'),
                                            onChanged: GKernel.instance.converting
                                                ? null
                                                : (val) {
                                                    if (val) {
                                                      GKernel.instance.show = GKernel.instance.convertedImage;
                                                      GKernel.instance.showraw = false;
                                                    }
                                                    setState(() {});
                                                  },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            Expanded(
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      '第三步，调整颜色。地图支持的颜色有限，你的图片必须由地图允许的颜色组成。',
                                      style: typography.body,
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      '七种算法对应不同的调整颜色的方式，你可以挨个试一试。如果开启“抖动仿色”，SlopeCraft会尝试用相近的颜色混合，更好的贴近原图。',
                                      style: typography.body,
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      '调整颜色可能较慢。',
                                      style: typography.bodyLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: RepaintBoundary(
                  child: ProgressBar(
                    value: GKernel.instance.converting ? null : (GKernel.instance.scl.SCL_queryStep() >= step.converted ? 100.0 : 0.0),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
