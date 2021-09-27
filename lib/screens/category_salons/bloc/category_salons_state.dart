import 'package:beauty_saloon/model/category_salon_model.dart';
import 'package:equatable/equatable.dart';

abstract class CategorySalonState extends Equatable {
  const CategorySalonState();
}

class CategorySalonInitial extends CategorySalonState {
  CategorySalonInitial();

  @override
  List<Object> get props => [];
}

class CategorySalonLoading extends CategorySalonState {
  const CategorySalonLoading();
  @override
  List<Object> get props => null;
}

class CategorySalonLoaded extends CategorySalonState {

  final CategorySalonModel categorySalonModel;
  const CategorySalonLoaded(this.categorySalonModel);

  @override
  List<Object> get props => [categorySalonModel];
}

class CategorySalonError extends CategorySalonState {

  final String message;
  const CategorySalonError(this.message);

  @override
  List<Object> get props => [message];
}

