import 'package:flutter/material.dart';

abstract class Languages {

  static Languages of(BuildContext context) {
    return Localizations.of<Languages>(context, Languages);
  }

  String get appName;

  String get labelWelcome;

  String get labelInfo;



  //welcome screen
  String get welcomeScreenTitle;


  String get welcomeLabelSelectCity;

  String selectedCountryValue;
  String selectedCityValue;


  String get getSelectedLanguageValue;

  String get getSelectedCountryValue;
  String get getSelectedCityValue;

  String get labelSelectLanguage;
  String get welcomeLabelSelectCountry;

  String get welcomeButtonTitle;
  String get welcomeInfo1;
  String get welcomeInfo2;
  String get welcomeCheckboxText;

  List<String> getCountriesDropdownList();

  void setLanguageValue(String selectedLanguageValue);
  void setCountryValue(String selectedCountryValue);

  void setCityValue(String selectedCityValue);
  void resetCityValue();

  final List<String> countriesDropdownValues = [];
  final List<String> citiesDropdownValues = [];

  String get selectLanguageErrorMessage;
  String get selectCountryErrorMessage;
  String get selectCityErrorMessage;


  //service type screen
  String get serviceTypeScreenTitle;

  String get serviceTypeHeading;

  String get radioSalonServiceType;

  String get radioHomeServiceType;

  String get serviceTypeContinueButtonText;


  //home screen
  String get homeScreenTitle;

  //navigation drawer
  String get navBarBeautyNews;
  String get navBarAbout;
  String get navBarSettings;
  String get navBarShare;
  String get navBarRateApp;

  String get navBarLoginSignUp;
  String get navBarLogoutButtonText;
  String get navBarLoginAsPartener;

  //bottom navigation bar
  String get bottomNavHome;
  String get bottomNavAppointments;
  String get bottomNavFavourites;
  String get bottomNavNotifications;
  String get bottomNavAccount;

  //home page
  String selectedAreaValue;

  void setAreaValue(String selectedArea);
  String get getSelectedAreaValue;

  final List<String> allAreasList = [];

  String get labelSelectArea;

  List<String> getAreasList();

  String get labelAllSalons;

  String get labelAllCategories;


  //sign in
  String get labelSignIn;

  String get buttonLabelSignIn;

  String get buttonLabelCreateAccountIn;

  String get lableRememberMeCheckbox;

  String get lableForgotPasswordButton;

  String get hintPassword;

  String get hintEmailMobileNo;


  //forgot password screen
  String get labelForgotPassword;

  String get buttonLabelSubmit;

  //settings screen

  String get labelSettingsScreen;

  String get settingsScreenSelectLanguage;

  String get lablePushNotification;

  String get emailCustomerService;

  String get feedbackAndSupport;


  //sign up screen
  String get createAccountTitle;
  String get uploadAnAvatar;
  String get firstNameHint;
  String get lastNameHint;
  String get emailHint;
  String get pleaseSelectDOB;
  String get pleaseSelectGender;
  String get pleaseSelectCountry;
  String get pleaseSelectCity;
  String get pleaseFirstSelectCountry;
  String get phoneNoEmpty;
  String get createAnAccountButtonText;
  String get pleaseSelectImage;
  String get selectGender;
  String get selectCountry;
  String get selectCity;
  String get photoLibraryImagePickerText;
  String get cameraImagePickerText;
  String get firstNameEmptyText;
  String get firstNameShortText;
  String get lastNameEmptyText;
  String get lastNameShortText;
  String get emailEmptyText;
  String get invalidEmailText;
  String get countryCodeEmptyText;
  String get phoneNoEmptyText;
  String get codeText;
  String get currentDateValue;
  String get genderValue;
  String get countryValue;
  String get cityValue;


  //filter screen
  String get lableFilterScreen;

  String get countriesListTitle;

  String get citiesListTitle;

  String get selectServicesTitle;

  String get promotionTypeTitle;

  String get priceTitle;

  String get sortByTitle;

  String get clearFilterButtonText;

  String get filterButtonText;




  //otp screen

  String get otpScreenTitle;

  String get buttonLabelOTPSubmit;






  //notifications page

  String get notificationsScreenTitle;


  //appointments page

  String get appointmentsScreenTitle;

  String get upcomingTabTitle;
  String get completedTabTitle;
  String get canceledTabTitle;


  //favourites page

  String get favouriteScreenTitle;

  //account page
  String get accountScreenTitle;

  String get bookButtonText;




  //search screen
  String get searchBarHintText;
  String get searchedSalonsText;
  String get noSearchResultsText;


  //upcoming appointments tab
  String get totalPriceUpcoming;
  String get statusUpcoming;
  String get serviceTypeUpcoming;
  String get cancelBookingUpcoming;

  //completed appointments tab
  String get totalPriceCompleted;
  String get serviceTypeCompleted;
  String get completedText;

  //cancelled appointments tab
  String get totalPriceCancelled;
  String get serviceTypeCancelled;
  String get cancelledText;


  //profile page
  String get nameFieldHeadingProfile;
  String get dobFieldHeadingProfile;
  String get genderHeadingProfile;
  String get countryHeadingProfile;
  String get cityHeadingProfile;


  //edit profile
  String get editNameField;
  String get editDobFieldHeading;
  String get editGenderHeading;
  String get editCountryHeading;
  String get editCityHeading;

  String get nameFieldError;
  String get dobError;
  String get genderError;
  String get countryError;
  String get cityError;

  String get uploadProfileButtonText;

  String get nameHintTextEditProfile;


  //salon details screen
  String get salonDetailsTotal;
  String get bookServiceButtonText;

  String get servicesTabText;
  String get gallterTabText;
  String get aboutTabText;
  String get reviewTabText;
  String get noCategoriesText;
  String get noServicesText;

  //gallery tab
  String get noGalleryImages;

  //about tab
  String get noDetails;
  String get aboutHeadingText;
  String get noDescriptionText;
  String get serviceOnDaysText;
  String get contactInfoText;
  String get callText;
  String get locationText;
  String get navigateToLocation;

  //reviews tab
  String get reviewHeadingText;
  String get totalReviewText;
  String get addReviewButtonText;
  String get noReviewText;



  //add review bottom sheet
  String get shareYourExperienceHeading;
  String get howManyStarts;
  String get shareReviewButtonText;
  String get reviewErrorMessage;
  String get reviewFieldText;


  //calendar screen
  String get chooseTime;
  String get salonIsClosed;


  //summary screen
  String get summaryHeadingText;
  String get salonNameSummary;
  String get countrySummary;
  String get citySummary;
  String get servicesSummary;
  String get dateSummary;
  String get timeSummary;
  String get addressSummary;
  String get homeServiceChargesSummary;
  String get totalServiceChargesSummary;
  String get reservationChargesSummary;
  String get deductionNoteSummary;
  String get payWithCardButtonText;
  String get applePayButtonText;


  String get noSalonAvailableText;
  String get noCategoriesAvailableText;
  String get userNotLoggedInText;
  String get pleaseLoginText;
  String get signInButtonText;
  String get noFavoriteSalonsText;
  String get noUpcomingAppointmentsText;
  String get noCompletedAppointmentsText;
  String get noCanceledAppointmentsText;
  String get welcomeHeaderText;

  String get selectCountryInFilter;
  String get selectCityInFilter;
  String get selectServiceTypeInFilter;





}