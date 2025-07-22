import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/res/svgs.dart';
import '../../../core/routes/router.dart';
import '../../../core/routes/routes.dart';

class BottomNavModel {
  final String name;
  final String image;

  BottomNavModel({required this.name, required this.image});
}

class BottomNavLayoutCubit extends Cubit<int> {
  BottomNavLayoutCubit() : super(0);

  List<BottomNavModel> list = [
    BottomNavModel(name: "Home", image: Svgs.home),
    BottomNavModel(name: "History", image: Svgs.home),
    BottomNavModel(name: "Settings", image: Svgs.profile),
  ];

  void goHome(){
    onTap(0);
  }

  void moveToNext() {
    if (state < list.length - 1) {
      emit(state + 1);
    }
  }

  void moveToPrevious() {
    if (state > 0) {
      emit(state - 1);
    }
  }

  void onTap(int index) {
    switch (index) {
      case 0:
        router.go(Paths.HOME);
        break;
      case 1:
        router.go(Paths.HISTORY);
        break;
        case 2:
        router.go(Paths.PROFILE);
        break;
      default:
        router.go(Paths.HOME);
        break;
    }
    if (index >= 0 && index < list.length) {
      emit(index);
    }
  }
}
