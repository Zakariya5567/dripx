import 'package:dripx/view/widgets/extention/int_extension.dart';
import 'package:dripx/view/widgets/extention/widget_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../provider/authentication_provider.dart';
import '../../utils/colors.dart';
import '../../utils/dimension.dart';
import '../../utils/style.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {super.key,
      required this.controller,
      this.hintText,
      this.obscureText,
      this.textInputType,
      this.textInputAction,
      this.isBorder = true,
      this.height,
      this.width,
      this.validator,
      this.onChanged,
      this.onSubmitted,
      this.borderColor = greyLight,
      this.hintColor = greyPrimary,
      this.isPassword = false,
      this.isSearch = false,
      this.onEyeTap,
      this.radius = 25,
      this.fillColor = whiteLight,
      this.isVisible = false,
      this.inputFormatter = 50,
      this.iconColor = greyPrimary,
      this.isEdit = false,
      this.isReadOnly = false,
      this.onTap,
      this.onTapOutside,
      this.onEditingComplete});
  TextEditingController controller;
  String? hintText;
  bool? obscureText;
  TextInputType? textInputType;
  TextInputAction? textInputAction;
  bool isBorder;
  double? height;
  double? width;
  bool isVisible;
  Color iconColor;
  bool isEdit;
  bool isReadOnly;

  Color borderColor;
  Color hintColor;
  bool isSearch;
  bool isPassword;
  double radius;
  Color fillColor;
  int inputFormatter;


  VoidCallback? onEyeTap;
  VoidCallback? onTap;
  Function(PointerDownEvent?)? onTapOutside;
  VoidCallback? onEditingComplete;
  final String? Function(String?)? validator;
  final String? Function(String?)? onChanged;
  final String? Function(String?)? onSubmitted;


  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return SizedBox(
      height: height,
      width: width,
      child: TextFormField(
        // maxLength: 100,
          readOnly: isReadOnly,
          autofocus: false,
          controller: controller,
          autovalidateMode: controller.text.isNotEmpty
              ? AutovalidateMode.always
              : AutovalidateMode.onUserInteraction,
          style:  TextStyle(fontSize: authProvider.isIpad ? 20 : 14),
          obscureText: obscureText ?? false,
          keyboardType: textInputType,
          validator: validator,
          onChanged: onChanged,
          onTapOutside: onTapOutside,
          onEditingComplete: onEditingComplete,
          onFieldSubmitted: onSubmitted,
          textInputAction: textInputAction,
          onTap: onTap,
          inputFormatters: [LengthLimitingTextInputFormatter(inputFormatter)],
          decoration: InputDecoration(
            errorMaxLines: 3,
            errorStyle: TextStyle(
                fontSize: authProvider.isIpad ? 16 : 12, color: redPrimary, fontFamily: sofiaRegular),
            fillColor: fillColor,
            filled: isBorder == true ? true : false,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: authProvider.isIpad ? 18 : 14, color: greySecondary, fontFamily: sofiaRegular),

            suffixIcon: isPassword == true
                ? InkWell(
                    onTap: onEyeTap,
                    child: Icon(
                      isVisible == true
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: iconColor,
                      size: authProvider.isIpad ? 12.w : 20.w,
                    ),
                  )
                : isSearch == true
                    ? Icon(
                        Icons.search_outlined,
                        color: iconColor,
                        size: authProvider.isIpad ? 12.w : 25.w,
                      )
                    : isEdit == true
                        ? Icon(
                            Icons.edit,
                            color: iconColor,
                            size: authProvider.isIpad ? 12.w : 20.w,
                          )
                        : const SizedBox(),
            // Content padding is the inside padding of the text field
            contentPadding: isBorder == true
                ? EdgeInsets.symmetric(vertical: 10.h, horizontal: 20)
                : null,

            border: isBorder == true
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius),
                    borderSide: BorderSide(color: borderColor, width: 1),
                  )
                : InputBorder.none,

            errorBorder: isBorder == true
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius),
                    borderSide: const BorderSide(color: redPrimary, width: 1),
                  )
                : InputBorder.none,

            focusedErrorBorder: isBorder == true
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius),
                    borderSide: const BorderSide(color: redPrimary, width: 1.2),
                  )
                : InputBorder.none,

            enabledBorder: isBorder == true
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius),
                    borderSide: BorderSide(color: borderColor, width: 1),
                  )
                : InputBorder.none,

            focusedBorder: isBorder == true
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius),
                    borderSide: const BorderSide(color: bluePrimary, width: 1),
                  )
                : InputBorder.none,
          )
      ),
    );
  }
}
