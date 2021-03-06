import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'model.dart';
import 'party.dart';

part 'transaction.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
// ignore: must_be_immutable
class Transaction extends Equatable implements JsonModel {
  Transaction({
    this.id,
    this.userId,
    this.payee,
    this.payer,
    this.sourceAccountId,
    this.consentId,
    this.amount,
    this.authentication,
    this.transactionId,
    this.transactionRequestId,
    this.completedTimestamp,
    this.quote,
    this.responseType,
    this.status,
  });

  @override
  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  /// Internal id that is used to identify the transaction.
  String id;

  /// User ID in Firebase that differentiate transaction documents for
  /// different users.
  String userId;

  /// Information about the payee in the proposed financial transaction.
  Party payee;

  /// Information about the payer in the proposed financial transaction.
  PartyIdInfo payer;

  /// DFSP specific account identifier to identify the source account used by
  /// the payer for the proposed financial transaction.
  String sourceAccountId;

  /// Common ID between the PISP and FSP for the Consent object. This tells
  /// DFSP and the authentication service which constent allows the PISP to
  /// initiate transaction.
  String consentId;

  /// Requested amount to be transferred from the Payer to Payee.
  Money amount;

  /// The authentication info that may be entered by the payer to authorize a
  /// proposed financial transaction.
  Authentication authentication;

  /// Common ID (decided by the PISP) to identify a transaction request.
  String transactionRequestId;

  /// Timestamp when the transaction was completed.
  String completedTimestamp;

  /// Common ID (decided by the Payer FSP) between the FSPs for the future transaction
  /// object. The actual transaction will be created as part of a successful transfer
  /// process.
  String transactionId;

  /// A quote object that contains more detailed information about the transaction.
  Quote quote;

  /// Payer's response after being prompted to authorize a proposed financial transaction.
  ResponseType responseType;

  /// Status of the proposed financial transaction.
  TransactionStatus status;

  @override
  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  @override
  List<Object> get props => [
        id,
        userId,
        payee,
        payer,
        sourceAccountId,
        consentId,
        amount,
        authentication,
        transactionId,
        transactionRequestId,
        completedTimestamp,
        quote,
        responseType,
        status
      ];
}

enum TransactionStatus {
  /// Waiting for a callback from Mojaloop to give the payee information.
  @JsonValue('PENDING_PARTY_LOOKUP')
  pendingPartyLookup,

  /// Waiting for the user to confirm payee information and provide more
  /// details about the transaction.
  @JsonValue('PENDING_PAYEE_CONFIRMATION')
  pendingPayeeConfirmation,

  /// Waiting for the user to authorize the transaction.
  @JsonValue('AUTHORIZATION_REQUIRED')
  authorizationRequired,

  /// The transaction is successful.
  @JsonValue('SUCCESS')
  success,
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Quote extends Equatable implements JsonModel {
  Quote({
    this.transferAmount,
    this.payeeFspFee,
    this.payeeReceiveAmount,
    this.payeeFspCommission,
    this.expiration,
    this.condition,
    this.ilpPacket,
  });

  @override
  factory Quote.fromJson(Map<String, dynamic> json) => _$QuoteFromJson(json);

  /// The amount of money that the Payee FSP should receive.
  final Money transferAmount;

  /// Payee FSP’s part of the transaction fee.
  final Money payeeFspFee;

  /// The amount of money that the Payee FSP should receive.
  final Money payeeReceiveAmount;

  /// Transaction commission from the Payee FSP.
  final Money payeeFspCommission;

  /// Date and time until when the quotation is valid and can be honored when used
  /// in the subsequent transaction.
  final String expiration;

  /// Condition that must be attached to a transfer by the Payer.
  final String condition;

  /// Information for recipient (transport layer information).
  final String ilpPacket;

  @override
  Map<String, dynamic> toJson() => _$QuoteToJson(this);

  @override
  List<Object> get props => [
        transferAmount,
        payeeFspFee,
        payeeFspCommission,
        expiration,
        condition,
        ilpPacket
      ];
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Money extends Equatable implements JsonModel {
  Money(this.amount, this.currency);

  @override
  factory Money.fromJson(Map<String, dynamic> json) => _$MoneyFromJson(json);

  /// Amount of money.
  final String amount;

  /// Currency of the amount.
  final String currency;

  @override
  Map<String, dynamic> toJson() => _$MoneyToJson(this);

  @override
  List<Object> get props => [amount, currency];
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class Authentication extends Equatable implements JsonModel {
  Authentication({this.type, this.value});

  @override
  factory Authentication.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationFromJson(json);

  /// The type of authentication that is required to authorize the proposed
  /// financial transaction.
  final AuthenticationType type;

  /// The value of authentication that is provided by payer to authorize the
  /// proposed financial transaction.
  final String value;

  @override
  Map<String, dynamic> toJson() => _$AuthenticationToJson(this);

  @override
  List<Object> get props => [type, value];
}

/// Enumeration allowed for AuthenticationType. At the moment, U2F is the
/// only supported authentication type.
enum AuthenticationType {
  /// U2F challenge-response, where payer FSP verifies if the response
  /// provided by end-user device matches the previously registered key.
  @JsonValue('U2F')
  u2f,
}

extension AuthenticationTypeJson on AuthenticationType {
  String toJsonString() {
    return _$AuthenticationTypeEnumMap[this];
  }
}

enum ResponseType {
  /// The user authorized the transaction.
  @JsonValue('AUTHORIZED')
  authorized,

  /// The user rejected the transaction.
  @JsonValue('REJECTED')
  rejected,
}

extension ResponseTypeJson on ResponseType {
  String toJsonString() {
    return _$ResponseTypeEnumMap[this];
  }
}
