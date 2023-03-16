import 'package:chaldea/app/battle/models/battle.dart';
import 'package:chaldea/app/battle/models/buff.dart';
import 'package:chaldea/models/gamedata/gamedata.dart';

class AddFieldChangeToField {
  AddFieldChangeToField._();

  static bool addFieldChangeToField(
    final BattleData battleData,
    final Buff buff,
    final DataVals dataVals,
  ) {
    final activator = battleData.activator;
    final buffData = BuffData(buff, dataVals)
      ..actorUniqueId = activator?.uniqueId ?? 0
      ..actorName = activator?.lBattleName ?? '';
    battleData.fieldBuffs.add(buffData);

    return true;
  }
}