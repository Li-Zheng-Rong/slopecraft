import 'package:fluent_ui/fluent_ui.dart';

import 'export_lite.dart';
import 'export_map.dart';
import 'export_structure.dart';
import 'kernel.dart';

class Export extends StatefulWidget {
  const Export({Key? key}) : super(key: key);

  @override
  State<Export> createState() => _ExportState();
}

class _ExportState extends State<Export> {
  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    if (GKernel.instance.exportType == ExportType.file) {
      return const ExportMap();
    } else if (GKernel.instance.exportType == ExportType.litematica) {
      return const ExportLitematica();
    } else if (GKernel.instance.exportType == ExportType.structure) {
      return const ExportStructure();
    }
    return ScaffoldPage(
      header: const PageHeader(
        title: Text('BUG'),
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Card(
          child: Center(
            child: Text(
              '？？？你触发了一个隐藏BUG',
              style: typography.display,
            ),
          ),
        ),
      ),
    );
  }
}
