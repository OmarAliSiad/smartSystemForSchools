// import 'dart:developer';
// import 'package:animate_do/animate_do.dart';
// import 'package:country_picker/country_picker.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:smartsystemforschools/core/methods/show_scaffold_messanger.dart';
// import 'package:smartsystemforschools/core/utils/animated_app_bar.dart';
// import 'package:smartsystemforschools/core/utils/api_keys.dart';
// import 'package:smartsystemforschools/core/utils/custom_button.dart';
// import 'package:smartsystemforschools/core/widgets/credit_card.dart';
// import 'package:smartsystemforschools/features/payment/presentation/manager/cubit/payment_cubit.dart';
// import 'package:smartsystemforschools/features/settings_view/presentation/manager/themeMode/theme_mode_cubit.dart';
// import 'package:smartsystemforschools/generated/locale_keys.g.dart';
// import '../../../../core/utils/app_styles.dart';
// import '../../../../core/utils/assets.dart';
// import '../../data/models/payment_intent_model/payment_intent_input_model.dart';
// import '../widgets/payment_option.dart';

// class PaymentView extends StatefulWidget {
//   const PaymentView({super.key});

//   @override
//   State<PaymentView> createState() => _PaymentViewState();
// }

// class _PaymentViewState extends State<PaymentView> {
//   GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   TextEditingController cardNumberController = TextEditingController();
//   TextEditingController expiryController = TextEditingController();
//   TextEditingController cvcController = TextEditingController();
//   TextEditingController postalCodeController = TextEditingController();
//   List<bool> isSelected = [false, false, false];
//   String selectedCountry = 'Egypt';
//   bool isTapped = false;
//   final List<CreditCardData> _cards = [
//     CreditCardData(
//       bankName: 'Puzzle Bank',
//       cardNumber: '4242 4242 4242 4242',
//       holderName: 'John Doe',
//       expiryDate: '12/24',
//       cvc: '123',
//     ),
//     CreditCardData(
//       bankName: 'Universal Bank',
//       cardNumber: '5555 5555 5555 4444',
//       holderName: 'Jane Smith',
//       expiryDate: '06/25',
//       cvc: '456',
//     ),
//     CreditCardData(
//       bankName: 'Global Bank',
//       cardNumber: '3714 4963 5398 431',
//       holderName: 'Alice Johnson',
//       expiryDate: '09/26',
//       cvc: '789',
//     ),
//   ];
//   CreditCardData? _selectedCard;
//   // Define the cards variable

//   OutlineInputBorder buildOutlineBorder() {
//     return const OutlineInputBorder(
//       borderSide: BorderSide(
//         width: 2,
//         color: Colors.grey,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     // Dispose the controllers when the widget is disposed
//     cardNumberController.dispose();
//     expiryController.dispose();
//     cvcController.dispose();
//     postalCodeController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AnimatedCustomAppBar(
//         waveColor: Colors.blue.shade700,
//         backgroundColor: Colors.blue.shade900,
//         thereIsIcon: false,
//         title: LocaleKeys.wallet_wallet.tr(),
//         textStyle: AppStyles.styleSemiBold20(),
//       ),
//       body: BlocProvider(
//         create: (context) => PaymentCubit(),
//         child: SingleChildScrollView(
//           // Added to allow scrolling
//           child: Padding(
//             padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
//             child: Form(
//               key: formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 20),
//                   // const SizedBox(height: 48),
//                   // Payment Options
//                   SizedBox(
//                     height: 64,
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: InkWell(
//                             onTap: () {
//                               isSelected[0] = !isSelected[0];
//                               isSelected[1] = false;
//                               isSelected[2] = false;

//                               setState(() {});
//                             },
//                             child: SlideInLeft(
//                               child: PaymentOption(
//                                 title: 'Card',
//                                 image: SvgPicture.asset(Assets.imagesVisa),
//                                 isSelected: isSelected[0],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: InkWell(
//                             onTap: () {
//                               isSelected[1] = !isSelected[1];
//                               isSelected[0] = false;
//                               isSelected[2] = false;
//                               setState(() {});
//                             },
//                             child: SlideInLeft(
//                               child: PaymentOption(
//                                 width: 45,
//                                 title: 'Paypal',
//                                 image: SvgPicture.asset(
//                                   Assets.imagesPaypal,
//                                   fit: BoxFit.scaleDown,
//                                 ),
//                                 isSelected: isSelected[1],
//                               ),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Expanded(
//                           child: InkWell(
//                             onTap: () {
//                               isSelected[2] = !isSelected[2];
//                               isSelected[0] = false;
//                               isSelected[1] = false;
//                               setState(() {});
//                             },
//                             child: SlideInRight(
//                               child: PaymentOption(
//                                 title: 'Paymob',
//                                 image: Image.asset(
//                                   Assets.imagesPaymob,
//                                 ),
//                                 isSelected: isSelected[2],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   InkWell(
//                     splashColor: Colors.transparent,
//                     borderRadius: BorderRadius.circular(15),
//                     onTap: () {
//                       isTapped = !isTapped;
//                       setState(() {});
//                     },
//                     child: CreditCardCarousel(
//                       cards: _cards,
//                       isTapped: isTapped,
//                       colors: const [Colors.blue, Colors.red, Colors.green],
//                       onCardSelected: (selectedCard) {
//                         setState(() {
//                           _selectedCard = selectedCard;
//                         });
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   // Card Number Input
//                   SlideInLeft(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           'Card number',
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontFamily: 'Poppins',
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Container(
//                           height: 43,
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             border: Border.all(
//                                 width: 2, color: const Color(0xFFE0E0E0)),
//                             borderRadius: BorderRadius.circular(6),
//                           ),
//                           child: TextFormField(
//                             controller: cardNumberController, // Bind controller
//                             style: const TextStyle(color: Colors.black),
//                             cursorColor: Colors.black,
//                             decoration: InputDecoration(
//                               contentPadding: const EdgeInsetsDirectional.only(
//                                   top: 3, bottom: 0),
//                               border: InputBorder.none,
//                               hintText: '1234 1234 1234 1234',
//                               hintFadeDuration:
//                                   const Duration(milliseconds: 400),
//                               suffixIcon: SizedBox(
//                                 width: 120,
//                                 height: 43,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     SvgPicture.asset(Assets.imagesVisa,
//                                         width: 24, height: 16),
//                                     const SizedBox(width: 4),
//                                     SvgPicture.asset(
//                                       Assets.imagesMasteCard,
//                                       width: 24,
//                                       height: 16,
//                                     ),
//                                     const SizedBox(width: 4),
//                                     SvgPicture.asset(Assets.imagesAMEX,
//                                         width: 24, height: 16),
//                                     const SizedBox(width: 4),
//                                     SvgPicture.asset(Assets.imagesDiscover,
//                                         width: 24, height: 16),
//                                   ],
//                                 ),
//                               ),
//                               hintStyle: AppStyles.styleRegular12().copyWith(
//                                 color: Colors.black54,
//                                 fontSize: 13,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),

//                   // Expiry and CVC Inputs
//                   Row(
//                     children: [
//                       Expanded(
//                         child: SlideInLeft(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Expiry',
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Container(
//                                 height: 43,
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 12),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: Border.all(
//                                       width: 2, color: const Color(0xFFE0E0E0)),
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: TextFormField(
//                                   controller: expiryController,
//                                   style: const TextStyle(color: Colors.black),
//                                   cursorColor: Colors.black,
//                                   decoration: const InputDecoration(
//                                     contentPadding: EdgeInsetsDirectional.only(
//                                         top: 0, bottom: 8),
//                                     hintText: 'MM / YY',
//                                     hintStyle: TextStyle(
//                                       color: Colors.black54,
//                                       fontSize: 13,
//                                       fontFamily: 'Poppins',
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                     border: InputBorder.none,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: SlideInRight(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'CVC',
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Container(
//                                 height: 43,
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 12),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: Border.all(
//                                       width: 2, color: const Color(0xFFE0E0E0)),
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: TextFormField(
//                                   controller: cvcController,
//                                   style: const TextStyle(color: Colors.black),
//                                   cursorColor: Colors.black,
//                                   decoration: const InputDecoration(
//                                     contentPadding: EdgeInsetsDirectional.only(
//                                         top: 0, bottom: 8),
//                                     hintText: 'CVC',
//                                     hintStyle: TextStyle(
//                                       color: Colors.black54,
//                                       fontSize: 13,
//                                       fontFamily: 'Poppins',
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                     border: InputBorder.none,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   // Country and Postal Code Inputs
//                   Row(
//                     children: [
//                       Expanded(
//                         child: SlideInLeft(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Country',
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Container(
//                                 height: 43,
//                                 width: 200,
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 12),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: Border.all(
//                                       width: 2, color: const Color(0xFFE0E0E0)),
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: FittedBox(
//                                   fit: BoxFit.scaleDown,
//                                   alignment: Alignment.centerLeft,
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(selectedCountry,
//                                           style: AppStyles.styleMedium16()
//                                               .copyWith(color: Colors.black)),
//                                       IconButton(
//                                         onPressed: () {
//                                           showCountryPicker(
//                                             context: context,
//                                             exclude: <String>[
//                                               'KN',
//                                               'MF',
//                                               'IL',
//                                               'PS'
//                                             ],
//                                             onSelect: (Country country) {
//                                               selectedCountry =
//                                                   '${country.flagEmoji}  ${country.name}';
//                                               log(selectedCountry);
//                                               setState(() {});
//                                             },
//                                             countryListTheme:
//                                                 CountryListThemeData(
//                                               inputDecoration: InputDecoration(
//                                                 hintFadeDuration:
//                                                     const Duration(
//                                                   milliseconds: 400,
//                                                 ),
//                                                 hintText: 'Search',
//                                                 hintStyle:
//                                                     AppStyles.styleMedium16()
//                                                         .copyWith(
//                                                   color: context
//                                                               .read<
//                                                                   ThemeModeCubit>()
//                                                               .currentTheme ==
//                                                           ThemeMode.dark
//                                                       ? Colors.white
//                                                       : Colors.black,
//                                                 ),
//                                                 labelText: 'Search',
//                                                 labelStyle:
//                                                     AppStyles.styleMedium16()
//                                                         .copyWith(
//                                                   color: context
//                                                               .read<
//                                                                   ThemeModeCubit>()
//                                                               .currentTheme ==
//                                                           ThemeMode.dark
//                                                       ? Colors.white
//                                                       : Colors.black,
//                                                 ),
//                                                 prefixIcon: const Icon(
//                                                   Icons.search,
//                                                 ),
//                                                 border: buildOutlineBorder(),
//                                                 enabledBorder:
//                                                     buildOutlineBorder(),
//                                                 focusedBorder:
//                                                     buildOutlineBorder(),
//                                               ),
//                                               bottomSheetHeight: 600,
//                                             ),
//                                           );
//                                         },
//                                         icon: const Icon(
//                                           Icons.arrow_drop_down,
//                                           size: 20,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: SlideInRight(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Postal code',
//                                 style: TextStyle(
//                                   fontSize: 13,
//                                   fontFamily: 'Poppins',
//                                   fontWeight: FontWeight.w400,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Container(
//                                 height: 43,
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 12),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   border: Border.all(
//                                       width: 2, color: const Color(0xFFE0E0E0)),
//                                   borderRadius: BorderRadius.circular(6),
//                                 ),
//                                 child: TextFormField(
//                                   controller: postalCodeController,
//                                   style: const TextStyle(color: Colors.black),
//                                   cursorColor: Colors.black,
//                                   decoration: const InputDecoration(
//                                     contentPadding: EdgeInsetsDirectional.only(
//                                       top: 0,
//                                       bottom: 8,
//                                     ),
//                                     hintText: '90210',
//                                     hintStyle: TextStyle(
//                                       color: Colors.black54,
//                                       fontSize: 13,
//                                       fontFamily: 'Poppins',
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                     border: InputBorder.none,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 240,
//                   ),
//                   BlocBuilder<PaymentCubit, PaymentState>(
//                     builder: (context, state) {
//                       return BounceInDown(
//                         child: Column(
//                           children: [
//                             CustomButton(
//                               isLoading: state is PaymentLoading ? true : false,
//                               padding: const EdgeInsetsDirectional.only(
//                                 start: 124,
//                                 end: 123,
//                                 top: 15,
//                                 bottom: 18,
//                               ),
//                               text: LocaleKeys.wallet_Transfer.tr(),
//                               textStyle: AppStyles.styleSemiBold14().copyWith(
//                                 height: 1.36,
//                               ),
//                               borderRadius: 20,
//                               onPressed: () {
//                                 if (isSelected[0]) {
//                                   if (formKey.currentState!.validate()) {
//                                     // Pass data to payment logic
//                                     context
//                                         .read<PaymentCubit>()
//                                         .makePaymenStripeService(
//                                           paymentIntentInputModel:
//                                               PaymentIntentInputModel(
//                                             amount: '30',
//                                             currency: 'EGP',
//                                             customerId: ApiKeys.customerId,
//                                           ),
//                                           context: context,
//                                         );
//                                   }
//                                 } else if (isSelected[1]) {
//                                   Navigator.of(context).push(
//                                     MaterialPageRoute(
//                                       builder: (BuildContext context) =>
//                                           PaypalCheckout(
//                                         sandboxMode: true,
//                                         clientId: ApiKeys
//                                             .paypalClientId, //"CLIENT_ID",
//                                         secretKey: ApiKeys
//                                             .paypalSecretKey, //"SECRET_KEY",
//                                         returnURL: "success.snippetcoder.com",
//                                         cancelURL: "cancel.snippetcoder.com",
//                                         transactions: const [
//                                           {
//                                             "amount": {
//                                               "total": '70',
//                                               "currency": "USD",
//                                               "details": {
//                                                 "subtotal": '70',
//                                                 "shipping": '0',
//                                                 "shipping_discount": 0
//                                               }
//                                             },
//                                             "description":
//                                                 "The payment transaction description.",
//                                             "item_list": {
//                                               "items": [
//                                                 {
//                                                   "name": "Apple",
//                                                   "quantity": 4,
//                                                   "price": '5',
//                                                   "currency": "USD"
//                                                 },
//                                                 {
//                                                   "name": "Pineapple",
//                                                   "quantity": 5,
//                                                   "price": '10',
//                                                   "currency": "USD"
//                                                 }
//                                               ],
//                                               // shipping address is Optional
//                                               // "shipping_address": {
//                                               //   "recipient_name": "Raman Singh",
//                                               //   "line1": "Delhi",
//                                               //   "line2": "",
//                                               //   "city": "Delhi",
//                                               //   "country_code": "IN",
//                                               //   "postal_code": "11001",
//                                               //   "phone": "+00000000",
//                                               //   "state": "Texas"
//                                               // },
//                                             }
//                                           }
//                                         ],
//                                         note: "PAYMENT_NOTE",
//                                         onSuccess: (Map params) async {
//                                           log("onSuccess: $params");
//                                         },
//                                         onError: (error) {
//                                           log("onError: $error");
//                                           Navigator.pop(context);
//                                         },
//                                         onCancel: () {
//                                           log('cancelled:');
//                                           dispalySnackBar(
//                                             context,
//                                             title:
//                                                 'Payment canceled by the user.',
//                                             titleActionButton: 'ok',
//                                             color: Colors.orange,
//                                           );
//                                         },
//                                       ),
//                                     ),
//                                   );
//                                 } else if (isSelected[2]) {
//                                   context
//                                       .read<PaymentCubit>()
//                                       .makePaymentWithPaymob(context: context);
//                                 }
//                               },
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
