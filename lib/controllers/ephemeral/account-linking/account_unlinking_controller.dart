import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pispapp/controllers/app/auth_controller.dart';
import 'package:pispapp/models/consent.dart';
import 'package:pispapp/repositories/interfaces/i_consent_repository.dart';
import 'package:pispapp/ui/theme/light_theme.dart';

class AccountUnlinkingController extends GetxController {
  AccountUnlinkingController(this._consentRepository) {
    _loadActiveConsents();
  }

  IConsentRepository _consentRepository;

  bool isAwaitingUpdate = false;

  // Observable list of consents
  List<Consent> consents;

  // Used to display accounts for removal
  RxList<Account> accounts = <Account>[].obs;

  // Consent that was selected for revocation
  Consent selectedConsent;

  // Account that was selected specifically
  String selectedAccountId;

  // Handles onTap for an account
  void onTap(String accId) {
    selectedAccountId = accId;

    // Display dialog for confirmation
    Get.defaultDialog<dynamic>(
      title: 'Remove Account?',
      confirmTextColor: Colors.white,
      cancelTextColor: LightColor.navyBlue1,
      content: const Padding(child: Text('Are you sure you wish to unlink this account?'),
          padding: EdgeInsets.all(10)),
      onConfirm: () {
        initiateRevocation(accId);
        Get.back();
      },
      onCancel: () {
        selectedAccountId = null;
      },
    );
  }

  Future<void> _loadActiveConsents() async {
    // Fetch all consents and create list of accounts with it
    final String currentUserId = Get.find<AuthController>().user.id;
    consents = await _consentRepository.getActiveConsents(currentUserId);

    // Flatten the consents into the list of accounts
    accounts.value = consents.expand((element) => element.accounts).toList();
  }

  /// Revokes a particular consent object associated with an accId
  Future<void> initiateRevocation(String accId) async {
    _setAwaitingUpdate(true);

    // Find Consent object linked to this accId - this is guaranteed to exist
    selectedConsent = consents.firstWhere((consent) =>
        consent.accounts.where((account) => account.id == accId).isNotEmpty);

    // TODO(kkzeng): Explore removing an account but not revoking Consent for multiple acc consents

    // Update status to be revokeRequested
    _consentRepository.updateData(selectedConsent.id,
        Consent(status: ConsentStatus.revokeRequested).toJson());

    // Listen for when the revoke request is fulfilled
    _startListening(selectedConsent.id);
  }

  void Function() _cancelListener;

  void _startListening(String id) {
    _cancelListener = _consentRepository.listen(id, onValue: _onValue);
  }

  void _stopListening() {
    _cancelListener();
  }

  void _onValue(Consent consent) {
    // If consent has been successfully revoked
    if (consent.status == ConsentStatus.revoked) {
      _setAwaitingUpdate(false);
      _stopListening();

      print('Consent len ${consents.length}');

      // Remove consent that was just successfully revoked
      consents.removeWhere((consent) => consent.id == selectedConsent.id);

      print('Consent len ${consents.length}');

      // Update the account list as well
      accounts.value = consents.expand((element) => element.accounts).toList();

      // No selected consent or account since it has been revoked already
      selectedConsent = null;
      selectedAccountId = null;
    }
  }

  void _setAwaitingUpdate(bool isAwaitingUpdate) {
    // This is intended to inform the UI that the user is not expected to
    // make any action and just need to wait. For example, a circular progress
    // indicator could be displayed.
    this.isAwaitingUpdate = isAwaitingUpdate;
    update();
  }
}