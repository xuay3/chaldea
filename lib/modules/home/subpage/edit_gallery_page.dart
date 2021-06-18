import 'package:chaldea/components/components.dart';

class EditGalleryPage extends StatefulWidget {
  final Map<String, GalleryItem> galleries;

  EditGalleryPage({Key? key, this.galleries = const {}}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditGalleryPageState();
}

class _EditGalleryPageState extends State<EditGalleryPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> tiles = [];
    widget.galleries.forEach((name, item) {
      if (!GalleryItem.persistentPages.contains(name)) {
        tiles.add(SwitchListTile.adaptive(
          value: db.userData.galleries[name] ?? true,
          onChanged: (bool _selected) {
            db.userData.galleries[name] = _selected;
            db.notifyAppUpdate();
          },
          title: Text(item.title),
        ));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit galleries'),
        leading: BackButton(),
      ),
      body: ListView(children: divideTiles(tiles, bottom: true)),
    );
  }
}

class GalleryItem {
  static const String servant = 'servant';
  static const String craft_essence = 'craft';
  static const String cmd_code = 'cmd_code';
  static const String item = 'item';
  static const String event = 'event';
  static const String plan = 'plan';
  static const String free_calculator = 'free_calculator';
  static const String mystic_code = 'mystic_code';
  static const String costume = 'costume';
  static const String gacha = 'gacha';
  static const String ffo = 'ffo';
  static const String cv_list = 'cv_list';
  static const String illustrator_list = 'illustrator_list';

  static const String master_mission = 'master_mission';
  static const String calculator = 'calculator';
  static const String master_equip = 'master_equip';
  static const String exp_card = 'exp_card';
  static const String ap_cal = 'ap_cal';
  static const String statistics = 'statistics';

  // static const String image_analysis = 'image_analysis';
  static const String import_data = 'import_data';
  static const String backup = 'backup';
  static const String more = 'more';
  static const String bug = 'bug';
  static const String about = 'about';

  static List<String> get persistentPages => [bug, about, more];

//  static Map<String, GalleryItem> allItems;

  // instant part
  final String name;
  final String title;
  final IconData? icon;
  final Widget? child;
  final SplitPageBuilder? builder;
  final bool isDetail;

  const GalleryItem({
    required this.name,
    required this.title,
    this.icon,
    this.child,
    this.builder,
    this.isDetail = false,
  }) : assert(icon != null || child != null);

  @override
  String toString() {
    return '$runtimeType($name)';
  }
}
