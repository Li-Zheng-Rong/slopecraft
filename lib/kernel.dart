import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:enough_convert/enough_convert.dart';
import 'package:ffi/ffi.dart' as ffi;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;
import 'package:worker_manager/worker_manager.dart' as tp;

import 'block.dart';
import 'blockmanager.dart';
import 'count_convert.dart';
import 'scl_interface.dart';

const String dataPrefix = 'SCData';

class ExportMultiArgs {
  ExportMultiArgs(
      {required this.convertMethod,
      required this.p,
      // ignore: non_constant_identifier_names
      required this.scl_halfTpPixelSt,
      // ignore: non_constant_identifier_names
      required this.scl_pureTpPixelSt,
      required this.dithering,
      required this.liteName,
      required this.liteAuthor,
      required this.liteRegionName,
      required this.bI,
      required this.bridge,
      required this.compress,
      required this.endermanProof,
      required this.exportType,
      required this.fireProof,
      required this.maH,
      required this.backgroundColor,
      required this.cpuid,
      required this.exportDir,
      required this.mapId});
  String convertMethod, p;

  // ignore: non_constant_identifier_names
  int scl_pureTpPixelSt;
  // ignore: non_constant_identifier_names
  int scl_halfTpPixelSt;
  int cpuid;
  bool dithering;
  String liteName;
  String liteAuthor;
  String liteRegionName;
  ExportType exportType;
  int compress;
  int maH;
  int bridge;
  int bI;
  bool fireProof;
  bool endermanProof;
  Color backgroundColor;
  String exportDir;
  int mapId;
}

class ExportMultiReturn {
  ExportMultiReturn({required this.p, required this.s});
  String p;
  bool s;
}

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
enum OSVersion { win11, win10, win7, unknown }

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
  bool founded = false;
  bool multiMode = false;
  List<String> multiRaw = [];
  String current = path.current;
  int mapid = 0;
  String mapdir = path.current;
  ValueNotifier<int> index = ValueNotifier<int>(0);
  Color backgroundColor = const Color.fromARGB(255, 220, 220, 220);
  int mapType = 0;
  String gameVersion = '1.18';
  bool multiSingleThread = false;
  bool verbose = true;
  int finished = 0;
  OSVersion osversion = OSVersion.unknown;
  SlopeCraftL scl = SlopeCraftL(DynamicLibrary.open('slopecraft.dll'));
  List<SlopeCraftL> sclcpu = [
    SlopeCraftL(DynamicLibrary.open('slopecraft cpu0.dll')),
    SlopeCraftL(DynamicLibrary.open('slopecraft cpu1.dll')),
    SlopeCraftL(DynamicLibrary.open('slopecraft cpu2.dll')),
    SlopeCraftL(DynamicLibrary.open('slopecraft cpu3.dll')),
    SlopeCraftL(DynamicLibrary.open('slopecraft cpu4.dll')),
    SlopeCraftL(DynamicLibrary.open('slopecraft cpu5.dll')),
    SlopeCraftL(DynamicLibrary.open('slopecraft cpu6.dll')),
    SlopeCraftL(DynamicLibrary.open('slopecraft cpu7.dll')),
  ];
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
  ValueNotifier<double?> multiProgress = ValueNotifier<double?>(0.0);
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
  ValueNotifier<bool> building = ValueNotifier<bool>(false);
  int compress = compressSettings.Both;
  TextEditingController maH = TextEditingController(text: '255');
  int bridge = glassBridgeSettings.noBridge;
  TextEditingController bI = TextEditingController(text: '4');
  bool fireProof = false;
  bool endermanProof = false;
  bool showraw = true;
  TextEditingController liteName = TextEditingController(text: 'Pixel Paint by SlopeCraft');
  TextEditingController liteAuthor = TextEditingController(text: 'SlopeCraft');
  TextEditingController liteRegionName = TextEditingController(text: 'Pixel Paint by SlopeCraft');
  TextEditingController mapIndex = TextEditingController(text: '0');
  TextEditingController multiExportFile = TextEditingController(text: '\${PICTURE_PARENT_PATH}/\${PICTURE_BASENAME}');
  List<String> multiFail = [];
  List<String> multiDirFiles = [];
  int dx = 0;
  int dy = 0;
  int dz = 0;
  img.Image? rawImage;
  int threads = 8;
  int imgHeight = 0;
  int imgWidth = 0;
  bool rawneedreset = false;
  bool converting = false;
  bool showString = false;
  List<Item> blocks = [];
  List<Item> blocksLeft = [];
  List<Item> blocksRight = [];
  double titleBarHeight = 0;
  List<String> multiDir = [];
  void getBlockCounts() {
    blocks.clear();
    blocksLeft.clear();
    blocksRight.clear();
    Pointer<Int32> total = ffi.calloc.call(1);
    Pointer<Int32> detail = ffi.calloc.call(64);
    scl.SCL_getBlockCountsInTypes(total, detail);
    for (int i = 0; i < 64; i++) {
      if (detail.elementAt(i).value > 0) {
        int c = detail.elementAt(i).value;
        blocks.add(Item(
            count: c,
            name: blockListManager.selected(baseColor: i)!.nameZH,
            image: Image.file(
              File(blockListManager.iconPath[blockListManager.selected(baseColor: i)!.icon] ?? path.join(current, dataPrefix, 'missing.png')),
            ),
            countb: convert(i == 12)(c)));
      }
    }
    blocks.sort(((a, b) {
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
    Pointer<Uint8> ena = ffi.calloc.allocate(sizeOf<Uint8>() * 64);

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

    Pointer<Pointer<AbstractBlock>> ab = ffi.calloc.allocate(sizeOf<Pointer<AbstractBlock>>() * 64);
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

  Future<void> setTypeCPU(BuildContext context, int cpuid, [bool silence = false]) async {
    if (sclcpu[cpuid].SCL_queryStep() < step.colorSetReady) {
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
    Pointer<Uint8> ena = ffi.calloc.allocate(sizeOf<Uint8>() * 64);

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

    Pointer<Pointer<AbstractBlock>> ab = ffi.calloc.allocate(sizeOf<Pointer<AbstractBlock>>() * 64);
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
      ab.elementAt(i).value = sclcpu[cpuid].SCL_createBlock();
      sclcpu[cpuid].SCL_setId(ab.elementAt(i).value, b.id.toNativeUtf8().cast());
      sclcpu[cpuid].SCL_setVersion(ab.elementAt(i).value, b.version);
      sclcpu[cpuid].SCL_setIdOld(ab.elementAt(i).value, (b.idOld ?? '').toNativeUtf8().cast());
      sclcpu[cpuid].SCL_setNeedGlass(ab.elementAt(i).value, b.needGlass ?? false);
      sclcpu[cpuid].SCL_setDoGlow(ab.elementAt(i).value, b.isGlowing ?? false);
      sclcpu[cpuid].SCL_setEndermanPickable(ab.elementAt(i).value, b.endermanPickable ?? false);
      sclcpu[cpuid].SCL_setBurnable(ab.elementAt(i).value, b.burnable ?? false);
      sclcpu[cpuid].SCL_setWallUseable(ab.elementAt(i).value, b.wallUseable ?? false);
    }
    sclcpu[cpuid].SCL_setType(mapType, int.parse(gameVersion.replaceAll('.', '')) - 100, ena, ab);
    for (int i = 0; i < 64; i++) {
      sclcpu[cpuid].SCL_destroyBlock(ab.elementAt(i).value);
    }
    if (sclcpu[cpuid].SCL_queryStep() < step.wait4Image) {
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

  Future<void> loadColorSetCPU(String p, int cpuid) async {
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
    sclcpu[cpuid].SCL_setColorSet(
        rgbs.toNativeUtf8().cast<Int8>(), hsvs.toNativeUtf8().cast<Int8>(), labs.toNativeUtf8().cast<Int8>(), xyzs.toNativeUtf8().cast<Int8>());
  }

  Future<void> setRawImage(BuildContext context, bool silence) async {
    if (rawImage == null) {
      await showDialog(
        builder: (context) {
          return ContentDialog(
            title: const Text('读取图片失败'),
            content: const Text('请检查图片'),
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
    imgHeight = rawImage!.height;
    imgWidth = rawImage!.width;
    if (imgHeight < 16 || imgWidth < 16) {
      await showDialog(
        builder: (context) {
          return ContentDialog(
            title: const Text('读取图片出错'),
            content: const Text('请选择大于等于16x16像素的图片'),
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
    height = null;
    width = null;
    var d = rawImage!.getBytes(format: img.Format.argb);

    Pointer<Uint32> pointer = ffi.calloc.allocate(sizeOf<Uint32>() * rawImage!.length);
    for (int h = 0; h < imgHeight; h++) {
      for (int w = 0; w < imgWidth; w++) {
        int i = h * imgWidth + w;
        pointer[w * imgHeight + h] = d[i * 4] << 24 | d[i * 4 + 1] << 16 | d[i * 4 + 2] << 8 | d[i * 4 + 3];
      }
    }
    scl.SCL_preprocessImage(pointer, rawImage!.length, scl_pureTpPixelSt, scl_halfTpPixelSt, backgroundColor.value);

    scl.SCL_setRawImage(pointer, imgHeight, imgWidth);

    ffi.calloc.free(pointer);
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
    rows = ffi.calloc.allocate(2);
    cols = ffi.calloc.allocate(2);
    if (width == null || height == null) {
      scl.SCL_getConvertedImage(rows, cols, dest);
      width = cols.value;
      height = rows.value;
    }
    dest = ffi.calloc.allocate(width! * height! * 4);
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
    ffi.calloc.free(rows);
    ffi.calloc.free(cols);
    ffi.calloc.free(dest);
  }

  Future<void> importMultiImage(BuildContext context, List<String> p) async {
    int failed = 0;
    for (var item in p) {
      if (FileStat.statSync(item).type == FileSystemEntityType.directory) {
        if (multiDir.contains(item)) {
          failed++;
        } else {
          multiDir.add(item);
        }
      } else {
        if (!multiRaw.contains(item)) {
          if (FileStat.statSync(item).type == FileSystemEntityType.file) {
            var picture = File(item);
            if (['.png', '.bmp', '.jpeg', '.jpg', '.tga', '.webp', '.tiff'].contains(path.extension(item))) {
              var v = picture.readAsBytesSync();
              List<int> f = v;
              var p = img.decodeNamedImage(f, path.extension(item));

              if (p != null) {
                if (p.height < 16 || p.width < 16) {
                  failed++;
                } else {
                  multiRaw.add(item);
                }
              } else {
                failed++;
              }
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

    picture = File(p);

    List<int> f = picture.readAsBytesSync();
    raw = Image.file(
      picture,
      fit: BoxFit.contain,
    );
    rawImage = img.decodeNamedImage(f, path.extension(picture.path));

    await setRawImage(context, false);
  }
}

ExportMultiReturn exportMulti(ExportMultiArgs args) {
  img.Image? multiRawCache;
  File pictureC = File('');
  int imgHeightC = 0;
  int imgWidthC = 0;
  //import picture
  if (args.exportType != ExportType.file && File(args.p).existsSync() == false) {
    return ExportMultiReturn(s: false, p: args.p);
  }

  pictureC = File(args.p);

  List<int> f = pictureC.readAsBytesSync();
  multiRawCache = img.decodeNamedImage(f, path.extension(pictureC.path));
  //setRawImage
  if (multiRawCache == null) {
    return ExportMultiReturn(s: false, p: args.p);
  }
  imgHeightC = multiRawCache.height;
  imgWidthC = multiRawCache.width;
  if (imgHeightC < 16 || imgWidthC < 16) {
    return ExportMultiReturn(s: false, p: args.p);
  }
  var d = multiRawCache.getBytes(format: img.Format.argb);

  Pointer<Uint32> pointer = ffi.calloc.allocate(sizeOf<Uint32>() * multiRawCache.length);
  for (int h = 0; h < imgHeightC; h++) {
    for (int w = 0; w < imgWidthC; w++) {
      int i = h * imgWidthC + w;
      pointer[w * imgHeightC + h] = d[i * 4] << 24 | d[i * 4 + 1] << 16 | d[i * 4 + 2] << 8 | d[i * 4 + 3];
    }
  }
  GKernel.instance.sclcpu[args.cpuid]
      .SCL_preprocessImage(pointer, multiRawCache.length, args.scl_pureTpPixelSt, args.scl_halfTpPixelSt, args.backgroundColor.value);

  GKernel.instance.sclcpu[args.cpuid].SCL_setRawImage(pointer, imgHeightC, imgWidthC);

  ffi.calloc.free(pointer);
  if (GKernel.instance.sclcpu[args.cpuid].SCL_queryStep() < step.convertionReady) {
    return ExportMultiReturn(s: false, p: args.p);
  }
  //convert
  switch (args.convertMethod) {
    case 'RGB':
      if (!GKernel.instance.sclcpu[args.cpuid].SCL_convert(convertAlgo.RGB, args.dithering)) {
        return ExportMultiReturn(s: false, p: args.p);
      }
      break;
    case 'RGB+':
      if (!GKernel.instance.sclcpu[args.cpuid].SCL_convert(convertAlgo.RGB_Better, args.dithering)) {
        return ExportMultiReturn(s: false, p: args.p);
      }
      break;
    case 'HSV':
      if (!GKernel.instance.sclcpu[args.cpuid].SCL_convert(convertAlgo.HSV, args.dithering)) {
        return ExportMultiReturn(s: false, p: args.p);
      }
      break;
    case 'Lab94':
      if (!GKernel.instance.sclcpu[args.cpuid].SCL_convert(convertAlgo.Lab94, args.dithering)) {
        return ExportMultiReturn(s: false, p: args.p);
      }
      break;
    case 'Lab00':
      if (!GKernel.instance.sclcpu[args.cpuid].SCL_convert(convertAlgo.Lab00, args.dithering)) {
        return ExportMultiReturn(s: false, p: args.p);
      }
      break;
    case 'XYZ':
      if (!GKernel.instance.sclcpu[args.cpuid].SCL_convert(convertAlgo.XYZ, args.dithering)) {
        return ExportMultiReturn(s: false, p: args.p);
      }
      break;
    case 'AiCvter':
      if (!GKernel.instance.sclcpu[args.cpuid].SCL_convert(convertAlgo.AiCvter, args.dithering)) {
        return ExportMultiReturn(s: false, p: args.p);
      }
      break;
    default:
      return ExportMultiReturn(s: false, p: args.p);
  }
  if (args.exportType == ExportType.litematica || args.exportType == ExportType.structure) {
    GKernel.instance.sclcpu[args.cpuid].SCL_build(args.compress, args.maH, args.bridge, args.bI, args.fireProof, args.endermanProof);

    if (GKernel.instance.sclcpu[args.cpuid].SCL_queryStep() < step.builded) {
      return ExportMultiReturn(s: false, p: args.p);
    }
  }

  if (args.exportType == ExportType.litematica) {
    String outputFile = path.setExtension(args.p, '.litematic');
    final gbk = const GbkCodec(allowInvalid: false).encode(outputFile);

    Pointer<Int8> pg = ffi.calloc.call(gbk.length + 1);
    for (int i = 0; i < gbk.length; i++) {
      pg.elementAt(i).value = gbk[i];
    }
    pg.elementAt(gbk.length).value = 0;
    GKernel.instance.sclcpu[args.cpuid].SCL_exportAsLitematic(
        pg, args.liteName.toNativeUtf8().cast(), args.liteAuthor.toNativeUtf8().cast(), args.liteRegionName.toNativeUtf8().cast(), nullptr);
    return ExportMultiReturn(s: true, p: args.p);
  } else if (args.exportType == ExportType.structure) {
    String outputFile = path.setExtension(args.p, '.nbt');
    final gbk = const GbkCodec(allowInvalid: false).encode(outputFile);

    Pointer<Int8> pg = ffi.calloc.call(gbk.length + 1);
    for (int i = 0; i < gbk.length; i++) {
      pg.elementAt(i).value = gbk[i];
    }
    pg.elementAt(gbk.length).value = 0;
    GKernel.instance.sclcpu[args.cpuid].SCL_exportAsStructure(pg, nullptr);
    return ExportMultiReturn(s: true, p: args.p);
  } else if (args.exportType == ExportType.file) {
    String outputFile = path.withoutExtension(args.exportDir);
    var dir = Directory(outputFile);
    if (!dir.existsSync()) {
      dir.createSync();
    } else if (dir.statSync().type != FileSystemEntityType.directory) {
      return ExportMultiReturn(s: false, p: args.p);
    }
    final gbk = const GbkCodec(allowInvalid: false).encode(outputFile);

    Pointer<Int8> pg = ffi.calloc.call(gbk.length + 1);
    for (int i = 0; i < gbk.length; i++) {
      pg.elementAt(i).value = gbk[i];
    }
    pg.elementAt(gbk.length).value = 0;

    GKernel.instance.sclcpu[args.cpuid].SCL_exportAsData(pg, args.mapId, nullptr, nullptr);

    return ExportMultiReturn(s: true, p: args.p);
  }
  return ExportMultiReturn(s: false, p: args.p);
}

ExportMultiReturn exportMultiSingle(ExportMultiArgs args) {
  img.Image? multiRawCache;
  File pictureC = File('');
  int imgHeightC = 0;
  int imgWidthC = 0;
  //import picture
  if (File(args.p).existsSync() == false) {
    return ExportMultiReturn(s: false, p: args.p);
  }

  pictureC = File(args.p);

  List<int> f = pictureC.readAsBytesSync();
  multiRawCache = img.decodeNamedImage(f, path.extension(pictureC.path));
  //setRawImage
  if (multiRawCache == null) {
    return ExportMultiReturn(s: false, p: args.p);
  }
  imgHeightC = multiRawCache.height;
  imgWidthC = multiRawCache.width;
  var d = multiRawCache.getBytes(format: img.Format.argb);

  Pointer<Uint32> pointer = ffi.calloc.allocate(sizeOf<Uint32>() * multiRawCache.length);
  for (int h = 0; h < imgHeightC; h++) {
    for (int w = 0; w < imgWidthC; w++) {
      int i = h * imgWidthC + w;
      pointer[w * imgHeightC + h] = d[i * 4] << 24 | d[i * 4 + 1] << 16 | d[i * 4 + 2] << 8 | d[i * 4 + 3];
    }
  }
  GKernel.instance.scl.SCL_preprocessImage(pointer, multiRawCache.length, args.scl_pureTpPixelSt, args.scl_halfTpPixelSt, args.backgroundColor.value);

  GKernel.instance.scl.SCL_setRawImage(pointer, imgHeightC, imgWidthC);

  ffi.calloc.free(pointer);
  if (GKernel.instance.scl.SCL_queryStep() < step.convertionReady) {
    return ExportMultiReturn(s: false, p: args.p);
  }
  //convert
  switch (args.convertMethod) {
    case 'RGB':
      if (!GKernel.instance.scl.SCL_convert(convertAlgo.RGB, args.dithering)) {
        return ExportMultiReturn(s: false, p: args.p);
      }
      break;
    case 'RGB+':
      if (!GKernel.instance.scl.SCL_convert(convertAlgo.RGB_Better, args.dithering)) {
        return ExportMultiReturn(s: false, p: args.p);
      }
      break;
    case 'HSV':
      if (!GKernel.instance.scl.SCL_convert(convertAlgo.HSV, args.dithering)) {
        return ExportMultiReturn(s: false, p: args.p);
      }
      break;
    case 'Lab94':
      if (!GKernel.instance.scl.SCL_convert(convertAlgo.Lab94, args.dithering)) {
        return ExportMultiReturn(s: false, p: args.p);
      }
      break;
    case 'Lab00':
      if (!GKernel.instance.scl.SCL_convert(convertAlgo.Lab00, args.dithering)) {
        return ExportMultiReturn(s: false, p: args.p);
      }
      break;
    case 'XYZ':
      if (!GKernel.instance.scl.SCL_convert(convertAlgo.XYZ, args.dithering)) {
        return ExportMultiReturn(s: false, p: args.p);
      }
      break;
    case 'AiCvter':
      if (!GKernel.instance.scl.SCL_convert(convertAlgo.AiCvter, args.dithering)) {
        return ExportMultiReturn(s: false, p: args.p);
      }
      break;
    default:
      return ExportMultiReturn(s: false, p: args.p);
  }
  if (args.exportType == ExportType.litematica || args.exportType == ExportType.structure) {
    GKernel.instance.scl.SCL_build(args.compress, args.maH, args.bridge, args.bI, args.fireProof, args.endermanProof);

    if (GKernel.instance.scl.SCL_queryStep() < step.builded) {
      return ExportMultiReturn(s: false, p: args.p);
    }
  }
  if (args.exportType == ExportType.litematica) {
    String outputFile = path.setExtension(args.p, '.litematic');
    final gbk = const GbkCodec(allowInvalid: false).encode(outputFile);

    Pointer<Int8> pg = ffi.calloc.call(gbk.length + 1);
    for (int i = 0; i < gbk.length; i++) {
      pg.elementAt(i).value = gbk[i];
    }
    pg.elementAt(gbk.length).value = 0;
    GKernel.instance.scl.SCL_exportAsLitematic(
        pg, args.liteName.toNativeUtf8().cast(), args.liteAuthor.toNativeUtf8().cast(), args.liteRegionName.toNativeUtf8().cast(), nullptr);
    return ExportMultiReturn(s: true, p: args.p);
  } else if (args.exportType == ExportType.structure) {
    String outputFile = path.setExtension(args.p, '.nbt');
    final gbk = const GbkCodec(allowInvalid: false).encode(outputFile);

    Pointer<Int8> pg = ffi.calloc.call(gbk.length + 1);
    for (int i = 0; i < gbk.length; i++) {
      pg.elementAt(i).value = gbk[i];
    }
    pg.elementAt(gbk.length).value = 0;
    GKernel.instance.scl.SCL_exportAsStructure(pg, nullptr);
    return ExportMultiReturn(s: true, p: args.p);
  } else if (args.exportType == ExportType.file) {
    String outputFile = path.withoutExtension(args.exportDir);
    var dir = Directory(outputFile);
    if (!dir.existsSync()) {
      dir.createSync();
    }
    if (dir.statSync().type != FileSystemEntityType.directory) {
      return ExportMultiReturn(s: false, p: args.p);
    }
    final gbk = const GbkCodec(allowInvalid: false).encode(outputFile);

    Pointer<Int8> pg = ffi.calloc.call(gbk.length + 1);
    for (int i = 0; i < gbk.length; i++) {
      pg.elementAt(i).value = gbk[i];
    }
    pg.elementAt(gbk.length).value = 0;

    GKernel.instance.scl.SCL_exportAsData(pg, args.mapId, nullptr, nullptr);

    return ExportMultiReturn(s: true, p: args.p);
  }
  return ExportMultiReturn(s: false, p: args.p);
}

Future<void> export(int i, int cpuid) async {
  int total = GKernel.instance.multiRaw.length + GKernel.instance.multiDirFiles.length;
  if (i >= total) {
    return;
  }
  int id = GKernel.instance.mapid;
  int wid = 0, hei = 0;
  if (GKernel.instance.exportType == ExportType.file) {
    String p =
        i >= GKernel.instance.multiDirFiles.length ? GKernel.instance.multiRaw[i - GKernel.instance.multiDirFiles.length] : GKernel.instance.multiDirFiles[i];
    List<int> f = File(p).readAsBytesSync();
    img.Image? r = img.decodeNamedImage(f, path.extension(p));
    if (r != null) {
      hei = (r.height / 128).ceil();
      wid = (r.width / 128).ceil();
      GKernel.instance.mapid += hei * wid;
    } else {
      GKernel.instance.multiFail.add(p);
      return;
    }
  }
  var value = await tp.Executor().execute(
    fun1: exportMulti,
    arg1: ExportMultiArgs(
        cpuid: cpuid,
        convertMethod: GKernel.instance.convertMethod,
        p: i >= GKernel.instance.multiDirFiles.length
            ? GKernel.instance.multiRaw[i - GKernel.instance.multiDirFiles.length]
            : GKernel.instance.multiDirFiles[i],
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
        mapId: id),
  );
  if (!value.s) {
    GKernel.instance.multiFail.add(value.p);
  }
  if (GKernel.instance.verbose) {
    GKernel.instance.finished++;
    GKernel.instance.multiProgress.value = GKernel.instance.finished / total * 100;
  }

  await export(i + GKernel.instance.threads, cpuid);
}
