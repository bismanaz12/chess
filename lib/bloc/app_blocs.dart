import 'package:get_it/get_it.dart';
import 'package:newchess/bloc/cubits/game_cubit.dart';
import 'package:newchess/bloc/cubits/settings_cubit.dart';

createAppBlocs() {
  GetIt.I.registerSingleton<GameCubit>(GameCubit.initial());
  GetIt.I.registerSingleton<SettingsCubit>(SettingsCubit.initial());
}
