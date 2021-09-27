import 'package:beauty_saloon/localization/language/languages.dart';

class LanguageEn extends Languages {

  @override
  String get appName => "Multi-languages";

  @override
  String get labelWelcome => "Welcome";

  @override
  //String get labelSelectLanguage => "Select Language";
  String get labelSelectLanguage => welcomeLabelSelectLanguageValue;



  @override
  void setLanguageValue(String selectedLanguage) {
    welcomeLabelSelectLanguageValue = selectedLanguage;
  }

  @override
  String get getSelectedLanguageValue => welcomeLabelSelectLanguageValue;

  @override
  String get labelInfo => "This is multi-languages demo application";

  //welcome screen
  String welcomeLabelSelectCountryValue = 'Select Country';
  String welcomeLabelSelectCityValue = 'Select City';
  String welcomeLabelSelectLanguageValue = 'Select Language';

  final List<String> countriesDropdownValues = [
    "Saudi Arabia",
  ];

  final List<String> citiesDropdownValues = [
    "Al Khobar",
    "Dammam",
    "Al Qatif - Sihat"
  ];



  @override
  String get welcomeScreenTitle => "Welcome";

  @override
  String get welcomeButtonTitle => "Get Started";

  @override
  String get welcomeInfo1 => "Be Ready to Discover all Salons, Spa and Beauty Centers in your city.";

  @override
  String get welcomeInfo2 => "Book the required service and Pay easily using our online payment method.";

  @override
  String get welcomeCheckboxText => "Do not show again";







  //country
  @override
  List<String> getCountriesDropdownList() {
    return countriesDropdownValues;
  }

  @override
  void setCountryValue(String selectedCountry) {
    welcomeLabelSelectCountryValue = selectedCountry;
  }

  @override
  String get getSelectedCountryValue => selectedCountryValue;

  @override
  String get welcomeLabelSelectCountry => welcomeLabelSelectCountryValue;



  //city
  @override
  List<String> getCitiesDropdownList() {
    return citiesDropdownValues;
  }

  @override
  void setCityValue(String selectedCityValue) {
    welcomeLabelSelectCityValue = selectedCityValue;
  }

  @override
  void resetCityValue() {
    welcomeLabelSelectCityValue = 'Select City';
  }

  @override
  String get getSelectedCityValue => selectedCityValue;

  @override
  String get welcomeLabelSelectCity => welcomeLabelSelectCityValue;


  String get selectLanguageErrorMessage => 'Please select language';
  String get selectCountryErrorMessage => 'Please select country';
  String get selectCityErrorMessage => 'Please select city';





  //service type screen
  String get serviceTypeScreenTitle => 'Service Type';

  String get serviceTypeHeading => 'Please select type of service';

  String get radioSalonServiceType => 'Salon';

  String get radioHomeServiceType => 'Home';

  String get serviceTypeContinueButtonText => 'Continue';


  //home screen
  @override
  String get homeScreenTitle => 'Beauty Centers';



  //navigation drawer
  @override
  String get navBarBeautyNews => 'Home';

  @override
  String get navBarAbout => 'About Sami';

  @override
  String get navBarSettings => 'Settings';

  @override
  String get navBarShare => 'Share';

  @override
  String get navBarRateApp => 'Rate the App';



  @override
  String get navBarLoginAsPartener => 'Login As A Partener'.toUpperCase();

  @override
  String get navBarLoginSignUp => 'Login / Signup'.toUpperCase();

  @override
  String get navBarLogoutButtonText => 'Logout'.toUpperCase();




  //bottom navigation bar
  @override
  String get bottomNavHome => 'Home';

  @override
  String get bottomNavAppointments => 'Appointments';

  @override
  String get bottomNavFavourites => 'Favourites';

  @override
  String get bottomNavNotifications => 'Notifications';

  @override
  String get bottomNavAccount => 'Account';


  //home page
  String selectedAreaValue = 'Select Area';
  String get labelSelectArea => 'Select Area';

  @override
  void setAreaValue(String selectedArea) {
    selectedAreaValue = selectedArea;
  }

  @override
  String get getSelectedAreaValue => selectedAreaValue;

  String get labelAllSalons => 'All Salons';

  String get labelAllCategories => 'All Categories';


  List<String> allAreasList = [
    'All Areas',
    'Al Mazuiyah',
    'Taybah',
    'Al Itisalat',
    'Uhud - 71',
    'AN NADA',
    'AS SAFA',
    'Al Tubayshi',
    'Al-Hamra\'a',
  ];


  @override
  List<String> getAreasList() {
    return allAreasList;
  }



  //sign in
  String get labelSignIn => 'Sign In';

  String get buttonLabelSignIn => 'Sign In';

  String get buttonLabelCreateAccountIn => 'Create Account';

  String get lableRememberMeCheckbox => 'Remember Me';

  String get lableForgotPasswordButton => 'Forgot Password';

  String get hintPassword => 'Password';

  String get hintEmailMobileNo => 'Mobile (e.g. +9665xxxxxxx)';


  //forgot password
  String get labelForgotPassword => 'Forgot Password';

  String get buttonLabelSubmit => 'Submit';


  //settings screen
  String get labelSettingsScreen => 'Settings';

  String get settingsScreenSelectLanguage => 'Select Language';

  String get lablePushNotification => 'Push Notifications';

  String get emailCustomerService => 'Email Customer Service';

  String get feedbackAndSupport => 'For feedback and support contact.';



  //sign up
  String get createAccountTitle => 'Create Account';
  String get uploadAnAvatar => 'upload an avatar';
  String get firstNameHint => 'First Name';
  String get lastNameHint => 'Last Name';
  String get emailHint => 'Email';
  String get pleaseSelectDOB => 'Please select date of birth';
  String get pleaseSelectGender => 'Please select gender';
  String get pleaseSelectCountry => 'Please select country';
  String get pleaseSelectCity => 'Please select city';
  String get pleaseFirstSelectCountry => 'Please first select country';
  String get phoneNoEmpty => 'Phone number empty';
  String get createAnAccountButtonText => 'Create an account';
  String get pleaseSelectImage => 'Please select image !';
  String get selectGender => 'Select Gender';
  String get selectCountry => 'Select Country';
  String get selectCity => 'Select City';
  String get photoLibraryImagePickerText => 'Photo Library';
  String get cameraImagePickerText => 'Camera';
  String get firstNameEmptyText => 'First Name empty';
  String get firstNameShortText => 'First Name short';
  String get lastNameEmptyText => 'Last Name empty';
  String get lastNameShortText => 'Last Name short';
  String get emailEmptyText => 'Email empty';
  String get invalidEmailText => 'Invalid email';
  String get countryCodeEmptyText => 'CC empty';
  String get phoneNoEmptyText => 'Phone number empty';
  String get codeText => 'code';
  String get currentDateValue => 'Birthday';
  String get genderValue => 'Gender';
  String get countryValue => 'Country';
  String get cityValue => 'City';




  //otp screen
  String get otpScreenTitle => 'One Time Password Screen';

  String get buttonLabelOTPSubmit => 'Submit';




  //filter screen
  String get lableFilterScreen => 'Filter';

  String get countriesListTitle => 'Country';

  String get citiesListTitle => 'City';

  String get selectServicesTitle => 'Service Type';

  String get promotionTypeTitle => 'Promotion Type';

  String get priceTitle => 'Price';

  String get sortByTitle => 'Sort By';

  String get clearFilterButtonText => 'Clear Filter';

  String get filterButtonText => 'Filter';



  //notifications page

  String get notificationsScreenTitle => 'Notifications';



  //appointments page

  String get appointmentsScreenTitle => 'Appointments';

  String get upcomingTabTitle => 'Upcoming';
  String get completedTabTitle => 'Completed';
  String get canceledTabTitle => 'Canceled';

  //favourites page

  String get favouriteScreenTitle => 'Favourites';
  String get bookButtonText => 'Book';

  //account page
  String get accountScreenTitle => 'Account';


  //search screen
  String get searchBarHintText => 'what are you looking for';

  String get searchedSalonsText => 'Searched Salons';

  String get noSearchResultsText => 'No Salons found !';

  //upcoming appointments tab
  String get totalPriceUpcoming => 'Total';
  String get statusUpcoming => 'Status';
  String get serviceTypeUpcoming => 'Service Type';
  String get cancelBookingUpcoming => 'Cancel Booking';

  //completed appointments tab
  String get totalPriceCompleted => 'Total';
  String get serviceTypeCompleted => 'Service Type';
  String get completedText => 'Completed';

  //cancelled appointments tab
  String get totalPriceCancelled => 'Total';
  String get serviceTypeCancelled => 'Service Type';
  String get cancelledText => 'Completed';

  //profile page
  String get nameFieldHeadingProfile => 'Name';
  String get dobFieldHeadingProfile => 'Date of Birth';
  String get genderHeadingProfile => 'Gender';
  String get countryHeadingProfile => 'Country';
  String get cityHeadingProfile => 'City';


  //edit profile
  String get editNameField => 'Edit Name';
  String get editDobFieldHeading => 'Edit Date of Birth';
  String get editGenderHeading => 'Gender';
  String get editCountryHeading => 'Edit Country';
  String get editCityHeading => 'Edit City';

  String get nameFieldError => 'Please enter your name';
  String get dobError => 'Please select date';
  String get genderError => 'Please select gender';
  String get countryError => 'Please select country';
  String get cityError => 'Please select city';

  String get uploadProfileButtonText => 'Update Profile';

  String get nameHintTextEditProfile => 'Name';


  //salon details screen
  String get salonDetailsTotal => 'Total';
  String get bookServiceButtonText => 'Book Service';

  String get servicesTabText => 'SERVICES';
  String get gallterTabText => 'GALLERY';
  String get aboutTabText => 'ABOUT';
  String get reviewTabText => 'REVIEW';
  String get noCategoriesText => 'No categories available';
  String get noServicesText => 'No services available';

  //gallery tab
  String get noGalleryImages => 'No images available';

  //about tab
  String get noDetails => 'No details available';
  String get aboutHeadingText => 'About';
  String get noDescriptionText => 'No description available';
  String get serviceOnDaysText => 'Service on Days';
  String get contactInfoText => 'Contact Information';
  String get callText => 'Call';

  //reviews tab
  String get reviewHeadingText => 'Review';
  String get totalReviewText => 'Total Reviews';
  String get addReviewButtonText => 'Add Review';
  String get noReviewText => 'No reviews available';

  //add review bottom sheet
  String get shareYourExperienceHeading => 'Share Your Experience';
  String get howManyStarts => 'How Many Stars You Will Give';
  String get shareReviewButtonText => 'Share Review';
  String get reviewErrorMessage => 'Please write a review !';
  String get reviewFieldText => 'Add your review here ...';

  //calendar screen
  String get chooseTime => 'Choose Time';
  String get salonIsClosed => 'Salon is closed.';


  //summary screen
  String get summaryHeadingText => 'Summary';
  String get salonNameSummary => 'Salon Name';
  String get countrySummary => 'Country';
  String get citySummary => 'City';
  String get servicesSummary => 'Services';
  String get dateSummary => 'Date';
  String get timeSummary => 'Time';
  String get addressSummary => 'Address';
  String get homeServiceChargesSummary => 'Home Service\nCharges';
  String get totalServiceChargesSummary => 'Total Service\nCharges';
  String get reservationChargesSummary => 'Reservation\nCharges';
  String get deductionNoteSummary => ' We will deduct only reservation charges';
  String get payWithCardButtonText => 'Pay with Card';
  String get applePayButtonText => 'Apple Pay';










  String get locationText => 'Location';
  String get navigateToLocation => 'Navigate to Location';

  String get noSalonAvailableText => 'No Salons available !';
  String get noCategoriesAvailableText => 'No Categories available !';
  String get userNotLoggedInText => 'User not logged in';
  String get pleaseLoginText => 'Please login';
  String get signInButtonText => 'Sign In';
  String get noFavoriteSalonsText => 'No Favourite Salons !';
  String get noUpcomingAppointmentsText => 'No Upcoming Appointments';
  String get noCompletedAppointmentsText => 'No Completed Appointments';
  String get noCanceledAppointmentsText => 'No Canceled Appointments';
  String get welcomeHeaderText => 'Welcome';

  String get selectCountryInFilter => 'Select Country';
  String get selectCityInFilter => 'Select City';
  String get selectServiceTypeInFilter => 'Select Service Type';

}