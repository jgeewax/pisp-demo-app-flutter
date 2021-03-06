import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pispapp/controllers/ephemeral/setup_controller.dart';
import 'package:pispapp/models/phone_number.dart';
import 'package:pispapp/ui/theme/light_theme.dart';
import 'package:pispapp/ui/widgets/phone_number_tile.dart';
import 'package:pispapp/ui/widgets/shadow_box.dart';
import 'package:pispapp/ui/widgets/title_text.dart';
import 'package:pispapp/ui/widgets/bottom_button.dart';
import 'package:pispapp/ui/widgets/phone_number_input.dart';

class PhoneNumberSetup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(10, 60, 0, 30),
              child:
                  TitleText('Set up your PineapplePay Account', fontSize: 20),
            ),
            const SizedBox(height: 20),
            GetBuilder<SetupController>(
              builder: (controller) => ShadowBox(
                color: LightColor.navyBlue1,
                child: Column(
                  children: <Widget>[
                    PhoneNumberTile(
                      heading: 'Enter phone Number',
                      trailingWidget: Obx(() {
                        if (Get.find<SetupController>()
                            .validPhoneNumber
                            .value) {
                          return const Icon(Icons.check_circle_outline,
                              color: Colors.green);
                        } else {
                          return const Text('');
                        }
                      }),
                    ),
                    PhoneNumberInput(
                        hintText: 'Enter phone number',
                        initialValue: Get.find<SetupController>().phoneNumber,
                        onUpdate:
                            Get.find<SetupController>().onPhoneNumberChange)
                  ],
                ),
              ),
            ),
            Obx(() {
              return BottomButton(
                  const TitleText(
                    'Login',
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  onTap: Get.find<SetupController>().validPhoneNumber.value
                      ? () =>
                          Get.find<SetupController>().onPhoneNumberSubmitted()
                      : null);
            }),
          ],
        ),
      ),
    );
  }
}
