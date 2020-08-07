import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pispapp/models/model.dart';

part 'fsp_info.g.dart';

@JsonSerializable(explicitToJson: true)
class FspInfo extends Equatable implements Model {
  FspInfo({this.fspId, this.fspName, this.fspIconUrl});

  @override
  factory FspInfo.fromJson(Map<String, dynamic> json) =>
      _$FspInfoFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FspInfoToJson(this);
  String fspId, fspName, fspIconUrl;

  @override
  List<Object> get props => [fspId, fspName, fspIconUrl];
}
