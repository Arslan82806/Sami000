import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:flutter/material.dart';

class CityDropDown extends StatefulWidget {
  @override
  _CityDropDownState createState() => _CityDropDownState();
}

class _CityDropDownState extends State<CityDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
            color: Colors.black,
            style: BorderStyle.solid,
            width: 0.80),
      ),
      child: DropdownButton(
        underline: SizedBox(),
        icon: Icon(Icons.keyboard_arrow_down_outlined),
        iconSize: 30,
        hint: Text(Languages
            .of(context)
            .welcomeLabelSelectCity),

        items: Languages
            .of(context)
            .citiesDropdownValues
            .map<DropdownMenuItem<String>>(
              (e) =>
              DropdownMenuItem<String>(
                value: e,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(e)
                  ],
                ),
              ),
        )
            .toList(),
        onChanged: (String value) {

          Languages
              .of(context)
              .setCityValue(value);

          setState(() {

            Languages
                .of(context)
                .welcomeLabelSelectCity;
          });
        },
        isExpanded: true,
        value: Languages
            .of(context).getSelectedCityValue,
      ),
    );
  }
}
