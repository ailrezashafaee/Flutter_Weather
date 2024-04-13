import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'suggest.g.dart';

@JsonSerializable()
class Suggest extends Equatable {
  const Suggest({
    required this.location,
    required this.country,
  });

  factory Suggest.fromJson(Map<String, dynamic> json) =>
      _$SuggestFromJson(json);

  Map<String, dynamic> toJson() => _$SuggestToJson(this);

  final String location;
  final String country;

  @override
  List<Object?> get props => [location, country];
}
