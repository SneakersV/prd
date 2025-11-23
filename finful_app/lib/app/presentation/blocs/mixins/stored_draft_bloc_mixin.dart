import 'package:finful_app/app/constants/key/BlocConstants.dart';
import 'package:finful_app/app/presentation/blocs/stored_draft/stored_draft.dart';
import 'package:finful_app/core/bloc/base/bloc_manager.dart';

mixin StoredDraftBlocMixin {
  StoredDraftState get getStoredDraftState {
    return BlocManager().blocFromKey<StoredDraftBloc>(
        BlocConstants.storedDraft)!.state;
  }
}