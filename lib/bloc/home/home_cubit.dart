import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_todo/bloc/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void setTab(HomeTab tab) => emit(HomeState(tab: tab));
}