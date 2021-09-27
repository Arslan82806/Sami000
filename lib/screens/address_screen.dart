import 'package:beauty_saloon/components/custom_button_2.dart';
import 'package:beauty_saloon/components/custom_textfield.dart';
import 'package:beauty_saloon/model/salon.dart';
import 'package:beauty_saloon/model/salon_categories_services_model.dart';
import 'package:beauty_saloon/screens/appointment_summary/appointment_summary_screen.dart';
import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {

  final Salon salon;
  final SalonCategoriesServicesModel salonCategoriesAndServices;
  final String selectedDate;
  final String selectedTime;
  final double totalCharges;

  AddressScreen({
    @required this.salon,
    @required this.salonCategoriesAndServices,
    @required this.selectedDate,
    @required this.selectedTime,
    @required this.totalCharges
  });

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text('Address', style: TextStyle(fontFamily: 'Quicksand', fontSize: 24, fontWeight: FontWeight.bold)),

                SizedBox(
                  height: 16,
                ),

                CustomTextField(
                  _streetController,
                  'Street',
                  'Street',
                  TextInputType.text,
                  validateStreet,
                ),

                SizedBox(
                  height: 16,
                ),

                CustomTextField(
                  _cityController,
                  'City',
                  'City',
                  TextInputType.text,
                  validateCity,
                ),


                SizedBox(
                  height: 16,
                ),

                CustomTextField(
                  _stateController,
                  'State',
                  'State',
                  TextInputType.text,
                  validateState,
                ),


                SizedBox(
                  height: 16,
                ),

                CustomTextField(
                  _countryController,
                  'Country',
                  'Country',
                  TextInputType.text,
                  validateCountry,
                ),


              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: CustomButton2(
            text: 'Save',
            callback: () {

              //form validation
              validateAndSave(context);

            },
        ),
      ),
    );
  }

  Function(String) validateStreet = (String lastName) {
    if (lastName.isEmpty) {
      return 'Street empty';
    }

    return null;
  };

  Function(String) validateCity = (String lastName) {
    if (lastName.isEmpty) {
      return 'City empty';
    }

    return null;
  };

  Function(String) validateState = (String lastName) {
    if (lastName.isEmpty) {
      return 'State empty';
    }

    return null;
  };


  Function(String) validateCountry = (String lastName) {
    if (lastName.isEmpty) {
      return 'Country empty';
    }

    return null;
  };


  void validateAndSave(BuildContext cxt) {

    final form = formKey.currentState;
    String completeAddress = _streetController.text +' ' +_cityController.text +' '
    +_stateController.text +' ' +_countryController.text;

    if (form.validate()) {
      form.save();

      /*pushNewScreen(
        context,
        screen: AppointmentSummaryScreen(
            salon: widget.salon,
            salonCategoriesAndServices:
            widget.salonCategoriesAndServices,
            selectedDate: widget.selectedDate,
            selectedTime: widget.selectedTime,
            totalCharges: widget.totalCharges,
            address: completeAddress,
        ),
        withNavBar: true, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );*/


      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              AppointmentSummaryScreen(
                salon: widget.salon,
                salonCategoriesAndServices:
                widget.salonCategoriesAndServices,
                selectedDate: widget.selectedDate,
                selectedTime: widget.selectedTime,
                totalCharges: widget.totalCharges,
                address: completeAddress,
              ),
        ),
      );


    }

  }




}
