import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:flutter/material.dart';


class CountryDropDown extends StatefulWidget {

  @override
  _CountryDropDownState createState() => _CountryDropDownState();
}

class _CountryDropDownState extends State<CountryDropDown> {

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
            .welcomeLabelSelectCountry),
        items: Languages
            .of(context)
            .countriesDropdownValues
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
              .setCountryValue(value);

          setState(() {

            Languages
                .of(context)
                .welcomeLabelSelectCountry;
          });

        },
        isExpanded: true,
        //value: selectedCountryValue,
        value: Languages
            .of(context).getSelectedCountryValue,
      ),
    );
  }
}
