import 'dart:convert';
import 'package:beauty_saloon/components/custom_button_2.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/check_time_slot_response.dart';
import 'package:beauty_saloon/model/salon.dart';
import 'package:beauty_saloon/model/salon_categories_services_model.dart';
import 'package:beauty_saloon/screens/address_screen.dart';
import 'package:beauty_saloon/screens/appointment_summary/appointment_summary_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:http/http.dart' as http;


class CalendarScreen extends StatefulWidget {
  final Salon salon;
  final SalonCategoriesServicesModel salonCategoriesAndServices;
  final double totalCharges;

  CalendarScreen({@required this.salon,
    @required this.salonCategoriesAndServices,
    @required this.totalCharges});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  //date
  String currentDate = '';
  DateTime selectedDate;

  //time
  String currentTime = '';
  String _hour, _minute, _time;

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  bool formValidation = false;

  List<TimeSlot> dummyTimeSlots = [];


  DateTime _currentDate = DateTime.now();
  DateTime _currentDate2 = DateTime(2019, 2, 3);
  String _currentMonth = DateFormat.yMMM().format(DateTime(2019, 2, 3));
  DateTime _markedDateMap = DateTime(2019, 2, 3);


  String weekDay;

  //salon opening and closing time
  String openingTime;
  String closingTime;

  String salonTiming = '';

  bool isLoading = false;

  DateTime startCalendarDate;

  @override
  void initState() {
    //select current date from calendar
    getCurrentDate(DateTime.now());




    DateTime date = DateTime.now();
    weekDay = DateFormat('EEEE').format(date);


    startCalendarDate = date.subtract(Duration(days: 1));


    String time = jsonDecode(widget.salon.timing)[weekDay.toLowerCase()];

    if (time != '') {
      salonTiming = 'has time';
      _createTimeSlots(time);
    }
    else {
      salonTiming = '';
    }


    /************************************/


    /*for (int i = 0; i < widget.salonCategoriesAndServices.data.length; i++) {
      if (widget.salonCategoriesAndServices.data[i].isSelected) {
        print(
            'selected service name: ${widget.salonCategoriesAndServices.data[i].serviceName}');
        print(
            'selected service time: ${widget.salonCategoriesAndServices.data[i].serviceTime}\n');
      }
    }*/

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*Text('Please select date for you appointment', style: mediumTextStyleBlack),

                SizedBox(
                  height: 16,
                ),

                //date picker
                Container(
                  height: 56,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                        //color: currentDate == 'Date' ? ColorConstants.redColor : ColorConstants.dividerColor,
                        color: ColorConstants.dividerColor,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: InkWell(
                    onTap: () async {
                      //open date picker
                      final DateTime picked = await showDatePicker(
                        context: context,
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                surface: ColorConstants.primaryColor,
                              ),
                            ),
                            child: child,
                          );
                        },
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2090),
                      );

                      if (picked != null && picked != selectedDate) {
                        setState(() {
                          selectedDate = picked;

                          getCurrentDate(selectedDate);
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Text(
                          currentDate,
                          style: TextStyle(
                              color: currentDate != 'Date' ? ColorConstants.black : ColorConstants.lightGreyTextColor),
                        ),
                      ],
                    ),
                  ),
                ),


                SizedBox(
                  height: 4
                ),

                Visibility(
                  visible: formValidation && currentDate == 'Date' ? true : false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28.0),
                    child: Text(
                      'Please select date',
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.redColor,
                      ),
                    ),
                  ),
                ),




            SizedBox(
                  height: 30,
                ),

                Text('Please select time for you appointment', style: mediumTextStyleBlack),

                SizedBox(
                  height: 16,
                ),

                //time picker
                Container(
                  height: 56,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      //color: currentDate == 'Date' ? ColorConstants.redColor : ColorConstants.dividerColor,
                        color: ColorConstants.dividerColor,
                        style: BorderStyle.solid,
                        width: 0.80),
                  ),
                  child: InkWell(
                    onTap: () {

                      //open time picker
                      _selectTime(context);

                    },
                    child: Row(
                      children: [
                        Text(
                          currentTime,
                          style: TextStyle(
                              color: currentTime != 'Time' ? ColorConstants.black : ColorConstants.lightGreyTextColor),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 4,
                ),

                Visibility(
                  visible: formValidation && currentTime == 'Time' ? true : false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 28.0),
                    child: Text(
                      'Please select time',
                      style: TextStyle(
                        fontSize: 12,
                        color: ColorConstants.redColor,
                      ),
                    ),
                  ),
                ),*/


                    //calendar
                    cal(),


                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(Languages.of(context).chooseTime,
                              style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width > 768 ? 30 : 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quicksand',
                                color: Colors.blue,
                              )),

                          SizedBox(
                            height: 20,
                          ),

                          //time slots
                          salonTiming != '' ? GridView.builder(
                            itemCount: dummyTimeSlots.length,
                            shrinkWrap: true,
                            primary: false,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                                childAspectRatio: MediaQuery.of(context).size.width > 768 ? 2.5 : 2.3),
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  dummyTimeSlots[index].isSelected =
                                  !dummyTimeSlots[index].isSelected;

                                  for (int i = 0; i < dummyTimeSlots.length; i++) {
                                    if (i != index) {
                                      dummyTimeSlots[i].isSelected = false;
                                    }
                                  }

                                  setState(() {
                                    currentTime =
                                    dummyTimeSlots[index].time.split(' ')[0];
                                  });
                                },
                                child: GridTile(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: !dummyTimeSlots[index].isSelected
                                              ? Colors.transparent
                                              : ColorConstants.primaryColor,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(32.0),
                                          )
                                      ),
                                      child: Center(
                                        child: Text(dummyTimeSlots[index].time,
                                            style: TextStyle(
                                              color: !dummyTimeSlots[index]
                                                  .isSelected ? Colors.blue : Colors
                                                  .white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: MediaQuery.of(context).size.width > 768 ? 22 : 14,
                                            )),
                                      )), //just for testing, will fill with image later
                                ),
                              );
                            },
                          ) : Center(
                              child: Container(child: Text(Languages.of(context).salonIsClosed))),
                        ],
                      ),
                    ),
                  ],
                ),

                Visibility(
                  visible: isLoading,
                  child: Utils.buildLoading(),
                ),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: CustomButton2(
            text: 'Continue',
            callback: () {

              /*setState(() {
                formValidation = true;
              });*/

              print('salon id: ${widget.salon.id.toString()}');
              print('time: $currentTime');

              if (currentDate != '' && currentTime != '') {

                //currentTime += (selectedTime.hour < 12) ? ' am' : ' pm';
                print('currentDate: $currentDate ---- currentTime: $currentTime');

                _checkTimeSlotAvailability(
                    widget.salon.id.toString(), currentTime, currentDate).then((
                    value) => {

                        if(value.status) {
                          
                          _getServiceType().then((value) => {
                            if (value == 'salon')
                              {

                                //continue to summary screen
                                _navigateToSummaryScreen(),

                              }
                            else if (value == 'home')
                              {
                                //continue to address screen
                                _navigateToAddressScreen(),

                              },

                          }),


                      }
                      else {
                        //display error message
                          Fluttertoast.showToast(
                              msg: value.message,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0
                          ),

                        }
                  });


            }


            }),
      ),
    );
  }

  getCurrentDate(DateTime now) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    setState(() {
      currentDate = formattedDate;
    });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        currentTime = _time;
        currentTime = formatDate(
            DateTime(2019, 08, 1, selectedTime.hour, selectedTime.minute),
            [hh, ':', nn, " ", am]).toString();

        currentTime += (selectedTime.hour < 12) ? ' am' : ' pm';
      });
  }

  Widget cal() {
    return Container(
      height: MediaQuery.of(context).size.width > 768 ? MediaQuery.of(context).size.height * 0.2 : MediaQuery.of(context).size.height * 0.24,
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          this.setState(() => _currentDate = date);

          getCurrentDate(date);


          dummyTimeSlots.clear();
          weekDay = DateFormat('EEEE').format(_currentDate);
          String time = jsonDecode(widget.salon.timing)[weekDay.toLowerCase()];

          if (time != '') {
            salonTiming = 'has time';
            _createTimeSlots(time);
          }
          else {
            salonTiming = '';
          }

          setState(() {

          });
        },
        weekendTextStyle: TextStyle(
          color: Colors.red,
        ),
        thisMonthDayBorderColor: Colors.grey,
//      weekDays: null, /// for pass null when you do not want to render weekDays
//      headerText: Container( /// Example for rendering custom header
//        child: Text('Custom Header'),
//      ),
        //minSelectedDate: DateTime.now(),
        minSelectedDate: startCalendarDate,
        weekFormat: true,
        //markedDatesMap: _markedDateMap,
        height: 220.0,
        selectedDateTime: _currentDate,
        todayButtonColor: ColorConstants.whiteColor,
        todayTextStyle: TextStyle(color: Colors.black,),
        todayBorderColor: Colors.grey,
        selectedDayBorderColor: ColorConstants.primaryColor,
        selectedDayButtonColor: ColorConstants.primaryColor,
        daysHaveCircularBorder: false,

        /// null for not rendering any border, true for circular border, false for rectangular border
      ),
    );
  }

  _createTimeSlots(String time) {
    String fromTime = time.split(',')[0];
    String toTime = time.split(',')[1];

    String strHour = '';
    String strMin = '';
    String amPm;

    print('opening time: $fromTime');
    print('closing time: $toTime');

    addInitialTime(fromTime);

    do {
      String fromHour = fromTime.split(':')[0];
      String fromMin = fromTime.split(':')[1];
      int intFromHour = int.parse(fromHour);
      int intFromMin = int.parse(fromMin);


      DateTime date1 = DateTime(
          0,
          0,
          0,
          intFromHour,
          intFromMin,
          0,
          0);
      date1 = date1.add(Duration(minutes: 30));

      //hour
      if (date1.hour < 10) {
        strHour += '0';
        strHour += date1.hour.toString();
      }
      else {
        strHour += date1.hour.toString();
      }

      //min
      if (date1.minute < 10) {
        strMin += '0';
        strMin += date1.minute.toString();
      }
      else {
        strMin += date1.minute.toString();
      }


      if (date1.hour < 12)
        amPm = 'am';
      else
        amPm = 'pm';


      String newTime = strHour + ":" + strMin + ' $amPm';
      print('new time1: $newTime');

      fromTime = newTime.split(' ')[0];
      strHour = '';
      strMin = '';

      dummyTimeSlots.add(TimeSlot(newTime));
    } while (fromTime != toTime); //end for


  }

  addInitialTime(String startTime) {
    String amPm;
    String h = startTime.split(':')[0];
    int intH = int.parse(h);

    if (intH < 12) {
      amPm = 'am';
    }
    else {
      amPm = 'pm';
    }

    String initialTime = startTime + ' $amPm';
    dummyTimeSlots.add(TimeSlot(initialTime, isSelected: true));

    setState(() {
      currentTime = dummyTimeSlots[0].time.split(' ')[0];
    });
  }


  Future<CheckTimeSlotResponse> _checkTimeSlotAvailability(String salonId,
      String appointmentTime, String appointmentDate) async {
    String url = '${AppConstants.baseURL}/api/check-slot';
    CheckTimeSlotResponse checkTimeSlotResponse;

    setState(() {
      isLoading = true;
    });

    var response = await http.post(
        url,
        headers: {
          "APP_KEY": AppConstants.APP_KEY,
        },
        body: {
          "salon_id": salonId,
          "appointment_time": appointmentTime,
          "appointment_date": appointmentDate,
        });


    // check the status code for the result
    int statusCode = response.statusCode;

    print('slot availability check: ${response.body}');

    if (statusCode == 200) {
      checkTimeSlotResponse =
          CheckTimeSlotResponse.fromJson(jsonDecode(response.body));

      setState(() {
        isLoading = false;
      });

      return checkTimeSlotResponse;
    }
    else {
      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong !');

      setState(() {
        isLoading = false;
      });

      checkTimeSlotResponse =
          CheckTimeSlotResponse.fromJson(jsonDecode(response.body));

      return checkTimeSlotResponse;
    }
    //end if

  }

  Future<String> _getServiceType() async {
    var serType = await SharedPref.read(AppConstants.prefServiceType);

    return serType.toString();
  }

  _navigateToAddressScreen() {

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AddressScreen(
                salon: widget.salon,
                salonCategoriesAndServices:
                widget.salonCategoriesAndServices,
                selectedDate: currentDate,
                selectedTime: currentTime,
                totalCharges: widget.totalCharges
            ),
      ),
    );

  }

  _navigateToSummaryScreen() {

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AppointmentSummaryScreen(
                salon: widget.salon,
                salonCategoriesAndServices:
                widget.salonCategoriesAndServices,
                selectedDate: currentDate,
                selectedTime: currentTime,
                totalCharges: widget.totalCharges,
                address: '',
            ),
      ),
    );

  }

}


class TimeSlot {

  String time;
  bool isSelected;

  TimeSlot(this.time, {this.isSelected = false});
}