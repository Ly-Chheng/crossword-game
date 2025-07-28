import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:belteiis_kids/widget/button_widget.dart';

class TermConditionDialog extends StatelessWidget {
  final String? name;
  final String? description;
  final VoidCallback? onAccept;

  const TermConditionDialog({
    super.key,
    this.name,
    this.description,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      child: Container(
        width: (Get.context?.isPhone ?? true)
            ? MediaQuery.of(context).size.width * 0.5
            : MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFDEA9F),
              Color(0XFFF3D988),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFFDEA9F),
                    Color(0XFFF3D988),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: (Get.context?.isPhone ?? true) ? 10 : 20.0,
                ),
                child: Center(
                  child: Text(
                    'Terms of Use',
                    style: TextStyle(
                      fontSize: (Get.context?.isPhone ?? true) ? 18 : 25.0,
                      color: Colors.white,
                      fontFamily: "PatrickHandSC",
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          offset: Offset(2, 2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: (Get.context?.isPhone ?? true) ? 10 : 20.0,
                vertical: (Get.context?.isPhone ?? true) ? 10 : 20.0,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: (Get.context?.isPhone ?? true) ? 5 : 10.0,
                    ),
                    Text(
                      description ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "PatrickHandSC",
                        fontSize: (Get.context?.isPhone ?? true) ? 13 : 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: (Get.context?.isPhone ?? true) ? 10 : 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.offNamed('/TermsOfUse');
                          },
                          child: Text(
                            "Terms of Use",
                            style: TextStyle(
                                fontSize:
                                    (Get.context?.isPhone ?? true) ? 13 : 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "PatrickHandSC",
                                color: Colors.purple,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.purple),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Get.offNamed('/PrivacyPolicy');
                            },
                            child: Text("Privacy Policy",
                                style: TextStyle(
                                    fontSize: (Get.context?.isPhone ?? true)
                                        ? 13
                                        : 18.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "PatrickHandSC",
                                    color: Colors.purple,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.purple))),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: (Get.context?.isPhone ?? true) ? 5 : 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildDialogButton(
                            label: 'ACCEPT',
                            color: Colors.green,
                            onPressed: () {
                              onAccept?.call();
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
