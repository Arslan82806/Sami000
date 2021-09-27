import 'dart:convert';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/categories_model.dart';
import 'package:beauty_saloon/model/city_model.dart';
import 'package:beauty_saloon/model/salon.dart';
import 'package:beauty_saloon/model/salon_by_country_city_service_model.dart';
import 'package:beauty_saloon/model/salon_model.dart';
import 'package:beauty_saloon/model/sliders_response.dart';
import 'package:beauty_saloon/pages/home_page/bloc/all_categories/all_categories_bloc.dart';
import 'package:beauty_saloon/pages/home_page/bloc/all_categories/all_categories_event.dart';
import 'package:beauty_saloon/pages/home_page/bloc/all_categories/all_categories_state.dart';
import 'package:beauty_saloon/pages/home_page/bloc/all_salons/all_salon_state.dart';
import 'package:beauty_saloon/pages/home_page/bloc/all_salons/all_salons_bloc.dart';
import 'package:beauty_saloon/pages/home_page/bloc/all_salons/all_salons_event.dart';
import 'package:beauty_saloon/screens/all_salon/all_salon_screen.dart';
import 'package:beauty_saloon/screens/category_salons/category_salons_screen.dart';
import 'package:beauty_saloon/screens/filter/filter_screen.dart';
import 'package:beauty_saloon/screens/paytabs_demo.dart';
import 'package:beauty_saloon/screens/salon_details/salon_details_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


final List<String> imgList = [
/*  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'*/
  'assets/images/salon_1.jpg',
  'assets/images/salon_2.jpeg',
  'assets/images/salon_3.jpg',
  'assets/images/salon_4.jpg'
];

List<String> sliderImages = [];

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AllSalonsBloc _allSalonsBloc = AllSalonsBloc();
  AllCategoriesBloc _allCategoriesBloc = AllCategoriesBloc();

  List<String> allAreasList = [];
  List<CityModel> _citiesList = [];
  Dialog allAreasDialog;

  CategoriesModel categoriesModel;
  SalonModel salonModel;

  bool isLoading = false;

  /*static String countryId = '';
  static String cityId = '';
  static String serviceType = '';*/

  //sliders
  //SlidersResponse slidersResponse;

  List<Widget> imageSliders;

  @override
  void initState() {

    _extractSliderImages();

    _getCountryIdType().then((value) => {
          setState(() {
            StaticData.countryId = value;
          }),
          _getCityIdType().then((value) => {
                setState(() {
                  StaticData.cityId = value;
                }),
                _getServiceType().then((value) => {
                      if (value == 'salon')
                        {
                          setState(() {
                            StaticData.serviceType = '2';
                          }),
                        }
                      else if (value == 'home')
                        {
                          setState(() {
                            StaticData.serviceType = '1';
                          }),
                        },
                      _allSalonsBloc
                          .add(GetAllSalons(StaticData.countryId, StaticData.cityId, StaticData.serviceType, '', '')),
                    }),
              }),
        });

    //bloc api calls
    _allCategoriesBloc.add(GetAllCategories());

    _getCitiesFromSharedPref();
    _loadFavouriteSalonsFromSharedPrefs();




    super.initState();
  }


  _loadFavouriteSalonsFromSharedPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      String jsonA = prefs.getString(AppConstants.prefFavSalonsList);

      List<Salon> listA =
          (json.decode(jsonA) as List)
              .map((e) => Salon.fromJson(e))
              .toList();

      //print('fav salons lis size: ${listA.length}');

      setState(() {
        StaticData.favouriteSalonsList = listA;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: isLoading
            ? Utils.buildLoading()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //select area and filter search row
                  Container(
                    color: ColorConstants.whiteColor,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            //open all areas dialog
                            displayAllAreasDialog();
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: ColorConstants.primaryColor,
                                size: 24,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                Languages.of(context).selectedAreaValue,
                                style: TextStyle(
                                  fontFamily: 'Quicksand',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.filter_alt_outlined),
                          color: ColorConstants.primaryColor,
                          iconSize: 24,
                          onPressed: () async {


                            //navigate to filter screen
                            int result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => FilterScreen(),
                              ),
                            );


                            if (StaticData.serviceType == 'salon')
                            {
                                StaticData.serviceType = '2';
                            }
                            else if(StaticData.serviceType == 'home')
                            {
                                StaticData.serviceType = '1';
                            }

                            print('CountryId sending: ${StaticData.countryId}');
                            print('CityId sending: ${StaticData.cityId}');
                            print('ServiceType sending: ${StaticData.serviceType}');


                            if(result == 1) {

                              print('filter applied');

                              _allSalonsBloc.add(GetAllSalons(StaticData.countryId, StaticData.cityId,
                                  StaticData.serviceType, StaticData.startPrice, StaticData.endPrice));
                            }
                            else {
                              print('filter cleared');
                              _allSalonsBloc.add(GetAllSalons(StaticData.countryId, StaticData.cityId,
                                  StaticData.serviceType, '', ''));
                            }


                            _getCitiesFromSharedPref();


                          },
                        ),
                      ],
                    ),
                  ),


                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: MediaQuery.of(context).size.width > 768 ?  4 : 3,
                      enlargeCenterPage: true,
                    ),
                    items: imageSliders,
                  ),

                  //all salons heading and button
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      16.0,
                      8.0,
                      0,
                      8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Languages.of(context).labelAllSalons,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Quicksand',
                                fontSize: 20)),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_right_alt,
                            color: ColorConstants.black,
                          ),
                          onPressed: () {

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AllSalonScreen(countryId: StaticData.countryId,
                                  cityId: StaticData.cityId, serviceType: StaticData.serviceType,),
                              ),
                            );

                            /*Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PaytabsDemo(),
                              ),
                            );*/


                          },
                        ),
                      ],
                    ),
                  ),

                  //all salons list view
                  _buildAllSalonsBlocContainer(),

                  //all categories heading and button
                  Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Text(Languages.of(context).labelAllCategories,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Quicksand',
                            fontSize: 20)),
                  ),

                  //categories list view
                  _buildAllCategoriesBlocContainer(),


                ],
              ),
      ),
    );
  }

  displayAllAreasDialog() {
    allAreasDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height / 1.6,
        height: _citiesList.length * 80.0,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //heading
              Container(
                width: double.maxFinite,
                height: 64,
                decoration: BoxDecoration(
                  color: ColorConstants.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    //'Select Area',
                    Languages.of(context).labelSelectArea,
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 22,
                        color: ColorConstants.whiteColor,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),

              //areas list
              ListView.builder(
                scrollDirection: Axis.vertical,
                //itemCount: allAreasList.length,
                //itemCount: Languages.of(context).getAreasList().length,
                itemCount: _citiesList.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        /*setState(() {
                            Languages.of(context).setAreaValue(Languages.of(context).getAreasList()[index]);
                          });*/

                        setState(() {
                          StaticData.cityId = _citiesList[index].id.toString();
                        });

                        Languages.of(context)
                            .setAreaValue(_citiesList[index].cityName);

                        Navigator.pop(context);
                      },
                      //child: Center(child: Text(allAreasList[index], style: TextStyle(fontFamily: 'Quicksand', fontSize: 20, ),)),
                      //child: Center(child: Text(Languages.of(context).getAreasList()[index], style: TextStyle(fontFamily: 'Quicksand', fontSize: 20, ),)),
                      child: Center(
                          child: Text(
                        _citiesList[index].cityName,
                        style: TextStyle(
                          fontFamily: 'Quicksand',
                          fontSize: 20,
                        ),
                      )),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    showDialog(
            context: context, builder: (BuildContext context) => allAreasDialog)
        .then((value) => {
              print('here after dialog'),
              _allSalonsBloc.add(GetAllSalons(StaticData.countryId, StaticData.cityId, StaticData.serviceType, '', '')),
            });
  }



  Widget _buildAllSalonsBlocContainer() {
    return Center(
      child: BlocProvider(
        create: (_) => _allSalonsBloc,
        child: BlocListener<AllSalonsBloc, AllSalonState>(
          listener: (context, state) {
            if (state is AllSalonError) {

              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  duration: Duration(seconds: 3),
                ),
              );
            }
          },
          child: BlocBuilder<AllSalonsBloc, AllSalonState>(
            builder: (context, state) {
              if (state is AllSalonInitial) {
                return Utils.buildLoading();
              } else if (state is AllSalonLoading) {
                return Utils.buildLoading();
              } else if (state is AllSalonLoaded) {
                return _buildAllSalonsList(context, state.salonModel);
              } else if (state is AllSalonError) {
                return emptySalon();
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAllSalonsList(
      BuildContext context, SalonByCountryCityServiceModel salonModel) {


    print('screen width: ${MediaQuery.of(context).size.width}');
    print('screen height: ${MediaQuery.of(context).size.height}');

    return salonModel.data != null ? SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 270,
      //height: MediaQuery.of(context).size.height * 0.3,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: salonModel.data.length,
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.all(8.0),
          itemBuilder: (BuildContext context, int index) {

            if (checkIfSalonIsInFavList(salonModel.data[index].id.toString())) {
              salonModel.data[index].isFavourite = true;
            } else {
              salonModel.data[index].isFavourite = false;
            }

            return InkWell(
              onTap: () {
                //navigate to salon details screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SalonDetailsScreen(salonModel.data[index]),
                  ),
                );
              },
              child: Stack(
                children: [
                  Card(
                    elevation: 4,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width > 768 ? MediaQuery.of(context).size.width * 0.2 :
                        MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4.0),
                            child: CachedNetworkImage(
                              imageUrl: salonModel.data[index].image,
                              width: double.maxFinite,
                              height: 150,
                              fit: BoxFit.fill,
                              placeholder: (context, url) =>
                                  CupertinoActivityIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    RatingBar.builder(
                                      ignoreGestures: true,
                                      initialRating: double.parse(
                                          salonModel.data[index].ratings),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 14,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                        child: Text(
                                      '(${double.parse(salonModel.data[index].ratings).toStringAsFixed(1)})',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    )),
                                  ],
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  salonModel.data[index].salonName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstants.black),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  salonModel.data[index].city.cityName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstants.greyColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(
                        salonModel.data[index].isFavourite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 30,
                      ),
                      color: ColorConstants.whiteColor,
                      onPressed: () {
                        if (checkIfSalonIsInFavList(
                            salonModel.data[index].id.toString())) {
                          //remove salon
                          removeFavouriteSalon(
                              salonModel.data[index].id.toString());

                          salonModel.data[index].isFavourite = false;

                          SharedPref.saveFavSalonsList(
                              AppConstants.prefFavSalonsList,
                              StaticData.favouriteSalonsList);

                          setState(() {
                            salonModel.data[index].isFavourite = false;
                          });
                        } else {
                          //add salon
                          salonModel.data[index].isFavourite = true;

                          StaticData.favouriteSalonsList
                              .add(salonModel.data[index]);

                          SharedPref.saveFavSalonsList(
                              AppConstants.prefFavSalonsList,
                              StaticData.favouriteSalonsList);

                          setState(() {
                            salonModel.data[index].isFavourite = true;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
    ) : emptySalon();
  }

  Widget _buildAllCategoriesBlocContainer() {
    return Center(
      child: BlocProvider(
        create: (_) => _allCategoriesBloc,
        child: BlocListener<AllCategoriesBloc, AllCategoriesState>(
          listener: (context, state) {
            if (state is AllCategoriesError) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  duration: Duration(seconds: 1),
                ),
              );
            }
          },
          child: BlocBuilder<AllCategoriesBloc, AllCategoriesState>(
            builder: (context, state) {
              if (state is AllCategoriesInitial) {
                return Utils.buildLoading();
              } else if (state is AllCategoriesLoading) {
                return Utils.buildLoading();
              } else if (state is AllCategoriesLoaded) {
                return _buildAllCategoriesList(context, state.categoriesModel);
              } else if (state is AllCategoriesError) {
                return emptyCategories();
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAllCategoriesList(
      BuildContext context, CategoriesModel categoriesModel) {
    return categoriesModel.data != null ? SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categoriesModel.data.length,
          shrinkWrap: true,
          primary: false,
          padding: EdgeInsets.all(8.0),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CategorySalonsScreen(
                      categoryId: categoriesModel.data[index].id.toString(),
                      countryId: StaticData.countryId,
                      cityId: StaticData.cityId
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 4,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width > 768 ?  MediaQuery.of(context).size.width * 0.2 :
                    MediaQuery.of(context).size.width * 0.3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(categoriesModel.data[index].image,
                          width: 80, height: 80),
                      //Image.asset(categoriesList[index].image, width: 80, height: 80),

                      SizedBox(
                        height: 16,
                      ),

                      Text(
                        categoriesModel.data[index].categoryName,
                        //categoriesList[index].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.black),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    ) : emptyCategories();
  }

  _getCitiesFromSharedPref() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String jsonA = prefs.getString(AppConstants.prefSelectedCountryCites);

      List<CityModel> listA = (json.decode(jsonA) as List)
          .map((e) => CityModel.fromJson(e))
          .toList();

      //print('cities list size: ${listA.length}');

      setState(() {
        _citiesList = listA;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> _getServiceType() async {
    var serType = await SharedPref.read(AppConstants.prefServiceType);

    return serType.toString();
  }

  Future<String> _getCountryIdType() async {
    dynamic ctyId = await SharedPref.read(AppConstants.prefSelectedCountry);
    //print('countryId: $ctyId');

    return ctyId.toString();
  }

  Future<String> _getCityIdType() async {
    dynamic cId = await SharedPref.read(AppConstants.prefSelectedCity);
    //print('cityId: $cId');

    return cId.toString();
  }

  removeFavouriteSalon(String id) {
    print('id to remove: $id');
    for (int i = 0; i < StaticData.favouriteSalonsList.length; i++) {
      if (StaticData.favouriteSalonsList[i].id.toString() == id) {
        StaticData.favouriteSalonsList.removeAt(i);
      }
    }
  }

  bool checkIfSalonIsInFavList(String id) {
    for (int i = 0; i < StaticData.favouriteSalonsList.length; i++) {
      if (StaticData.favouriteSalonsList[i].id.toString() == id) {
        return true;
      }
    }

    return false;
  }

  Widget emptySalon() {
    return Center(child: Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Text(Languages.of(context).noSalonAvailableText, style: TextStyle(fontFamily: 'Quicksand', fontSize: 16,)),
    ));
  }

  Widget emptyCategories() {
    return Center(child: Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Text(Languages.of(context).noCategoriesAvailableText, style: TextStyle(fontFamily: 'Quicksand', fontSize: 16,)),
    ));
  }


  _extractSliderImages() {
    for(int i=0; i<StaticData.slidersResponse.data.length; i++) {
      sliderImages.add(StaticData.slidersResponse.data[i].image);
    }

    imageSliders = sliderImages
        .map((item) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.network(item, fit: BoxFit.fill, width: 1000.0),
                //Image.asset(item, fit: BoxFit.cover, width: 1000.0),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Text(
                      'Book the best salon',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    ))
        .toList();

    setState(() {

    });
  }



}
