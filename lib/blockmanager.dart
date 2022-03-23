import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'block.dart';

class BlockListManager {
  Map<int, List<Block>> blocks = {
    0: [Block(baseColor: 0, id: 'minecraft:glass', nameZH: '玻璃', nameEN: 'Glass', icon: 'glass.png', version: 0)]
  };
  List<Block?> selectBlocks = List.filled(64, null);
  List<bool> enable = List.filled(64, true);
  Map<String, bool> haveIcon = {};
  Map<String, String> iconPath = {};
  void importBlocks(String jsonSource) {
    var blocklist = BlockList.fromJson(jsonDecode(jsonSource));
    for (var item in blocklist.Blocks) {
      if (!blocks.containsValue(item)) {
        blocks[item.baseColor] != null ? blocks[item.baseColor]?.add(item) : blocks[item.baseColor] = [item];
      }
    }
  }

  List<Block> getBlockList({required int version, required int baseColor}) {
    List<Block> ret = <Block>[];
    for (var item in blocks[baseColor] ?? <Block>[]) {
      if (item.version <= version) {
        ret.add(item);
      }
    }
    return ret;
  }

  void select({Block? block, required int baseColor}) {
    selectBlocks[baseColor] = block;
  }

  Block? selected({required int baseColor}) {
    return selectBlocks[baseColor];
  }

  void uesPreset(List<String?> ids) {
    for (int i = 0; i < 64; i++) {
      if (ids[i] == null) {
        enable[i] = false;
      } else {
        enable[i] = true;
        bool founded = false;
        for (Block item in blocks.containsKey(i) ? blocks[i] ?? <Block>[] : <Block>[]) {
          if (item.id.compareTo(ids[i]!) == 0) {
            selectBlocks[i] = item;
            founded = true;
            break;
          }
        }
        if (!founded) {
          selectBlocks[i] = null;
        }
      }
    }
  }

  void selectByName({required String keyWord}) {
    for (int i = 0; i < 64; i++) {
      if (blocks[i] != null) {
        for (var item in blocks[i] ?? <Block>[]) {
          if (item.id.contains(keyWord)) {
            selectBlocks[i] = item;
          }
        }
      }
    }
  }

  bool isEnabled({required int baseColor}) {
    return enable[baseColor];
  }

  void setEnabled({required int baseColor, required bool enabled}) {
    enable[baseColor] = enabled;
  }

  Future<void> loadTexture({required String folderPath}) async {
    Directory dir = Directory(folderPath);
    dir.stat().then((value) async {
      if (value.type == FileSystemEntityType.directory) {
        await for (var entity in dir.list(recursive: true, followLinks: false)) {
          entity.stat().then((value) {
            if (value.type == FileSystemEntityType.file) {
              haveIcon[path.basename(entity.path)] = haveIcon[path.basename(entity.path)] ?? true;
              iconPath[path.basename(entity.path)] = iconPath[path.basename(entity.path)] ?? path.absolute(entity.path);
            }
          });
        }
      }
    });
  }
}
