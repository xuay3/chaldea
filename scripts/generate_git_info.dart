import 'dart:io';

void main(List<String> args) async {
  try {
    final gitInfo = (await Process.run(
            'git', ['show', '-s', '--pretty=format:%h-%ct', "HEAD"]))
        .stdout
        .toString()
        .split('-');
    final hash = gitInfo[0].substring(0, 6);
    final date = int.parse(gitInfo[1]);

    final String content = '''
// GENERATED CODE - DO NOT MODIFY BY HAND
const String kCommitHash = "$hash";
const int kCommitTimestamp = $date;
''';
    File('lib/generated/git_info.dart').writeAsStringSync(content);
  } catch (e, s) {
    if (args.contains('-s')) {
      print(e);
      print(s);
    } else {
      rethrow;
    }
  }
}
