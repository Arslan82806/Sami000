import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/screens/salon_details/salon_details_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FavouriteSalonsPage extends StatefulWidget {
  @override
  _FavouriteSalonsPageState createState() => _FavouriteSalonsPageState();
}

class _FavouriteSalonsPageState extends State<FavouriteSalonsPage> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: StaticData.favouriteSalonsList.length == 0 ? Utils.emptyLayout(Languages.of(context).noFavoriteSalonsText) : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: StaticData.favouriteSalonsList.length,
                    shrinkWrap: true,
                    primary: false,
                    padding: EdgeInsets.all(16.0),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [

                            //image
                            SizedBox(
                              width: MediaQuery.of(context).size.width > 768 ? 120 : 90,
                              height: MediaQuery.of(context).size.width > 768 ? 120 : 90,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: StaticData.favouriteSalonsList[index].image,
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      CupertinoActivityIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                            ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width > 768 ? 32 : 16,
                            ),

                            //name, location, rating
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    StaticData.favouriteSalonsList[index].salonName
                                        .toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontSize: MediaQuery.of(context).size.width > 768 ? 22 : 14,
                                      fontWeight: FontWeight.bold,
                                      color: ColorConstants.black,
                                    ),
                                  ),

                                  SizedBox(
                                    height: 4,
                                  ),

                                  Text(
                                    StaticData.favouriteSalonsList[index].city.cityName
                                        .toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontFamily: 'Quicksand',
                                      fontSize: MediaQuery.of(context).size.width > 768 ? 18 : 13,
                                      fontWeight: FontWeight.normal,
                                      color: ColorConstants.black,
                                    ),
                                  ),

                                  SizedBox(
                                    height: 10,
                                  ),

                                  Row(
                                    children: [
                                      RatingBar.builder(
                                        ignoreGestures: true,
                                        initialRating: double.parse(
                                            StaticData.favouriteSalonsList[index].ratings),
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemSize: MediaQuery.of(context).size.width > 768 ? 22 : 12,
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
                                      Text('(${double.parse(StaticData.favouriteSalonsList[index].ratings).toStringAsFixed(1)})',
                                      style: TextStyle(fontSize: MediaQuery.of(context).size.width > 768 ? 14 : 11,)),
                                    ],
                                  ),


                                ],
                              ),
                            ),

                            SizedBox(
                              width: 8,
                            ),

                            //book button
                            Expanded(
                              flex: 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  InkWell(
                                    onTap: () {

                                      //navigate to salon details screen
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SalonDetailsScreen(StaticData.favouriteSalonsList[index]),
                                        ),
                                      );


                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.red[500],
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(4))
                                      ),
                                      child: Center(child: Text(Languages.of(context).bookButtonText, style: TextStyle(color: ColorConstants.redColor))),
                                    ),
                                  ),

                                  SizedBox(
                                    height: 4.0,
                                  ),

                                  InkWell(
                                    onTap: () {

                                      //remove from favourites
                                      StaticData.favouriteSalonsList.removeAt(index);

                                      //remove favourite product from shared preferences
                                      SharedPref.saveFavSalonsList(
                                          AppConstants.prefFavSalonsList,
                                          StaticData.favouriteSalonsList);

                                      setState(() {

                                      });

                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(4),
                                      child: Center(child: Icon(Icons.delete, color: ColorConstants.redColor, size: MediaQuery.of(context).size.width > 768 ? 40 : 24)),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                          ],
                        ),
                      );
                    }),
              ),
            ),


          ),
        ),
      ),
    );
  }






}
