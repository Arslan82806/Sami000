import 'package:beauty_saloon/screens/service_type/service_type_screen.dart';
import 'package:beauty_saloon/screens/welcome/welcome_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  AnimationController controller;
  Animation<double> animation;

  String outPutString = '';

  Future initOneSignal() async {
    await  OneSignal.shared.init("c92c4082-28fe-4dcf-914a-cfe5a36a49a7");
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared.setNotificationReceivedHandler((OSNotification notification) {
      this.setState(() {
        outPutString =
        "Received notification: \n${notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      this.setState(() {
        outPutString =
        "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    //new code
    var status = await OneSignal.shared.getPermissionSubscriptionState();
    var playerId = status.subscriptionStatus.userId;

    StaticData.playerId = playerId;

    print('my player id: $playerId');

  }



  @override
  void initState() {

    initOneSignal();


    controller = AnimationController(
        duration: const Duration(milliseconds: 4000), vsync: this);
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    animation.addStatusListener((status) {

    if (status == AnimationStatus.completed) {

      _getShowWelcomeScreenCheckValue().then((value) => {

        print('show welcome screen: $value'),

      if(value) {
          Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ServiceTypeScreen(),
          ),
        ),
      }
      else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(),
          ),
        ),

      }


    });


    } else if (status == AnimationStatus.dismissed) {
    controller.forward();
    }

    });

    //this will start the animation
    controller.forward();




    super.initState();
  }

  _fadeInAnimation() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: animation,
            child: Image.asset(
              'assets/images/salon_logo.png',
              width: MediaQuery.of(context).size.width > 768 ? 300 : 220,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _getShowWelcomeScreenCheckValue() async {

    var showWelcomeScreen = await SharedPref.read(AppConstants.prefShowWelcomeSceen);

    if(showWelcomeScreen == null)
      return false;

    return showWelcomeScreen;
  }


}
