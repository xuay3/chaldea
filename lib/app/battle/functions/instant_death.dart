import 'package:chaldea/app/battle/models/battle.dart';
import 'package:chaldea/app/battle/utils/battle_logger.dart';
import 'package:chaldea/app/battle/utils/battle_utils.dart';
import 'package:chaldea/generated/l10n.dart';
import 'package:chaldea/models/gamedata/gamedata.dart';

class InstantDeath {
  InstantDeath._();

  static Future<bool> instantDeath(
    final BattleData battleData,
    final DataVals dataVals,
    final List<BattleServantData> targets, {
    final bool force = false,
  }) async {
    final activator = battleData.activator;
    final record = BattleInstantDeathRecord(forceInstantDeath: force, activator: activator, targets: []);
    bool success = false;
    for (final target in targets) {
      battleData.setTarget(target);
      final params = InstantDeathParameters();

      if (await shouldInstantDeath(battleData, dataVals, activator, target, force, params)) {
        target.hp = 0;
        target.lastHitBy = activator;
        success = true;
      }
      battleData.unsetTarget();
      record.targets.add(InstantDeathResultDetail(target: target, params: params));
    }
    battleData.recorder.instantDeath(record);

    return success;
  }

  static Future<bool> shouldInstantDeath(
    final BattleData battleData,
    final DataVals dataVals,
    final BattleServantData? activator,
    final BattleServantData target,
    final bool force,
    InstantDeathParameters? params,
  ) async {
    params ??= InstantDeathParameters();
    params.isForce = force || (activator == target && dataVals.ForceSelfInstantDeath == 1);
    if (params.isForce) {
      params.success = true;
      params.resultString = S.current.success;
      battleData.battleLogger
          .debug('${S.current.effect_target}: ${target.lBattleName} - ${S.current.force_instant_death}');
      return true;
    }

    if (await target.hasBuffOnAction(battleData, BuffAction.avoidInstantdeath)) {
      params.immune = true;
      params.success = false;
      params.resultString = kBattleFuncNoEffect;
      battleData.battleLogger.debug('${S.current.effect_target}: ${target.lBattleName} - ${S.current.battle_invalid}');
      return false;
    }

    final resistInstantDeath = await target.getBuffValueOnAction(battleData, BuffAction.resistInstantdeath);
    final nonResistInstantDeath = await target.getBuffValueOnAction(battleData, BuffAction.nonresistInstantdeath);
    final grantInstantDeath = await activator?.getBuffValueOnAction(battleData, BuffAction.grantInstantdeath) ?? 0;

    final functionRate = dataVals.Rate ?? 1000;
    final resistRate = resistInstantDeath - nonResistInstantDeath;
    final buffRate = grantInstantDeath - resistRate;
    final activationRate = (functionRate * toModifier(target.deathRate) * toModifier(1000 + buffRate)).toInt();
    final success = await battleData.canActivateFunction(activationRate);
    final resultsString = success
        ? S.current.success
        : resistRate > 0
            ? kBattleFuncGUARD
            : kBattleFuncMiss;

    params
      ..functionRate = functionRate
      ..deathRate = target.deathRate
      ..buffRate = buffRate
      ..activateRate = activationRate
      ..success = success
      ..resultString = resultsString;
    battleData.battleLogger.debug('${S.current.effect_target}: ${target.lBattleName} - '
        '$resultsString'
        '${battleData.options.tailoredExecution ? '' : ' [$activationRate vs ${battleData.options.probabilityThreshold}]'}');

    return success;
  }
}
