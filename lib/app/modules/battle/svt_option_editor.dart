import 'package:flutter/foundation.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:chaldea/app/app.dart';
import 'package:chaldea/app/battle/models/card_dmg.dart';
import 'package:chaldea/app/descriptors/skill_descriptor.dart';
import 'package:chaldea/app/modules/command_code/cmd_code_list.dart';
import 'package:chaldea/app/modules/common/filter_group.dart';
import 'package:chaldea/app/modules/common/misc.dart';
import 'package:chaldea/app/modules/servant/tabs/skill_tab.dart';
import 'package:chaldea/app/modules/servant/tabs/td_tab.dart';
import 'package:chaldea/generated/l10n.dart';
import 'package:chaldea/models/db.dart';
import 'package:chaldea/models/gamedata/gamedata.dart';
import 'package:chaldea/models/userdata/filter_data.dart';
import 'package:chaldea/packages/logger.dart';
import 'package:chaldea/utils/utils.dart';
import 'package:chaldea/widgets/widgets.dart';
import 'simulation_preview.dart';

class ServantOptionEditPage extends StatefulWidget {
  final PlayerSvtData playerSvtData;
  final VoidCallback onChange;

  ServantOptionEditPage({super.key, required this.playerSvtData, required this.onChange});

  @override
  State<ServantOptionEditPage> createState() => _ServantOptionEditPageState();

  static Widget buildSlider({
    required final String leadingText,
    required final int min,
    required final int max,
    required final int value,
    required final String label,
    required final ValueChanged<double> onChange,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 10),
          child: Text('$leadingText: $label'),
        ),
        Slider(
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          value: value.toDouble(),
          label: label,
          onChanged: (v) {
            onChange(v);
          },
        ),
      ],
    );
  }
}

class _ServantOptionEditPageState extends State<ServantOptionEditPage> {
  PlayerSvtData get playerSvtData => widget.playerSvtData;

  Servant get svt => playerSvtData.svt!;

  VoidCallback get onChange => widget.onChange;

  @override
  Widget build(final BuildContext context) {
    final List<Widget> topListChildren = [];
    topListChildren.add(_header(context));
    topListChildren.add(ServantOptionEditPage.buildSlider(
      leadingText: 'Lv',
      min: 1,
      max: 120,
      value: playerSvtData.lv,
      label: playerSvtData.lv.toString(),
      onChange: (v) {
        playerSvtData.lv = v.round();
        _updateState();
      },
    ));
    topListChildren.add(ServantOptionEditPage.buildSlider(
      leadingText: 'ATK ${S.current.foukun}',
      min: 0,
      max: 200,
      value: playerSvtData.atkFou ~/ 10,
      label: playerSvtData.atkFou.toString(),
      onChange: (v) {
        final int fou = v.round() * 10;
        if (fou > 1000 && fou % 20 == 10) {
          playerSvtData.atkFou = fou - 10;
        } else {
          playerSvtData.atkFou = fou;
        }
        _updateState();
      },
    ));
    topListChildren.add(ServantOptionEditPage.buildSlider(
      leadingText: 'HP ${S.current.foukun}',
      min: 0,
      max: 200,
      value: playerSvtData.hpFou ~/ 10,
      label: playerSvtData.hpFou.toString(),
      onChange: (v) {
        final int fou = v.round() * 10;
        if (fou > 1000 && fou % 20 == 10) {
          playerSvtData.hpFou = fou - 10;
        } else {
          playerSvtData.hpFou = fou;
        }
        _updateState();
      },
    ));
    topListChildren.add(_buildNPSection(context));
    for (int i = 0; i < svt.groupedActiveSkills.length; i += 1) {
      topListChildren.add(_buildSkillSection(context, i));
    }
    for (int i = 0; i < svt.appendPassive.length; i += 1) {
      topListChildren.add(_buildAppendSkillSection(context, i));
    }

    topListChildren.add(_buildCmdCodePlanner());

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: AutoSizeText(S.current.battle_edit_servant_option, maxLines: 1),
        centerTitle: false,
      ),
      body: ListView(
        children: divideTiles(
          topListChildren,
          divider: const Divider(height: 10, thickness: 2),
        ),
      ),
    );
  }

  Widget _header(final BuildContext context) {
    final faces = svt.extraAssets.faces;
    final ascensionText = svt.profile.costume.containsKey(playerSvtData.ascensionPhase)
        ? svt.profile.costume[playerSvtData.ascensionPhase]!.lName.l
        : '${S.current.ascension} ${playerSvtData.ascensionPhase == 0 ? 1 : playerSvtData.ascensionPhase}';
    return CustomTile(
      leading: svt.iconBuilder(
        context: context,
        height: 72,
        jumpToDetail: true,
        overrideIcon: ServantSelector.getSvtAscensionBorderedIconUrl(svt, playerSvtData.ascensionPhase),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Transl.svtNames(ServantSelector.getSvtName(svt, playerSvtData.ascensionPhase)).l),
          Text(
            'No.${svt.collectionNo > 0 ? svt.collectionNo : svt.id}'
            '  ${Transl.svtClassId(svt.classId).l}',
          ),
          TextButton(
            child: Text(ascensionText),
            onPressed: () async {
              await null;
              if (!mounted) return;
              await showDialog(
                context: context,
                useRootNavigator: false,
                builder: (context) {
                  final List<Widget> children = [];
                  void _addOne(final int ascension, final String name, final String? icon) {
                    if (icon == null) return;
                    final borderedIcon = svt.bordered(icon);
                    children.add(ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: db.getIconImage(
                        borderedIcon,
                        width: 36,
                        padding: const EdgeInsets.symmetric(vertical: 2),
                      ),
                      title: Text(name),
                      onTap: () {
                        final ascensionPhase = ascension == 1 ? 0 : ascension;

                        for (int i = 0; i < svt.groupedActiveSkills.length; i += 1) {
                          final List<NiceSkill> previousShownSkills =
                              ServantSelector.getShownSkills(svt, playerSvtData.ascensionPhase, i);
                          final List<NiceSkill> shownSkills = ServantSelector.getShownSkills(svt, ascensionPhase, i);
                          if (!listEquals(previousShownSkills, shownSkills)) {
                            playerSvtData.skillStrengthenLvs[i] =
                                svt.groupedActiveSkills[i].indexOf(shownSkills.last) + 1;
                            logger.d('Changing skillStrengthenLv: ${playerSvtData.skillStrengthenLvs[i]}');
                          }
                        }

                        final List<NiceTd> previousShownTds =
                            ServantSelector.getShownTds(svt, playerSvtData.ascensionPhase);
                        final List<NiceTd> shownTds = ServantSelector.getShownTds(svt, ascensionPhase);
                        playerSvtData.ascensionPhase = ascensionPhase;
                        if (!listEquals(previousShownTds, shownTds)) {
                          playerSvtData.npStrengthenLv = svt.groupedNoblePhantasms.first.indexOf(shownTds.last) + 1;
                          logger.d('Capping npStrengthenLv: ${playerSvtData.npStrengthenLv}');
                        }
                        Navigator.pop(context);
                      },
                    ));
                  }

                  if (faces.ascension != null) {
                    faces.ascension!.forEach((key, value) {
                      _addOne(key, '${S.current.ascension} $key', value);
                    });
                  }
                  if (faces.costume != null) {
                    faces.costume!.forEach((key, value) {
                      _addOne(
                        key,
                        svt.profile.costume[key]?.lName.l ?? '${S.current.costume} $key',
                        value,
                      );
                    });
                  }

                  return SimpleCancelOkDialog(
                    title: Text(S.current.battle_change_ascension),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: children,
                      ),
                    ),
                    hideOk: true,
                  );
                },
              );
              _updateState();
            },
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildNPSection(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ServantOptionEditPage.buildSlider(
          leadingText: S.current.noble_phantasm_level,
          min: 1,
          max: 5,
          value: playerSvtData.npLv,
          label: playerSvtData.npLv.toString(),
          onChange: (v) {
            playerSvtData.npLv = v.round();
            _updateState();
          },
        ),
        _buildTdDescriptor(context),
      ],
    );
  }

  Widget _buildTdDescriptor(final BuildContext context) {
    final int ascension = playerSvtData.ascensionPhase;
    final List<NiceTd> shownTds = ServantSelector.getShownTds(svt, ascension);
    final ascensionOverride = svt.ascensionAdd.overWriteTDName.all.containsKey(ascension)
        ? OverrideTDData(
            tdName: svt.ascensionAdd.overWriteTDName.all[ascension],
            tdRuby: svt.ascensionAdd.overWriteTDRuby.all[ascension],
            tdFileName: svt.ascensionAdd.overWriteTDFileName.all[ascension],
            tdRank: svt.ascensionAdd.overWriteTDRank.all[ascension],
            tdTypeText: svt.ascensionAdd.overWriteTDTypeText.all[ascension],
          )
        : null;
    ascensionOverride?.keys.add(ascension);

    if (shownTds.length == 1 && shownTds.first.condQuestId <= 0) {
      return TdDescriptor(
        td: shownTds.first,
        showEnemy: !svt.isUserSvt,
        level: playerSvtData.npLv,
        overrideData: ascensionOverride,
      );
    }

    final td = svt.groupedNoblePhantasms.first[playerSvtData.npStrengthenLv - 1];

    final toggle = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: FilterGroup<NiceTd>(
            shrinkWrap: true,
            combined: true,
            options: shownTds,
            optionBuilder: (selectedTd) {
              String name = ascensionOverride?.tdName ?? selectedTd.name;
              name = Transl.tdNames(name).l;
              final rank = ascensionOverride?.tdRank ?? selectedTd.rank;
              if (!['なし', '无', 'None', '無', '없음'].contains(rank)) {
                name = '$name $rank';
              }
              if (name.trim().isEmpty) name = '???';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Text(name),
              );
            },
            values: FilterRadioData.nonnull(td),
            onFilterChanged: (v, _) {
              playerSvtData.npStrengthenLv = svt.groupedNoblePhantasms.first.indexOf(v.radioValue!) + 1;
              logger.d('Changing npStrengthenLv: ${playerSvtData.npStrengthenLv}');
              _updateState();
            },
          ),
        ),
        if (td.condQuestId > 0 || ascensionOverride != null)
          IconButton(
            padding: const EdgeInsets.all(2),
            constraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 24,
            ),
            onPressed: () => showDialog(
              context: context,
              useRootNavigator: false,
              builder: (context) => SvtTdTab.releaseCondition(svt, td, ascensionOverride),
            ),
            icon: const Icon(Icons.info_outline),
            color: Theme.of(context).hintColor,
            tooltip: S.current.open_condition,
          ),
      ],
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        toggle,
        TdDescriptor(
          td: td,
          showEnemy: !svt.isUserSvt,
          level: playerSvtData.npLv,
          overrideData: ascensionOverride,
        ),
      ],
    );
  }

  Widget _buildSkillSection(final BuildContext context, final int skillGroupIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ServantOptionEditPage.buildSlider(
          leadingText: '${S.current.active_skill} ${skillGroupIndex + 1} ${S.current.level}',
          min: 1,
          max: 10,
          value: playerSvtData.skillLvs[skillGroupIndex],
          label: playerSvtData.skillLvs[skillGroupIndex].toString(),
          onChange: (v) {
            playerSvtData.skillLvs[skillGroupIndex] = v.round();
            _updateState();
          },
        ),
        _buildSkillDescriptor(context, skillGroupIndex),
      ],
    );
  }

  Widget _buildSkillDescriptor(final BuildContext context, final int skillGroupIndex) {
    final int ascension = playerSvtData.ascensionPhase;
    final List<NiceSkill> shownSkills = ServantSelector.getShownSkills(svt, ascension, skillGroupIndex);

    if (shownSkills.length == 1 && shownSkills.first.condQuestId <= 0) {
      return SkillDescriptor(
        skill: shownSkills.first,
        level: playerSvtData.skillLvs[skillGroupIndex],
        showEnemy: !svt.isUserSvt,
      );
    }

    final skill = svt.groupedActiveSkills[skillGroupIndex][playerSvtData.skillStrengthenLvs[skillGroupIndex] - 1];

    final toggle = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: FilterGroup<NiceSkill>(
            shrinkWrap: true,
            combined: true,
            options: shownSkills,
            optionBuilder: (niceSkill) {
              String name = Transl.skillNames(niceSkill.name).l;
              if (name.trim().isEmpty) name = '???';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                child: Text(name),
              );
            },
            values: FilterRadioData.nonnull(skill),
            onFilterChanged: (v, _) {
              playerSvtData.skillStrengthenLvs[skillGroupIndex] =
                  svt.groupedActiveSkills[skillGroupIndex].indexOf(v.radioValue!) + 1;
              logger.d('Changing skillStrengthenLv: ${playerSvtData.skillStrengthenLvs[skillGroupIndex]}');
              _updateState();
            },
          ),
        ),
        if (skill.condQuestId > 0 || SvtSkillTab.hasUnusualLimitCond(skill))
          IconButton(
            padding: const EdgeInsets.all(2),
            constraints: const BoxConstraints(
              minWidth: 48,
              minHeight: 24,
            ),
            onPressed: () => showDialog(
              context: context,
              useRootNavigator: false,
              builder: (_) => SvtSkillTab.releaseCondition(skill),
            ),
            icon: const Icon(Icons.info_outline),
            color: Theme.of(context).hintColor,
            tooltip: S.current.open_condition,
          ),
      ],
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        toggle,
        SkillDescriptor(
          skill: skill,
          level: playerSvtData.skillLvs[skillGroupIndex],
          showEnemy: !svt.isUserSvt,
        ),
      ],
    );
  }

  Widget _buildAppendSkillSection(final BuildContext context, final int skillGroupIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ServantOptionEditPage.buildSlider(
          leadingText: '${S.current.append_skill} ${skillGroupIndex + 1} ${S.current.level}',
          min: 0,
          max: 10,
          value: playerSvtData.appendLvs[skillGroupIndex],
          label: playerSvtData.appendLvs[skillGroupIndex].toString(),
          onChange: (v) {
            playerSvtData.appendLvs[skillGroupIndex] = v.round();
            _updateState();
          },
        ),
        SkillDescriptor(
          skill: svt.appendPassive[skillGroupIndex].skill,
          level: playerSvtData.appendLvs[skillGroupIndex],
          showEnemy: !svt.isUserSvt,
        ),
      ],
    );
  }

  Widget _buildCmdCodePlanner() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SHeader(S.current.command_code),
        Material(
          color: Theme.of(context).cardColor,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: List.generate(svt.cards.length, (index) {
              final code = playerSvtData.commandCodes[index];
              return TableRow(children: [
                Center(
                  child: CommandCardWidget(card: svt.cards[index], width: 60),
                ),
                Column(
                  children: [
                    ServantOptionEditPage.buildSlider(
                      leadingText: S.current.card_strengthen,
                      min: 0,
                      max: 25,
                      value: playerSvtData.cardStrengthens[index] ~/ 20,
                      label: playerSvtData.cardStrengthens[index].toString(),
                      onChange: (v) {
                        playerSvtData.cardStrengthens[index] = v.round() * 20;
                        _updateState();
                      },
                    ),
                    Table(
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: [
                        TableRow(
                          children: [
                            InkWell(
                              onTap: () async {
                                router.pushBuilder(
                                  builder: (context) => CmdCodeListPage(
                                    onSelected: (selectedCode) {
                                      playerSvtData.commandCodes[index] =
                                          db.gameData.commandCodes[selectedCode.collectionNo];
                                      _updateState();
                                    },
                                  ),
                                  detail: false,
                                );
                              },
                              child: db.getIconImage(code?.icon ?? Atlas.asset('SkillIcons/skill_999999.png'),
                                  height: 60, aspectRatio: 132 / 144, padding: const EdgeInsets.all(4)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: GestureDetector(
                                onTap: code?.routeTo,
                                child: Text(
                                  code?.skills.getOrNull(0)?.lDetail ?? '',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  playerSvtData.commandCodes[index] = null;
                                });
                              },
                              icon: const Icon(Icons.remove_circle_outline, size: 18),
                              tooltip: S.current.remove,
                            ),
                          ],
                        ),
                      ],
                      columnWidths: const {
                        0: FixedColumnWidth(68),
                        // 1:
                        2: FixedColumnWidth(32)
                      },
                      border: TableBorder.all(color: const Color.fromRGBO(58, 61, 61, 1.0), width: 0.25),
                    )
                  ],
                ),
              ]);
            }),
            columnWidths: const {
              0: FixedColumnWidth(68),
            },
            border: TableBorder.all(color: const Color.fromRGBO(58, 61, 61, 1.0), width: 0.25),
          ),
        ),
      ],
    );
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
      onChange();
    }
  }
}

class CraftEssenceOptionEditPage extends StatefulWidget {
  final PlayerSvtData playerSvtData;
  final VoidCallback onChange;

  CraftEssenceOptionEditPage({super.key, required this.playerSvtData, required this.onChange});

  @override
  State<CraftEssenceOptionEditPage> createState() => _CraftEssenceOptionEditPageState();
}

class _CraftEssenceOptionEditPageState extends State<CraftEssenceOptionEditPage> {
  PlayerSvtData get playerSvtData => widget.playerSvtData;

  CraftEssence get ce => playerSvtData.ce!;

  VoidCallback get onChange => widget.onChange;

  @override
  Widget build(final BuildContext context) {
    final List<Widget> topListChildren = [];
    topListChildren.add(_header(context));
    topListChildren.add(ServantOptionEditPage.buildSlider(
      leadingText: 'Lv',
      min: 1,
      max: ce.lvMax,
      value: playerSvtData.ceLv,
      label: playerSvtData.ceLv.toString(),
      onChange: (v) {
        playerSvtData.ceLv = v.round();
        _updateState();
      },
    ));
    topListChildren.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ToggleButtons(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onPressed: (final int index) {
          playerSvtData.ceLimitBreak = index == 1;
          _updateState();
        },
        isSelected: [!playerSvtData.ceLimitBreak, playerSvtData.ceLimitBreak],
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(S.current.battle_not_limit_break),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(S.current.battle_limit_break),
          )
        ],
      ),
    ));

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: AutoSizeText(S.current.battle_edit_ce_option, maxLines: 1),
        centerTitle: false,
      ),
      body: ListView(
        children: divideTiles(
          topListChildren,
          divider: const Divider(height: 10, thickness: 4),
        ),
      ),
    );
  }

  Widget _header(final BuildContext context) {
    return CustomTile(
      leading: playerSvtData.ce!.iconBuilder(
        context: context,
        height: 72,
        jumpToDetail: true,
        overrideIcon: ce.borderedIcon,
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(ce.lName.l),
          Text(
            'No.${ce.collectionNo > 0 ? ce.collectionNo : ce.id}'
            '  ${Transl.ceObtain(ce.obtain).l}',
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
      onChange();
    }
  }
}