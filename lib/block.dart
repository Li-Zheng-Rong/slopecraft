// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'block.g.dart';

@JsonSerializable()
class Block {
  Block(
      {required this.baseColor,
      required this.id,
      required this.nameZH,
      required this.nameEN,
      required this.icon,
      required this.version,
      this.idOld,
      this.endermanPickable,
      this.needGlass,
      this.isGlowing,
      this.burnable,
      this.wallUseable});
  int baseColor;
  String id;
  String nameZH;
  String nameEN;
  String icon;
  int version;
  @JsonKey(defaultValue: false)
  bool? needGlass;
  @JsonKey(defaultValue: false)
  bool? isGlowing;
  @JsonKey(defaultValue: false)
  bool? burnable;
  @JsonKey(defaultValue: true)
  bool? wallUseable;
  @JsonKey(defaultValue: false)
  bool? endermanPickable;
  @JsonKey(defaultValue: null)
  String? idOld;

  factory Block.fromJson(Map<String, dynamic> json) => _$BlockFromJson(json);

  Map<String, dynamic> toJson() => _$BlockToJson(this);
}

@JsonSerializable(explicitToJson: true)
class BlockList {
  BlockList({required this.Blocks});

  List<Block> Blocks;

  factory BlockList.fromJson(Map<String, dynamic> json) => _$BlockListFromJson(json);
  Map<String, dynamic> toJson() => _$BlockListToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Config {
  Config({required this.name, required this.blocks});
  String name;
  List<String?> blocks;

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigToJson(this);
}
