import 'dart:io';

import 'package:file_picker/file_picker.dart' as file_picker;
import 'package:fluent_ui/fluent_ui.dart';

import 'kernel.dart';
import 'scl_interface.dart';
import 'set_block_list.dart';

class MultiConvert extends StatefulWidget {
  const MultiConvert({Key? key}) : super(key: key);

  @override
  State<MultiConvert> createState() => _MultiConvertState();
}

class _MultiConvertState extends State<MultiConvert> {
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
  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return ScaffoldPage.scrollable(
      header: const PageHeader(
        title: Text('批量生成'),
      ),
      children: [
        SizedBox(
          height: 70,
          child: Card(
            child: Row(
              children: [
                Text(
                  '路径：${GKernel.instance.multidir == null ? '' : GKernel.instance.multidir!.path}',
                  style: typography.bodyLarge,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Button(
                  child: const Text('选择文件夹'),
                  onPressed: () async {
                    String? selectedDirectory = await file_picker.FilePicker.platform.getDirectoryPath();

                    if (selectedDirectory == null) {
                      return;
                    }
                    GKernel.instance.multidir = Directory(selectedDirectory);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
