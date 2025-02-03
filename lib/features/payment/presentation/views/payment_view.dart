import 'dart:developer';
import 'package:animate_do/animate_do.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartsystemforschools/core/methods/show_scaffold_messanger.dart';
import 'package:smartsystemforschools/core/utils/api_keys.dart';
import 'package:smartsystemforschools/core/utils/custom_button.dart';
import 'package:smartsystemforschools/core/widgets/show_dialog.dart';
import 'package:smartsystemforschools/features/payment/presentation/manager/cubit/payment_cubit.dart';
import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
import 'package:smartsystemforschools/generated/locale_keys.g.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/custom_app_bar.dart';
import '../../data/models/payment_intent_model/payment_intent_input_model.dart';
import '../widgets/payment_option.dart';

class PaymentView extends StatefulWidget {
  const PaymentView({super.key});

  @override
  State<PaymentView> createState() => _PaymentViewState();
}

class _PaymentViewState extends State<PaymentView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryController = TextEditingController();
  TextEditingController cvcController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  List<bool> isSelected = [false, false, false];
  String selectedCountry = 'Egypt';
  OutlineInputBorder buildOutlineBorder() {
    return const OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Colors.grey,
      ),
    );
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    cardNumberController.dispose();
    expiryController.dispose();
    cvcController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        ThereIsicon: false,
        title: LocaleKeys.wallet_wallet.tr(),
        textStyle: AppStyles.styleSemiBold20(),
      ),
      body: BlocProvider(
        create: (context) => PaymentCubit(),
        child: SingleChildScrollView(
          // Added to allow scrolling
          child: Padding(
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 48),
                  // Payment Options
                  SizedBox(
                    height: 64,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              isSelected[0] = !isSelected[0];
                              isSelected[1] = false;
                              isSelected[2] = false;

                              setState(() {});
                            },
                            child: SlideInLeft(
                              child: PaymentOption(
                                title: 'Card',
                                image: SvgPicture.asset(Assets.imagesVisa),
                                isSelected: isSelected[0],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              isSelected[1] = !isSelected[1];
                              isSelected[0] = false;
                              isSelected[2] = false;
                              setState(() {});
                            },
                            child: SlideInLeft(
                              child: PaymentOption(
                                title: 'EPS',
                                image: SvgPicture.asset(Assets.imagesPaypal),
                                isSelected: isSelected[1],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              isSelected[2] = !isSelected[2];
                              isSelected[0] = false;
                              isSelected[1] = false;
                              setState(() {});
                            },
                            child: SlideInRight(
                              child: PaymentOption(
                                title: 'Giropay',
                                image: SvgPicture.asset(Assets.imagesDiscover),
                                isSelected: isSelected[2],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Card Number Input
                  SlideInLeft(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Card number',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 43,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 2, color: const Color(0xFFE0E0E0)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: TextFormField(
                            controller: cardNumberController, // Bind controller
                            style: const TextStyle(color: Colors.black),
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsetsDirectional.only(
                                  top: 3, bottom: 0),
                              border: InputBorder.none,
                              hintText: '1234 1234 1234 1234',
                              hintFadeDuration:
                                  const Duration(milliseconds: 400),
                              suffixIcon: SizedBox(
                                width: 120,
                                height: 43,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SvgPicture.asset(Assets.imagesVisa,
                                        width: 24, height: 16),
                                    const SizedBox(width: 4),
                                    SvgPicture.asset(Assets.imagesPaypal,
                                        width: 24, height: 16),
                                    const SizedBox(width: 4),
                                    SvgPicture.asset(Assets.imagesAMEX,
                                        width: 24, height: 16),
                                    const SizedBox(width: 4),
                                    SvgPicture.asset(Assets.imagesDiscover,
                                        width: 24, height: 16),
                                  ],
                                ),
                              ),
                              hintStyle: AppStyles.styleRegular12().copyWith(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Expiry and CVC Inputs
                  Row(
                    children: [
                      Expanded(
                        child: SlideInLeft(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Expiry',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 43,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 2, color: const Color(0xFFE0E0E0)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: TextFormField(
                                  controller: expiryController,
                                  style: const TextStyle(color: Colors.black),
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsetsDirectional.only(
                                        top: 0, bottom: 8),
                                    hintText: 'MM / YY',
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SlideInRight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'CVC',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 43,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 2, color: const Color(0xFFE0E0E0)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: TextFormField(
                                  controller: cvcController,
                                  style: const TextStyle(color: Colors.black),
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsetsDirectional.only(
                                        top: 0, bottom: 8),
                                    hintText: 'CVC',
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Country and Postal Code Inputs
                  Row(
                    children: [
                      Expanded(
                        child: SlideInLeft(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Country',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 43,
                                width: 200,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 2, color: const Color(0xFFE0E0E0)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(selectedCountry,
                                          style: AppStyles.styleMedium16()
                                              .copyWith(color: Colors.black)),
                                      IconButton(
                                        onPressed: () {
                                          showCountryPicker(
                                            context: context,
                                            exclude: <String>[
                                              'KN',
                                              'MF',
                                              'IL',
                                              'PS'
                                            ],
                                            onSelect: (Country country) {
                                              selectedCountry =
                                                  '${country.flagEmoji}  ${country.name}';
                                              log(selectedCountry);
                                              setState(() {});
                                            },
                                            countryListTheme:
                                                CountryListThemeData(
                                              inputDecoration: InputDecoration(
                                                hintFadeDuration:
                                                    const Duration(
                                                  milliseconds: 400,
                                                ),
                                                hintText: 'Search',
                                                hintStyle:
                                                    AppStyles.styleMedium16()
                                                        .copyWith(
                                                  color: context
                                                              .read<
                                                                  ThemeModeCubit>()
                                                              .currentTheme ==
                                                          ThemeMode.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                labelText: 'Search',
                                                labelStyle:
                                                    AppStyles.styleMedium16()
                                                        .copyWith(
                                                  color: context
                                                              .read<
                                                                  ThemeModeCubit>()
                                                              .currentTheme ==
                                                          ThemeMode.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                                prefixIcon: const Icon(
                                                  Icons.search,
                                                ),
                                                border: buildOutlineBorder(),
                                                enabledBorder:
                                                    buildOutlineBorder(),
                                                focusedBorder:
                                                    buildOutlineBorder(),
                                              ),
                                              bottomSheetHeight: 600,
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SlideInRight(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Postal code',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 43,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 2, color: const Color(0xFFE0E0E0)),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: TextFormField(
                                  controller: postalCodeController,
                                  style: const TextStyle(color: Colors.black),
                                  cursorColor: Colors.black,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsetsDirectional.only(
                                      top: 0,
                                      bottom: 8,
                                    ),
                                    hintText: '90210',
                                    hintStyle: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 240,
                  ),
                  BlocBuilder<PaymentCubit, PaymentState>(
                    builder: (context, state) {
                      return BounceInDown(
                        child: CustomButton(
                          isLoading: state is PaymentLoading ? true : false,
                          padding: const EdgeInsetsDirectional.only(
                            start: 124,
                            end: 123,
                            top: 15,
                            bottom: 18,
                          ),
                          text: LocaleKeys.wallet_Transfer.tr(),
                          textStyle: AppStyles.styleSemiBold14().copyWith(
                            height: 1.36,
                          ),
                          borderRadius: 20,
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              // Pass data to payment logic
                              context.read<PaymentCubit>().makePayment(
                                    paymentIntentInputModel:
                                        PaymentIntentInputModel(
                                      amount: '3000',
                                      currency: 'EGP',
                                      customerId: ApiKeys.customerId,
                                    ),
                                    context: context,
                                  );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
