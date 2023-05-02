import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:chaldea/app/battle/functions/damage.dart';
import 'package:chaldea/app/battle/functions/gain_np.dart';
import 'package:chaldea/app/battle/functions/gain_star.dart';
import 'package:chaldea/app/battle/models/command_card.dart';
import 'package:chaldea/app/battle/utils/battle_logger.dart';
import 'package:chaldea/app/battle/utils/buff_utils.dart';
import 'package:chaldea/app/descriptors/func/func.dart';
import 'package:chaldea/generated/l10n.dart';
import 'package:chaldea/models/models.dart';
import 'package:chaldea/packages/logger.dart';
import 'package:chaldea/utils/utils.dart';
import 'package:chaldea/widgets/widgets.dart';
import '../interactions/tailored_execution_confirm.dart';
import 'buff.dart';
import 'skill.dart';
import 'svt_entity.dart';

export 'buff.dart';
export 'skill.dart';
export 'svt_entity.dart';
export 'craft_essence_entity.dart';
export 'card_dmg.dart';
export 'command_card.dart';

class BattleData {
  static const kValidTotalStarMax = 99;
  static const kValidViewStarMax = 49;
  static const kValidStarMax = 50;

  static const kMaxCommand = 3;
  static const playerOnFieldCount = 3;

  static final DataVals artsChain = DataVals({'Rate': 5000, 'Value': 2000});
  static final DataVals quickChainBefore7thAnni = DataVals({'Rate': 5000, 'Value': 10});
  static final DataVals quickChainAfter7thAnni = DataVals({'Rate': 5000, 'Value': 20});
  static final DataVals cardDamage = DataVals({'Rate': 1000, 'Value': 1000});

  /// Log all action histories, pop/undo/copy should not involve this filed!
  final List<BattleData> snapshots = [];

  /// User action records, should be copied/saved to snapshots
  BattleRecordManager recorder = BattleRecordManager();

  QuestPhase? niceQuest;
  Stage? curStage;

  int enemyOnFieldCount = 3;
  List<BattleServantData?> enemyDataList = [];
  List<BattleServantData?> playerDataList = [];
  List<BattleServantData?> onFieldEnemies = [];
  List<BattleServantData?> onFieldAllyServants = [];
  Map<DeckType, List<QuestEnemy>> enemyDecks = {};

  int enemyTargetIndex = 0;
  int allyTargetIndex = 0;

  BattleServantData? get targetedEnemy =>
      onFieldEnemies.length > enemyTargetIndex ? onFieldEnemies[enemyTargetIndex] : null;

  BattleServantData? get targetedAlly =>
      onFieldAllyServants.length > allyTargetIndex ? onFieldAllyServants[allyTargetIndex] : null;

  List<BattleServantData> get nonnullEnemies => _getNonnull(onFieldEnemies);

  List<BattleServantData> get nonnullAllies => _getNonnull(onFieldAllyServants);

  List<BattleServantData> get nonnullActors => [...nonnullAllies, ...nonnullEnemies];

  List<BattleServantData> get nonnullBackupEnemies => _getNonnull(enemyDataList);

  List<BattleServantData> get nonnullBackupAllies => _getNonnull(playerDataList);

  bool get isBattleFinished => nonnullEnemies.isEmpty || nonnullAllies.isEmpty;
  List<BuffData> fieldBuffs = [];
  MysticCode? mysticCode;
  int mysticCodeLv = 10;
  List<BattleSkillInfoData> masterSkillInfo = []; //BattleSkillInfoData

  int waveCount = 0;
  int turnCount = 0;
  int totalTurnCount = 0;

  double criticalStars = 0;
  int uniqueIndex = 1;

  BattleOptionsRuntime options = BattleOptionsRuntime();
  final BattleLogger battleLogger = BattleLogger();
  BuildContext? context;

  bool get mounted => context != null && context!.mounted;

  // unused fields
  // int countEnemyAttack = 0;
  // List<int> playerEntryIds = [-1, -1, -1]; // unique id
  // List<int> enemyEntryIds = [-1, -1, -1]; // unique id
  // BattleData? data;
  // BattleInfoData battleInfo;
  // QuestEntity questEnt;
  // QuestPhaseEntity questPhaseEnt;

  // List<BattleSkillInfoData> boostSkillInfo;
  // List fieldDataList = []; //BattleFieldData

  // List<int> questIndividuality = [];

  // int limitTurnCount = 0;
  // int limitAct = 0;
  // List<int> turnEffect = [];
  // int turnEffectType = 0;
  // int globalTargetId = -1;
  // int lockTargetId = -1;
  // ComboData comboData;
  // List commandCodeInfos = []; //CommandCodeInfo

  // int addCriticalStars = 0;
  // int subCriticalCount = 0;
  // int prevCriticalStars = 0;
  // bool isCalcCritical = true;
  // List<DataVals>performedValsList=[];

  // int lastActId = 0;
  // int prevTargetId = 0;

  bool previousFunctionResult = true;
  CommandCardData? currentCard;
  final List<BuffData?> _currentBuff = [];
  final List<BattleServantData> _activator = [];
  final List<BattleServantData> _target = [];

  // Just for logging
  NiceFunction? curFunc;

  void setCurrentBuff(final BuffData buff) {
    _currentBuff.add(buff);
  }

  BuffData? get currentBuff => _currentBuff.isNotEmpty ? _currentBuff.last : null;

  void unsetCurrentBuff() {
    _currentBuff.removeLast();
  }

  void setActivator(final BattleServantData svt) {
    _activator.add(svt);
  }

  BattleServantData? get activator => _activator.isNotEmpty ? _activator.last : null;

  void unsetActivator() {
    _activator.removeLast();
  }

  void setTarget(final BattleServantData svt) {
    _target.add(svt);
  }

  BattleServantData? get target => _target.isNotEmpty ? _target.last : null;

  void unsetTarget() {
    _target.removeLast();
  }

  bool get isBattleWin {
    return waveCount >= Maths.max(niceQuest?.stages.map((e) => e.wave) ?? [], -1) &&
        (curStage == null || (enemyDataList.isEmpty && onFieldEnemies.every((e) => e == null)));
  }

  Future<void> init(
    final QuestPhase quest,
    final List<PlayerSvtData?> playerSettings,
    final MysticCodeData? mysticCodeData,
  ) async {
    niceQuest = quest;
    waveCount = 1;
    turnCount = 0;
    recorder.progressWave(waveCount);
    totalTurnCount = 0;
    criticalStars = 0;

    previousFunctionResult = true;
    uniqueIndex = 1;
    enemyDecks.clear();
    enemyTargetIndex = 0;
    allyTargetIndex = 0;

    fieldBuffs.clear();

    onFieldAllyServants.clear();
    onFieldEnemies.clear();
    playerDataList = playerSettings
        .map((svtSetting) =>
            svtSetting == null || svtSetting.svt == null ? null : BattleServantData.fromPlayerSvtData(svtSetting))
        .toList();
    _fetchWaveEnemies();

    for (final svt in playerDataList) {
      svt?.uniqueId = uniqueIndex;
      await svt?.init(this);
      uniqueIndex += 1;
    }
    for (final enemy in enemyDataList) {
      enemy?.uniqueId = uniqueIndex;
      await enemy?.init(this);
      uniqueIndex += 1;
    }

    mysticCode = mysticCodeData?.mysticCode;
    mysticCodeLv = mysticCodeData?.level ?? 10;
    if (mysticCode != null) {
      masterSkillInfo =
          mysticCode!.skills.map((skill) => BattleSkillInfoData([skill], skill)..skillLv = mysticCodeLv).toList();
    }

    _initOnField(playerDataList, onFieldAllyServants, playerOnFieldCount);
    _initOnField(enemyDataList, onFieldEnemies, enemyOnFieldCount);
    allyTargetIndex = getNonNullTargetIndex(onFieldAllyServants, allyTargetIndex);
    enemyTargetIndex = getNonNullTargetIndex(onFieldEnemies, enemyTargetIndex);

    for (final svt in nonnullActors) {
      await svt.enterField(this);
    }

    await nextTurn();
  }

  Future<void> nextTurn() async {
    await replenishActors();
    bool addTurn = true;

    if (enemyDataList.isEmpty && nonnullEnemies.isEmpty) {
      addTurn = await nextWave();
    }
    if (addTurn) {
      turnCount += 1;
      totalTurnCount += 1;
      recorder.progressTurn(totalTurnCount);
      battleLogger.action('${S.current.battle_turn} $totalTurnCount');
    }

    // start of ally turn
    for (final svt in nonnullAllies) {
      await svt.startOfMyTurn(this);
    }
  }

  Future<bool> nextWave() async {
    if (niceQuest?.stages.every((s) => s.wave < waveCount + 1) == true) {
      recorder.message('End');
      return false;
    }
    waveCount += 1;
    recorder.progressWave(waveCount);
    turnCount = 0;

    _fetchWaveEnemies();
    for (final enemy in enemyDataList) {
      enemy?.uniqueId = uniqueIndex;
      await enemy?.init(this);
      uniqueIndex += 1;
    }

    onFieldEnemies.clear();
    _initOnField(enemyDataList, onFieldEnemies, enemyOnFieldCount);
    enemyTargetIndex = getNonNullTargetIndex(onFieldEnemies, enemyTargetIndex);

    for (final enemy in nonnullEnemies) {
      await enemy.enterField(this);
    }
    return true;
  }

  Future<void> replenishActors() async {
    final List<BattleServantData> newActors = [
      ..._populateListAndReturnNewActors(onFieldEnemies, enemyDataList),
      ..._populateListAndReturnNewActors(onFieldAllyServants, playerDataList)
    ];

    for (final svt in newActors) {
      await svt.enterField(this);
    }
  }

  static List<BattleServantData> _populateListAndReturnNewActors(
    final List<BattleServantData?> toList,
    final List<BattleServantData?> fromList,
  ) {
    final List<BattleServantData> newActors = [];
    for (int i = 0; i < toList.length; i += 1) {
      if (toList[i] == null && fromList.isNotEmpty) {
        BattleServantData? nextEnemy;
        while (fromList.isNotEmpty && nextEnemy == null) {
          nextEnemy = fromList.removeAt(0);
        }
        if (nextEnemy != null) {
          toList[i] = nextEnemy;
          newActors.add(nextEnemy);
        }
      }
    }
    return newActors;
  }

  void _fetchWaveEnemies() {
    curStage = niceQuest?.stages.firstWhereOrNull((s) => s.wave == waveCount);
    enemyOnFieldCount = curStage?.enemyFieldPosCount ?? 3;
    enemyDataList = List.filled(enemyOnFieldCount, null, growable: true);
    enemyDecks.clear();

    if (curStage != null) {
      for (final enemy in curStage!.enemies) {
        if (enemy.deck == DeckType.enemy) {
          if (enemy.deckId > enemyDataList.length) {
            enemyDataList.length = enemy.deckId;
          }

          enemyDataList[enemy.deckId - 1] = BattleServantData.fromEnemy(enemy);
        } else {
          if (!enemyDecks.containsKey(enemy.deck)) {
            enemyDecks[enemy.deck] = [];
          }
          enemyDecks[enemy.deck]!.add(enemy);
        }
      }
    }
  }

  void _initOnField(
    final List<BattleServantData?> dataList,
    final List<BattleServantData?> onFieldList,
    final int maxCount,
  ) {
    while (dataList.isNotEmpty && onFieldList.length < maxCount) {
      final svt = dataList.removeAt(0);
      svt?.deckIndex = onFieldList.length + 1;
      onFieldList.add(svt);
    }
  }

  List<BattleServantData> _getNonnull(final List<BattleServantData?> list) {
    List<BattleServantData> results = [];
    for (final nullableSvt in list) {
      if (nullableSvt != null) {
        results.add(nullableSvt);
      }
    }
    return results;
  }

  void changeStar(final num change) {
    criticalStars += change;
    criticalStars = criticalStars.clamp(0, kValidTotalStarMax).toDouble();
  }

  List<NiceTrait> getFieldTraits() {
    final List<NiceTrait> allTraits = [];
    allTraits.addAll(niceQuest!.individuality);

    bool fieldTraitCheck(final NiceTrait trait) {
      // > 3000 is a buff trait
      return trait.id < 3000;
    }

    final List<int> removeTraitIds = [];
    for (final svt in nonnullActors) {
      setActivator(svt);
      for (final buff in svt.battleBuff.allBuffs) {
        if (buff.buff.type == BuffType.fieldIndividuality && buff.shouldApplyBuff(this, false)) {
          allTraits.addAll(buff.traits.where((trait) => fieldTraitCheck(trait)));
        } else if (buff.buff.type == BuffType.subFieldIndividuality && buff.shouldApplyBuff(this, false)) {
          removeTraitIds.addAll(buff.vals.TargetList!.map((traitId) => traitId));
        }
      }
      unsetActivator();
    }

    fieldBuffs
        .where((buff) => buff.buff.type == BuffType.toFieldChangeField)
        .forEach((buff) => allTraits.addAll(buff.traits.where((trait) => fieldTraitCheck(trait))));

    allTraits.removeWhere((trait) => removeTraitIds.contains(trait.id));

    return allTraits;
  }

  bool checkTraits(final CheckTraitParameters params) {
    if (params.requiredTraits.isEmpty) {
      return true;
    }

    final List<NiceTrait> currentTraits = [];

    final actor = params.actor;
    if (actor != null) {
      if (params.checkActorTraits) {
        currentTraits.addAll(actor.getTraits(this));
      }

      if (params.checkActorBuffTraits) {
        currentTraits.addAll(actor.getBuffTraits(
          this,
          activeOnly: params.checkActiveBuffOnly,
          ignoreIrremovable: params.ignoreIrremovableBuff,
        ));
      }

      if (params.checkActorNpTraits) {
        final currentNp = actor.getNPCard(this);
        if (currentNp != null) {
          currentTraits.addAll(currentNp.traits);
        }
      }
    }

    if (params.checkCurrentBuffTraits && currentBuff != null) {
      currentTraits.addAll(currentBuff!.traits);
    }

    if (params.checkCurrentCardTraits && currentCard != null) {
      currentTraits.addAll(currentCard!.traits);
      if (currentCard!.isCritical) {
        currentTraits.add(NiceTrait(id: Trait.criticalHit.id));
      }
    }

    if (params.checkQuestTraits) {
      currentTraits.addAll(getFieldTraits());
    }

    if (params.checkIndivType == 1 || params.checkIndivType == 3) {
      return containsAllTraits(currentTraits, params.requiredTraits);
    } else {
      return containsAnyTraits(currentTraits, params.requiredTraits);
    }
  }

  bool isActorOnField(final int actorUniqueId) {
    return nonnullActors.any((svt) => svt.uniqueId == actorUniqueId);
  }

  void checkBuffStatus() {
    nonnullActors.forEach((svt) {
      svt.checkBuffStatus(this);
    });

    for (int index = 0; index < onFieldAllyServants.length; index += 1) {
      onFieldAllyServants[index]?.fieldIndex = index;
    }
    for (int index = 0; index < playerDataList.length; index += 1) {
      playerDataList[index]?.fieldIndex = onFieldAllyServants.length + index;
    }
    for (int index = 0; index < onFieldEnemies.length; index += 1) {
      onFieldEnemies[index]?.fieldIndex = index;
    }
    for (int index = 0; index < enemyDataList.length; index += 1) {
      enemyDataList[index]?.fieldIndex = onFieldEnemies.length + index;
    }
  }

  bool canSelectNp(final int servantIndex) {
    if (onFieldAllyServants[servantIndex] == null) {
      return false;
    }

    return onFieldAllyServants[servantIndex]!.canSelectNP(this);
  }

  // NOTE: this is different from canSelectNP
  bool canUseNp(final int servantIndex) {
    if (onFieldAllyServants[servantIndex] == null) {
      return false;
    }

    return onFieldAllyServants[servantIndex]!.canNP(this);
  }

  bool isSkillSealed(final int servantIndex, final int skillIndex) {
    if (onFieldAllyServants[servantIndex] == null) {
      return false;
    }

    return onFieldAllyServants[servantIndex]!.isSkillSealed(this, skillIndex);
  }

  bool isSkillCondFailed(final int servantIndex, final int skillIndex) {
    if (onFieldAllyServants[servantIndex] == null) {
      return false;
    }

    return onFieldAllyServants[servantIndex]!.isCondFailed(this, skillIndex);
  }

  bool canUseSvtSkillIgnoreCoolDown(final int servantIndex, final int skillIndex) {
    if (onFieldAllyServants[servantIndex] == null) {
      return false;
    }

    return onFieldAllyServants[servantIndex]!.canUseSkillIgnoreCoolDown(this, skillIndex);
  }

  Future<T> recordError<T>({
    required bool save,
    required String action,
    required Future<T> Function() task,
  }) async {
    try {
      if (save) pushSnapshot();
      return await task();
    } catch (e, s) {
      battleLogger.error("Failed: $action");
      logger.e('Battle action failed: $action', e, s);
      if (mounted) EasyLoading.showError('${S.current.failed}\n\n$e');
      if (save) popSnapshot();
      rethrow;
    }
  }

  Future<void> activateSvtSkill(final int servantIndex, final int skillIndex) async {
    if (onFieldAllyServants[servantIndex] == null || isBattleFinished) {
      return;
    }

    final svt = onFieldAllyServants[servantIndex]!;
    battleLogger
        .action('${svt.lBattleName} - ${S.current.active_skill} ${skillIndex + 1}: ${svt.getSkillName(skillIndex)}');
    return recordError(
      save: true,
      action: 'svt_skill-${servantIndex + 1}-${skillIndex + 1}',
      task: () => svt.activateSkill(this, skillIndex),
    );
  }

  bool canUseMysticCodeSkillIgnoreCoolDown(final int skillIndex) {
    if (masterSkillInfo.length <= skillIndex || skillIndex < 0) {
      return false;
    }

    final skill = masterSkillInfo[skillIndex].proximateSkill;
    if (skill == null) {
      return true; // enable update
    }

    if (skill.functions.any((func) => func.funcType == FuncType.replaceMember)) {
      return nonnullBackupAllies.isNotEmpty && nonnullAllies.where((svt) => svt.canOrderChange(this)).isNotEmpty;
    }

    return true;
  }

  Future<void> activateMysticCodeSKill(final int skillIndex) async {
    if (masterSkillInfo.length <= skillIndex || isBattleFinished) {
      return;
    }

    battleLogger.action('${S.current.mystic_code} - ${S.current.active_skill} ${skillIndex + 1}: '
        '${masterSkillInfo[skillIndex].lName}');
    return recordError(
      save: true,
      action: 'mystic_code_skill-${skillIndex + 1}',
      task: () async {
        int effectiveness = 1000;
        for (final svt in nonnullAllies) {
          effectiveness += await svt.getBuffValueOnAction(this, BuffAction.masterSkillValueUp);
        }
        await masterSkillInfo[skillIndex].activate(this, effectiveness: effectiveness != 1000 ? effectiveness : null);
        recorder.skill(
          battleData: this,
          activator: null,
          skill: masterSkillInfo[skillIndex],
          type: SkillInfoType.mysticCode,
          fromPlayer: true,
        );
        return;
      },
    );
  }

  Future<void> playerTurn(final List<CombatAction> actions) async {
    if (actions.isEmpty || isBattleFinished) {
      return;
    }

    return recordError(
      save: true,
      action: 'play_turn-${actions.length} cards',
      task: () async {
        criticalStars = 0;

        // assumption: only Quick, Arts, and Buster are ever listed as viable actions
        final cardTypesSet =
            actions.where((action) => action.isValid(this)).map((action) => action.cardData.cardType).toSet();
        final isTypeChain = actions.length == 3 && cardTypesSet.length == 1;
        final isMightyChain = cardTypesSet.length == 3 && options.isAfter7thAnni;
        final isBraveChain = actions.where((action) => action.isValid(this)).length == kMaxCommand &&
            actions.map((action) => action.actor).toSet().length == 1;
        if (isBraveChain) {
          final actor = actions[0].actor;
          final extraCard = actor.getExtraCard(this);
          if (extraCard != null) actions.add(CombatAction(actor, extraCard));
        }

        final CardType firstCardType =
            options.isAfter7thAnni || actions[0].isValid(this) ? actions[0].cardData.cardType : CardType.blank;
        if (isTypeChain) {
          applyTypeChain(firstCardType, actions);
        }
        final previousTargetIndex = allyTargetIndex;
        int extraOvercharge = 0;
        for (int i = 0; i < actions.length; i += 1) {
          if (nonnullEnemies.isNotEmpty) {
            final action = actions[i];
            currentCard = action.cardData;
            recorder.startPlayerCard(action.actor, action.cardData);
            allyTargetIndex = onFieldAllyServants.indexOf(action.actor); // help damageFunction identify attacker

            if (allyTargetIndex != -1 && action.isValid(this)) {
              if (currentCard!.isNP) {
                await action.actor
                    .activateBuffOnActions(this, [BuffAction.functionAttackBefore, BuffAction.functionNpattack]);
                await action.actor.activateNP(this, extraOvercharge);
                extraOvercharge += 1;

                for (final svt in nonnullEnemies) {
                  if (svt.attacked) await svt.activateBuffOnAction(this, BuffAction.functionDamage);
                }
              } else {
                extraOvercharge = 0;
                await executePlayerCard(action.actor, currentCard!, i + 1, isTypeChain, isMightyChain, firstCardType);
              }
            }

            if (shouldRemoveDeadActors(actions, i)) {
              await removeDeadActors();
            }

            currentCard = null;
            recorder.endPlayerCard(action.actor, action.cardData);
          }

          checkBuffStatus();
        }

        // end player turn
        await endPlayerTurn();

        await startEnemyTurn();
        await endEnemyTurn();

        await nextTurn();

        allyTargetIndex = previousTargetIndex;
      },
    );
  }

  Future<void> skipWave() async {
    if (isBattleFinished) {
      return;
    }
    recorder.skipWave(waveCount);
    battleLogger.action('${S.current.battle_skip_current_wave} ($waveCount)');
    pushSnapshot();

    onFieldEnemies.clear();
    enemyDataList.clear();

    await endPlayerTurn();

    await startEnemyTurn();
    await endEnemyTurn();

    await nextTurn();
  }

  Future<void> endPlayerTurn() async {
    for (final svt in nonnullAllies) {
      await svt.endOfMyTurn(this);
    }

    for (final svt in nonnullEnemies) {
      await svt.endOfYourTurn(this);
    }

    masterSkillInfo.forEach((skill) {
      skill.turnEnd();
    });

    await removeDeadActors();
  }

  Future<void> startEnemyTurn() async {
    for (final svt in nonnullEnemies) {
      if (svt.hp <= 0) {
        await svt.shift(this);
      }
      await svt.startOfMyTurn(this);
    }
  }

  Future<void> endEnemyTurn() async {
    for (final svt in nonnullEnemies) {
      await svt.endOfMyTurn(this);
    }

    for (final svt in nonnullAllies) {
      await svt.endOfYourTurn(this);
    }

    await removeDeadActors();

    fieldBuffs.forEach((buff) {
      buff.turnPass();
    });
    fieldBuffs.removeWhere((buff) => !buff.isActive);
  }

  Future<void> executePlayerCard(
    final BattleServantData actor,
    final CommandCardData card,
    final int chainPos,
    final bool isTypeChain,
    final bool isMightyChain,
    final CardType firstCardType,
  ) async {
    await actor.activateCommandCode(this, card.cardIndex);

    await actor.activateBuffOnActions(this, [
      BuffAction.functionAttackBefore,
      BuffAction.functionCommandattackBefore,
      BuffAction.functionCommandcodeattackBefore,
    ]);

    setActivator(actor);

    final List<BattleServantData> targets = [];
    if (card.cardDetail.attackType == CommandCardAttackType.all) {
      targets.addAll(nonnullEnemies);
    } else {
      targets.add(targetedEnemy!);
    }
    await Damage.damage(this, cardDamage, targets, chainPos, isTypeChain, isMightyChain, firstCardType);

    unsetActivator();

    await actor.activateBuffOnActions(this, [
      BuffAction.functionAttackAfter,
      BuffAction.functionCommandattackAfter,
      BuffAction.functionCommandcodeattackAfter,
    ]);

    actor.clearCommandCodeBuffs();

    for (final svt in targets) {
      await svt.activateBuffOnAction(this, BuffAction.functionDamage);
    }
  }

  void applyTypeChain(final CardType cardType, final List<CombatAction> actions) {
    battleLogger.action('${cardType.name} Chain');
    if (cardType == CardType.quick) {
      final dataValToUse = options.isAfter7thAnni ? quickChainAfter7thAnni : quickChainBefore7thAnni;
      GainStar.gainStar(this, dataValToUse);
    } else if (cardType == CardType.arts) {
      final targets = actions.map((action) => action.actor).toSet();
      GainNP.gainNP(this, artsChain, targets);
    }
  }

  Future<void> chargeAllyNP() async {
    if (isBattleFinished) {
      return;
    }
    // 宝具充填
    // 出撃中のサーヴァント全員の宝具ゲージを+100％する
    final skill = NiceSkill(
      id: 10000000003,
      type: SkillType.active,
      name: S.current.battle_charge_party,
      unmodifiedDetail: S.current.battle_charge_party,
      coolDown: [0],
      functions: [
        NiceFunction(
          funcId: 1,
          funcType: FuncType.gainNp,
          funcTargetType: FuncTargetType.ptAll,
          funcTargetTeam: FuncApplyTarget.playerAndEnemy,
          svals: [
            DataVals({
              'Rate': 5000,
              'Value': 10000,
              'Unaffected': 1,
            })
          ],
        )
      ],
    );

    battleLogger.action(S.current.battle_charge_party);

    return recordError(
      save: true,
      action: S.current.battle_charge_party,
      task: () async {
        await BattleSkillInfoData.activateSkill(this, skill, 1, defaultToPlayer: true);
        recorder.skill(
          battleData: this,
          activator: null,
          skill: BattleSkillInfoData([], skill),
          type: SkillInfoType.commandSpell,
          fromPlayer: true,
        );
      },
    );
  }

  Future<void> commandSpellRepairHp() {
    final skill = NiceSkill(
      id: 10000000001,
      type: SkillType.active,
      name: '霊基修復',
      unmodifiedDetail: 'サーヴァント1騎のHPを全回復する',
      coolDown: [0],
      functions: [
        NiceFunction(
          funcId: 452,
          funcType: FuncType.gainHpPer,
          funcTargetType: FuncTargetType.ptOne,
          funcTargetTeam: FuncApplyTarget.playerAndEnemy,
          svals: [
            DataVals({
              'Rate': 1000,
              'Value': 1000,
              'Unaffected': 1,
            })
          ],
        )
      ],
    );
    final csRepairHpName = '${S.current.command_spell}: ${Transl.skillNames('霊基修復').l}';

    return recordError(
      save: true,
      action: csRepairHpName,
      task: () async {
        await BattleSkillInfoData.activateSkill(this, skill, 1, defaultToPlayer: true);
        recorder.skill(
          battleData: this,
          activator: null,
          skill: BattleSkillInfoData([], skill),
          type: SkillInfoType.commandSpell,
          fromPlayer: true,
        );
      },
    );
  }

  Future<void> commandSpellReleaseNP() {
    final skill = NiceSkill(
      id: 10000000009,
      type: SkillType.active,
      name: '宝具解放',
      unmodifiedDetail: 'サーヴァント1騎のNPを100％増加させる',
      coolDown: [0],
      functions: [
        NiceFunction(
          funcId: 464,
          funcType: FuncType.gainNp,
          funcTargetType: FuncTargetType.ptOne,
          funcTargetTeam: FuncApplyTarget.player,
          funcPopupText: 'NP増加',
          svals: [
            DataVals({
              'Rate': 3000,
              'Value': 10000,
              'Unaffected': 1,
            })
          ],
        )
      ],
    );
    final csReleaseNpName = '${S.current.command_spell}: ${Transl.skillNames('宝具解放').l}';
    battleLogger.action(csReleaseNpName);

    return recordError(
      save: true,
      action: csReleaseNpName,
      task: () async {
        await BattleSkillInfoData.activateSkill(this, skill, 1, defaultToPlayer: true);
        recorder.skill(
          battleData: this,
          activator: null,
          skill: BattleSkillInfoData([], skill),
          type: SkillInfoType.commandSpell,
          fromPlayer: true,
        );
      },
    );
  }

  Future<void> removeDeadActors() async {
    await removeDeadActorsFromList(onFieldAllyServants);
    await removeDeadActorsFromList(onFieldEnemies);
    allyTargetIndex = getNonNullTargetIndex(onFieldAllyServants, allyTargetIndex);
    enemyTargetIndex = getNonNullTargetIndex(onFieldEnemies, enemyTargetIndex);

    if (niceQuest != null && niceQuest!.flags.contains(QuestFlag.enemyImmediateAppear)) {
      await replenishActors();
    }
  }

  Future<void> removeDeadActorsFromList(final List<BattleServantData?> actorList) async {
    for (int i = 0; i < actorList.length; i += 1) {
      if (actorList[i] == null) {
        continue;
      }

      final actor = actorList[i]!;
      if (actor.hp <= 0 && !actor.hasNextShift()) {
        bool hasGuts = false;
        await actor.activateGuts(this).then((value) => hasGuts = value);
        if (!hasGuts) {
          await actor.death(this);
          if (actor.lastHitBy != null) {
            await actor.lastHitBy!.activateBuffOnAction(this, BuffAction.functionDeadattack);
          }
          actorList[i] = null;
          actor.fieldIndex = -1;
          if (actor.isPlayer) {
            nonnullAllies.forEach((svt) {
              svt.removeBuffWithTrait(NiceTrait(id: Trait.buffLockCardsDeck.id));
            });
          }
        }
      }
    }
  }

  int getNonNullTargetIndex(final List<BattleServantData?> actorList, final int targetIndex) {
    if (actorList.length > targetIndex && targetIndex >= 0 && actorList[targetIndex] != null) {
      return targetIndex;
    }

    for (int i = 0; i < actorList.length; i += 1) {
      if (actorList[i] != null) {
        return i;
      }
    }
    return 0;
  }

  bool shouldRemoveDeadActors(final List<CombatAction> actions, final int index) {
    final action = actions[index];
    if (action.cardData.isNP || index == actions.length - 1) {
      return true;
    }

    final nextAction = actions[index + 1];
    return nextAction.cardData.isNP || nextAction.actor != action.actor;
  }

  Future<bool> canActivate(final int activationRate, final String description) async {
    if (activationRate < 1000 && activationRate > 0 && options.tailoredExecution && mounted) {
      final curResult = options.probabilityThreshold <= activationRate ? S.current.success : S.current.failed;
      final String details = '${S.current.results}: $curResult => '
          '${S.current.battle_activate_probability}: '
          '${(activationRate / 10).toStringAsFixed(1)}% '
          'vs ${S.current.probability_expectation}: '
          '${(options.probabilityThreshold / 10).toStringAsFixed(1)}%';
      return TailoredExecutionConfirm.show(context: context!, description: description, details: details);
    }

    return options.probabilityThreshold <= activationRate;
  }

  Future<bool> canActivateFunction(final int activationRate) async {
    final function = curFunc!;
    final fieldTraitString = function.funcquestTvals.isNotEmpty
        ? ' - ${S.current.battle_require_field_traits} ${function.funcquestTvals.map((e) => e.shownName()).toList()}'
        : '';
    final targetTraitString = function.functvals.isNotEmpty
        ? ' - ${S.current.battle_require_opponent_traits} ${function.functvals.map((e) => e.shownName()).toList()}'
        : '';
    final targetString = target != null ? ' vs ${target!.lBattleName}' : '';
    final funcString = '${activator?.lBattleName ?? S.current.battle_no_source} - '
        '${FuncDescriptor.buildFuncText(function)}'
        '$fieldTraitString'
        '$targetTraitString'
        '$targetString';
    return await canActivate(activationRate, funcString);
  }

  void pushSnapshot() {
    final BattleData copy = BattleData()
      ..niceQuest = niceQuest
      ..curStage = curStage
      ..enemyOnFieldCount = enemyOnFieldCount
      ..enemyDataList = enemyDataList.map((e) => e?.copy()).toList()
      ..playerDataList = playerDataList.map((e) => e?.copy()).toList()
      ..onFieldEnemies = onFieldEnemies.map((e) => e?.copy()).toList()
      ..onFieldAllyServants = onFieldAllyServants.map((e) => e?.copy()).toList()
      ..enemyDecks = enemyDecks
      ..enemyTargetIndex = enemyTargetIndex
      ..allyTargetIndex = allyTargetIndex
      ..fieldBuffs = fieldBuffs.map((e) => e.copy()).toList()
      ..mysticCode = mysticCode
      ..mysticCodeLv = mysticCodeLv
      ..masterSkillInfo = masterSkillInfo.map((e) => e.copy()).toList()
      ..waveCount = waveCount
      ..turnCount = turnCount
      ..totalTurnCount = totalTurnCount
      ..criticalStars = criticalStars
      ..uniqueIndex = uniqueIndex
      ..options = options.copy()
      ..recorder = recorder.copy();

    snapshots.add(copy);
  }

  void popSnapshot() {
    if (snapshots.isEmpty) {
      return;
    }

    battleLogger.action(S.current.battle_undo);
    final BattleData copy = snapshots.removeLast();
    this
      ..niceQuest = copy.niceQuest
      ..curStage = copy.curStage
      ..enemyOnFieldCount = copy.enemyOnFieldCount
      ..enemyDataList = copy.enemyDataList
      ..playerDataList = copy.playerDataList
      ..onFieldEnemies = copy.onFieldEnemies
      ..onFieldAllyServants = copy.onFieldAllyServants
      ..enemyDecks = copy.enemyDecks
      ..enemyTargetIndex = copy.enemyTargetIndex
      ..allyTargetIndex = copy.allyTargetIndex
      ..fieldBuffs = copy.fieldBuffs.map((e) => e.copy()).toList()
      ..mysticCode = copy.mysticCode
      ..mysticCodeLv = copy.mysticCodeLv
      ..masterSkillInfo = copy.masterSkillInfo
      ..waveCount = copy.waveCount
      ..turnCount = copy.turnCount
      ..totalTurnCount = copy.totalTurnCount
      ..criticalStars = copy.criticalStars
      ..uniqueIndex = copy.uniqueIndex
      ..options = copy.options.copy()
      ..recorder = copy.recorder;
  }
}

// TACTICAL_START
// START_PLAYERTURN
// COMMAND_BEFORE
// // FIELDAI_START_PLAYERTURN
// // NPCAI_START_PLAYERTURN
// COMMAND_ATTACK_1
// COUNTER_FUNC_ENEMY
// CHECK_OVERKILL
// CHECK_IMMEDIATE_ENTRY
// START_IMMEDIATE_ENTRY
// AFTER_IMMEDIATE_ENTRY
// COMMAND_ATTACK_2
// COUNTER_FUNC_ENEMY
// CHECK_OVERKILL
// CHECK_IMMEDIATE_ENTRY
// START_IMMEDIATE_ENTRY
// AFTER_IMMEDIATE_ENTRY
// COMMAND_ATTACK_3
// COUNTER_FUNC_ENEMY
// CHECK_OVERKILL
// CHECK_IMMEDIATE_ENTRY
// START_IMMEDIATE_ENTRY
// AFTER_IMMEDIATE_ENTRY
// COMMAND_ADDATTACK
// COUNTER_FUNC_ENEMY
// COMMAND_AFTER
// CHECK_IMMEDIATE_ENTRY
// START_IMMEDIATE_ENTRY
// AFTER_IMMEDIATE_ENTRY
// GET_DROPITEM
// COMMAND_WAIT
// REACTION_PLAYERACTIONEND
// REFLECTION_ENEMY
// PLAYER_ENDTURN
// FIELDAI_END_PLAYERTURN
// NPCAI_END_PLAYERTURN
// BUFF_ADDPARAM_ENEMY
// UPDATE_SHIFTSERVANT
// AFTER_SHIFTSERVANT
// PLAYER_ATTACK_TERM
// START_ENEMYTURN
// FIELDAI_START_ENEMYTURN
// NPCAI_START_ENEMYTURN
// REACTION_STARTENEMY
// RESET_ENEMYACTLIST
// ENEMY_ATTACK_NORMAL_AI
// COUNTER_FUNC_PLAYER
// CHECK_IMMEDIATE_ENTRY
// START_IMMEDIATE_ENTRY
// AFTER_IMMEDIATE_ENTRY
// ENEMY_ATTACK_NORMAL_AI
// COUNTER_FUNC_PLAYER
// CHECK_IMMEDIATE_ENTRY
// START_IMMEDIATE_ENTRY
// AFTER_IMMEDIATE_ENTRY
// ENEMY_ATTACK_NORMAL_AI
// COUNTER_FUNC_PLAYER
// CHECK_IMMEDIATE_ENTRY
// START_IMMEDIATE_ENTRY
// AFTER_IMMEDIATE_ENTRY
// ENEMY_ATTACK_NORMAL_AI
// COUNTER_FUNC_PLAYER
// CHECK_IMMEDIATE_ENTRY
// START_IMMEDIATE_ENTRY
// AFTER_IMMEDIATE_ENTRY
// ENEMY_ATTACK_NORMAL_AI
// COUNTER_FUNC_PLAYER
// CHECK_IMMEDIATE_ENTRY
// START_IMMEDIATE_ENTRY
// AFTER_IMMEDIATE_ENTRY
// ENEMY_ATTACK_NORMAL_AI
// COUNTER_FUNC_PLAYER
// CHECK_IMMEDIATE_ENTRY
// START_IMMEDIATE_ENTRY
// AFTER_IMMEDIATE_ENTRY
// ENEMY_ATTACK_NORMAL_AI
// COUNTER_FUNC_PLAYER
// CHECK_IMMEDIATE_ENTRY
// START_IMMEDIATE_ENTRY
// AFTER_IMMEDIATE_ENTRY
// ENEMY_ATTACK_NORMAL_AI
// COUNTER_FUNC_PLAYER
// CHECK_IMMEDIATE_ENTRY
// START_IMMEDIATE_ENTRY
// AFTER_IMMEDIATE_ENTRY
// ENEMY_ATTACK_NORMAL_AI
// COUNTER_FUNC_PLAYER
// CHECK_IMMEDIATE_ENTRY
// START_IMMEDIATE_ENTRY
// AFTER_IMMEDIATE_ENTRY
// REACTION_ENDENEMY
// LAST_BACKSTEP
// REFLECTION_PLAYER
// ENEMY_ENDTURN
// FIELDAI_END_ENEMYTURN
// NPCAI_END_ENEMYTURN
// BUFF_ADDPARAM_PLAYER
// ENEMY_ENDWAIT
// GET_DROPITEM
// ENEMY_ATTACK_TERM
