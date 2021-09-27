import 'dart:convert';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/otp_response.dart';
import 'package:beauty_saloon/screens/calendar/calendar_screen.dart';
import 'package:beauty_saloon/screens/sign_in/sign_in_screen.dart';
import 'package:beauty_saloon/utils/map_utils.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:beauty_saloon/model/salon.dart';
import 'package:beauty_saloon/model/salon_categories_services_model.dart';
import 'package:beauty_saloon/screens/salon_details/salon_detail_pages/reviews_page.dart';
import 'package:beauty_saloon/screens/salon_details/salon_detail_pages/salon_gallery_page.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';



class SalonDetailsScreen extends StatefulWidget {

  final Salon salon;
  SalonDetailsScreen(this.salon);

  @override
  _SalonDetailsScreenState createState() => _SalonDetailsScreenState();
}

class _SalonDetailsScreenState extends State<SalonDetailsScreen> {

  int selectedDateIndex = 0;
  List<String> _categories = [];
  List<ServicesData> _servicesList = [];
  List<ReviewData> _reviewList = [];


  bool isServicesTabSelected;
  bool isGalleryTabSelected;
  bool isAboutTabSelected;
  bool isReviewTabSelected;

  Widget currentSelectedTab;

  //gallery page
  List<String> mediaList = [];

  String weekDay;

  SalonCategoriesServicesModel salonCategoriesAndServices;
  bool isLoading = false;
  String selectedCategoryId;

  double totalCharges = 0.0;

  OTPResponse userData;

  //salon opening and closing time
  String openingTime;
  String closingTime;

  String salonTiming = '';

  @override
  void initState() {

    _getSalonOpeningAndClosingTime();

    _getSalonCatServ(widget.salon.id.toString()).then((value) => {
      salonCategoriesAndServices = value,

      if(value != null) {
        setState(() {
          selectedCategoryId = value.data[0].categoryId;
        }),
      }


    });


    isServicesTabSelected = true;
    isGalleryTabSelected = false;
    isAboutTabSelected = false;
    isReviewTabSelected = false;

    setState(() {
      currentSelectedTab = _getServicesTab();
    });


    _getCategories();
    _getServices();

    _getGalleryImages();
    _getReviewsList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //header
              Stack(
                overflow: Overflow.visible,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.27,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        //image: NetworkImage('https://picsum.photos/200/300'),
                        image: NetworkImage(widget.salon.image),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),

                  //main data
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.27,
                    color: Colors.black.withOpacity(0.4),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.salon.salonName, style: largeTextStyleWhite),
                        SizedBox(height: 4),
                        Text(widget.salon.city.cityName, style: smallTextStyleWhite),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 6),
                              decoration: BoxDecoration(
                                  color: jsonDecode(widget.salon.timing)[weekDay.toLowerCase()] == '' ? ColorConstants.redColor : ColorConstants.greenColor,
                                  border: Border.all(
                                    color: jsonDecode(widget.salon.timing)[weekDay.toLowerCase()] == '' ? ColorConstants.redColor : ColorConstants.greenColor,
                                  ),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                              child: Center(
                                  child: Text(jsonDecode(widget.salon.timing)[weekDay.toLowerCase()] == '' ? 'Closed' : 'Open',
                                      style: TextStyle(
                                          color: ColorConstants.whiteColor))),
                            ),
                            SizedBox(
                              width: 24,
                            ),
                            //Expanded(child: Text(jsonDecode(widget.salon.timing)[weekDay.toLowerCase()], style: smallTextStyleWhite, overflow: TextOverflow.ellipsis, maxLines: 2,)),
                            Expanded(child: Text('$salonTiming', style: smallTextStyleWhite, overflow: TextOverflow.ellipsis, maxLines: 2,)),
                            SizedBox(
                              width: 24,
                            ),
                            Icon(
                              Icons.star,
                              color: ColorConstants.ratingStarColor,
                              size: 16,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text('${double.parse(widget.salon.ratings).toStringAsFixed(1)} Rating', style: smallTextStyleWhite),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: -24,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        elevation: 4.0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      isServicesTabSelected = true;
                                      isGalleryTabSelected = false;
                                      isAboutTabSelected = false;
                                      isReviewTabSelected = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Text(Languages.of(context).servicesTabText,
                                        style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          color: isServicesTabSelected
                                              ? ColorConstants.primaryColor
                                              : ColorConstants.greyColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        )),
                                  )),

                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      isServicesTabSelected = false;
                                      isGalleryTabSelected = true;
                                      isAboutTabSelected = false;
                                      isReviewTabSelected = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Text(Languages.of(context).gallterTabText,
                                        style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          color: isGalleryTabSelected
                                              ? ColorConstants.primaryColor
                                              : ColorConstants.greyColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        )),
                                  )),

                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      isServicesTabSelected = false;
                                      isGalleryTabSelected = false;
                                      isAboutTabSelected = true;
                                      isReviewTabSelected = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Text(Languages.of(context).aboutTabText,
                                        style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          color: isAboutTabSelected
                                              ? ColorConstants.primaryColor
                                              : ColorConstants.greyColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        )),
                                  )),

                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      isServicesTabSelected = false;
                                      isGalleryTabSelected = false;
                                      isAboutTabSelected = false;
                                      isReviewTabSelected = true;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Text(Languages.of(context).reviewTabText,
                                        style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          color: isReviewTabSelected
                                              ? ColorConstants.primaryColor
                                              : ColorConstants.greyColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        )),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: 30,
              ),

              if(isServicesTabSelected)
                _getServicesTab(),
              if(isGalleryTabSelected)
                //_getGalleryTab(),
                SalonGalleryPage(salonId: widget.salon.id.toString()),

              if(isAboutTabSelected)
                _getAboutTab(),
              if(isReviewTabSelected)
                //_getReviewTab(),
                ReviewsPage(salonId: widget.salon.id.toString()),


            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 64,
        color: Colors.blue,
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Text(Languages.of(context).salonDetailsTotal +': $totalCharges SAR', style: normalTextStyleWhite),


            InkWell(
              onTap: () async {

                if(totalCharges != 0) {

                  if(await SharedPref.checkIfKeyExistsInSharedPref(AppConstants.user_data)) {

                    print('user logged in');

                    //navigate to calendar screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CalendarScreen(salon: widget.salon,
                            salonCategoriesAndServices: salonCategoriesAndServices, totalCharges: totalCharges),
                      ),
                    );

                  }
                  else {

                    print('user not logged in');

                    //Navigate to sign in screen
                    /*int result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SignInScreen(),
                      ),
                    );*/

                    pushNewScreen(
                      context,
                      screen: SignInScreen(),
                      withNavBar: false, // OPTIONAL VALUE. True by default.
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    ).then((value) => {

                        print('salon name: ${widget.salon.salonName}'),
                            if(value == 1) {

                          _getUserDataFromSharedPref().then((value) => {
                            setState(() {
                              StaticData.userData = value;
                              isLoading = false;
                            }),
                          }),

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CalendarScreen(salon: widget.salon,
                                  salonCategoriesAndServices: salonCategoriesAndServices, totalCharges: totalCharges),
                            ),
                          ),

                    }




              });


                  }


                }

              },
              child: Container(
                width: 130,
                height: 40,
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: totalCharges == 0 ? Colors.white70 : Colors.white,
                    border: Border.all(
                      color: Colors.white70,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                child: Center(
                    child: Text(Languages.of(context).bookServiceButtonText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: totalCharges == 0 ? Colors.blue.withOpacity(0.6) : Colors.blue))),
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget _getServicesTab() {

    return isLoading ? Utils.buildLoading() : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        //horizontal categories list view
        SizedBox(
          height: 50,
          child: salonCategoriesAndServices != null ? ListView.builder(
            scrollDirection: Axis.horizontal,
            //itemCount: _categories.length,
            itemCount: salonCategoriesAndServices.data.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedDateIndex = index;

                      selectedCategoryId = salonCategoriesAndServices.data[index].categoryId;

                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: selectedDateIndex == index
                          ? ColorConstants.primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        //color: Colors.grey
                          color: selectedDateIndex == index
                              ? ColorConstants.primaryColor
                              : Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        //_categories[index],
                        salonCategoriesAndServices.data[index].categoryName,
                        style: TextStyle(
                            color: selectedDateIndex == index
                                ? ColorConstants.whiteColor
                                : Colors.grey,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              );
            },
          ) : Utils.emptyLayout(Languages.of(context).noCategoriesText),
        ),

        SizedBox(
          height: 30,
        ),

        //vertical services list view
        salonCategoriesAndServices == null ? Utils.emptyLayout(Languages.of(context).noServicesText) : ListView.builder(
          scrollDirection: Axis.vertical,
          //itemCount: _servicesList.length,
          itemCount: salonCategoriesAndServices.data.length,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (BuildContext context, int index) {
            return salonCategoriesAndServices.data[index].categoryId != selectedCategoryId ? Container() : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Checkbox(
                      //value: _servicesList[index].isSelected,
                      value: salonCategoriesAndServices.data[index].isSelected,
                      onChanged: (value) {

                        setState(() {
                          salonCategoriesAndServices.data[index].isSelected = value;
                        });

                        if(value) {
                          setState(() {
                            totalCharges = totalCharges + double.parse(salonCategoriesAndServices.data[index].servicePrice);
                          });

                        }
                        else {
                          setState(() {
                            totalCharges = totalCharges - double.parse(salonCategoriesAndServices.data[index].servicePrice);
                          });
                        }

                        for(int i=0; i<salonCategoriesAndServices.data.length; i++) {
                          if(salonCategoriesAndServices.data[index].categoryId != selectedCategoryId)
                            salonCategoriesAndServices.data[index].isSelected = false;
                        }


                      }),
                  Container(
                    width: 40,
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: CachedNetworkImage(
                        //imageUrl: _servicesList[index].image,
                        imageUrl: salonCategoriesAndServices.data[index].image,
                        width: double.maxFinite,
                        height: 150,
                        fit: BoxFit.fill,
                        placeholder: (context, url) =>
                            CupertinoActivityIndicator(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Text(
                      //_servicesList[index].name,
                      '${salonCategoriesAndServices.data[index].serviceName} (${salonCategoriesAndServices.data[index].serviceTime} mins) ',
                      style: normalTextStyleBlack,
                    ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    //_servicesList[index].price,
                    ' ${salonCategoriesAndServices.data[index].servicePrice} SAR',
                    style: normalTextStyleBlack,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(
                    width: 30,
                  ),
                ],
              ),
            );
          },
        ),

      ],
    );
  }

  /*Widget _getGalleryTab() {
    return SalonGalleryPage(salonId: ,);
  }*/

  Widget _getAboutTab() {
    return widget.salon == null ? Utils.emptyLayout(Languages.of(context).noDetails) : Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(Languages.of(context).aboutHeadingText +' ${widget.salon.salonName}', style: headingTextStyleBlack),
          SizedBox(height: 20),
          Text(
              widget.salon.description == null ? Languages.of(context).noDescriptionText : widget.salon.description,
              style: normalTextStyleBlack),
          SizedBox(height: 20),
          Text(Languages.of(context).serviceOnDaysText, style: headingTextStyleBlack),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text('Sunday', style: normalTextStyleGrey),
              Text(jsonDecode(widget.salon.timing)['sunday'] == '' ? 'Closed' : jsonDecode(widget.salon.timing)['sunday'], style: normalTextStyleGrey),

            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text('Monday', style: normalTextStyleGrey),
              Text(jsonDecode(widget.salon.timing)['monday'] == '' ? 'Closed' : jsonDecode(widget.salon.timing)['monday'], style: normalTextStyleGrey),

            ],
          ),
          SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text('Tuesday', style: normalTextStyleGrey),
              Text(jsonDecode(widget.salon.timing)['tuesday'] == '' ? 'Closed' : jsonDecode(widget.salon.timing)['tuesday'], style: normalTextStyleGrey),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text('Wednesday', style: normalTextStyleGrey),
              Text(jsonDecode(widget.salon.timing)['wednesday'] == '' ? 'Closed' : jsonDecode(widget.salon.timing)['wednesday'], style: normalTextStyleGrey),

            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text('Thursday', style: normalTextStyleGrey),
              Text(jsonDecode(widget.salon.timing)['thursday'] == '' ? 'Closed' : jsonDecode(widget.salon.timing)['thursday'], style: normalTextStyleGrey),

            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text('Friday', style: normalTextStyleGrey),
              Text(jsonDecode(widget.salon.timing)['friday'] == '' ? 'Closed' : jsonDecode(widget.salon.timing)['friday'], style: normalTextStyleGrey),

            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text('Saturday', style: normalTextStyleGrey),
              Text(jsonDecode(widget.salon.timing)['saturday'] == '' ? 'Closed' : jsonDecode(widget.salon.timing)['saturday'], style: normalTextStyleGrey),

            ],
          ),
          SizedBox(height: 20),
          Text(Languages.of(context).contactInfoText, style: headingTextStyleBlack),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.call, color: ColorConstants.primaryColor),
              SizedBox(width: 8),
              Text(Languages.of(context).callText, style: smallTextStyleBlack),
              Expanded(child: SizedBox()),
              InkWell(
                  onTap: () {

                    launch("tel://${widget.salon.phone}");

                  },
                  child: Text(widget.salon.phone ?? 'NA', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blue))),
            ],
          ),

          SizedBox(height: 20),

          Row(
            children: [
              Icon(Icons.location_pin, color: ColorConstants.primaryColor),
              SizedBox(width: 8),
              Text(Languages.of(context).locationText, style: smallTextStyleBlack),
              Expanded(child: SizedBox()),
              InkWell(
                  onTap: () {

                    MapUtils.openMap(double.parse(widget.salon.lat), double.parse(widget.salon.lng));

                  },
                  child: Text(Languages.of(context).navigateToLocation, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue))),
            ],
          ),

          SizedBox(height: 20),

        ],
      ),
    );
  }

  Future<SalonCategoriesServicesModel> _getSalonCatServ(String salonId) async {

    String url = '${AppConstants.baseURL}/api/getSalonService';
    SalonCategoriesServicesModel salogCategoriesServicesModel;


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
        });


    // check the status code for the result
    int statusCode = response.statusCode;

    if (statusCode == 200) {

      salogCategoriesServicesModel = SalonCategoriesServicesModel.fromJson(jsonDecode(response.body));

      setState(() {
        isLoading = false;
      });

      return salogCategoriesServicesModel;

    }
    else {

      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong !');

      setState(() {
        isLoading = false;
      });

      return salogCategoriesServicesModel;
    }
    //end if

  }

  Future<OTPResponse> _getUserDataFromSharedPref() async {

    OTPResponse userData;

    if(await SharedPref.checkIfKeyExistsInSharedPref(AppConstants.user_data)) {
      userData = OTPResponse.fromJson(await SharedPref.read(AppConstants.user_data));
    }
    else {
      userData = null;
    }

    return userData;
  }



  /*Widget _getReviewTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text('Review', style: headingTextStyleBlack),
          SizedBox(height: 20),
          Text(
              'Total Reviews ${_reviewList.length}',
              style: normalTextStyleBlack
          ),
          SizedBox(height: 20),

          ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _reviewList.length,
            shrinkWrap: true,
            primary: false,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [

                    Column(
                      children: [

                        Icon(Icons.person, size: 32),
                        SizedBox(height: 8),
                        Text('5.0', style: normalTextStyleBlack),

                      ],
                    ),

                    SizedBox(
                      width: 16.0,
                    ),

                    Expanded(
                      child: Container(
                        height: 90.0,
                        color: Colors.transparent,
                        child: Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                                color: ColorConstants.bgColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                  bottomRight: Radius.circular(8.0),
                                ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text("le berber", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Quicksand')),
                                SizedBox(height: 8.0),
                                Text("best salon ever", style: normalTextStyleGrey),

                              ],
                            )
                        ),
                      ),
                    ),

                  ],
                ),
              );
            },),




        ],
      ),
    );
  }*/

  _getCategories() {
    _categories.add('Nails');
    _categories.add('Hair');
    _categories.add('Makeup');
    _categories.add('Hair Removal Treatment');

    _categories.add('Nails');
    _categories.add('Hair');
    _categories.add('Makeup');
    _categories.add('Hair Removal Treatment');
  }

  _getServices() {
    _servicesList.add(
        ServicesData('https://picsum.photos/200', 'Manicure', '\$ 20', false));
    _servicesList.add(
        ServicesData('https://picsum.photos/200', 'Pedicure', '\$ 20', false));
    _servicesList
        .add(ServicesData('https://picsum.photos/200', 'Test', '\$ 20', false));
  }


  _getGalleryImages() {
    mediaList.add('https://picsum.photos/200');
    mediaList.add('https://picsum.photos/200');
    mediaList.add('https://picsum.photos/200');
    mediaList.add('https://picsum.photos/200');
    mediaList.add('https://picsum.photos/200');
    mediaList.add('https://picsum.photos/200');
    mediaList.add('https://picsum.photos/200');
    mediaList.add('https://picsum.photos/200');
    mediaList.add('https://picsum.photos/200');
    mediaList.add('https://picsum.photos/200');
    mediaList.add('https://picsum.photos/200');
    mediaList.add('https://picsum.photos/200');
    mediaList.add('https://picsum.photos/200');
    mediaList.add('https://picsum.photos/200');
    mediaList.add('https://picsum.photos/200');
  }

  _getReviewsList() {
    _reviewList.add(ReviewData('test', 'best salon ever', '5.0'));
    _reviewList.add(ReviewData('test', 'best salon ever', '5.0'));
    _reviewList.add(ReviewData('test', 'best salon ever', '5.0'));
    _reviewList.add(ReviewData('test', 'best salon ever', '5.0'));
    _reviewList.add(ReviewData('test', 'best salon ever', '5.0'));
  }

  _getSalonOpeningAndClosingTime() {
    DateTime date = DateTime.now();
    weekDay = DateFormat('EEEE').format(date);

    String time = jsonDecode(widget.salon.timing)[weekDay.toLowerCase()];

    print('time: $time');

    if(time != '') {
      //opening time
      String fromTime = time.split(',')[0];
      String fromHour = fromTime.split(':')[0];

      int intFromHour = int.parse(fromHour);

      if(intFromHour < 12) {
        openingTime = time.split(',')[0] +' am';
        print('${time.split(',')[0]}am');
      }
      else {
        openingTime = time.split(',')[0] +' pm';
        print('${time.split(',')[0]}pm');
      }

      //closing time
      String toTime = time.split(',')[1];
      String toHour = toTime.split(':')[0];

      print('closing time: $toTime');
      int intToHour = int.parse(toHour);

      if(intToHour < 12) {
        closingTime = time.split(',')[1] +' am';
        print('${time.split(',')[1]} am');
      }
      else {
        closingTime = time.split(',')[1] +' pm';
        print('${time.split(',')[1]} pm');
      }

      salonTiming = openingTime +' to ' +closingTime;

    }
    else {
      salonTiming = '';
    }

  }


}


class ServicesData {
  String image;
  String name;
  String price;
  bool isSelected = false;

  ServicesData(this.image, this.name, this.price, this.isSelected);
}

class ReviewData {

  String username;
  String message;
  String rating;

  ReviewData(this.username, this.message, this.rating);

}