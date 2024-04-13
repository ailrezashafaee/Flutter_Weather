// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Suggest _$SuggestFromJson(Map<String, dynamic> json) => $checkedCreate(
      'Suggest',
      json,
      ($checkedConvert) {
        final val = Suggest(
          location: $checkedConvert('location', (v) => v as String),
          country: $checkedConvert('country', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$SuggestToJson(Suggest instance) => <String, dynamic>{
      'location': instance.location,
      'country': instance.country,
    };
