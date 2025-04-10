import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'saved_address_cubit_state.dart';

class SavedAddressCubitCubit extends Cubit<SavedAddressCubitState> {
  SavedAddressCubitCubit() : super(SavedAddressCubitInitial());
}
