import '../../../../config/config.dart';
import 'package:flutter/material.dart';

class MaintenanceParameters {
  final String message;

  const MaintenanceParameters({required this.message});
}

class MaintenanceScreen extends StatefulWidget {
  final MaintenanceParameters parameters;

  const MaintenanceScreen({super.key, required this.parameters});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
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
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: height * 0.18),
            Container(
              height: height * 0.35,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  image: AssetImage('assets/image/maintenance.png'),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 30),
              child: Text(
                widget.parameters.message,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: fontFamilyMain,
                ),
                textAlign: TextAlign.center,
              ),
              // height: height * 0.35,

              // decoration: const BoxDecoration(
              //   color: colorBabyBlue,
              //   image: DecorationImage(
              //     fit: BoxFit.fitWidth,
              //     image: AssetImage('assets/image/maintenance.png'),
              //   ),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
