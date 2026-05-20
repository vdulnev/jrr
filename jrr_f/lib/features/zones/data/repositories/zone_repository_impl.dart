import 'package:fpdart/fpdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/network/mcws_client.dart';
import '../../../connection/data/repositories/connection_repository.dart';
import '../../providers/active_zone_provider.dart';
import '../../services/android_auto_session_service.dart';
import '../models/zone.dart';
import 'zone_repository.dart';

const _localZones = [Zone.local, Zone.offline];

class ZoneRepositoryImpl implements ZoneRepository {
  final McwsClient Function() _client;
  final ConnectionRepository _connectionRepository;
  final SharedPreferences _prefs;
  final AndroidAutoSessionService _autoSession;

  ZoneRepositoryImpl({
    required McwsClient Function() client,
    required ConnectionRepository connectionRepository,
    required SharedPreferences prefs,
    required AndroidAutoSessionService autoSession,
  }) : _client = client,
       _connectionRepository = connectionRepository,
       _prefs = prefs,
       _autoSession = autoSession;

  /// Appends [Zone.androidAuto] when an Auto session is currently bound.
  /// Phase 4: detection is debounced through [AndroidAutoSessionService] —
  /// the zone disappears from the picker shortly after the car disconnects.
  List<Zone> _withAndroidAuto(List<Zone> zones) {
    if (_autoSession.isConnected.value) {
      return [...zones, Zone.androidAuto];
    }
    return zones;
  }

  @override
  Future<Either<AppException, List<Zone>>> getZones() async {
    // If the current session is the synthetic "offline" one, we skip all
    // network calls and only return the Offline zone.
    // We also hide the 'local' zone in this case because without a server
    // it's non-functional (cannot resolve streaming URLs).
    final session = _connectionRepository.currentToken;
    if (session == null) {
      return right(_withAndroidAuto([Zone.offline]));
    }

    final savedGuid = _prefs.getString(kActiveZoneGuidKey);
    if (savedGuid == 'offline-zone-guid') {
      return right(_withAndroidAuto(_localZones));
    }

    try {
      final result = await _client().getZones();
      return result.fold(
        (e) => right(_withAndroidAuto(_localZones)),
        (zones) => right(_withAndroidAuto([...zones, ..._localZones])),
      );
    } catch (_) {
      return right(_withAndroidAuto(_localZones));
    }
  }

  @override
  Future<Either<AppException, Unit>> setActiveZone(String zoneId) async {
    // Virtual zones (Local/Offline/Android Auto) don't need a server-side
    // setActiveZone call.
    if (zoneId == 'local' || zoneId == 'offline' || zoneId == 'android-auto') {
      return right(unit);
    }

    try {
      return await _client().setActiveZone(zoneId);
    } catch (e) {
      return left(AppException.unknown(error: e));
    }
  }
}
