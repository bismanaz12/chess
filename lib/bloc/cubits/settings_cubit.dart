import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newchess/bloc/states/settings_state.dart';
import 'package:newchess/models/board.dart';
import 'package:newchess/models/lost_figures.dart';
import 'package:newchess/models/player.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(SettingsState initialState) : super(initialState);

  factory SettingsCubit.initial() {
    final board =
        Board(cells: [], whiteLost: LostFigures(), blackLost: LostFigures());
    board.createCells();
    board.putFigures();

    return SettingsCubit(SettingsState(
      whitePlayer: Player.human(), // Human player
      blackPlayer: Player.ai(), // AI player
      difficulty: 1,
    ));
  }
}
