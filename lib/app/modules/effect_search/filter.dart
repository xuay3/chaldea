import 'package:flutter/material.dart';

import 'package:chaldea/app/modules/common/filter_group.dart';
import 'package:chaldea/app/modules/common/filter_page_base.dart';
import 'package:chaldea/generated/l10n.dart';
import 'package:chaldea/utils/utils.dart';
import '../../../models/models.dart';

enum SearchCardType {
  svt,
  ce,
  cc,
}

class BuffFuncFilterData {
  bool useGrid = false;
  final rarity = FilterGroupData<int>();
  final svtClass = FilterGroupData<SvtClass>();
  final region = FilterRadioData<Region>();
  final effectScope = FilterGroupData<SvtEffectScope>(
      options: {SvtEffectScope.active, SvtEffectScope.td});
  final effectTarget = FilterGroupData<FuncTargetType?>();
  final funcAndBuff = FilterGroupData();
  final funcType = FilterGroupData<FuncType>();
  final buffType = FilterGroupData<BuffType>();
  final targetTrait = FilterGroupData<int>();

  BuffFuncFilterData();

  List<FilterGroupData> get groups => [
        rarity,
        svtClass,
        region,
        effectScope,
        effectTarget,
        funcType,
        buffType,
        funcAndBuff,
        targetTrait
      ];

  void reset() {
    for (final group in groups) {
      group.reset();
    }
    effectScope.options = {SvtEffectScope.active, SvtEffectScope.td};
  }

  static const specialFuncTarget = [
    FuncTargetType.ptSelfAnotherFirst,
    FuncTargetType.ptSelfAnotherLast,
    FuncTargetType.ptOneOther,
    FuncTargetType.ptOneHpLowestRate,
    FuncTargetType.commandTypeSelfTreasureDevice,
    FuncTargetType.enemyOneNoTargetNoAction,
  ];
  static const ignoredFuncTypes = [FuncType.classDropUp];
  static const ignoredBuffTypes = [
    BuffType.donotNobleCondMismatch,
    BuffType.preventDeathByDamage
  ];
}

class BuffFuncFilter extends FilterPage<BuffFuncFilterData> {
  final SearchCardType type;
  const BuffFuncFilter({
    Key? key,
    required BuffFuncFilterData filterData,
    required this.type,
    ValueChanged<BuffFuncFilterData>? onChanged,
  }) : super(key: key, onChanged: onChanged, filterData: filterData);

  @override
  _BuffFuncFilterState createState() => _BuffFuncFilterState();
}

class _BuffFuncFilterState
    extends FilterPageState<BuffFuncFilterData, BuffFuncFilter> {
  Map<FuncType, String> allFuncs = {};
  Map<BuffType, String> allBuffs = {};
  @override
  void initState() {
    super.initState();
    allFuncs = {
      for (final type in db.gameData.others.allFuncs)
        if (!BuffFuncFilterData.ignoredFuncTypes.contains(type))
          type: SearchUtil.getSortAlphabet(Transl.funcType(type).l),
    };
    allFuncs =
        Map.fromEntries(allFuncs.entries.toList()..sort2((e) => e.value));

    allBuffs = {
      for (final type in db.gameData.others.allBuffs)
        if (!BuffFuncFilterData.ignoredBuffTypes.contains(type))
          type: SearchUtil.getSortAlphabet(Transl.buffType(type).l),
    };
    allBuffs =
        Map.fromEntries(allBuffs.entries.toList()..sort2((e) => e.value));
  }

  @override
  Widget build(BuildContext context) {
    Set<FuncType> _funcs;
    Set<BuffType> _buffs;
    switch (widget.type) {
      case SearchCardType.svt:
        _funcs = db.gameData.others.svtFuncs;
        _buffs = db.gameData.others.svtBuffs;
        break;
      case SearchCardType.ce:
        _funcs = db.gameData.others.ceFuncs;
        _buffs = db.gameData.others.ceBuffs;
        break;
      case SearchCardType.cc:
        _funcs = db.gameData.others.ccFuncs;
        _buffs = db.gameData.others.ccBuffs;
        break;
    }
    List<FuncType> funcs =
        allFuncs.keys.where((e) => _funcs.contains(e)).toList();
    List<BuffType> buffs =
        allBuffs.keys.where((e) => _buffs.contains(e)).toList();

    return buildAdaptive(
      title: Text(S.current.filter_shown_type, textScaleFactor: 0.8),
      actions: getDefaultActions(onTapReset: () {
        filterData.reset();
        update();
      }),
      content: getListViewBody(children: [
        getGroup(header: S.of(context).filter_sort, children: [
          FilterGroup.display(
            useGrid: filterData.useGrid,
            onChanged: (v) {
              if (v != null) filterData.useGrid = v;
              update();
            },
          ),
        ]),
        if (widget.type == SearchCardType.svt)
          buildClassFilter(filterData.svtClass),
        FilterGroup<int>(
          title: Text(S.of(context).filter_sort_rarity, style: textStyle),
          options: const [0, 1, 2, 3, 4, 5],
          values: filterData.rarity,
          optionBuilder: (v) => Text('$v$kStarChar'),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        FilterGroup<Region>(
          title: Text(S.current.game_server, style: textStyle),
          options: Region.values,
          values: filterData.region,
          optionBuilder: (v) => Text(v.localName),
          onFilterChanged: (v, _) {
            update();
          },
        ),
        const Divider(height: 16, indent: 12, endIndent: 12),
        if (widget.type == SearchCardType.svt)
          FilterGroup<SvtEffectScope>(
            title: Text(S.current.effect_scope),
            options: SvtEffectScope.values,
            values: filterData.effectScope,
            optionBuilder: (v) => Text(v.shownName),
            onFilterChanged: (value, _) {
              update();
            },
          ),
        FilterGroup<FuncTargetType?>(
          title: Text(S.current.effect_target),
          options: [
            ...db.gameData.others.funcTargets.where(
                (e) => !BuffFuncFilterData.specialFuncTarget.contains(e)),
            null,
          ],
          values: filterData.effectTarget,
          optionBuilder: (v) => Text(v == null
              ? S.current.general_special
              : Transl.funcTargetType(v).l),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        FilterGroup<int>(
          title: const Text('Card'),
          options: [
            Trait.cardQuick.id!,
            Trait.cardArts.id!,
            Trait.cardBuster.id!,
            Trait.cardExtra.id!,
            Trait.faceCard.id!,
            Trait.cardNP.id!,
          ],
          values: filterData.targetTrait,
          showMatchAll: false,
          showInvert: false,
          optionBuilder: (v) => Text({
                Trait.cardQuick.id!: 'Quick',
                Trait.cardArts.id!: 'Arts',
                Trait.cardBuster.id!: 'Buster',
                Trait.cardExtra.id!: 'Extra',
                Trait.faceCard.id!: Transl.trait(Trait.faceCard.id!).l,
                Trait.cardNP.id!: S.current.np_short,
              }[v] ??
              v.toString()),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        const Divider(height: 16),
        FilterGroup<dynamic>(
          options: const [],
          values: filterData.funcAndBuff,
          title: const Text('FuncType & BuffType'),
          showMatchAll: true,
          showInvert: true,
          onFilterChanged: (v, _) {
            update();
          },
        ),
        FilterGroup<FuncType>(
          title: const Text('FuncType'),
          options: funcs,
          values: filterData.funcType,
          showMatchAll: false,
          showInvert: false,
          optionBuilder: (v) => Text(Transl.funcType(v).l),
          onFilterChanged: (value, _) {
            update();
          },
        ),
        FilterGroup<BuffType>(
          title: const Text('BuffType'),
          options: buffs,
          values: filterData.buffType,
          showMatchAll: false,
          showInvert: false,
          optionBuilder: (v) => Text(Transl.buffType(v).l),
          onFilterChanged: (value, _) {
            update();
          },
        ),
      ]),
    );
  }
}
