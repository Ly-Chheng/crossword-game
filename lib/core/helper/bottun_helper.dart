import 'package:belteiis_kids/core/constant/color.dart';
import 'package:flutter/material.dart';

class BottunHelper {
  static Widget textButton({
    required String label,
    required VoidCallback onPressed,
    Color? textColor,
    double borderRadius = 8.0,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(label),
    );
  }

  static Widget elevatedButton({
    required String label,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
    double borderRadius = 2.0,
    double? width,
    height,
  }) {
    return SizedBox(
      height: height ?? 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? AppColors.purple[400],
          foregroundColor: textColor ?? Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  static Widget outlinedButton({
    required String label,
    required VoidCallback onPressed,
    Color? textColor,
    Color? borderColor,
    double borderRadius = 8.0,
    EdgeInsets padding =
        const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  }) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor,
        side: BorderSide(color: borderColor ?? Colors.blue),
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(label),
    );
  }

  static Widget iconButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? iconColor,
    double iconSize = 24.0,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: iconColor ?? Colors.red,
        size: iconSize,
      ),
    );
  }

  static IconButtonTheme iconButtonTheme({
    required Widget child,
    Color? iconColor,
    double? iconSize,
  }) {
    return IconButtonTheme(
      data: IconButtonThemeData(
        style: ButtonStyle(
          iconColor: MaterialStateProperty.all(iconColor ?? Colors.black),
          iconSize: MaterialStateProperty.all(iconSize ?? 24.0),
        ),
      ),
      child: child,
    );
  }

  static IconButtonThemeData customIconButtonThemeData({
    Color? iconColor,
    double? iconSize,
  }) {
    return IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStateProperty.all(iconColor ?? Colors.black),
        iconSize: MaterialStateProperty.all(iconSize ?? 24.0),
      ),
    );
  }
}
