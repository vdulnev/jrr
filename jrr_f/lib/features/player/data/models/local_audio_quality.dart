/// MCWS conversion presets used when streaming a track from JRiver to the
/// local just_audio player. Maps to `Conversion=…&Quality=…` query params.
enum LocalAudioQuality {
  lossless('flac', 'high', 'Lossless'),
  lossyHigh('opus', 'high', 'Lossy (high)'),
  lossyNormal('opus', 'normal', 'Lossy (normal)'),
  lossyLow('opus', 'low', 'Lossy (low)');

  final String conversion;
  final String quality;
  final String label;

  const LocalAudioQuality(this.conversion, this.quality, this.label);

  /// `Conversion=…&Quality=…` fragment ready to append to a GetFile URL.
  String get mcwsParams => 'Conversion=$conversion&Quality=$quality';

  static LocalAudioQuality fromName(String? name) =>
      LocalAudioQuality.values.firstWhere(
        (e) => e.name == name,
        orElse: () => LocalAudioQuality.lossless,
      );
}
