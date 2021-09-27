import 'package:beauty_saloon/model/salon_model.dart';
import 'package:beauty_saloon/screens/all_salon/bloc/get_all_salons_bloc.dart';
import 'package:beauty_saloon/screens/all_salon/bloc/get_all_salons_event.dart';
import 'package:beauty_saloon/screens/all_salon/bloc/get_all_salons_state.dart';
import 'package:beauty_saloon/screens/salon_details/salon_details_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AllSalonScreen extends StatefulWidget {
  final String countryId;
  final String cityId;
  final String serviceType;

  AllSalonScreen(
      {@required this.countryId,
      @required this.cityId,
      @required this.serviceType});

  @override
  _AllSalonScreenState createState() => _AllSalonScreenState();
}

class _AllSalonScreenState extends State<AllSalonScreen> {
  GetAllSalonsBloc _getAllSalonsBloc = GetAllSalonsBloc();

  @override
  void initState() {
    _getAllSalonsBloc.add(
        GetAllMySalons(widget.countryId, widget.cityId, widget.serviceType));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: _buildGetAllSalonsBlocContainer(),
      ),
    );
  }

  Widget _buildGetAllSalonsBlocContainer() {
    return BlocProvider(
      create: (_) => _getAllSalonsBloc,
      child: BlocListener<GetAllSalonsBloc, GetAllSalonState>(
        listener: (context, state) {
          if (state is GetAllSalonError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        child: BlocBuilder<GetAllSalonsBloc, GetAllSalonState>(
          builder: (context, state) {
            if (state is GetAllSalonInitial) {
              return Container(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Utils.buildLoading(),
              );
            } else if (state is GetAllSalonLoading) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Utils.buildLoading(),
              );
            } else if (state is GetAllSalonLoaded) {
              return _buildGetAllSalonsList(context, state.salonModel);
            } else if (state is GetAllSalonError) {
              return Utils.emptyLayout('No salons available');
            }

            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildGetAllSalonsList(BuildContext context, SalonModel salonModel) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: salonModel.data != null
          ? GridView.builder(
              itemCount: salonModel.data.length,
              shrinkWrap: true,
              primary: false,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 768 ? 3 : 2, childAspectRatio: 0.7),
              itemBuilder: (BuildContext context, int index) {
                if (checkIfSalonIsInFavList(
                    salonModel.data[index].id.toString())) {
                  salonModel.data[index].isFavourite = true;
                } else {
                  salonModel.data[index].isFavourite = false;
                }

                return InkWell(
                  onTap: () {
                    //navigate to salon details screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            SalonDetailsScreen(salonModel.data[index]),
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
                                  imageUrl: salonModel.data[index].image,
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
                                          fontSize: MediaQuery.of(context).size.width > 768 ? 22 : 15,
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
                            salonModel.data[index].isFavourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: MediaQuery.of(context).size.width > 768 ? 50 : 30,
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
              })
          : Utils.emptyLayout('No salons available'),
    );
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
}
