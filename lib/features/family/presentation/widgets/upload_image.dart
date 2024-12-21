import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';

class CustomUploadImageWidget extends StatelessWidget {
  const CustomUploadImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: () {},
        splashColor: Colors.grey,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 0.50),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 7,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 33, left: 33),
                child: Text(
                  'Student id',
                  style:
                      AppStyles.styleMedium16().copyWith(color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 47, left: 45),
                child: Image.asset(
                  Assets.imagesUploadImage,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 5,
              )
            ],
          ),
        ),
      ),
    );
  }
}
