import 'package:beauty_saloon/model/category_salon_model.dart';
import 'package:beauty_saloon/screens/category_salons/bloc/category_salons_state.dart';
import 'package:beauty_saloon/screens/salon_details/salon_details_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:beauty_saloon/screens/category_salons/bloc/category_salons_bloc.dart';
import 'package:beauty_saloon/screens/category_salons/bloc/category_salons_event.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CategorySalonsScreen extends StatefulWidget {
  final String categoryId;
  final String countryId;
  final String cityId;

  CategorySalonsScreen({this.categoryId, this.countryId, this.cityId});

  @override
  _CategorySalonsScreenState createState() => _CategorySalonsScreenState();
}

class _CategorySalonsScreenState extends State<CategorySalonsScreen> {
  CategorySalonsBloc _getCategorySalonsBloc = CategorySalonsBloc();

  @override
  void initState() {
    _getCategorySalonsBloc.add(GetCategorySalons(widget.categoryId, widget.countryId, widget.cityId));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: _buildCategorySalonsBlocContainer(),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySalonsBlocContainer() {
    return BlocProvider(
      create: (_) => _getCategorySalonsBloc,
      child: BlocListener<CategorySalonsBloc, CategorySalonState>(
        listener: (context, state) {
          if (state is CategorySalonError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        child: BlocBuilder<CategorySalonsBloc, CategorySalonState>(
          builder: (context, state) {
            if (state is CategorySalonInitial) {
              return Utils.buildLoading();
            } else if (state is CategorySalonLoading) {
              return Utils.buildLoading();
            } else if (state is CategorySalonLoaded) {
              return _buildCategorySalonsList(
                  context, state.categorySalonModel);
            } else if (state is CategorySalonError) {
              return Container();
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildCategorySalonsList(
      BuildContext context, CategorySalonModel salonModel) {
    return Container(
        padding: EdgeInsets.all(16.0),
        child: salonModel.data == null
            ? _emptyCategorySalon()
            : GridView.builder(
                itemCount: salonModel.data.length,
                shrinkWrap: true,
                primary: false,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 768 ? 3 : 2, childAspectRatio: 0.7),
                itemBuilder: (BuildContext context, int index) {
                  if (checkIfSalonIsInFavList(
                      salonModel.data[index].salon.id.toString())) {
                    salonModel.data[index].salon.isFavourite = true;
                  } else {
                    salonModel.data[index].salon.isFavourite = false;
                  }

                  return InkWell(
                    onTap: () {
                      //navigate to salon details screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              SalonDetailsScreen(salonModel.data[index].salon),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Card(
                          elevation: 4,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        salonModel.data[index].salon.image,
                                    width: double.maxFinite,
                                    height: MediaQuery.of(context).size.width > 768 ? MediaQuery.of(context).size.height * 0.26 : 150,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          RatingBar.builder(
                                            ignoreGestures: true,
                                            initialRating: double.parse(
                                                salonModel
                                                    .data[index].salon.ratings),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: MediaQuery.of(context).size.width > 768 ? 18 : 14,
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
                                            '(${double.parse(salonModel.data[index].salon.ratings).toStringAsFixed(1)})',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        salonModel.data[index].salon.salonName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: MediaQuery.of(context).size.width > 768 ? 22 : 15,
                                            fontWeight: FontWeight.bold,
                                            color: ColorConstants.black),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        salonModel
                                            .data[index].salon.city.cityName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: MediaQuery.of(context).size.width > 768 ? 18 : 13,
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
                          right: MediaQuery.of(context).size.width > 768 ? 20 : 0,
                          child: IconButton(
                            icon: Icon(
                              salonModel.data[index].salon.isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: MediaQuery.of(context).size.width > 768 ? 50 : 30,
                            ),
                            color: ColorConstants.whiteColor,
                            onPressed: () {
                              if (checkIfSalonIsInFavList(
                                  salonModel.data[index].salon.id.toString())) {
                                //remove salon
                                removeFavouriteSalon(
                                    salonModel.data[index].salon.id.toString());

                                salonModel.data[index].salon.isFavourite =
                                    false;

                                SharedPref.saveFavSalonsList(
                                    AppConstants.prefFavSalonsList,
                                    StaticData.favouriteSalonsList);

                                setState(() {
                                  salonModel.data[index].salon.isFavourite =
                                      false;
                                });
                              } else {
                                //add salon
                                salonModel.data[index].salon.isFavourite = true;

                                /*Salon obj = Salon(
                            id: salonModel.data[index].salon.id,
                            role: salonModel.data[index].salon.role,
                            firstName: salonModel.data[index].salon.firstName,
                            lastName: salonModel.data[index].salon.lastName,
                            salonName: salonModel.data[index].salon.salonName,
                            email: salonModel.data[index].salon.email,
                            phone: salonModel.data[index].salon.phone,
                            countryId: salonModel.data[index].salon.countryId,
                            cityId: salonModel.data[index].salon.cityId,
                            image: salonModel.data[index].salon.image,
                            status: salonModel.data[index].salon.status,
                            giveService: salonModel.data[index].salon.giveService,
                            serviceCharges: salonModel.data[index].salon.serviceCharges,
                            wallet: salonModel.data[index].salon.wallet,
                            timing: salonModel.data[index].salon.timing,
                            description: salonModel.data[index].salon.description,
                            website: salonModel.data[index].salon.website,
                            lat: salonModel.data[index].salon.lat,
                            lng: salonModel.data[index].salon.lng,
                            createdAt: salonModel.data[index].salon.createdAt,
                            updatedAt: salonModel.data[index].salon.updatedAt,
                            city: salonModel.data[index].salon.city,
                            country: salonModel.data[index].salon.country,
                            ratings: salonModel.data[index].salon.ratings,

                          );*/

                                StaticData.favouriteSalonsList
                                    .add(salonModel.data[index].salon);

                                SharedPref.saveFavSalonsList(
                                    AppConstants.prefFavSalonsList,
                                    StaticData.favouriteSalonsList);

                                setState(() {
                                  salonModel.data[index].salon.isFavourite =
                                      true;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ));
  }

  Widget _emptyCategorySalon() {
    return Center(
        child: Text('No Salons found !',
            style: TextStyle(
              fontSize: 20,
            )));
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

/*getSalons() {

    _categorySalonsList.add(CategorySalonModel('https://picsum.photos/seed/picsum/200/300',
        '3.0', 'Violet Salon', 'Taybah, Dammam'));
    _categorySalonsList.add(CategorySalonModel('https://picsum.photos/seed/picsum/200/300',
        '4.5', 'Abeer World Ladies Center', 'Al Itisalat, Dammam'));
    _categorySalonsList.add(CategorySalonModel('https://picsum.photos/seed/picsum/200/300',
        '5.0', 'Pronzag Ladies Center', 'Al Tubayshi, Dammam'));
    _categorySalonsList.add(CategorySalonModel('https://picsum.photos/seed/picsum/200/300',
        '4.0', 'Bint Al Mamlaka Salon', 'Uhud - 71, Dammam'));

    _categorySalonsList.add(CategorySalonModel('https://picsum.photos/seed/picsum/200/300',
        '3.0', 'Violet Salon', 'Taybah, Dammam'));
    _categorySalonsList.add(CategorySalonModel('https://picsum.photos/seed/picsum/200/300',
        '4.5', 'Abeer World Ladies Center', 'Al Itisalat, Dammam'));
    _categorySalonsList.add(CategorySalonModel('https://picsum.photos/seed/picsum/200/300',
        '5.0', 'Pronzag Ladies Center', 'Al Tubayshi, Dammam'));
    _categorySalonsList.add(CategorySalonModel('https://picsum.photos/seed/picsum/200/300',
        '4.0', 'Bint Al Mamlaka Salon', 'Uhud - 71, Dammam'));


    _categorySalonsList.add(CategorySalonModel('https://picsum.photos/seed/picsum/200/300',
        '3.0', 'Violet Salon', 'Taybah, Dammam'));
    _categorySalonsList.add(CategorySalonModel('https://picsum.photos/seed/picsum/200/300',
        '4.5', 'Abeer World Ladies Center', 'Al Itisalat, Dammam'));
    _categorySalonsList.add(CategorySalonModel('https://picsum.photos/seed/picsum/200/300',
        '5.0', 'Pronzag Ladies Center', 'Al Tubayshi, Dammam'));
    _categorySalonsList.add(CategorySalonModel('https://picsum.photos/seed/picsum/200/300',
        '4.0', 'Bint Al Mamlaka Salon', 'Uhud - 71, Dammam'));

  }*/

/*Widget listViewDemo() {

    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: salonModel.data.length,
        shrinkWrap: true,
        primary: false,
        padding: EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              //navigate to salon details screen
            },
            child: Stack(
              children: [
                Card(
                  elevation: 4,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
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
                                        salonModel.data[index].salon.ratings),
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
                                        '(${double.parse(salonModel.data[index].salon.ratings).toStringAsFixed(1)})',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                salonModel.data[index].salon.salonName,
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
                                salonModel.data[index].salon.city.cityName,
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

                        */ /*Salon obj = Salon(
                            id: salonModel.data[index].salon.id,
                            role: salonModel.data[index].salon.role,
                            firstName: salonModel.data[index].salon.firstName,
                            lastName: salonModel.data[index].salon.lastName,
                            salonName: salonModel.data[index].salon.salonName,
                            email: salonModel.data[index].salon.email,
                            phone: salonModel.data[index].salon.phone,
                            countryId: salonModel.data[index].salon.countryId,
                            cityId: salonModel.data[index].salon.cityId,
                            image: salonModel.data[index].salon.image,
                            status: salonModel.data[index].salon.status,
                            giveService: salonModel.data[index].salon.giveService,
                            serviceCharges: salonModel.data[index].salon.serviceCharges,
                            wallet: salonModel.data[index].salon.wallet,
                            timing: salonModel.data[index].salon.timing,
                            description: salonModel.data[index].salon.description,
                            website: salonModel.data[index].salon.website,
                            lat: salonModel.data[index].salon.lat,
                            lng: salonModel.data[index].salon.lng,
                            createdAt: salonModel.data[index].salon.createdAt,
                            updatedAt: salonModel.data[index].salon.updatedAt,
                            city: salonModel.data[index].salon.city,
                            country: salonModel.data[index].salon.country,
                            ratings: salonModel.data[index].salon.ratings,

                          );*/ /*


                        StaticData.favouriteSalonsList
                            .add(salonModel.data[index].salon);

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
        });

  }*/

}
