import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:screenshot/screenshot.dart';

import 'package:chaldea/generated/l10n.dart';
import 'package:chaldea/models/models.dart';
import 'package:chaldea/packages/platform/platform.dart';
import 'package:chaldea/utils/utils.dart';
import 'package:chaldea/widgets/widgets.dart';
import '../common/builders.dart';

class BondTotalTable extends StatefulWidget {
  const BondTotalTable({super.key});

  @override
  State<BondTotalTable> createState() => _BondTotalStateTable();
}

class _BondTotalStateTable extends State<BondTotalTable> {
  final screenshotController = ScreenshotController();

  final kBondLvs = const [5, 10, 15];
  final int kGroupBondWidth = 5000;
  int maxBondLv = 10;
  // bool get useGroupBond => maxBondLv > 5;
  bool get useGroupBond => false;

  List<(int, List<(int, Servant)>)> getData() {
    Map<int, List<(int, Servant)>> groups = {};
    for (final svt in db.gameData.servantsById.values) {
      final int? bond = svt.bondGrowth.getOrNull(maxBondLv - 1) ?? svt.bondGrowth.lastOrNull;
      if (bond == null) continue;
      int groupValue = bond;
      if (useGroupBond) {
        groupValue = (groupValue / kGroupBondWidth).ceil() * kGroupBondWidth;
      }
      groups.putIfAbsent(groupValue, () => []).add((bond, svt));
    }
    for (final group in groups.values) {
      group.sort((a, b) {
        final dx = b.$1 - a.$1;
        if (dx != 0) return dx;
        return SvtFilterData.compare(
          a.$2,
          b.$2,
          keys: [SvtCompare.rarity, SvtCompare.className, SvtCompare.no],
          reversed: [true, false, true],
        );
      });
    }
    groups = sortDict(groups, reversed: true);
    return groups.entries.map((e) => (e.key, e.value)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final groups = getData();
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.bond),
        actions: [
          DropdownButton<int>(
            value: maxBondLv,
            items: [
              for (final value in kBondLvs)
                DropdownMenuItem(
                  value: value,
                  child: Text('Lv.$value'),
                ),
            ],
            icon: Icon(
              Icons.arrow_drop_down,
              color: SharedBuilder.appBarForeground(context),
            ),
            selectedItemBuilder: (context) {
              final style = TextStyle(color: SharedBuilder.appBarForeground(context));
              return [
                for (final value in kBondLvs)
                  DropdownMenuItem(
                    value: value,
                    child: Text('Lv.$value', style: style),
                  )
              ];
            },
            onChanged: (v) {
              setState(() {
                if (v != null) maxBondLv = v;
              });
            },
            underline: const SizedBox(),
          ),
          IconButton(
            onPressed: takeScreenshot,
            icon: const Icon(Icons.camera_alt),
            tooltip: S.current.screenshots,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Screenshot(
          controller: screenshotController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final group in groups) buildGroup(group.$1, group.$2),
            ],
          ),
        ),
      ),
    );
  }

  String fmtBond(int bond) {
    String _fmt(int v) => v.format(compact: false, groupSeparator: ',', minVal: 999);
    if (bond % 1000 == 0) {
      return '${_fmt(bond ~/ 1000)}K';
    } else {
      return _fmt(bond);
    }
  }

  Widget buildGroup(int groupBond, List<(int, Servant)> group) {
    List<Widget> children = [];
    children.add(SHeader(useGroupBond ? '≤${fmtBond(groupBond)}' : fmtBond(groupBond)));
    Widget grid = Wrap(
      spacing: 2,
      runSpacing: 4,
      children: [
        for (final (bond, svt) in group)
          svt.iconBuilder(
            context: context,
            width: 56,
            text: useGroupBond ? fmtBond(bond) : null,
            option: ImageWithTextOption(
              fontSize: 12,
            ),
          ),
      ],
    );
    children.add(Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: grid,
    ));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Future<void> takeScreenshot() async {
    if (!PlatformU.supportScreenshot) {
      EasyLoading.showToast(S.current.screenshot_not_support_html_renderer);
      return;
    }
    try {
      final data = await screenshotController.capture();
      if (!mounted) return;
      if (data == null) {
        EasyLoading.showError(S.current.failed);
        return;
      }
      ImageActions.showSaveShare(
        context: context,
        data: data,
        destFp: joinPaths(db.paths.downloadDir, 'bond-table-${DateTime.now().toSafeFileName()}.png'),
      );
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }
}
