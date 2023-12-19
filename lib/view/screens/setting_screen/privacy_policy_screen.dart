import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/colors.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: whiteStatusBar(),
      child: SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    25.height,
                    CustomAppBar(title: 'Privacy Policy', isBackEnable: true),
                    25.height,

                    "DripX ('we', 'us', 'our') operates the DripX mobile application (the 'Service') available on iOS and Android platforms. This Privacy Policy informs you of our policies regarding the collection, use, and disclosure of personal data when you use our Service and the choices you have associated with that data.\n\n1. Personal Information We Collect\nWhen you install and use our Service, we may collect several types of data, including:\n\n- Personal Identifiable Information (PII): Such as your name, email address, and phone number, which you provide during account registration.\n- Device Information: Such as your device's IP address, browser type, mobile network information, and unique device identifiers.\n- Usage Data: Such as information about how and when you use our Service.\n\n2. Use of Data\nWe use the collected data for various purposes, including:\n\n- To provide and maintain our Service.\n- To notify you about changes to our Service.\n- To allow you to participate in interactive features of our Service when you choose to do so.\n- To provide customer support.\n- To gather analysis or valuable information so that we can improve our Service.\n\n3. Disclosure of Data\nWe may disclose your Personal Data under the following circumstances:\n\n- To comply with a legal obligation.\n- To protect and defend the rights or property of DripX.\n- To prevent or investigate possible wrongdoing in connection with the Service.\n\n4. Data Security\n\nWe value your trust in providing us your Personal Data and thus we strive to use commercially acceptable means of protecting it. However, no method of transmission over the internet or method of electronic storage is 100% secure and reliable, and we cannot guarantee its absolute security.\n\n5. Children's Privacy\n\nOur Service does not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13.\n\n6. Changes to This Privacy Policy\n\nWe may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.\n\n7. Contact Us\n\nIf you have any questions about this Privacy Policy, please contact us at: Avi@waterx.io".toText(
                        fontSize: 16,
                        maxLine: 500
                    ).paddingSymmetric(horizontal: 15.w),
                    10.height,
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}
