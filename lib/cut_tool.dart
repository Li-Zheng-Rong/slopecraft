import 'package:fluent_ui/fluent_ui.dart';

class CutTool extends StatefulWidget {
  const CutTool({Key? key}) : super(key: key);

  @override
  State<CutTool> createState() => _CutToolState();
}

class _CutToolState extends State<CutTool> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: PageHeader(
        title: Text('图像预处理'),
      ),
      content: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      ),
    );
  }
}
