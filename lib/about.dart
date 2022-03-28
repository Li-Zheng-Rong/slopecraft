import 'package:fluent_ui/fluent_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Typography typography = FluentTheme.of(context).typography;
    return ScaffoldPage(
        header: const PageHeader(title: Text('关于')),
        content: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Card(
                child: Text(
                    '感谢你使用SlopeCraft，我是开发者TokiNoBug。SlopeCraft是由我开发的一款立体地图画生成器，主要用于在minecraft中制造可以生存实装的立体地图画（但同样支持传统的平板地图画）。立体地图画的优势在于拥有更高的“画质”，此处不再详述。',
                    style: typography.body),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Card(
                child: Text(
                  '你正在使用的是SlopeCraft的第三代版本，在开发时使用了zlib和eigen，对上述库的开发者表示感谢。也感谢Mojang，整个软件就是为minecraft而设计的。',
                  style: typography.body,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Card(
                child: Text(
                  'SlopeCraft遵循GPL-3.0及以后版本(GPL-3.0 or later)协议开放源代码。',
                  style: typography.body,
                ),
              ),
            ),
          ],
        ),
        bottomBar: Padding(
          padding: const EdgeInsets.all(10.0),
          child: RepaintBoundary(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Button(
                    child: const Text('联系作者'),
                    onPressed: () async {
                      launch('https://github.com/ToKiNoBug/SlopeCraft');
                      launch('https://space.bilibili.com/351429231');
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Button(
                    child: const Text('退出'),
                    onPressed: () {
                      Navigator.pop(context);
                      windowManager.destroy();
                      // appWindow.close();
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
