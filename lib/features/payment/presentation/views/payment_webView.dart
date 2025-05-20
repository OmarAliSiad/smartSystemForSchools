// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// class PaymentWebview extends StatefulWidget {
//   final Uri url;
//   const PaymentWebview({super.key, required this.url});

//   @override
//   State<PaymentWebview> createState() => _PaymentWebviewState();
// }

// class _PaymentWebviewState extends State<PaymentWebview> {
//   late InAppWebViewController? webViewController;

//   @override
//   void initState() {
//     log('Initial URL: ${widget.url.toString()}');
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back_ios),
//         ),
//       ),
//       body: InAppWebView(
//         initialOptions: InAppWebViewGroupOptions(
//           crossPlatform: InAppWebViewOptions(
//             javaScriptEnabled: true,
//           ),
//         ),
//         onWebViewCreated: (controller) {
//           webViewController = controller;
//           webViewController!.loadUrl(
//             urlRequest: URLRequest(
//               url: widget.url,
//             ),
//           );
//         },
//         onLoadStop: (controller, url) async {
//           if (url != null) {
//             log('Page loaded: ${url.toString()}');
//             log('Query parameters: ${url.queryParameters}');
//             // Check for payment success
//             if (url.queryParameters.containsKey('success') &&
//                 url.queryParameters['success'] == 'true') {
//               log('paymentSuccess');
//             } else if (url.queryParameters.containsKey('success') &&
//                 url.queryParameters['success'] == 'false') {
//               // Payment failed
//               log('payment Failed');
//             }
//           }
//         },
//       ),
//     );
//   }
// }
