import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/colors.dart';

class TermAndConditionScreen extends StatefulWidget {
  const TermAndConditionScreen({Key? key}) : super(key: key);

  @override
  State<TermAndConditionScreen> createState() => _TermAndConditionScreenState();
}

class _TermAndConditionScreenState extends State<TermAndConditionScreen> {
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
                  CustomAppBar(title: 'Term & Condition', isBackEnable: true),
                  25.height,

                  "Please read these Terms and Conditions ('Terms', 'Terms and Conditions') carefully before using the DripX mobile application (the 'Service') operated by DripX ('us', 'we', or 'our').\n\n1. Acceptance of TermsBy accessing or using the Service, you agree to be bound by these Terms. If you disagree with any part of the terms, then you do not have permission to access the Service.\n\n2. User ObligationsBy downloading, accessing, or using the Service, you represent that you are at least thirteen (13) years old and you will use the Service in compliance with all applicable laws, rules, and regulations.\n\n3. Intellectual PropertyThe Service and its original content, features, and functionality are and will remain the exclusive property of DripX and its licensors. The Service is protected by copyright, trademark, and other laws of both the United States and foreign countries.\n\n4. ContentYou are responsible for all content that you post, upload, transmit or otherwise make available via the Service. You warrant that all such content complies with applicable laws and these Terms and Conditions.\n\n5. TerminationWe may terminate or suspend your access to the Service immediately, without prior notice or liability, under our sole discretion, for any reason whatsoever, including but not limited to a breach of the Terms.\n\n6. Limitation of LiabilityIn no event shall DripX, nor its directors, employees, partners, agents, suppliers, or affiliates, be liable for any indirect, incidental, special, consequential or punitive damages, including without limitation, loss of profits, data, use, goodwill, or other intangible losses, resulting from your access to or use of or inability to access or use the Service.\n\n7. Changes to Terms and ConditionsWe reserve the right, at our sole discretion, to modify or replace these Terms at any time. We will make reasonable efforts to provide notice of significant changes. Your continued use of the Service after any changes constitutes your acceptance of the new Terms.\n\n8. Contact UsIf you have any questions about these Terms and Conditions, please contact us at: Avi@waterx.io. ".toText(
                    fontSize: 16,
                    maxLine: 200
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
