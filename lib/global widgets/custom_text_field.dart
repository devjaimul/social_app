import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/utlis/app_colors.dart';
import 'package:social_app/utlis/app_constant.dart';


class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscure;
  final Color? filColor;
  final Color? borderColor;
  final Color? hinTextColor;
  final Widget? prefixIcon;
  final String? labelText;
  final String? hintText;
  final double? contentPaddingHorizontal;
  final double? contentPaddingVertical;
  final int? maxLine;
  final double? hinTextSize;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final bool isPassword;
  final bool? isEmail;
  final bool? readOnly;
  final double? borderRadio;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    this.contentPaddingHorizontal,
    this.contentPaddingVertical,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLine,
    this.validator,
    this.hinTextColor,
    this.borderColor,
    this.isEmail,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isObscureText = false,
    this.obscure = '*',
    this.filColor,
    this.hinTextSize,
    this.labelText,
    this.isPassword = false,
    this.readOnly = false,
    this.borderRadio,
    this.onTap,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool obscureText = true;

  void toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        // Prevent null errors when text is empty
        if (widget.onChanged != null) {
          widget.onChanged!(value.isEmpty ? '' : value);
        }
      },
      onTap: widget.onTap,
      readOnly: widget.readOnly ?? false,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscuringCharacter: widget.obscure ?? '*',
      maxLines: widget.maxLine ?? 1,
      validator: widget.validator ??
              (value) {
            if (value == null || value.isEmpty) {
              return "Please enter ${widget.hintText?.toLowerCase() ?? 'this field'}";
            }

            if (widget.isPassword) {
              bool isValidPassword = AppConstants.validatePassword(value);
              if (!isValidPassword) {
                return "password must be 6-20 characters with letters \n and numbers";
              }
            }

            if (widget.isEmail ?? false) {
              bool isValidEmail = AppConstants.emailValidate.hasMatch(value);
              if (!isValidEmail) {
                return "Please enter a valid email address.";
              }
            }
            return null;
          },
      cursorColor: Colors.black,
      obscureText: widget.isPassword ? obscureText : false,
      style: TextStyle(
        color: widget.hinTextColor ?? Colors.black,
        fontSize: widget.hinTextSize ?? 12.sp,
      ),
      decoration: InputDecoration(
        hintMaxLines: 1,
        contentPadding: EdgeInsets.symmetric(
          horizontal: widget.contentPaddingHorizontal ?? 20.w,
          vertical: widget.contentPaddingVertical ?? 14.h,
        ),
        fillColor: widget.filColor ?? Colors.transparent,
        filled: true,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword
            ? GestureDetector(
          onTap: toggle,
          child: _suffixIcon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        )
            : widget.suffixIcon,
        prefixIconConstraints:
        BoxConstraints(minHeight: 20.w, minWidth: 20.w),
        labelText: widget.labelText,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: widget.hinTextColor ?? Colors.black,
          fontSize: widget.hinTextSize ?? 12.sp,
          fontWeight: FontWeight.w400,
        ),
        focusedBorder: _focusedBorder(),
        enabledBorder: _enabledBorder(),
        errorBorder: _errorBorder(),
        focusedErrorBorder: _focusedErrorBorder(),
        border: _focusedBorder(),
        errorStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _suffixIcon(IconData icon) {
    return Padding(
      padding: EdgeInsets.all(12.r),
      child: Icon(
        icon,
        color: AppColors.iconColor,
      ),
    );
  }

  OutlineInputBorder _focusedBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio?.r ?? 16.r),
      borderSide: BorderSide(
        color: widget.borderColor ?? AppColors.primaryColor,
      ),
    );
  }

  OutlineInputBorder _enabledBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio?.r ?? 16.r),
      borderSide: BorderSide(
        color: widget.borderColor ?? AppColors.primaryColor,
        width: 0.8,
      ),
    );
  }

  OutlineInputBorder _errorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio?.r ?? 16.r),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 0.8,
      ),
    );
  }

  OutlineInputBorder _focusedErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(widget.borderRadio?.r ?? 16.r),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    );
  }
}
