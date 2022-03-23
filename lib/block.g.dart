// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Block _$BlockFromJson(Map<String, dynamic> json) => Block(
      baseColor: json['baseColor'] as int,
      id: json['id'] as String,
      nameZH: json['nameZH'] as String,
      nameEN: json['nameEN'] as String,
      icon: json['icon'] as String,
      version: json['version'] as int,
      idOld: json['idOld'] as String? ?? '',
      endermanPickable: json['endermanPickable'] as bool? ?? false,
      needGlass: json['needGlass'] as bool? ?? false,
      isGlowing: json['isGlowing'] as bool? ?? false,
      burnable: json['burnable'] as bool? ?? false,
      wallUseable: json['wallUseable'] as bool? ?? true,
    );

Map<String, dynamic> _$BlockToJson(Block instance) => <String, dynamic>{
      'baseColor': instance.baseColor,
      'id': instance.id,
      'nameZH': instance.nameZH,
      'nameEN': instance.nameEN,
      'icon': instance.icon,
      'version': instance.version,
      'needGlass': instance.needGlass,
      'isGlowing': instance.isGlowing,
      'burnable': instance.burnable,
      'wallUseable': instance.wallUseable,
      'endermanPickable': instance.endermanPickable,
      'idOld': instance.idOld,
    };

BlockList _$BlockListFromJson(Map<String, dynamic> json) => BlockList(
      Blocks: (json['Blocks'] as List<dynamic>)
          .map((e) => Block.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BlockListToJson(BlockList instance) => <String, dynamic>{
      'Blocks': instance.Blocks.map((e) => e.toJson()).toList(),
    };

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
      name: json['name'] as String,
      blocks:
          (json['blocks'] as List<dynamic>).map((e) => e as String?).toList(),
    );

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'name': instance.name,
      'blocks': instance.blocks,
    };
