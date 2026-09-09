import '../../../../config/config.dart';
import 'package:flutter/material.dart';

// class ServiceErrorParameters {
//   final String message;

//   const ServiceErrorParameters({required this.message});
// }

class ServiceErrorScreen extends StatefulWidget {
  // final ServiceErrorParameters parameters;

  const ServiceErrorScreen({super.key});

  @override
  State<ServiceErrorScreen> createState() => _ServiceErrorScreenState();
}

class _ServiceErrorScreenState extends State<ServiceErrorScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.1),
            Container(
              height: height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/image/service_error.png'),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                'Service Not Support',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: fontFamilyMain,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
