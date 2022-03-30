import 'package:fluent_ui/fluent_ui.dart';
import 'package:process_run/shell.dart' as process;

class CutTool extends StatefulWidget {
  const CutTool({Key? key}) : super(key: key);

  @override
  State<CutTool> createState() => _CutToolState();
}

class _CutToolState extends State<CutTool> {
  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return ScaffoldPage(
      header: const PageHeader(
        title: Text('图像处理'),
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Card(
          child: Center(
            child: Button(
              child: Text(
                '启动最好的图像处理软件!',
                style: typography.titleLarge,
              ),
              onPressed: () {
                process.Shell().run('mspaint');
              },
            ),
          ),
        ),
      ),
    );
  }
}
