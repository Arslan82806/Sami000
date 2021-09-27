import 'package:beauty_saloon/model/categories_model.dart';
import 'package:equatable/equatable.dart';

abstract class AllCategoriesState extends Equatable {
  const AllCategoriesState();
}

class AllCategoriesInitial extends AllCategoriesState {
  AllCategoriesInitial();

  @override
  List<Object> get props => [];
}

class AllCategoriesLoading extends AllCategoriesState {
  const AllCategoriesLoading();
  @override
  List<Object> get props => null;
}

class AllCategoriesLoaded extends AllCategoriesState {

  final CategoriesModel categoriesModel;
  const AllCategoriesLoaded(this.categoriesModel);

  @override
  List<Object> get props => [categoriesModel];
}

class AllCategoriesError extends AllCategoriesState {

  final String message;
  const AllCategoriesError(this.message);

  @override
  List<Object> get props => [message];
}

