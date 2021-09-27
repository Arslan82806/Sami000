import 'package:beauty_saloon/components/custom_app_bar.dart';
import 'package:beauty_saloon/components/custom_button_1.dart';
import 'package:beauty_saloon/components/custom_textfield.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _emailMobileNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Languages.of(context).labelForgotPassword,),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/images/salon_logo.png',
                  width: 220,
                ),

                /*CustomTextfield(emailMobileNoController,
                    Languages.of(context).hintEmailMobileNo, TextInputType.text),*/

                CustomTextField(_emailMobileNoController, Languages.of(context).hintEmailMobileNo,
                    Languages.of(context).hintEmailMobileNo, TextInputType.text, validateEmail),

                SizedBox(height: 16),

                //get started button
                CustomButton1(
                  text: Languages.of(context).buttonLabelSubmit.toUpperCase(),
                  callback: () {

                    //form validate
                    validateAndSave(context);

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final Function(String) validateEmail = (String email) {
    if (email.isEmpty) {
      return 'Email empty';
    }
    else if(Utils.isEmail(email) == false) {
      return 'Invalid email';
    }

    return null;
  };

  void validateAndSave(BuildContext cxt) {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      ///to-do forgot password api call

    }
  }

  @override
  void dispose() {
    _emailMobileNoController.dispose();
    super.dispose();
  }
}
