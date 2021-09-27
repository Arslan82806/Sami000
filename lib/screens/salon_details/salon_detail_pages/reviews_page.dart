import 'dart:convert';
import 'package:beauty_saloon/components/custom_button_2.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/add_review_response.dart';
import 'package:beauty_saloon/model/reviews_model.dart';
import 'package:beauty_saloon/screens/sign_in/sign_in_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/styles.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class ReviewsPage extends StatefulWidget {

  final String salonId;
  ReviewsPage({this.salonId});

  @override
  _ReviewsPageState createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {

  ReviewsModel rvModel;
  bool isLoading = false;
  bool isLoading2 = false;

  TextEditingController _reviewController = TextEditingController();
  double ratingValue = 3.0;

  AddReviewResponse addReview;

  @override
  void initState() {

    _getReviews(widget.salonId).then((value) => {
      rvModel = value,
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading ? Utils.buildLoading() : rvModel == null ? emptyReview() : SingleChildScrollView(
      //child: isLoading ? Utils.buildLoading() : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(Languages.of(context).reviewHeadingText, style: headingTextStyleBlack),

                  SizedBox(height: 20),
                  Text(
                      Languages.of(context).totalReviewText +' ${rvModel.data.length}',
                      style: normalTextStyleBlack
                  ),
                  SizedBox(height: 20),

                  //reviews list view
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: rvModel.data.length,
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
                                Text(rvModel.data[index].rating, style: normalTextStyleBlack),

                              ],
                            ),

                            SizedBox(
                              width: 16.0,
                            ),

                            Expanded(
                              child: Container(
                                //height: 90.0,
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

                                        Text(rvModel.data[index].userName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, fontFamily: 'Quicksand'), overflow: TextOverflow.ellipsis, maxLines: 1,),
                                        SizedBox(height: 8.0),
                                        Text(rvModel.data[index].description, style: normalTextStyleGrey),

                                      ],
                                    )
                                ),
                              ),
                            ),

                          ],
                        ),
                      );
                    },),

                  SizedBox(height: 20),

                  //add review button
                  CustomButton2(text: Languages.of(context).addReviewButtonText, callback: () {

                    //open add review bottom sheet
                    _addReviewBottomSheet();

                  },),



                ],
              ),

              Visibility(
                visible: isLoading2,
                child: Utils.buildLoading(),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget emptyReview() {
    return Center(
      child: Column(
        children: [
          Text(Languages.of(context).noReviewText, style: TextStyle(fontFamily: 'Quicksand', fontSize: 20,)),

          SizedBox(
            height: 20,
          ),

          //add review button
          CustomButton2(text: Languages.of(context).addReviewButtonText, callback: () {

            //open add review bottom sheet
            _addReviewBottomSheet();

          },),


    ],
      ),
    );
  }

  Future<ReviewsModel> _getReviews(String salonId) async {

    String url = '${AppConstants.baseURL}/api/getSalonReview';
    ReviewsModel reviewsModel;

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

      reviewsModel = ReviewsModel.fromJson(jsonDecode(response.body));

      setState(() {
        isLoading = false;
      });

      return reviewsModel;

    }
    else {

      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong !');

      setState(() {
        isLoading = false;
      });

      return reviewsModel;
    }
    //end if


  }


  void _addReviewBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.50,
            color: Colors.transparent,
            child: Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Languages.of(context).shareYourExperienceHeading,
                      style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.black),
                    ),

                    SizedBox(
                      height: 32,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Icon(Icons.person, size: 32),

                        SizedBox(
                          width: 16.0,
                        ),

                        //review text field
                        Expanded(
                          child: Container(
                            height: 90.0,
                            color: Colors.transparent,
                            child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: ColorConstants.bgColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                  ),
                                ),
                                child: TextField(
                                  controller: _reviewController,
                                  maxLines: 3,
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding:
                                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                                      hintText: Languages.of(context).reviewFieldText
                                  ),
                                ),
                            ),
                          ),
                        ),


                      ],
                    ),

                    SizedBox(
                      height: 16.0,
                    ),

                    //rating
                    Text(Languages.of(context).howManyStarts, style: TextStyle(fontFamily: 'Quicksand', color: ColorConstants.black, fontSize: 17, fontWeight: FontWeight.bold,),),

                    SizedBox(
                      height: 4.0,
                    ),

                    //rating stars
                    RatingBar.builder(
                      ignoreGestures: false,
                      initialRating: ratingValue,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 20,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {

                        setState(() {
                          ratingValue = rating;
                        });

                      },
                    ),


                    SizedBox(
                      height: 40,
                    ),

                    CustomButton2(text: Languages.of(context).shareReviewButtonText, callback: () {

                      //login check
                      if(StaticData.userData != null) {

                        //user is logged in
                        if(_reviewController.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: Languages.of(context).reviewErrorMessage,
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                        else
                        {

                          print('review: ${_reviewController.text}');
                          print('rating: $ratingValue');

                          //close bottom sheet
                          Navigator.pop(context);

                          //call add review API
                          /*_addReviewAPICall(widget.salonId, StaticData.userData.data.id.toString(), ratingValue.toString(), _reviewController.text)
                              .then((value) => {

                                Fluttertoast.showToast(
                                    msg: value.message,
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.blue,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                ),

                          });*/
                        }


                      }
                      else {

                        //user is not logged in
                        //redirect to login screen
                        pushNewScreen(
                          context,
                          screen: SignInScreen(),
                          withNavBar: false, // OPTIONAL VALUE. True by default.
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                        );

                      }


                    },),

                  ],
                ),
              ),
            ),
          );
        }).then((value) => {

          _addReviewAPICall(widget.salonId, StaticData.userData.data.id.toString(), ratingValue.toString(), _reviewController.text)
              .then((value) => {

                _getReviews(widget.salonId).then((reviews) => {

                  setState(() {
                    rvModel = reviews;
                  }),

                }),

                Fluttertoast.showToast(
                msg: value.message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0
                ),

            }),

        });
  }


  Future<AddReviewResponse> _addReviewAPICall(String salonId, String userId, String rating, String description) async {

    String url = '${AppConstants.baseURL}/api/addSalonReview';
    AddReviewResponse addReviewResponse;

    setState(() {
      isLoading2 = true;
    });

    var response = await http.post(
        url,
        headers: {
          "APP_KEY": AppConstants.APP_KEY,
        },
        body: {
          "salon_id": salonId,
          "user_id": userId,
          "rating": rating,
          "description": description,
        });


    // check the status code for the result
    int statusCode = response.statusCode;

    if (statusCode == 200) {

      addReviewResponse = AddReviewResponse.fromJson(jsonDecode(response.body));

      setState(() {
        isLoading2 = false;
      });

      return addReviewResponse;

    }
    else {

      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong ! ${response.body}');

      addReviewResponse = AddReviewResponse.fromJson(jsonDecode(response.body));

      setState(() {
        isLoading2 = false;
      });

      return addReviewResponse;
    }
    //end if


  }




}
