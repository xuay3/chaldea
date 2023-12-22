import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:chaldea/app/app.dart';
import 'package:chaldea/app/modules/common/filter_group.dart';
import 'package:chaldea/generated/l10n.dart';
import 'package:chaldea/models/gamedata/raw.dart';
import 'package:chaldea/models/models.dart';
import 'package:chaldea/packages/logger.dart';
import 'package:chaldea/utils/utils.dart';
import 'package:chaldea/widgets/widgets.dart';
import 'gacha_parser.dart';
import 'mc_prob_edit.dart';

class MCSummonCreatePage extends StatefulWidget {
  final List<MstGacha> gachas;
  const MCSummonCreatePage({super.key, required this.gachas});

  @override
  State<MCSummonCreatePage> createState() => _MCSummonCreatePageState();
}

class _MCSummonCreatePageState extends State<MCSummonCreatePage> {
  late List<GachaProbData> gachas = widget.gachas.map((e) => GachaProbData(e, '', [])).toList();
  List<JpGachaNotice> notices = [];
  JpGachaNotice? _selectedNotice;

  bool get anyNoResult => gachas.any((e) => e.isInvalid);

  // -2=gacha page, -1=simulator page, 0/1/2/3=data{X+1}
  final curTab = FilterRadioData<int>.nonnull(-2);
  late final _jpNameController = TextEditingController();
  late final _cnNameController = TextEditingController();
  bool _isLuckyBagWithSR = false;

  @override
  void initState() {
    super.initState();
    parseProbs();
    parseNotices();
  }

  @override
  Widget build(BuildContext context) {
    return InheritSelectionArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("新建Mooncell卡池"),
        ),
        body: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        for (final (index, gacha) in gachas.indexed)
          ListTile(
            dense: true,
            minLeadingWidth: 24,
            horizontalTitleGap: 8,
            contentPadding: EdgeInsets.zero,
            leading: gacha.isInvalid
                ? const Icon(Icons.error, color: Colors.red, size: 18)
                : const Icon(Icons.check_circle, color: Colors.green, size: 18),
            title: Text('${index + 1} - ${gacha.gacha.name.setMaxLines(1)}'),
            onTap: () {
              router.pushPage(MCGachaProbEditPage(gacha: gacha.gacha));
            },
            trailing: Icon(DirectionalIcons.keyboard_arrow_forward(context)),
          ),
        Center(
          child: ElevatedButton(
            onPressed: parseProbs,
            child: const Text('解析所有卡池'),
          ),
        ),
        const Divider(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('公告: '),
            Expanded(
              child: DropdownButton<JpGachaNotice>(
                value: _selectedNotice,
                hint: const Text('官方公告'),
                isExpanded: true,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(
                      notices.isEmpty ? "解析中..." : "<选择一个公告(若在列表中)>",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  for (final notice in notices)
                    DropdownMenuItem(
                      value: notice,
                      child: Text.rich(TextSpan(
                        style: const TextStyle(fontSize: 12),
                        children: [
                          TextSpan(
                            text: '[${notice.lastUpdate}更新]',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          TextSpan(text: notice.title)
                        ],
                      )),
                    )
                ],
                onChanged: (v) {
                  setState(() {
                    _selectedNotice = v;
                    if (v != null) {
                      _jpNameController.text = v.title;
                    }
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: _selectedNotice == null
                  ? null
                  : () {
                      launch(_selectedNotice!.link);
                    },
              child: const Text('打开公告'),
            ),
            TextButton(
              onPressed: _selectedNotice?.topBanner == null
                  ? null
                  : () {
                      launch(_selectedNotice!.topBanner!, external: true);
                    },
              child: const Text('下载标题图'),
            ),
            TextButton(
              onPressed: () {
                final cnName = _cnNameController.text.trim();
                if (cnName.isEmpty) {
                  EasyLoading.showInfo('请先填写中文卡池名');
                  return;
                }
                final fn = '${cnName}_jp.png';
                if (fn.contains('/')) {
                  EasyLoading.showError('文件名不能包含半角斜杠"/"');
                  return;
                }
                launch("https://fgo.wiki/index.php?title=特殊:上传文件&wpDestFile=$fn");
              },
              child: const Text('上传标题图'),
            ),
          ],
        ),
        if (_selectedNotice?.topBanner != null)
          Container(
            constraints: const BoxConstraints(maxHeight: 80),
            child: CachedImage(
              imageUrl: _selectedNotice!.topBanner,
              aspectRatio: 8 / 3,
              onTap: () {
                launch(_selectedNotice!.topBanner!, external: true);
              },
            ),
          ),
        const Divider(height: 16),
        const SizedBox(height: 8),
        TextFormField(
          controller: _jpNameController,
          decoration: const InputDecoration(
            isDense: true,
            labelText: '日文卡池名(不能出现英文斜杠/)',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(),
          ),
          onChanged: (_) {
            setState(() {});
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _cnNameController,
          decoration: const InputDecoration(
            isDense: true,
            labelText: '中文卡池名(不能出现英文斜杠/)',
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(),
          ),
          onChanged: (_) {
            setState(() {});
          },
        ),
        if (gachas.any((e) => e.gacha.isLuckyBag))
          SwitchListTile(
            dense: true,
            title: const Text("福袋是否必定保底一四星从者"),
            contentPadding: EdgeInsets.zero,
            value: _isLuckyBagWithSR,
            onChanged: (v) {
              setState(() {
                _isLuckyBagWithSR = v;
              });
            },
          ),
        const SizedBox(height: 16),
        Center(
          child: FilterGroup<int>(
            combined: true,
            options: [-2, -1, ...List.generate(gachas.length, (index) => index)],
            values: curTab,
            optionBuilder: (v) {
              if (v == -2) return const Text('卡池');
              if (v == -1) return const Text('模拟器');
              return Text('data${v + 1}');
            },
            onFilterChanged: (_, __) {
              setState(() {});
            },
          ),
        ),
        curTab.radioValue == -2
            ? summonTab
            : curTab.radioValue == -1
                ? simulatorTab
                : dataTab(curTab.radioValue!)
      ],
    );
  }

  String fmtJpDate(int t) {
    final utc = DateTime.fromMillisecondsSinceEpoch(t * 1000, isUtc: true);
    final jst = utc.add(const Duration(hours: 9)); // JST=UTC+9
    String pad(int v) => v.toString().padLeft(2, '0');
    return '${jst.year}-${pad(jst.month)}-${pad(jst.day)} ${pad(jst.hour)}:${jst.minute}';
  }

  Widget _buildWikitext(String? wikitext, String? page, {String? warning}) {
    page = page?.trim();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          children: [
            FilledButton(
              onPressed:
                  wikitext == null || wikitext.trim().isEmpty ? null : () => copyToClipboard(wikitext, toast: true),
              child: Text(S.current.copy),
            ),
            FilledButton.tonal(
              onPressed: page == null || page.isEmpty
                  ? null
                  : () {
                      launch(Uri.parse('https://fgo.wiki/w/$page?action=edit').toString(), external: true);
                    },
              child: const Text('创建页面'),
            ),
          ],
        ),
        if (warning != null)
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                warning,
                style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer),
              ),
            ),
          ),
        InheritSelectionArea(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(wikitext ?? "解析失败"),
            ),
          ),
        ),
      ],
    );
  }

  Widget get summonTab {
    final openAt = Maths.min(gachas.map((e) => e.gacha.openedAt), 0);
    final closeAt = Maths.min(gachas.map((e) => e.gacha.closedAt), 0);
    List<int> puSvts = [], puCEs = [];
    for (final gacha in gachas) {
      if (gacha.isInvalid) continue;
      for (final group in gacha.groups) {
        if (group.display) {
          if (group.isSvt) {
            puSvts.addAll(group.ids);
          } else {
            puCEs.addAll(group.ids);
          }
        }
      }
    }
    puSvts = puSvts.toSet().toList();
    puCEs = puCEs.toSet().toList();
    puSvts.sort((a, b) => SvtFilterData.compare(
          db.gameData.servantsNoDup[a],
          db.gameData.servantsNoDup[b],
          keys: [SvtCompare.rarity, SvtCompare.no],
          reversed: [true, false],
        ));
    puCEs.sort((a, b) => CraftFilterData.compare(
          db.gameData.craftEssences[a],
          db.gameData.craftEssences[b],
          keys: [CraftCompare.rarity, CraftCompare.no],
          reversed: [true, false],
        ));

    String svtNames = puSvts.map((e) => db.gameData.servantsNoDup[e]?.extra.mcLink ?? "未知从者$e").join(',');
    String ceNames = puCEs.map((e) => db.gameData.craftEssences[e]?.extra.mcLink ?? "未知礼装$e").join(',');
    if (anyNoResult) {
      const hint = '<!-- 部分卡池解析失败 -->';
      svtNames += hint;
      ceNames += hint;
    }

    String cnName = _cnNameController.text.trim();
    String bannerFilename = cnName.isEmpty ? "<!-- 上传标题图 -->" : '$cnName jp.png';
    String? jpLink = _selectedNotice?.link ?? "<!-- 填写公告地址 -->";

    final wikitext = """{{卡池信息
|卡池名cn=
|卡池名缩短cn=
|卡池开始时间cn=
|卡池结束时间cn=
|卡池图文件名cn=
|卡池时间预估cn=
|卡池官网链接cn=
|卡池名jp=${_jpNameController.text}
|卡池名ha=$cnName
|卡池名缩短jp=
|卡池开始时间jp=${fmtJpDate(openAt)}
|卡池结束时间jp=${fmtJpDate(closeAt)}
|卡池图文件名jp=$bannerFilename
|卡池官网链接jp=$jpLink
|关联活动1=
|关联卡池1=
|推荐召唤从者=$svtNames
|推荐召唤礼装=$ceNames
|其他信息=
}}
""";
    return _buildWikitext(wikitext, _cnNameController.text);
  }

  Widget get simulatorTab {
    final buffer = StringBuffer();
    buffer.writeln("""{{抽卡模拟器
|卡池图片={{#show:{{Decode|{{BASEPAGENAME}}}}|?SummonImage|link=none}}
|类型=20220101""");
    if (gachas.any((e) => e.gacha.isLuckyBag)) {
      buffer.write('|福袋=');
      buffer.writeln(_isLuckyBagWithSR ? 'ssrsr' : 'ssr');
    }

    List<Set<int>> svtIdsGroups = [];
    for (final gacha in gachas) {
      final groups = gacha.groups;
      if (groups.isEmpty) continue;
      final ids = groups.where((e) => e.isSvt && e.display).expand((e) => e.ids).toList();
      if (ids.isNotEmpty) {
        svtIdsGroups.add(ids.toSet());
      }
    }
    final Set<int> allSvtIds = {for (final x in svtIdsGroups) ...x};
    final Set<int> sameSvtIds = allSvtIds.where((e) => svtIdsGroups.every((g) => g.contains(e))).toSet();
    for (final (index, gacha) in gachas.indexed) {
      final idx = index + 1;
      final groups = gacha.groups.where((e) => e.isSvt && e.display).toList();
      final groupIds = groups.expand((e) => e.ids).toList();
      final diffIds = groupIds.where((e) => !sameSvtIds.contains(e));
      if (diffIds.isEmpty) {
        if (gachas.length == 1) {
          buffer.writeln("|子名称$idx=默认");
        } else {
          buffer.writeln("|子名称$idx=第$idx组<!-- ${gacha.gacha.name.setMaxLines(1)} -->");
        }
      } else {
        final name = diffIds.map((e) => db.gameData.servantsNoDup[e]?.extra.mcLink ?? "从者$e").join('+');
        buffer.writeln('|子名称$idx=$name');
      }
      buffer.writeln('|数据$idx={{PAGENAME}}/data$idx');
    }
    buffer.writeln('}}');
    if (gachas.any((e) => e.gacha.isLuckyBag)) {
      // buffer.writeln('|类型=20220101');
    }

    final wikitext = buffer.toString();
    String page = _cnNameController.text.trim();
    return _buildWikitext(wikitext, page.isEmpty ? null : '$page/模拟器');
  }

  Widget dataTab(int index) {
    final gacha = gachas[index];
    final table = gacha.toOutput();
    String page = _cnNameController.text.trim();
    if (page.isNotEmpty) {
      page = '$page/模拟器/data${index + 1}';
    }
    String? warning;
    if (gacha.isInvalid) {
      warning = '该卡池解析失败';
    } else {
      warning = '检查概率: ${gacha.guessTotalProb()}% (${gacha.getTotalProb()}%)';
    }

    return _buildWikitext(table, page, warning: warning);
  }

  Future<void> parseProbs() async {
    try {
      gachas = await showEasyLoading(() => JpGachaParser().parseMultiple(widget.gachas));
      final errorCount = gachas.where((e) => e.isInvalid).length;
      if (errorCount > 0) {
        EasyLoading.showSuccess('$errorCount个卡池解析失败');
      } else {
        EasyLoading.showSuccess('Done');
      }
    } catch (e, s) {
      logger.e('parse gachas failed', e, s);
      EasyLoading.showError(e.toString());
    }
    if (mounted) setState(() {});
  }

  Future<void> parseNotices() async {
    notices = await JpGachaParser().parseNotices();
    _selectedNotice = null;
    if (mounted) {
      setState(() {});
    }
  }
}
