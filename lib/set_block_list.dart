import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart' as ffi;
import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart' as path;

import 'block.dart';
import 'kernel.dart';
import 'scl_interface.dart';

class SetBlockList extends StatefulWidget {
  const SetBlockList({Key? key}) : super(key: key);

  @override
  State<SetBlockList> createState() => _SetBlockListState();
}

class _SetBlockListState extends State<SetBlockList> {
  List<int> baseColors = List.filled(64, 0);
  final _versions = ['1.12', '1.13', '1.14', '1.15', '1.16', '1.17', '1.18'];

  @override
  void initState() {
    Pointer<Uint32> pointer = ffi.malloc.allocate(sizeOf<Uint32>() * 64);
    GKernel.instance.scl.SCL_getARGB32(pointer);
    for (int i = 0; i < 64; i++) {
      baseColors[i] = pointer.elementAt(i).value;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    if (GKernel.instance.scl.SCL_queryStep() < step.colorSetReady) {
      return ScaffoldPage(
        header: const PageHeader(
          title: Text('方块列表'),
        ),
        content: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Card(
            child: Center(
              child: Text(
                '无法跳步操作',
                style: typography.display,
              ),
            ),
          ),
        ),
      );
    }
    return ScaffoldPage(
      header: PageHeader(
          title: const Text('方块列表'),
          commandBar: Row(
            children: [
              SizedBox(
                width: 140,
                child: RepaintBoundary(
                  child: Button(
                      child: const Text('导入方块'),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ContentDialog(
                              constraints: const BoxConstraints(maxWidth: 500),
                              title: const Text('导入'),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('导入方块：增加自定义方块'),
                                  SizedBox(height: 5),
                                  Text('导入材质：方块的显示材质（与地图画基色无关）'),
                                ],
                              ),
                              actions: [
                                Button(
                                  child: const Text('导入材质（可选）'),
                                  onPressed: () async {
                                    String? selectedDirectory = await file_picker.FilePicker.platform.getDirectoryPath();

                                    if (selectedDirectory != null) {
                                      await GKernel.instance.blockListManager.loadTexture(folderPath: selectedDirectory);
                                      setState(() {});
                                    }
                                  },
                                ),
                                FilledButton(
                                  child: const Text('导入方块'),
                                  onPressed: () async {
                                    file_picker.FilePickerResult? result = await file_picker.FilePicker.platform.pickFiles(
                                      type: file_picker.FileType.custom,
                                      allowedExtensions: ['json'],
                                      allowMultiple: true,
                                    );

                                    if (result != null) {
                                      List<File> files = result.paths.map((path) => File(path!)).toList();
                                      for (var item in files) {
                                        GKernel.instance.blockListManager.importBlocks(item.readAsStringSync());
                                      }
                                      setState(() {});
                                    }
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
                      }),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 140,
                child: RepaintBoundary(
                  child: Button(
                    child: const Text('预设方块列表'),
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          String index = '';
                          return StatefulBuilder(
                            builder: (context, setStatethis) {
                              return ContentDialog(
                                constraints: const BoxConstraints(maxWidth: 600),
                                title: const Text('使用预设方块列表'),
                                content: Column(
                                  children: [
                                    ...blocklists.map((e) {
                                      return Column(
                                        children: [
                                          ToggleButton(
                                            checked: index.compareTo(e.name) == 0,
                                            child: Row(
                                              children: [
                                                Text(
                                                  e.name,
                                                  textAlign: TextAlign.left,
                                                ),
                                                const Expanded(
                                                  child: Text(''),
                                                ),
                                                Text(
                                                  e.info,
                                                  textAlign: TextAlign.right,
                                                  style: const TextStyle(color: Color.fromARGB(255, 150, 150, 150)),
                                                )
                                              ],
                                            ),
                                            onChanged: (bool b) {
                                              if (b == true) {
                                                GKernel.instance.blockListManager.uesPreset(e.set);
                                                index = e.name;
                                              }
                                              setStatethis(() {});
                                            },
                                          ),
                                          const SizedBox(height: 5),
                                        ],
                                      );
                                    }).toList(),
                                    Button(
                                        child: Row(children: const [Text('导入自定义列表')]),
                                        onPressed: () async {
                                          file_picker.FilePickerResult? result = await file_picker.FilePicker.platform.pickFiles(
                                            type: file_picker.FileType.custom,
                                            allowedExtensions: ['preset'],
                                            allowMultiple: true,
                                          );

                                          if (result != null) {
                                            List<File> files = result.paths.map((path) => File(path!)).toList();
                                            for (var item in files) {
                                              Config cfg = Config.fromJson(jsonDecode(item.readAsStringSync()));
                                              blocklists.add(BlockListInfo(name: cfg.name, info: item.path, set: cfg.blocks));
                                            }
                                            setStatethis(() {});
                                          }
                                        }),
                                  ],
                                ),
                                actions: [
                                  RepaintBoundary(
                                    child: FilledButton(
                                      child: const SizedBox(
                                        width: 100,
                                        child: Text('确定'),
                                      ),
                                      onPressed: () {
                                        setState(() {});
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
                    },
                  ),
                ),
              ),
            ],
          )),
      content: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            '第一步，给每一种颜色设置对应的方块，我们有四种预设。',
                            style: typography.body,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            '你也可以在右侧的滚动条里自定义。每一列方块对应一种颜色，每种颜色只能选择一种方块。你也可以勾掉启用，禁用任何一种颜色。',
                            style: typography.body,
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
                          child: Combobox<String>(
                            placeholder: const Text('选择游戏版本'),
                            isExpanded: true,
                            items: _versions
                                .map((e) => ComboboxItem<String>(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            value: GKernel.instance.gameVersion,
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => GKernel.instance.gameVersion = value);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Row(
                          children: [
                            Expanded(
                              child: RepaintBoundary(
                                child: Button(
                                    child: const Text('优先混凝土'),
                                    onPressed: () {
                                      GKernel.instance.blockListManager.selectByName(keyWord: 'concrete');
                                      setState(() {});
                                    }),
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: RepaintBoundary(
                                child: Button(
                                    child: const Text('优先羊毛'),
                                    onPressed: () {
                                      GKernel.instance.blockListManager.selectByName(keyWord: 'wool');
                                      setState(() {});
                                    }),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        RepaintBoundary(
                          child: Button(
                              child: const Text('优先染色玻璃'),
                              onPressed: () {
                                GKernel.instance.blockListManager.selectByName(keyWord: 'stained_glass');
                                setState(() {});
                              }),
                        ),
                        const SizedBox(height: 8.0),
                        RepaintBoundary(
                          child: Button(
                              child: const Text('保存预设到文件'),
                              onPressed: () {
                                TextEditingController _name = TextEditingController(text: 'Custom');

                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ContentDialog(
                                      title: const Text('保存预设'),
                                      content: TextBox(
                                        header: '预设名称',
                                        placeholder: 'Preset name',
                                        controller: _name,
                                      ),
                                      actions: [
                                        FilledButton(
                                            child: const Text('确定'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Config config = Config(name: _name.text, blocks: List.filled(64, null));
                                              for (int i = 0; i < 64; i++) {
                                                Block? b = GKernel.instance.blockListManager.isEnabled(baseColor: i)
                                                    ? GKernel.instance.blockListManager.selected(baseColor: i)
                                                    : null;
                                                config.blocks[i] = (b?.id);
                                              }

                                              File out = File(_name.text + '.preset');
                                              out.writeAsStringSync(jsonEncode(config.toJson()));
                                            })
                                      ],
                                    );
                                  },
                                );
                              }),
                        ),
                        const SizedBox(height: 8.0),
                        FilledButton(
                            child: const Text('保存设置'),
                            onPressed: () async {
                              await GKernel.instance.setType(context);
                              GKernel.instance.index.value = 2;
                            })
                      ],
                    ),
                  ),
                ],
              ),
              flex: 2,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Card(
                  child: ListView.builder(
                    itemCount: 64,
                    itemBuilder: (context, index) {
                      int version = int.parse(GKernel.instance.gameVersion.replaceAll('.', '')) - 100;
                      List<Block> blocklist = GKernel.instance.blockListManager.getBlockList(version: version, baseColor: index);
                      Block? block = GKernel.instance.blockListManager.selected(baseColor: index);
                      bool enabled = GKernel.instance.blockListManager.isEnabled(baseColor: index);

                      //无效基色||未选择||已禁用
                      Color? tileColor = (blocklist.isEmpty || block == null || !enabled) ? const Color.fromARGB(255, 220, 220, 220) : null;
                      String title = '基色$index ${baseColorNames[index]}${blocklist.isEmpty ? '[不存在]' : !enabled ? '[已禁用]' : block == null ? '[未选择]' : ''}';

                      return ListTile(
                        tileColor: tileColor,
                        leading: SizedBox(
                            height: 40,
                            width: 40,
                            child: Container(
                              color: blocklist.isEmpty ? Colors.white : Color(baseColors[index]),
                              child: Center(
                                child: index != 0
                                    ? Text(blocklist.isEmpty ? '无效' : '')
                                    : Image.file(File(path.join(GKernel.instance.current, dataPrefix, 'transparent.png')), fit: BoxFit.none),
                              ),
                            )),
                        title: Text(title),
                        subtitle: Row(
                          children: blocklist.isEmpty || !GKernel.instance.blockListManager.isEnabled(baseColor: index) || block == null
                              ? [const Text('无效')]
                              : [
                                  Image.file(
                                    File(GKernel.instance.blockListManager.iconPath[block.icon] ??
                                        path.join(GKernel.instance.current, dataPrefix, 'missing.png')),
                                    height: 16,
                                    width: 16,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(block.nameZH),
                                ],
                        ),
                        trailing: Button(
                          child: const Text('选择方块'),
                          onPressed: blocklist.isEmpty || index == 0
                              ? null
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setStatethis) {
                                          return ContentDialog(
                                            title: Text('为基色$index选择方块'),
                                            content: Column(
                                              children: [
                                                Checkbox(
                                                    content: const Text('禁用基色'),
                                                    checked: !GKernel.instance.blockListManager.isEnabled(baseColor: index),
                                                    onChanged: (value) {
                                                      GKernel.instance.blockListManager.setEnabled(baseColor: index, enabled: !(value ?? false));
                                                      setStatethis(() {});
                                                    }),
                                                ...blocklist.map((e) {
                                                  return Column(
                                                    children: [
                                                      const SizedBox(height: 5),
                                                      ToggleButton(
                                                        checked: GKernel.instance.blockListManager.selected(baseColor: index)?.id.compareTo(e.id) == 0,
                                                        child: Row(
                                                          children: [
                                                            Image.file(
                                                              File(GKernel.instance.blockListManager.iconPath[e.icon] ??
                                                                  path.join(GKernel.instance.current, dataPrefix, 'missing.png')),
                                                              height: 16,
                                                              width: 16,
                                                              fit: BoxFit.contain,
                                                            ),
                                                            const SizedBox(width: 10),
                                                            Text(e.nameZH),
                                                          ],
                                                        ),
                                                        onChanged: GKernel.instance.blockListManager.isEnabled(baseColor: index)
                                                            ? (bool b) {
                                                                if (b == true) {
                                                                  GKernel.instance.blockListManager.select(baseColor: e.baseColor, block: e);
                                                                }
                                                                setStatethis(() {});
                                                              }
                                                            : null,
                                                      ),
                                                    ],
                                                  );
                                                }).toList(),
                                              ],
                                            ),
                                            actions: [
                                              Button(
                                                  child: const Text('确定'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    setState(() {});
                                                  })
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                        ),
                      );
                    },
                  ),
                ),
              ),
              flex: 4,
            ),
          ],
        ),
      ),
    );
  }
}
