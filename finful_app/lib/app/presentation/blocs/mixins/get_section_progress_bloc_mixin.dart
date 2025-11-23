
import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/presentation/blocs/get_section_progress/get_section_progress.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';

mixin GetSectionProgressMixin {
  GetSectionProgressState get getSectionProgressState {
    return BlocManager().blocFromKey<GetSectionProgressBloc>(
        BlocConstants.getSectionProgress)!.state;
  }
}