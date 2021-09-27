import 'package:beauty_saloon/localization/language/languages.dart';

class LanguageAr extends Languages {

  @override
  String get appName => "متعدد اللغات";

  @override
  String get labelWelcome => "مرحبا";

  @override
  //String get labelSelectLanguage => "اختيار اللغة";
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
  String welcomeLabelSelectCountryValue = 'اختيار المنطقة';
  String welcomeLabelSelectCityValue = 'خيار المدينة';
  String welcomeLabelSelectLanguageValue = 'اختيار اللغة';

  final List<String> countriesDropdownValues = [
    "Saudi Arabia",
  ];

  final List<String> citiesDropdownValues = [
    "Al Khobar",
    "Dammam",
    "Al Qatif - Sihat"
  ];



  @override
  String get welcomeScreenTitle => "مرحبا";

  @override
  String get welcomeButtonTitle => "استمرار";

  @override
  String get welcomeInfo1 => "اكتشاف جميع الصالونات و الخدمات في المنطقة";

  @override
  String get welcomeInfo2 => "احجز الخدمة و ادفع بطرق الكترونية";

  @override
  String get welcomeCheckboxText => "لا تظهر مرة اخرى";







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
    welcomeLabelSelectCityValue = 'خيار المدينة';
  }

  @override
  String get getSelectedCityValue => selectedCityValue;

  @override
  String get welcomeLabelSelectCity => welcomeLabelSelectCityValue;


  String get selectLanguageErrorMessage => 'اختيار اللغة';
  String get selectCountryErrorMessage => 'اختيار المنطقة';
  String get selectCityErrorMessage => 'خيار المدينة';





  //service type screen
  String get serviceTypeScreenTitle => 'تصنيف الخدمة';

  String get serviceTypeHeading => 'اختيار الخدمة';

  String get radioSalonServiceType => 'الصالون';

  String get radioHomeServiceType => 'الرئيسية';

  String get serviceTypeContinueButtonText => 'استمرار';


  //home screen
  @override
  String get homeScreenTitle => 'مركز الصالونات';



  //navigation drawer
  @override
  String get navBarBeautyNews => 'الرئيسية';

  @override
  String get navBarAbout => 'عن سامي';

  @override
  String get navBarSettings => 'اعدادات ';

  @override
  String get navBarShare => 'مشاركة';

  @override
  String get navBarRateApp => 'تقيم التطبيق';



  @override
  String get navBarLoginAsPartener => 'Login As A Partener'.toUpperCase();

  @override
  String get navBarLoginSignUp => 'تسجيل / جديد'.toUpperCase();

  @override
  String get navBarLogoutButtonText => 'تسجيل خروج'.toUpperCase();




  //bottom navigation bar
  @override
  String get bottomNavHome => 'الرئيسية';

  @override
  String get bottomNavAppointments => 'المواعيد';

  @override
  String get bottomNavFavourites => 'المفضلة';

  @override
  String get bottomNavNotifications => 'الأشعارات';

  @override
  String get bottomNavAccount => 'الحساب';


  //home page
  String selectedAreaValue = 'اختيار الموقع';
  String get labelSelectArea => 'اختيار الموقع';

  @override
  void setAreaValue(String selectedArea) {
    selectedAreaValue = selectedArea;
  }

  @override
  String get getSelectedAreaValue => selectedAreaValue;

  String get labelAllSalons => 'جميع الصالونات';

  String get labelAllCategories => 'جميع التصنيفات';


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
  String get labelSignIn => 'تسجيل الدخول';

  String get buttonLabelSignIn => 'تسجيل الدخول';

  String get buttonLabelCreateAccountIn => 'عمل حساب جديد';

  String get lableRememberMeCheckbox => 'تذكرني';

  String get lableForgotPasswordButton => 'نسيت كلمة المرور';

  String get hintPassword => 'كلمة المرور';

  String get hintEmailMobileNo => 'الهاتف (٩٦٦+)';


  //forgot password
  String get labelForgotPassword => 'نسيت كلمة المرور';

  String get buttonLabelSubmit => 'ارسال';


  //settings screen
  String get labelSettingsScreen => 'اعدادات';

  String get settingsScreenSelectLanguage => 'اختيار اللغة';

  String get lablePushNotification => 'ارسال تنبيهات';

  String get emailCustomerService => 'ايميل الدعم الفني';

  String get feedbackAndSupport => 'للدعم الفني و الشكاوي تواصل عبر';



  //sign up
  String get createAccountTitle => 'إنشاء حساب';
  String get uploadAnAvatar => 'تحميل الصورة الرمزية';
  String get firstNameHint => 'الاسم الأول';
  String get lastNameHint => 'الكنية';
  String get emailHint => 'بريد إلكتروني';
  String get pleaseSelectDOB => 'الرجاء تحديد تاريخ الميلاد';
  String get pleaseSelectGender => 'يرجى تحديد الجنس';
  String get pleaseSelectCountry => 'الرجاء تحديد الدولة';
  String get pleaseSelectCity => 'الرجاء تحديد المدينة';
  String get pleaseFirstSelectCountry => 'الرجاء تحديد الدولة أولا';
  String get phoneNoEmpty => 'رقم الهاتف فارغ';
  String get createAnAccountButtonText => 'إنشاء حساب';
  String get pleaseSelectImage => 'الرجاء تحديد الصورة!';
  String get selectGender => 'حدد نوع الجنس';
  String get selectCountry => 'حدد الدولة';
  String get selectCity => 'اختر مدينة';
  String get photoLibraryImagePickerText => 'مكتبة الصور';
  String get cameraImagePickerText => 'آلة تصوير';
  String get firstNameEmptyText => 'الاسم الاول فارغ';
  String get firstNameShortText => 'الاسم الأول قصير';
  String get lastNameEmptyText => 'الاسم الاخير فارغ';
  String get lastNameShortText => 'الاسم الاخير قصير';
  String get emailEmptyText => 'البريد الإلكتروني فارغ';
  String get invalidEmailText => 'بريد إلكتروني خاطئ';
  String get countryCodeEmptyText => 'رمز الدولة فارغ';
  String get phoneNoEmptyText => 'رقم الهاتف فارغ';
  String get codeText => 'الشفرة';
  String get currentDateValue => 'عيد ميلاد';
  String get genderValue => 'جنس';
  String get countryValue => 'دولة';
  String get cityValue => 'مدينة';





  //otp screen
  String get otpScreenTitle => 'كلمة مرور مرة واحدة';

  String get buttonLabelOTPSubmit => 'ارسال';




  //filter screen
  String get lableFilterScreen => 'تصنيف';

  String get countriesListTitle => 'المدينة';

  String get citiesListTitle => 'المنطقة';

  String get selectServicesTitle => 'تصنيف الخدمة';

  String get promotionTypeTitle => 'صنف الترويج';

  String get priceTitle => 'الأسعار';

  String get sortByTitle => 'مختصر التصنيف';

  String get clearFilterButtonText => 'مسح التصنيفات';

  String get filterButtonText => 'تصنيف';



  //notifications page

  String get notificationsScreenTitle => 'الأشعارات';



  //appointments page

  String get appointmentsScreenTitle => 'المواعيد';

  String get upcomingTabTitle => 'قادم';
  String get completedTabTitle => 'تم الأكتمال';
  String get canceledTabTitle => 'ملغي';

  //favourites page

  String get favouriteScreenTitle => 'المفضلة';
  String get bookButtonText => 'منصة حجوزات';

  //account page
  String get accountScreenTitle => 'الحساب';


  //search screen
  String get searchBarHintText => 'ماذا تبحث عنه؟';

  String get searchedSalonsText => 'بحث عن صالون';

  String get noSearchResultsText => 'لا يوجد صالون متاح';

  //upcoming appointments tab
  String get totalPriceUpcoming => 'المجموع';
  String get statusUpcoming => 'الحالة';
  String get serviceTypeUpcoming => 'تصنيف الخدمة';
  String get cancelBookingUpcoming => 'الغاء الحجز';

  //completed appointments tab
  String get totalPriceCompleted => 'المجموع';
  String get serviceTypeCompleted => 'تصنيف الخدمة';
  String get completedText => 'تمت المعالجة';

  //cancelled appointments tab
  String get totalPriceCancelled => 'المجموع';
  String get serviceTypeCancelled => 'تصنيف الخدمة';
  String get cancelledText => 'تمت المعالجة';

  //profile page
  String get nameFieldHeadingProfile => 'الاسم';
  String get dobFieldHeadingProfile => 'تاريخ الميلاد';
  String get genderHeadingProfile => 'الجنس';
  String get countryHeadingProfile => 'المدينة';
  String get cityHeadingProfile => 'المنطقة';


  //edit profile
  String get editNameField => 'تغير الاسم';
  String get editDobFieldHeading => 'تحرير تاريخ الميلاد';
  String get editGenderHeading => 'الجنس';
  String get editCountryHeading => 'حرير المنطقة';
  String get editCityHeading => 'تحرير المدينة';

  String get nameFieldError => 'ادخل بينات اسمك';
  String get dobError => 'اختيار الموعد';
  String get genderError => 'اختيار الجنس';
  String get countryError => 'اختيار المنطقة';
  String get cityError => 'خيار المدينة';

  String get uploadProfileButtonText => 'تحديث الحساب';

  String get nameHintTextEditProfile => 'الاسم';


  //salon details screen
  String get salonDetailsTotal => 'الحجز';
  String get bookServiceButtonText => 'خدمات الحجز';

  String get servicesTabText => 'خدماتنا';
  String get gallterTabText => 'الصور';
  String get aboutTabText => 'عننا';
  String get reviewTabText => 'التقيمات';
  String get noCategoriesText => 'لا يوجد خصائص متاحا';
  String get noServicesText => 'لا يوجد خدمات متاحا';

  //gallery tab
  String get noGalleryImages => 'لا يوجد صورة متاحا';

  //about tab
  String get noDetails => 'لا يوجد محتوى.';
  String get aboutHeadingText => 'معرفة المزيد';
  String get noDescriptionText => 'لا يوجد محتوى متوفر';
  String get serviceOnDaysText => 'خدمات بالأيام';
  String get contactInfoText => 'معلومات التواصل';
  String get callText => 'الأتصال';

  //reviews tab
  String get reviewHeadingText => 'الآراء';
  String get totalReviewText => 'مجموع الآراء';
  String get addReviewButtonText => 'إضافة رأي';
  String get noReviewText => 'لا يوجد رأي متاح.';

  //add review bottom sheet
  String get shareYourExperienceHeading => 'مشاركة تجربتك';
  String get howManyStarts => 'عدد النجمات';
  String get shareReviewButtonText => 'مشاركة الرأي';
  String get reviewErrorMessage => 'كتابة تعليق';
  String get reviewFieldText => 'إضافة رأي';

  //calendar screen
  String get chooseTime => 'اختيار الساعة';
  String get salonIsClosed => 'الصالون مقفل';


  //summary screen
  String get summaryHeadingText => 'نبذة';
  String get salonNameSummary => 'أسم الصالون';
  String get countrySummary => 'المدينة';
  String get citySummary => 'المنطقة';
  String get servicesSummary => 'الخدمات';
  String get dateSummary => 'التاريخ';
  String get timeSummary => 'الوقت';
  String get addressSummary => 'العنوان';
  String get homeServiceChargesSummary => 'رسوم خدمة المنزل';
  String get totalServiceChargesSummary => 'مجموع المبلغ';
  String get reservationChargesSummary => 'مبلغ الحجز';
  String get deductionNoteSummary => 'بيتم خصم عمولة الحجز فقط';
  String get payWithCardButtonText => 'الدفع بطاقة أتمانية';
  String get applePayButtonText => 'آبل باي';



  String get locationText => 'موقع';
  String get navigateToLocation => 'انتقل إلى الموقع';

  String get noSalonAvailableText => 'لا يوجد صالونات متاحة!';
  String get noCategoriesAvailableText => 'لا توجد فئات متاحة!';
  String get userNotLoggedInText => 'المستخدم لم يسجل الدخول';
  String get pleaseLoginText => 'الرجاء تسجيل الدخول';
  String get signInButtonText => 'جديد';
  String get noFavoriteSalonsText => 'لا توجد صالونات مفضلة!';
  String get noUpcomingAppointmentsText => 'لا توجد مواعيد قادمة';
  String get noCompletedAppointmentsText => 'لا توجد مواعيد مكتملة';
  String get noCanceledAppointmentsText => 'لا توجد مواعيد ملغاة';

  String get welcomeHeaderText => 'مرحبا';

  String get selectCountryInFilter => 'حدد الدولة';
  String get selectCityInFilter => 'اختر مدينة';
  String get selectServiceTypeInFilter => 'حدد نوع الخدمة';

}
