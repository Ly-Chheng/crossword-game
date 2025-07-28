import 'package:belteiis_kids/core/constant/font.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimalCard extends StatelessWidget {
  final String title;
  // final String backgroundImageAsset;
  final String foregroundImageAsset;
  final VoidCallback? ontap;
  final bool? isShowborder ;

  const AnimalCard({
    Key? key,
    required this.title,
    // required this.backgroundImageAsset,
    required this.foregroundImageAsset,
    this.ontap,
    this.isShowborder = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding:   EdgeInsets.symmetric(  horizontal: context.isPhone ? 3.0 : 5.0,),
      child: GestureDetector(
        onTap:ontap,
        child: Container(
            // width: (Get.context?.isPhone ?? true) ? 100 : 150,
            // height: (Get.context?.isPhone ?? true) ? 110 : 190,
 
            width: (Get.context?.isPhone ?? true)
                ? screenWidth * 0.13  
                : screenWidth * 0.14,  

            height: (Get.context?.isPhone ?? true)
                ? screenWidth * 0.14  
                : screenWidth * 0.15,  


          decoration: BoxDecoration(
            border: isShowborder == true
              ? Border.all(
                  color: const Color.fromARGB(255, 2, 176, 26).withOpacity(0.9),
                  width: (Get.context?.isPhone ?? true) ? 3 : 6,
                )
              : null,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage("assets/image/card_animals.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            
            children: [
                SizedBox( height: (Get.context?.isPhone ?? true) ? 10 : 15,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: ManagerFontStyles.labelStyleBold.copyWith(
                      color: Colors.white,
                      fontSize: context.isPhone ? 13 : 20,

                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                   SizedBox( width: (Get.context?.isPhone ?? true) ? 3 : 5,),
                  isShowborder == true
                    ? Icon(
                        Icons.check_circle,
                        color: const Color.fromARGB(255, 2, 176, 26).withOpacity(0.9),
                        size:  context.isPhone ? 20 : 30,

                      )
                    : const SizedBox.shrink(),
                 
                ],
              ),
              Expanded(
                child: Center(
                  child: Image.asset(
                    foregroundImageAsset,
                    width: context.isPhone ? 80 : 120,
                    height: context.isPhone ? 120 : 170,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// context.isPhone
//                           ? Get.height * 0.03
//                           : Get.height * 0.02,