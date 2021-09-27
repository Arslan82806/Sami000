import 'package:equatable/equatable.dart';

abstract class AllCategoriesEvent extends Equatable {
  AllCategoriesEvent();
}

class GetAllCategories extends AllCategoriesEvent {

  @override
  List<Object> get props => null;

}