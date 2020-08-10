import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pispapp/controllers/ephemeral/payment_initiate_controller.dart';
import 'package:pispapp/ui/theme/light_theme.dart';
import 'package:pispapp/ui/widgets/bottom_button.dart';
import 'package:pispapp/ui/widgets/phone_number.dart';
import 'package:pispapp/ui/widgets/phone_number_tile.dart';
import 'package:pispapp/ui/widgets/shadow_box.dart';
import 'package:pispapp/ui/widgets/title_text.dart';

class PaymentInitiate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 60, 0, 30),
            child: TitleText(
              text: 'Pay Now',
              fontSize: 20,
            ),
          ),
          GetBuilder<PaymentInitiateController>(
            builder: (value) => ShadowBox(
              color:
                  value.phoneNumberPrompt ? Colors.red : LightColor.navyBlue1,
              child: Column(
                children: <Widget>[
                  PhoneNumberTile(
                    heading: 'Find Payee',
                    trailingWidget: GetBuilder<PaymentInitiateController>(
                      builder: (value) => value.validPhoneNumber
                          ? const Icon(
                              Icons.check_circle_outline,
                            )
                          : const Text(
                              '',
                            ),
                    ),
                  ),
                  PhoneNumberInput(
                    value.onPhoneNumberChange,
                    'Enter phone number',
                    value.phoneNumber,
                  ),
                ],
              ),
            ),
          ),
          GetBuilder<PaymentInitiateController>(
            builder: (value) => BottomButton(
              value.transactionSubmitting
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const TitleText(
                      text: 'Find Payee', color: Colors.white, fontSize: 20),
              () => Get.find<PaymentInitiateController>().onPayNow(),
            ),
          )
        ],
      ),
    );
  }
}
