import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_info.freezed.dart';

@freezed
abstract class ServerInfo with _$ServerInfo {
  const factory ServerInfo({
    required String id,
    required String name,
    required String version,
    required String platform,
    required String address,
  }) = _ServerInfo;
}
