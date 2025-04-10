import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'component_state.dart';

class ComponentCubit extends Cubit<ComponentState> {
  ComponentCubit() : super(ComponentInitial());
}
