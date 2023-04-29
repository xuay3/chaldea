import 'package:tuple/tuple.dart';

import 'package:chaldea/generated/l10n.dart';
import 'package:chaldea/models/models.dart';
import 'package:chaldea/utils/utils.dart';
import 'package:chaldea/widgets/widgets.dart';
import '../../quest/quest_card.dart';

enum _SortType { openTime, apRate, dropRate }

class ItemObtainEventFreeTab extends StatefulWidget {
  final int itemId;
  final bool showOutdated;

  const ItemObtainEventFreeTab({super.key, required this.itemId, required this.showOutdated});

  @override
  _ItemObtainEventFreeTabState createState() => _ItemObtainEventFreeTabState();
}

class _ItemObtainEventFreeTabState extends State<ItemObtainEventFreeTab> {
  _SortType sortType = _SortType.openTime;

  Map<int, Quest> getEventQuests() {
    List<int> questsIds = [];
    for (final questId in db.gameData.dropData.freeDrops.keys) {
      final drops = db.gameData.dropData.freeDrops2[questId]!;
      final count = drops.items[widget.itemId] ?? 0;
      if (drops.runs < 10 || count <= 0) continue;
      questsIds.add(questId);
    }
    questsIds.sort2((e) => -(db.gameData.quests[e]?.openedAt ?? e));
    Map<int, Quest> quests = {};
    for (final questId in questsIds) {
      final quest = db.gameData.quests[questId];
      if (quest == null || !quest.isAnyFree || quest.phases.isEmpty) continue;
      if (quest.warId == WarId.chaldeaGate || quest.warId >= 8000) {
        // Hunting quests or event quests
        quests[questId] = quest;
      }
    }
    return quests;
  }

  @override
  Widget build(BuildContext context) {
    final quests = getEventQuests();
    return Column(
      children: <Widget>[
        Material(
          elevation: 1,
          child: ListTile(
            title: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[for (final type in _SortType.values) buildSortRadio(type)],
            ),
          ),
        ),
        kDefaultDivider,
        Expanded(
          child: InheritSelectionArea(
            child: ListView(children: buildEventFree(quests)),
          ),
        )
      ],
    );
  }

  Widget buildSortRadio(_SortType value) {
    String name;
    switch (value) {
      case _SortType.openTime:
        name = S.current.time;
        break;
      case _SortType.apRate:
        name = S.current.ap_efficiency;
        break;
      case _SortType.dropRate:
        name = S.current.drop_rate;
        break;
    }
    return RadioWithLabel<_SortType>(
      value: value,
      groupValue: sortType,
      label: Text(
        name,
        style: value == sortType ? null : TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
      ),
      onChanged: (v) => setState(() => sortType = v ?? sortType),
    );
  }

  List<Widget> buildEventFree(Map<int, Quest> quests) {
    final tmpData = <Tuple4<double, double, Widget, Quest>>[];
    for (final key in quests.keys) {
      final quest = quests[key]!;
      final event = quest.war?.event;

      bool outdated;
      final delaySecs = db.curUser.region.eventDelayMonth * 30 * kSecsPerDay;
      if (db.curUser.region != Region.jp && quest.warId != WarId.chaldeaGate && event != null) {
        int? endTime = event.extra.endTime.ofRegion(db.curUser.region);
        if (endTime != null && endTime < DateTime.now().timestamp - 14 * kSecsPerDay) {
          outdated = true;
        } else {
          outdated = false;
        }
      } else {
        outdated = quest.openedAt + delaySecs < DateTime.now().timestamp;
      }
      if (!widget.showOutdated && outdated) continue;

      final drops = db.gameData.dropData.freeDrops[key]!;
      final dropCount = drops.items[widget.itemId] ?? 0;
      if (drops.runs <= 0) continue;
      final dropRate = dropCount / drops.runs;
      final double? apRate =
          quest.consumeType.useAp && quest.consume > 0 ? quest.consume * drops.runs / dropCount : null;
      final dropRateString = (dropRate * 100).toStringAsFixed(2), apRateString = apRate?.toStringAsFixed(2) ?? '-';
      final child = SimpleAccordion(
        key: ValueKey('event_free_$key'),
        headerBuilder: (context, _) {
          String subtitle = 'Lv${quest.recommendLv} ${quest.consume}AP.  ';
          subtitle += sortType != _SortType.dropRate
              ? '${S.current.drop_rate} $dropRateString%.'
              : '${S.current.ap_efficiency} $apRateString AP.';
          subtitle += '\nJP ${quest.openedAt.sec2date().toDateString()}.  ';
          subtitle += '${S.current.quest_runs(drops.runs)}.';

          return ListTile(
            dense: true,
            title: Text(quest.lDispName.setMaxLines(1)),
            subtitle: Text(subtitle),
            trailing: Text(sortType != _SortType.dropRate ? '$apRateString AP' : '$dropRateString%'),
            isThreeLine: true,
            enabled: !outdated,
          );
        },
        contentBuilder: (context) {
          return QuestCard(key: ValueKey('quest_card_$key'), quest: quest);
        },
        expandIconBuilder: (context, _) => const SizedBox.shrink(),
      );
      tmpData.add(Tuple4(apRate ?? 0, dropRate, child, quest));
    }

    tmpData.sort((a, b) {
      switch (sortType) {
        case _SortType.openTime:
          return b.item4.openedAt - a.item4.openedAt;
        case _SortType.apRate:
          return (a.item1 - b.item1).sign.toInt();
        case _SortType.dropRate:
          return (b.item2 - a.item2).sign.toInt();
      }
    });
    return [
      ...tmpData.map((e) => e.item3),
      const Divider(height: 16, thickness: 0.5, indent: 16, endIndent: 16),
      SafeArea(child: SFooter(S.current.item_obtain_event_free_hint)),
    ];
  }
}
