
import 'package:flutter/material.dart';

import '../../../../core/utils/assets.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Assets.imagesLogo,
      width: 121,
      height: 107,
      color: const Color(0xff191BA9),
    );
  }
}
