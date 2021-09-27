import 'package:equatable/equatable.dart';

abstract class CategorySalonEvent extends Equatable {
  CategorySalonEvent();
}

class GetCategorySalons extends CategorySalonEvent {

  final String categoryId;
  final String countryId;
  final String cityId;

  GetCategorySalons(this.categoryId, this.countryId, this.cityId);

  @override
  List<Object> get props => null;

}