import 'dart:convert';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/search_response.dart';
import 'package:beauty_saloon/screens/salon_details/salon_details_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;

class SearchSalonScreen extends StatefulWidget {
  @override
  _SearchSalonScreenState createState() => _SearchSalonScreenState();
}

class _SearchSalonScreenState extends State<SearchSalonScreen> {

  TextEditingController _searchController = TextEditingController();

  SearchResponse searchResponse;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        automaticallyImplyLeading: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Expanded(
              child: TextField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: Languages.of(context).searchBarHintText,
                  hintStyle: TextStyle(color: Colors.white),

                ),
                onChanged: (value) {
                  onSearchQueryChange(value);
                },
              ),
            ),

            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {

              },
            ),



          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(Languages.of(context).searchedSalonsText, style: TextStyle(fontSize: 20,)),
              ),

              searchResponse != null ? GridView.builder(
                primary: false,
                shrinkWrap: true,
                itemCount: searchResponse.data.length,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width > 768 ? 3 : 2,
                    childAspectRatio: MediaQuery.of(context).size.width > 768 ? 0.8 : 0.7),
                itemBuilder: (BuildContext context, int index) {

                  if (checkIfSalonIsInFavList(searchResponse.data[index].id.toString())) {
                    searchResponse.data[index].isFavourite = true;
                  } else {
                    searchResponse.data[index].isFavourite = false;
                  }

                  return InkWell(
                    onTap: () {

                      //navigate to salon details screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => SalonDetailsScreen(searchResponse.data[index]),
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
                                    imageUrl: searchResponse.data[index].image,
                                    width: double.maxFinite,
                                    height: MediaQuery.of(context).size.width > 768 ? MediaQuery.of(context).size.height * 0.21 : 150,
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
                                                searchResponse.data[index].ratings),
                                            minRating: 1,
                                            direction: Axis.horizontal,
                                            allowHalfRating: true,
                                            itemCount: 5,
                                            itemSize: MediaQuery.of(context).size.width > 768 ? 22 : 14,
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
                                                '(${double.parse(searchResponse.data[index].ratings).toStringAsFixed(1)})',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: TextStyle(fontSize: MediaQuery.of(context).size.width > 768 ? 22 : 14)
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        searchResponse.data[index].salonName,
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
                                        searchResponse.data[index].city.cityName,
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
                          right: 0,
                          child: IconButton(
                            icon: Icon(
                              searchResponse.data[index].isFavourite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 30,
                            ),
                            color: ColorConstants.whiteColor,
                            onPressed: () {
                              if (checkIfSalonIsInFavList(
                                  searchResponse.data[index].id.toString())) {
                                //remove salon
                                removeFavouriteSalon(
                                    searchResponse.data[index].id.toString());

                                searchResponse.data[index].isFavourite = false;

                                SharedPref.saveFavSalonsList(
                                    AppConstants.prefFavSalonsList,
                                    StaticData.favouriteSalonsList);

                                setState(() {
                                  searchResponse.data[index].isFavourite = false;
                                });
                              } else {
                                //add salon
                                searchResponse.data[index].isFavourite = true;

                                StaticData.favouriteSalonsList
                                    .add(searchResponse.data[index]);

                                SharedPref.saveFavSalonsList(
                                    AppConstants.prefFavSalonsList,
                                    StaticData.favouriteSalonsList);

                                setState(() {
                                  searchResponse.data[index].isFavourite = true;
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ) : _emptySearchResult(),


            ],
          ),
        ),
      ),
    );
  }

  onSearchQueryChange(String query) async {

    print('search $query');
    String url = '${AppConstants.baseURL}/api/searchSalonByName';

    try {

      // make POST request
      var response = await http.post(
          url,
          headers: {
            "APP_KEY": AppConstants.APP_KEY,
          },
          body: {
            'search': query
          });


      int statusCode = response.statusCode;
      if(statusCode == 200) {

        String body = response.body;
        print('search response $body');

        setState(() {
          searchResponse = SearchResponse.fromJson(jsonDecode(response.body));
        });

      }//end if
      else  {
        print('something went wrong !');
      }


    }
    catch(e) {
      print(e);
    }

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

  Widget _emptySearchResult() {
    return Center(child: Text(Languages.of(context).noSearchResultsText, style: TextStyle(fontSize: 20,)));
  }


}
