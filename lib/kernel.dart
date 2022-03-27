import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:ffi/ffi.dart' as ffi;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;

import 'block.dart';
import 'blockmanager.dart';
import 'count_convert.dart';
import 'scl_interface.dart';

const String dataPrefix = 'SCData';

class BlockListInfo {
  BlockListInfo({required this.name, required this.info, required this.set});
  String name;
  String info;
  List<String?> set;
}

List<BlockListInfo> blocklists = [
  BlockListInfo(name: 'Vanilla', info: '内置', set: [
    "minecraft:glass",
    "minecraft:grass_block[snowy=false]",
    "minecraft:smooth_sandstone",
    "minecraft:cobweb",
    "minecraft:redstone_block",
    "minecraft:ice",
    "minecraft:iron_block",
    "minecraft:oak_leaves[distance=7,persistent=true]",
    "minecraft:snow_block",
    "minecraft:clay",
    "minecraft:dirt",
    "minecraft:stone",
    "minecraft:water[level=0]",
    "minecraft:oak_planks",
    "minecraft:quartz_block",
    "minecraft:orange_concrete",
    "minecraft:magenta_concrete",
    "minecraft:light_blue_concrete",
    "minecraft:yellow_concrete",
    "minecraft:lime_concrete",
    "minecraft:pink_concrete",
    "minecraft:gray_concrete",
    "minecraft:light_gray_concrete",
    "minecraft:cyan_concrete",
    "minecraft:purple_concrete",
    "minecraft:blue_concrete",
    "minecraft:brown_concrete",
    "minecraft:green_concrete",
    "minecraft:red_concrete",
    "minecraft:black_concrete",
    "minecraft:gold_block",
    "minecraft:diamond_block",
    "minecraft:lapis_block",
    "minecraft:emerald_block",
    "minecraft:podzol[snowy=false]",
    "minecraft:netherrack",
    "minecraft:white_terracotta",
    "minecraft:orange_terracotta",
    "minecraft:magenta_terracotta",
    "minecraft:light_blue_terracotta",
    "minecraft:yellow_terracotta",
    "minecraft:lime_terracotta",
    "minecraft:pink_terracotta",
    "minecraft:gray_terracotta",
    "minecraft:light_gray_terracotta",
    "minecraft:cyan_terracotta",
    "minecraft:purple_terracotta",
    "minecraft:blue_terracotta",
    "minecraft:brown_terracotta",
    "minecraft:green_terracotta",
    "minecraft:red_terracotta",
    "minecraft:black_terracotta",
    "minecraft:crimson_nylium",
    "minecraft:crimson_planks",
    "minecraft:crimson_hyphae[axis=y]",
    "minecraft:warped_nylium",
    "minecraft:warped_planks",
    "minecraft:warped_hyphae[axis=y]",
    "minecraft:warped_wart_block",
    "minecraft:deepslate",
    "minecraft:raw_iron_block",
    "minecraft:glow_lichen[down=true,east=false,north=false,south=false,up=false,waterlogged=false]",
    null,
    null
  ]),
  BlockListInfo(name: 'Cheap', info: '内置', set: [
    "minecraft:glass",
    "minecraft:grass_block[snowy=false]",
    "minecraft:birch_planks",
    "minecraft:mushroom_stem[east=true,west=true,north=true,south=true,up=true,down=true]",
    "minecraft:tnt[unstable=false]",
    "minecraft:ice",
    "minecraft:grindstone[face=floor,facing=north]",
    "minecraft:birch_leaves[distance=7,persistent=true]",
    "minecraft:snow_block",
    "minecraft:clay",
    "minecraft:dirt",
    "minecraft:cobblestone",
    "minecraft:water[level=0]",
    "minecraft:oak_planks",
    "minecraft:target[power=0]",
    "minecraft:orange_concrete",
    "minecraft:magenta_concrete",
    "minecraft:light_blue_concrete",
    "minecraft:yellow_concrete",
    "minecraft:lime_concrete",
    "minecraft:pink_concrete",
    "minecraft:gray_concrete",
    "minecraft:light_gray_concrete",
    "minecraft:cyan_concrete",
    "minecraft:purple_concrete",
    "minecraft:blue_concrete",
    "minecraft:brown_concrete",
    "minecraft:green_concrete",
    "minecraft:red_concrete",
    "minecraft:black_concrete",
    "minecraft:light_weighted_pressure_plate[power=0]",
    "minecraft:prismarine_bricks",
    "minecraft:lapis_block",
    "minecraft:emerald_block",
    "minecraft:spruce_planks",
    "minecraft:netherrack",
    "minecraft:white_terracotta",
    "minecraft:orange_terracotta",
    "minecraft:magenta_terracotta",
    "minecraft:light_blue_terracotta",
    "minecraft:yellow_terracotta",
    "minecraft:lime_terracotta",
    "minecraft:pink_terracotta",
    "minecraft:gray_terracotta",
    "minecraft:light_gray_terracotta",
    "minecraft:cyan_terracotta",
    "minecraft:purple_terracotta",
    "minecraft:blue_terracotta",
    "minecraft:brown_terracotta",
    "minecraft:green_terracotta",
    "minecraft:red_terracotta",
    "minecraft:black_terracotta",
    "minecraft:crimson_nylium",
    "minecraft:crimson_planks",
    "minecraft:crimson_hyphae[axis=y]",
    "minecraft:warped_nylium",
    "minecraft:warped_planks",
    "minecraft:warped_hyphae[axis=y]",
    "minecraft:warped_wart_block",
    "minecraft:deepslate",
    "minecraft:raw_iron_block",
    "minecraft:glow_lichen[down=true,east=false,north=false,south=false,up=false,waterlogged=false]",
    null,
    null
  ]),
  BlockListInfo(name: 'Elegant', info: '内置', set: [
    "minecraft:glass",
    "minecraft:slime_block",
    "minecraft:smooth_sandstone",
    "minecraft:mushroom_stem[east=true,west=true,north=true,south=true,up=true,down=true]",
    "minecraft:redstone_block",
    "minecraft:packed_ice",
    "minecraft:iron_block",
    "minecraft:birch_leaves[distance=7,persistent=true]",
    "minecraft:white_concrete",
    "minecraft:clay",
    "minecraft:brown_mushroom_block[east=true,west=true,north=true,south=true,up=true,down=true]",
    "minecraft:smooth_stone",
    "minecraft:water[level=0]",
    "minecraft:oak_planks",
    "minecraft:quartz_block",
    "minecraft:orange_concrete",
    "minecraft:magenta_concrete",
    "minecraft:light_blue_concrete",
    "minecraft:yellow_concrete",
    "minecraft:lime_concrete",
    "minecraft:pink_concrete",
    "minecraft:gray_concrete",
    "minecraft:light_gray_concrete",
    "minecraft:cyan_concrete",
    "minecraft:purple_concrete",
    "minecraft:blue_concrete",
    "minecraft:brown_concrete",
    "minecraft:green_concrete",
    "minecraft:red_concrete",
    "minecraft:black_concrete",
    "minecraft:gold_block",
    "minecraft:prismarine_bricks",
    "minecraft:lapis_block",
    "minecraft:emerald_block",
    "minecraft:spruce_planks",
    "minecraft:nether_bricks",
    "minecraft:white_terracotta",
    "minecraft:orange_terracotta",
    "minecraft:magenta_terracotta",
    "minecraft:light_blue_terracotta",
    "minecraft:yellow_terracotta",
    "minecraft:lime_terracotta",
    "minecraft:pink_terracotta",
    "minecraft:gray_terracotta",
    "minecraft:light_gray_terracotta",
    "minecraft:cyan_terracotta",
    "minecraft:purple_terracotta",
    "minecraft:blue_terracotta",
    "minecraft:brown_terracotta",
    "minecraft:green_terracotta",
    "minecraft:red_terracotta",
    "minecraft:black_terracotta",
    "minecraft:crimson_nylium",
    "minecraft:crimson_planks",
    "minecraft:stripped_crimson_hyphae[axis=y]",
    "minecraft:warped_nylium",
    "minecraft:warped_planks",
    "minecraft:stripped_warped_hyphae[axis=y]",
    "minecraft:warped_wart_block",
    "minecraft:deepslate",
    "minecraft:raw_iron_block",
    "minecraft:glow_lichen[down=true,east=false,north=false,south=false,up=false,waterlogged=false]",
    null,
    null
  ]),
  BlockListInfo(name: 'Shiny', info: '内置', set: [
    "minecraft:glass",
    "minecraft:slime_block",
    "minecraft:glowstone",
    "minecraft:mushroom_stem[east=true,west=true,north=true,south=true,up=true,down=true]",
    "minecraft:redstone_block",
    "minecraft:blue_ice",
    "minecraft:lantern[hanging=false]",
    "minecraft:birch_leaves[distance=7,persistent=true]",
    "minecraft:white_concrete",
    "minecraft:clay",
    "minecraft:brown_mushroom_block[east=true,west=true,north=true,south=true,up=true,down=true]",
    "minecraft:smooth_stone",
    "minecraft:water[level=0]",
    "minecraft:oak_planks",
    "minecraft:sea_lantern",
    "minecraft:orange_concrete",
    "minecraft:magenta_concrete",
    "minecraft:light_blue_concrete",
    "minecraft:yellow_concrete",
    "minecraft:lime_concrete",
    "minecraft:pink_concrete",
    "minecraft:gray_concrete",
    "minecraft:light_gray_concrete",
    "minecraft:cyan_concrete",
    "minecraft:purple_concrete",
    "minecraft:blue_concrete",
    "minecraft:brown_concrete",
    "minecraft:green_concrete",
    "minecraft:shroomlight",
    "minecraft:black_concrete",
    "minecraft:gold_block",
    "minecraft:prismarine_bricks",
    "minecraft:lapis_block",
    "minecraft:emerald_block",
    "minecraft:campfire[facing=north,lit=true,signal_fire=false,waterlogged=false]",
    "minecraft:magma_block",
    "minecraft:white_terracotta",
    "minecraft:orange_terracotta",
    "minecraft:magenta_terracotta",
    "minecraft:light_blue_terracotta",
    "minecraft:yellow_terracotta",
    "minecraft:lime_terracotta",
    "minecraft:pink_terracotta",
    "minecraft:gray_terracotta",
    "minecraft:light_gray_terracotta",
    "minecraft:cyan_terracotta",
    "minecraft:purple_terracotta",
    "minecraft:blue_terracotta",
    "minecraft:brown_terracotta",
    "minecraft:green_terracotta",
    "minecraft:red_terracotta",
    "minecraft:black_terracotta",
    "minecraft:crimson_nylium",
    "minecraft:crimson_planks",
    "minecraft:stripped_crimson_hyphae[axis=y]",
    "minecraft:warped_nylium",
    "minecraft:warped_planks",
    "minecraft:stripped_warped_hyphae[axis=y]",
    "minecraft:warped_wart_block",
    "minecraft:deepslate",
    "minecraft:raw_iron_block",
    "minecraft:glow_lichen[down=true,east=false,north=false,south=false,up=false,waterlogged=false]",
    null,
    null
  ]),
];
List<String> baseColorNames = [
  'None',
  'Grass',
  'Sand',
  'Wool',
  'Fire',
  'Ice',
  'Metal',
  'Plant',
  'Snow',
  'Clay',
  'Dirt',
  'Stone',
  'Water',
  'Wood',
  'Quartz',
  'ColorOrange',
  'ColorMagenta',
  'ColorLightBlue',
  'ColorYellow',
  'ColorLime',
  'ColorPink',
  'ColorGray',
  'ColorLightGray',
  'ColorCyan',
  'ColorPurple',
  'ColorBlue',
  'ColorBrown',
  'ColorGreen',
  'ColorRed',
  'ColorBlack',
  'Gold',
  'Diamond',
  'Lapis',
  'Emerald',
  'Podzol',
  'Nether',
  'TerracottaWhite',
  'TerracottaOrange',
  'TerracottaMagenta',
  'TerracottaLightBlue',
  'TerracottaYellow',
  'TerracottaLime',
  'TerracottaPink',
  'TerracottaGray',
  'TerracottaLightGray',
  'TerracottaCyan',
  'TerracottaPurple',
  'TerracottaBlue',
  'TerracottaBrown',
  'TerracottaGreen',
  'TerracottaRed',
  'TerracottaBlack',
  'CrimsonNylium',
  'CrimsonStem',
  'CrimsonHyphae',
  'WarpedNylium',
  'WarpedStem',
  'WarpedHyphae',
  'WarpedWartBlock',
  'Deepslate',
  'RawIron',
  'GlowLichen',
  '',
  ''
];
enum ExportType { file, litematica, structure }

class Item {
  Item({required this.count, required this.name, required this.image, required this.countb});
  int count;
  String name;
  Image image;
  String countb;
}

class GKernel {
  GKernel._internal();

  static GKernel instance = GKernel._internal();

  static getInstance() {
    return instance;
  }

  factory GKernel() => getInstance();
  bool multiMode = false;
  List<String> multiRaw = [];
  String current = path.current;
  ValueNotifier<int> index = ValueNotifier<int>(0);
  Color backgroundColor = const Color.fromARGB(255, 220, 220, 220);
  int mapType = 0;
  String gameVersion = '1.18';
  SlopeCraftL scl = SlopeCraftL(DynamicLibrary.open('slopecraft.dll'));
  File picture = File('');
  // ignore: non_constant_identifier_names
  int scl_pureTpPixelSt = SCL_PureTpPixelSt.ReplaceWithBackGround;
  // ignore: non_constant_identifier_names
  int scl_halfTpPixelSt = SCL_HalfTpPixelSt.ComposeWithBackGround;
  Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 4, errorMethodCount: 8, lineLength: 120, colors: true, printEmojis: false, printTime: true),
  );
  ExportType exportType = ExportType.litematica;
  BlockListManager blockListManager = BlockListManager();
  bool dithering = false;
  String convertMethod = 'RGB+';
  int? height, width;
  Image? convertedImage = Image.file(
    File(path.join(dataPrefix, 'transparent.png')),
    cacheHeight: 1,
    cacheWidth: 1,
  );
  Image raw = Image.file(
    File(path.join(dataPrefix, 'transparent.png')),
    cacheHeight: 1,
    cacheWidth: 1,
  );
  Image? show;
  int compress = compressSettings.Both;
  TextEditingController maH = TextEditingController(text: '255');
  int bridge = glassBridgeSettings.noBridge;
  TextEditingController bI = TextEditingController(text: '4');
  bool fireProof = true;
  bool endermanProof = false;
  bool showraw = true;
  TextEditingController liteName = TextEditingController(text: 'Pixel Paint by SlopeCraft');
  TextEditingController liteAuthor = TextEditingController(text: 'SlopeCraft');
  TextEditingController liteRegionName = TextEditingController(text: 'Pixel Paint by SlopeCraft');
  TextEditingController mapIndex = TextEditingController(text: '0');
  int dx = 0;
  int dy = 0;
  int dz = 0;
  img.Image? rawImage;
  int imgHeight = 0;
  int imgWidth = 0;
  bool rawneedreset = false;
  bool converting = false;
  bool showString = false;
  List<Item> blocks = [];
  List<Item> blocksLeft = [];
  List<Item> blocksRight = [];
  double titleBarHeight = 0;
  List<String> multiPath = [];
  List<String> multiDir = [];
  void getBlockCounts() {
    blocks.clear();
    blocksLeft.clear();
    blocksRight.clear();
    Pointer<Int32> total = ffi.malloc.call(1);
    Pointer<Int32> detail = ffi.malloc.call(64);
    scl.SCL_getBlockCountsInTypes(total, detail);
    for (int i = 0; i < 64; i++) {
      if (detail.elementAt(i).value > 0) {
        int c = detail.elementAt(i).value;
        blocks.add(Item(
            count: c,
            name: blockListManager.selected(baseColor: i)!.nameZH,
            image: Image.file(
              File(blockListManager.iconPath[GKernel.instance.blockListManager.selected(baseColor: i)!.icon] ?? path.join(current, dataPrefix, 'missing.png')),
            ),
            countb: convert(i == 12)(c)));
      }
    }
    GKernel.instance.blocks.sort(((a, b) {
      return b.count - a.count;
    }));
    for (int i = 0; i < blocks.length; i++) {
      if (i * 2 < blocks.length) {
        blocksLeft.add(blocks[i]);
      } else {
        blocksRight.add(blocks[i]);
      }
    }
  }

  Future<void> setType(BuildContext context, [bool silence = false]) async {
    if (scl.SCL_queryStep() < step.colorSetReady) {
      await showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: const Text('错误'),
            content: const Text('不能跳步操作'),
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
      );
      return;
    }
    Pointer<Uint8> ena = ffi.malloc.allocate(sizeOf<Uint8>() * 64);

    for (int i = 0; i < 64; i++) {
      //基色无效
      if (blockListManager.getBlockList(version: int.parse(gameVersion.replaceAll('.', '')) - 100, baseColor: i).isEmpty) {
        ena.elementAt(i).value = 0;
      }
      //基色已禁用
      else if (!blockListManager.isEnabled(baseColor: i)) {
        ena.elementAt(i).value = 0;
      }
      //未选择方块
      else if (blockListManager.selected(baseColor: i) == null) {
        ena.elementAt(i).value = 0;
      } else {
        ena.elementAt(i).value = 1;
      }
    }

    Pointer<Pointer<AbstractBlock>> ab = ffi.malloc.allocate(sizeOf<Pointer<AbstractBlock>>() * 64);
    for (int i = 0; i < 64; i++) {
      Block b;
      //基色无效
      if (blockListManager.getBlockList(version: int.parse(gameVersion.replaceAll('.', '')) - 100, baseColor: i).isEmpty) {
        b = blockListManager.getBlockList(version: 114514, baseColor: 0)[0];
      }
      //未选择方块
      else if (blockListManager.selected(baseColor: i) == null) {
        await showDialog(
          context: context,
          builder: (context) {
            return ContentDialog(
              title: const Text('配置未完成'),
              content: const Text('你没有为某些基色选择方块'),
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
        );
        return;
      } else {
        b = blockListManager.selected(baseColor: i)!;
      }
      ab.elementAt(i).value = scl.SCL_createBlock();
      scl.SCL_setId(ab.elementAt(i).value, b.id.toNativeUtf8().cast());
      scl.SCL_setVersion(ab.elementAt(i).value, b.version);
      scl.SCL_setIdOld(ab.elementAt(i).value, (b.idOld ?? '').toNativeUtf8().cast());
      scl.SCL_setNeedGlass(ab.elementAt(i).value, b.needGlass ?? false);
      scl.SCL_setDoGlow(ab.elementAt(i).value, b.isGlowing ?? false);
      scl.SCL_setEndermanPickable(ab.elementAt(i).value, b.endermanPickable ?? false);
      scl.SCL_setBurnable(ab.elementAt(i).value, b.burnable ?? false);
      scl.SCL_setWallUseable(ab.elementAt(i).value, b.wallUseable ?? false);
    }
    scl.SCL_setType(mapType, int.parse(gameVersion.replaceAll('.', '')) - 100, ena, ab);
    for (int i = 0; i < 64; i++) {
      scl.SCL_destroyBlock(ab.elementAt(i).value);
    }
    if (scl.SCL_queryStep() < step.wait4Image) {
      await showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: const Text('设置保存失败'),
            content: const Text('未知错误'),
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
      );
      return;
    }
    if (!silence) {
      showSnackbar(
        context,
        const Snackbar(
          content: Text('设置保存成功!'),
        ),
      );
      index.value = 2;
    }
  }

  Future<void> loadColorSet(String p) async {
    File rgb = File(path.join(p, 'RGB.TokiColor'));
    if (!(await rgb.exists())) {
      return;
    }
    String rgbs = await rgb.readAsString();
    File hsv = File(path.join(p, 'HSV.TokiColor'));
    if (!(await hsv.exists())) {
      return;
    }
    String hsvs = await hsv.readAsString();
    File lab = File(path.join(p, 'Lab.TokiColor'));
    if (!(await lab.exists())) {
      return;
    }
    String labs = await lab.readAsString();
    File xyz = File(path.join(p, 'XYZ.TokiColor'));
    if (!(await xyz.exists())) {
      return;
    }
    String xyzs = await xyz.readAsString();
    scl.SCL_setColorSet(rgbs.toNativeUtf8().cast<Int8>(), hsvs.toNativeUtf8().cast<Int8>(), labs.toNativeUtf8().cast<Int8>(), xyzs.toNativeUtf8().cast<Int8>());
  }

  Future<void> setRawImage(BuildContext context, bool silence) async {
    if (rawImage == null) {
      await showDialog(
        builder: (context) {
          return ContentDialog(
            title: const Text('读取图片失败'),
            content: const Text('请检查图片'),
            actions: [
              Button(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        },
        context: context,
      );
      return;
    }
    imgHeight = rawImage!.height;
    imgWidth = rawImage!.width;
    height = null;
    width = null;
    var d = rawImage!.getBytes(format: img.Format.argb);

    Pointer<Uint32> pointer = ffi.malloc.allocate(sizeOf<Uint32>() * rawImage!.length);
    for (int h = 0; h < imgHeight; h++) {
      for (int w = 0; w < imgWidth; w++) {
        int i = h * imgWidth + w;
        pointer[w * imgHeight + h] = d[i * 4] << 24 | d[i * 4 + 1] << 16 | d[i * 4 + 2] << 8 | d[i * 4 + 3];
      }
    }
    scl.SCL_preprocessImage(pointer, rawImage!.length, scl_pureTpPixelSt, scl_halfTpPixelSt, backgroundColor.value);

    scl.SCL_setRawImage(pointer, imgHeight, imgWidth);

    ffi.malloc.free(pointer);
    if (scl.SCL_queryStep() < step.convertionReady) {
      await showDialog(
        context: context,
        builder: (context) {
          return ContentDialog(
            title: const Text('导入图片失败'),
            content: const Text('未知错误'),
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
      );
      return;
    }
    convertedImage = Image.file(
      File(path.join(dataPrefix, 'transparent.png')),
      cacheHeight: 1,
      cacheWidth: 1,
    );
    show = raw;
    showraw = true;
    if (!silence) {
      showSnackbar(
        context,
        const Snackbar(
          content: Text('导入图片成功!'),
        ),
      );
      index.value = 3;
    }
  }

  void getConvertedImage() {
    Pointer<Int16> rows = nullptr, cols = nullptr;
    Pointer<Uint32> dest = nullptr;
    rows = ffi.malloc.allocate(2);
    cols = ffi.malloc.allocate(2);
    if (width == null || height == null) {
      scl.SCL_getConvertedImage(rows, cols, dest);
      width = cols.value;
      height = rows.value;
    }
    dest = ffi.malloc.allocate(width! * height! * 4);
    scl.SCL_getConvertedImage(rows, cols, dest);
    Uint32List bytes = Uint32List(width! * height!);
    for (int i = 0; i < width! * height!; i++) {
      bytes[i] = dest.elementAt(i).value;
    }
    int _h = height!;
    int _w = width!;
    Uint32List conv = Uint32List(bytes.length);
    for (int h = 0; h < _h; h++) {
      for (int w = 0; w < _w; w++) {
        conv[h * _w + w] = bytes[w * _h + h];
      }
    }
    img.Image image = img.Image.fromBytes(width!, height!, conv, format: img.Format.bgra);
    convertedImage = Image.memory(
      Uint8List.fromList(img.encodeBmp(image)),
      fit: BoxFit.contain,
    );
    ffi.malloc.free(rows);
    ffi.malloc.free(cols);
    ffi.malloc.free(dest);
  }

  Future<void> importMultiImage(BuildContext context, List<String> p) async {
    int failed = 0;
    for (var item in p) {
      if (!multiPath.contains(item)) {
        if (path.extension(item) == '') {
          if (multiDir.contains(item)) {
            failed++;
          } else {
            multiDir.add(item);
            multiPath.add(item);
          }
        } else {
          bool value = File(item).existsSync();
          if (value) {
            var picture = File(item);
            if (['.png', '.bmp', '.jpeg', '.jpg', '.tga', '.webp', '.tiff'].contains(path.extension(item))) {
              var v = picture.readAsBytesSync();
              List<int> f = v;
              var p = img.decodeNamedImage(f, path.extension(item));

              if (p != null) {
                multiRaw.add(item);
                multiPath.add(item);
              } else {
                failed++;
              }
            } else {
              failed++;
            }
          } else {
            failed++;
          }
        }
      } else {
        failed++;
      }
    }
    await showDialog(
      builder: (context) {
        return ContentDialog(
          title: const Text('读取完成'),
          content: Text('已加载${p.length - failed}/${p.length}'),
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
      context: context,
    );
    return;
  }

  Future<void> importImage(BuildContext context, String p) async {
    if (File(p).existsSync() == false) {
      await showDialog(
        builder: (context) {
          return ContentDialog(
            title: const Text('文件不存在'),
            content: const Text('请检查图片'),
            actions: [
              Button(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  })
            ],
          );
        },
        context: context,
      );
      return;
    }

    GKernel.instance.picture = File(p);

    List<int> f = GKernel.instance.picture.readAsBytesSync();
    GKernel.instance.raw = Image.file(
      GKernel.instance.picture,
      fit: BoxFit.contain,
    );
    GKernel.instance.rawImage = img.decodeNamedImage(f, path.extension(GKernel.instance.picture.path));

    await GKernel.instance.setRawImage(context, false);
  }
}
