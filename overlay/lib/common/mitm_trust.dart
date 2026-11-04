import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:fl_clash/enum/enum.dart';
import 'package:fl_clash/models/models.dart';

const mitmCheckHost = 'mitm-check.flclash.invalid';
const mitmCertificateFileName = 'FlClash CA.crt';

String mitmSavedFileName(MitmCertificate ca) => '${ca.subject}.crt';

class MitmTrustCheck {
  const MitmTrustCheck(
    this.trust, {
    this.missingStores = const [],
    this.certutilInstall,
    this.systemStore = false,
    this.rootAvailable = false,
  });

  final MitmTrust trust;
  final bool systemStore;
  final bool rootAvailable;
  final List<String> missingStores;
  final String? certutilInstall;
}

abstract interface class MitmTrustStore {
  Future<MitmTrustCheck> check(
    MitmCertificate ca,
    Future<String> Function() issueLeaf,
  );
  Future<MitmInstallOutcome> install(MitmCertificate ca);
  Future<bool> remove(MitmCertificate ca);
}

class AndroidMitmTrustStore implements MitmTrustStore {
  @override
  Future<MitmTrustCheck> check(
    MitmCertificate ca,
    Future<String> Function() issueLeaf,
  ) async => const MitmTrustCheck(MitmTrust.notGenerated);

  @override
  Future<MitmInstallOutcome> install(MitmCertificate ca) async =>
      MitmInstallOutcome.saved;

  @override
  Future<bool> remove(MitmCertificate ca) async => false;
}

MitmTrustStore? mitmTrustStoreForPlatform() => null;

List<int> mitmCertificateDer(MitmCertificate ca) {
  final body = const LineSplitter()
      .convert(ca.pem)
      .where((line) => line.isNotEmpty && !line.startsWith('-----'))
      .join();
  return base64.decode(body.trim());
}

String _hexOf(List<int> bytes) =>
    bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join().toUpperCase();

String mitmSha1Hex(MitmCertificate ca) =>
    _hexOf(sha1.convert(mitmCertificateDer(ca)).bytes);

String mitmSha256Hex(MitmCertificate ca) =>
    ca.fingerprint.replaceAll(':', '').toUpperCase();

