import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/models/server_info.dart';

part 'session_state.freezed.dart';

@freezed
sealed class SessionState with _$SessionState {
  const factory SessionState.unauthenticated() = Unauthenticated;
  const factory SessionState.authenticated({required ServerInfo serverInfo}) =
      Authenticated;
}
