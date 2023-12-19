import 'dart:async';
import 'dart:io';
import 'package:dripx/utils/app_keys.dart';
import 'package:dripx/view/widgets/custom_app_bar.dart';
import 'package:dripx/view/widgets/custom_app_bar_auth.dart';
import 'package:dripx/view/widgets/extention/border_extension.dart';
import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/string_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../../../utils/colors.dart';
import '../../../helper/routes_helper.dart';
import '../../../helper/validation.dart';
import '../../../provider/authentication_provider.dart';
import '../../../utils/images.dart';
import '../../../utils/string.dart';
import '../../../utils/style.dart';
import '../../widgets/button_with_icon.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import 'components/logo_section.dart';
import 'components/reset_logo_section.dart';

class SignUpOtpVerificationScreen extends StatefulWidget {
  const SignUpOtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<SignUpOtpVerificationScreen> createState() => _SignUpOtpVerificationScreenState();
}

class _SignUpOtpVerificationScreenState extends State<SignUpOtpVerificationScreen> {
  //Scaffold key
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // Form key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      var controller = Provider.of<AuthProvider>(context, listen: false);
      startTimer(controller);
    });
    super.initState();
  }
  Timer? timer;
  int start = 60;

  void startTimer(AuthProvider controller) {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (start == 0) {
          timer.cancel();
          controller.notifyListeners();
        } else {
          start--;
          controller.notifyListeners();
        }
      },
    );
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String email = ModalRoute.of(context)!.settings.arguments as String;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: blueStatusBar(),
      child: SafeArea(
        key: scaffoldKey,
        bottom: Platform.isAndroid ? true : false,
        top: Platform.isAndroid ? true : false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: greenSecondary,
          body: Consumer<AuthProvider>(builder: (context, controller, child) {
            return Container(
              height: 844.h,
              width: 390.w,
              decoration: BoxDecoration(gradient: gradientBlue),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    10.height,
                    CustomAppBarAuth(title: "", changeColor: true,),
                    ResetLogoSection(
                      image: Images.iconLock,
                      title: "",
                      description: otpDescription,
                      iconColor: redPrimary,
                      titleVisibility: false,
                      iconVisibility: true,
                    ),
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 35.w, vertical: 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Pinput(
                              defaultPinTheme: PinTheme(
                                width: 55.w,
                                height: 55.w,
                                textStyle: const TextStyle(
                                    fontSize: 18,
                                    color: greySecondary,
                                    fontFamily: sofiaMedium,
                                    fontWeight: FontWeight.w600),
                                decoration: BoxDecoration(
                                  color: whitePrimary,
                                  border: Border.all(color: greyLight),
                                  borderRadius: borderRadiusCircular(8),
                                ),
                              ),
                              length: 6,
                              forceErrorState: true,
                              //errorText: 'Error',
                              pinputAutovalidateMode:
                              PinputAutovalidateMode.onSubmit,
                              validator: (pin) {
                                if(pin!.length<5) {
                                  return 'Pin is incorrect';
                                }
                                else {
                                  return null;
                                }
                              },
                              controller: controller.signUpOtpController,
                            ),
                            20.height,
                            controller.isSignUpOtpVerification ? const Center(child: CircularProgressIndicator(color: whitePrimary,),) :  CustomButton(
                              buttonName: btnVerifyAndProceed,
                              onPressed: () async {

                                if (formKey.currentState!.validate()) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  controller.sigUpOtpVerification(context, email);
                                }
                              },
                            ),
                            30.height,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (controller.otpReceived == false
                                    ? didNotReceivedCode
                                    : "${timeRemaining}00:${start}")
                                    .toText(
                                    fontSize: 13,
                                    color: whiteSecondary,
                                    fontFamily: sofiaLight),
                                textBtnResendCode
                                    .toText(
                                    fontSize: 13,
                                    color: start == 0
                                        ? blueDark
                                        : whiteSecondary,
                                    fontFamily: sofiaRegular)
                                    .onPress(() async {
                                  if(start == 0) {
                                    await controller.resendSignUpOtp(context, email);
                                    start = 60;
                                    startTimer(controller);
                                  }
                                })
                              ],
                            ).paddingSymmetric(horizontal: 10.w)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
