import 'package:ecommerceapp/features/home/domain/usecases/get_home_data_usecase.dart';
import 'package:ecommerceapp/features/home/domain/entities/home_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetHomeDataUseCase getHomeDataUseCase;

  HomeCubit({
    required this.getHomeDataUseCase,
  }) : super(HomeInitial());

  Future<void> loadHomeData(String userId) async {
    emit(HomeLoading());

    try {
      final homeData = await getHomeDataUseCase.call(userId: userId);
      emit(HomeSuccess(homeData));
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }
}