import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pispapp/models/consent.dart';
import 'package:pispapp/repositories/interfaces/i_consent_repository.dart';

class ConsentRepository implements IConsentRepository {
  final CollectionReference _consentRef =
      Firestore.instance.collection('consents');

  @override
  Future<List<Consent>> getConsents(String userId) {
    return _consentRef.where('userId', isEqualTo: userId).getDocuments().then(
          (snapshot) => snapshot.documents.map((element) {
            final Consent c = Consent.fromJson(element.data);
            c.id = element.documentID;
            return c;
          }).toList(),
        );
  }

  @override
  Future<List<Consent>> getActiveConsents(String userId) {
    return getConsents(userId).then((consents) {
      return consents.where((c) => c.status == ConsentStatus.active).toList();
    });
  }

  @override
  Future<String> add(Map<String, dynamic> data) async {
    final docRef = await _consentRef.add(data);
    return docRef.documentID;
  }

  @override
  Future<void> updateData(String id, Map<String, dynamic> data) async {
    await _consentRef.document(id).updateData(data);
  }

  @override
  void Function() listen(String id, {ConsentHandler onValue}) {
    final subscription = _consentRef.document(id).snapshots().listen((event) {
      onValue(Consent.fromJson(event.data));
    });

    return () => subscription.cancel();
  }

  @override
  Future<void> setData(String id, Map<String, dynamic> data,
      {bool merge = false}) async {
    await _consentRef.document(id).setData(data, merge: merge);
  }
}