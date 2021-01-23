// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static S current;

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();

      return S.current;
    });
  }

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `简体中文`
  String get language {
    return Intl.message(
      '简体中文',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `你好！御主!`
  String get hello {
    return Intl.message(
      '你好！御主!',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `首页`
  String get gallery_tab_name {
    return Intl.message(
      '首页',
      name: 'gallery_tab_name',
      desc: '',
      args: [],
    );
  }

  /// `设置`
  String get settings_tab_name {
    return Intl.message(
      '设置',
      name: 'settings_tab_name',
      desc: '',
      args: [],
    );
  }

  /// `通用`
  String get settings_general {
    return Intl.message(
      '通用',
      name: 'settings_general',
      desc: '',
      args: [],
    );
  }

  /// `语言`
  String get settings_language {
    return Intl.message(
      '语言',
      name: 'settings_language',
      desc: '',
      args: [],
    );
  }

  /// `数据`
  String get settings_data {
    return Intl.message(
      '数据',
      name: 'settings_data',
      desc: '',
      args: [],
    );
  }

  /// `使用帮助`
  String get settings_tutorial {
    return Intl.message(
      '使用帮助',
      name: 'settings_tutorial',
      desc: '',
      args: [],
    );
  }

  /// `当前账号`
  String get cur_account {
    return Intl.message(
      '当前账号',
      name: 'cur_account',
      desc: '',
      args: [],
    );
  }

  /// `取消`
  String get cancel {
    return Intl.message(
      '取消',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `确定`
  String get ok {
    return Intl.message(
      '确定',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `确定`
  String get confirm {
    return Intl.message(
      '确定',
      name: 'confirm',
      desc: '',
      args: [],
    );
  }

  /// `重命名`
  String get rename {
    return Intl.message(
      '重命名',
      name: 'rename',
      desc: '',
      args: [],
    );
  }

  /// `删除`
  String get delete {
    return Intl.message(
      '删除',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `新建账号`
  String get new_account {
    return Intl.message(
      '新建账号',
      name: 'new_account',
      desc: '',
      args: [],
    );
  }

  /// `服务器`
  String get server {
    return Intl.message(
      '服务器',
      name: 'server',
      desc: '',
      args: [],
    );
  }

  /// `国服`
  String get server_cn {
    return Intl.message(
      '国服',
      name: 'server_cn',
      desc: '',
      args: [],
    );
  }

  /// `日服`
  String get server_jp {
    return Intl.message(
      '日服',
      name: 'server_jp',
      desc: '',
      args: [],
    );
  }

  /// `备份`
  String get backup {
    return Intl.message(
      '备份',
      name: 'backup',
      desc: '',
      args: [],
    );
  }

  /// `恢复`
  String get restore {
    return Intl.message(
      '恢复',
      name: 'restore',
      desc: '',
      args: [],
    );
  }

  /// `从者`
  String get servant_title {
    return Intl.message(
      '从者',
      name: 'servant_title',
      desc: '',
      args: [],
    );
  }

  /// `素材`
  String get item_title {
    return Intl.message(
      '素材',
      name: 'item_title',
      desc: '',
      args: [],
    );
  }

  /// `活动`
  String get event_title {
    return Intl.message(
      '活动',
      name: 'event_title',
      desc: '',
      args: [],
    );
  }

  /// `规划`
  String get plan_title {
    return Intl.message(
      '规划',
      name: 'plan_title',
      desc: '',
      args: [],
    );
  }

  /// `纹章`
  String get cmd_code_title {
    return Intl.message(
      '纹章',
      name: 'cmd_code_title',
      desc: '',
      args: [],
    );
  }

  /// `AP计算`
  String get ap_calc_title {
    return Intl.message(
      'AP计算',
      name: 'ap_calc_title',
      desc: '',
      args: [],
    );
  }

  /// `统计`
  String get statistics_title {
    return Intl.message(
      '统计',
      name: 'statistics_title',
      desc: '',
      args: [],
    );
  }

  /// `刷新首页图`
  String get tooltip_refresh_sliders {
    return Intl.message(
      '刷新首页图',
      name: 'tooltip_refresh_sliders',
      desc: '',
      args: [],
    );
  }

  /// `跳转到{site}`
  String jump_to(Object site) {
    return Intl.message(
      '跳转到$site',
      name: 'jump_to',
      desc: '',
      args: [site],
    );
  }

  /// `编辑`
  String get edit {
    return Intl.message(
      '编辑',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `更多`
  String get more {
    return Intl.message(
      '更多',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `从者`
  String get servant {
    return Intl.message(
      '从者',
      name: 'servant',
      desc: '',
      args: [],
    );
  }

  /// `概念礼装`
  String get craft_essence {
    return Intl.message(
      '概念礼装',
      name: 'craft_essence',
      desc: '',
      args: [],
    );
  }

  /// `概念礼装`
  String get craft_essence_title {
    return Intl.message(
      '概念礼装',
      name: 'craft_essence_title',
      desc: '',
      args: [],
    );
  }

  /// `指令纹章`
  String get command_code {
    return Intl.message(
      '指令纹章',
      name: 'command_code',
      desc: '',
      args: [],
    );
  }

  /// `素材`
  String get item {
    return Intl.message(
      '素材',
      name: 'item',
      desc: '',
      args: [],
    );
  }

  /// `羁绊`
  String get game_kizuna {
    return Intl.message(
      '羁绊',
      name: 'game_kizuna',
      desc: '',
      args: [],
    );
  }

  /// `经验`
  String get game_experience {
    return Intl.message(
      '经验',
      name: 'game_experience',
      desc: '',
      args: [],
    );
  }

  /// `掉落`
  String get game_drop {
    return Intl.message(
      '掉落',
      name: 'game_drop',
      desc: '',
      args: [],
    );
  }

  /// `AP`
  String get ap {
    return Intl.message(
      'AP',
      name: 'ap',
      desc: '',
      args: [],
    );
  }

  /// `次数`
  String get counts {
    return Intl.message(
      '次数',
      name: 'counts',
      desc: '',
      args: [],
    );
  }

  /// `总AP`
  String get total_ap {
    return Intl.message(
      '总AP',
      name: 'total_ap',
      desc: '',
      args: [],
    );
  }

  /// `总次数`
  String get total_counts {
    return Intl.message(
      '总次数',
      name: 'total_counts',
      desc: '',
      args: [],
    );
  }

  /// `掉落速查`
  String get drop_calculator {
    return Intl.message(
      '掉落速查',
      name: 'drop_calculator',
      desc: '',
      args: [],
    );
  }

  /// `掉落速查`
  String get drop_calculator_short {
    return Intl.message(
      '掉落速查',
      name: 'drop_calculator_short',
      desc: '',
      args: [],
    );
  }

  /// `计算器`
  String get calculator {
    return Intl.message(
      '计算器',
      name: 'calculator',
      desc: '',
      args: [],
    );
  }

  /// `下载`
  String get download {
    return Intl.message(
      '下载',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `下载中`
  String get downloading {
    return Intl.message(
      '下载中',
      name: 'downloading',
      desc: '',
      args: [],
    );
  }

  /// `已下载`
  String get downloaded {
    return Intl.message(
      '已下载',
      name: 'downloaded',
      desc: '',
      args: [],
    );
  }

  /// `下载完成`
  String get download_complete {
    return Intl.message(
      '下载完成',
      name: 'download_complete',
      desc: '',
      args: [],
    );
  }

  /// `查询失败`
  String get query_failed {
    return Intl.message(
      '查询失败',
      name: 'query_failed',
      desc: '',
      args: [],
    );
  }

  /// `文件名`
  String get filename {
    return Intl.message(
      '文件名',
      name: 'filename',
      desc: '',
      args: [],
    );
  }

  /// `铜`
  String get copper {
    return Intl.message(
      '铜',
      name: 'copper',
      desc: '',
      args: [],
    );
  }

  /// `银`
  String get silver {
    return Intl.message(
      '银',
      name: 'silver',
      desc: '',
      args: [],
    );
  }

  /// `金`
  String get gold {
    return Intl.message(
      '金',
      name: 'gold',
      desc: '',
      args: [],
    );
  }

  /// `当前`
  String get current_ {
    return Intl.message(
      '当前',
      name: 'current_',
      desc: '',
      args: [],
    );
  }

  /// `关注`
  String get favorite {
    return Intl.message(
      '关注',
      name: 'favorite',
      desc: '',
      args: [],
    );
  }

  /// `重置`
  String get reset {
    return Intl.message(
      '重置',
      name: 'reset',
      desc: '',
      args: [],
    );
  }

  /// `普通素材`
  String get item_category_usual {
    return Intl.message(
      '普通素材',
      name: 'item_category_usual',
      desc: '',
      args: [],
    );
  }

  /// `铜素材`
  String get item_category_copper {
    return Intl.message(
      '铜素材',
      name: 'item_category_copper',
      desc: '',
      args: [],
    );
  }

  /// `银素材`
  String get item_category_silver {
    return Intl.message(
      '银素材',
      name: 'item_category_silver',
      desc: '',
      args: [],
    );
  }

  /// `金素材`
  String get item_category_gold {
    return Intl.message(
      '金素材',
      name: 'item_category_gold',
      desc: '',
      args: [],
    );
  }

  /// `特殊素材`
  String get item_category_special {
    return Intl.message(
      '特殊素材',
      name: 'item_category_special',
      desc: '',
      args: [],
    );
  }

  /// `技能石`
  String get item_category_gems {
    return Intl.message(
      '技能石',
      name: 'item_category_gems',
      desc: '',
      args: [],
    );
  }

  /// `辉石`
  String get item_category_gem {
    return Intl.message(
      '辉石',
      name: 'item_category_gem',
      desc: '',
      args: [],
    );
  }

  /// `魔石`
  String get item_category_magic_gem {
    return Intl.message(
      '魔石',
      name: 'item_category_magic_gem',
      desc: '',
      args: [],
    );
  }

  /// `秘石`
  String get item_category_secret_gem {
    return Intl.message(
      '秘石',
      name: 'item_category_secret_gem',
      desc: '',
      args: [],
    );
  }

  /// `职阶棋子`
  String get item_category_ascension {
    return Intl.message(
      '职阶棋子',
      name: 'item_category_ascension',
      desc: '',
      args: [],
    );
  }

  /// `银棋`
  String get item_category_piece {
    return Intl.message(
      '银棋',
      name: 'item_category_piece',
      desc: '',
      args: [],
    );
  }

  /// `金像`
  String get item_category_monument {
    return Intl.message(
      '金像',
      name: 'item_category_monument',
      desc: '',
      args: [],
    );
  }

  /// `活动从者灵基再临素材`
  String get item_category_event_svt_ascension {
    return Intl.message(
      '活动从者灵基再临素材',
      name: 'item_category_event_svt_ascension',
      desc: '',
      args: [],
    );
  }

  /// `其他`
  String get item_category_others {
    return Intl.message(
      '其他',
      name: 'item_category_others',
      desc: '',
      args: [],
    );
  }

  /// `效率剧场`
  String get fgo_domus_aurea {
    return Intl.message(
      '效率剧场',
      name: 'fgo_domus_aurea',
      desc: '',
      args: [],
    );
  }

  /// `版本`
  String get version {
    return Intl.message(
      '版本',
      name: 'version',
      desc: '',
      args: [],
    );
  }

  /// `检查更新`
  String get check_update {
    return Intl.message(
      '检查更新',
      name: 'check_update',
      desc: '',
      args: [],
    );
  }

  /// `复制`
  String get copy {
    return Intl.message(
      '复制',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `现有AP`
  String get cur_ap {
    return Intl.message(
      '现有AP',
      name: 'cur_ap',
      desc: '',
      args: [],
    );
  }

  /// `最大AP`
  String get max_ap {
    return Intl.message(
      '最大AP',
      name: 'max_ap',
      desc: '',
      args: [],
    );
  }

  /// `计算`
  String get calculate {
    return Intl.message(
      '计算',
      name: 'calculate',
      desc: '',
      args: [],
    );
  }

  /// `AP溢出时间`
  String get ap_overflow_time {
    return Intl.message(
      'AP溢出时间',
      name: 'ap_overflow_time',
      desc: '',
      args: [],
    );
  }

  /// `口算不及格的咕朗台.jpg`
  String get ap_calc_page_joke {
    return Intl.message(
      '口算不及格的咕朗台.jpg',
      name: 'ap_calc_page_joke',
      desc: '',
      args: [],
    );
  }

  /// `数据管理`
  String get settings_data_management {
    return Intl.message(
      '数据管理',
      name: 'settings_data_management',
      desc: '',
      args: [],
    );
  }

  /// `使用移动数据下载`
  String get settings_use_mobile_network {
    return Intl.message(
      '使用移动数据下载',
      name: 'settings_use_mobile_network',
      desc: '',
      args: [],
    );
  }

  /// `包含现有素材`
  String get statistics_include_checkbox {
    return Intl.message(
      '包含现有素材',
      name: 'statistics_include_checkbox',
      desc: '',
      args: [],
    );
  }

  /// `关于`
  String get settings_about {
    return Intl.message(
      '关于',
      name: 'settings_about',
      desc: '',
      args: [],
    );
  }

  /// `　本应用所使用数据均来源于游戏及以下网站，游戏图片文本原文等版权属于TYPE MOON/FGO PROJECT。\n　程序功能与界面设计参考微信小程序"素材规划"以及iOS版Guda。`
  String get about_app_declaration_text {
    return Intl.message(
      '　本应用所使用数据均来源于游戏及以下网站，游戏图片文本原文等版权属于TYPE MOON/FGO PROJECT。\n　程序功能与界面设计参考微信小程序"素材规划"以及iOS版Guda。',
      name: 'about_app_declaration_text',
      desc: '',
      args: [],
    );
  }

  /// `数据来源`
  String get about_data_source {
    return Intl.message(
      '数据来源',
      name: 'about_data_source',
      desc: '',
      args: [],
    );
  }

  /// `若存在未标注的来源或侵权敬请告知`
  String get about_data_source_footer {
    return Intl.message(
      '若存在未标注的来源或侵权敬请告知',
      name: 'about_data_source_footer',
      desc: '',
      args: [],
    );
  }

  /// `反馈`
  String get about_feedback {
    return Intl.message(
      '反馈',
      name: 'about_feedback',
      desc: '',
      args: [],
    );
  }

  /// `请附上出错页面截图和日志`
  String get about_email_subtitle {
    return Intl.message(
      '请附上出错页面截图和日志',
      name: 'about_email_subtitle',
      desc: '',
      args: [],
    );
  }

  /// `请将出错页面的截图以及日志文件发送到以下邮箱:\n {email}\n日志文件路径: {logPath}`
  String about_email_dialog(Object email, Object logPath) {
    return Intl.message(
      '请将出错页面的截图以及日志文件发送到以下邮箱:\n $email\n日志文件路径: $logPath',
      name: 'about_email_dialog',
      desc: '',
      args: [email, logPath],
    );
  }

  /// `NGA`
  String get nga {
    return Intl.message(
      'NGA',
      name: 'nga',
      desc: '',
      args: [],
    );
  }

  /// `NGA-FGO`
  String get nga_fgo {
    return Intl.message(
      'NGA-FGO',
      name: 'nga_fgo',
      desc: '',
      args: [],
    );
  }

  /// `App Store评分`
  String get about_appstore_rating {
    return Intl.message(
      'App Store评分',
      name: 'about_appstore_rating',
      desc: '',
      args: [],
    );
  }

  /// `应用更新`
  String get about_update_app {
    return Intl.message(
      '应用更新',
      name: 'about_update_app',
      desc: '',
      args: [],
    );
  }

  /// `当前版本: {curVersion}\n最新版本: {newVersion}\n跳转到浏览器下载`
  String about_update_app_detail(Object curVersion, Object newVersion) {
    return Intl.message(
      '当前版本: $curVersion\n最新版本: $newVersion\n跳转到浏览器下载',
      name: 'about_update_app_detail',
      desc: '',
      args: [curVersion, newVersion],
    );
  }

  /// `请在App Store中检查更新`
  String get about_update_app_alert_ios_mac {
    return Intl.message(
      '请在App Store中检查更新',
      name: 'about_update_app_alert_ios_mac',
      desc: '',
      args: [],
    );
  }

  /// `剩余`
  String get item_left {
    return Intl.message(
      '剩余',
      name: 'item_left',
      desc: '',
      args: [],
    );
  }

  /// `拥有`
  String get item_own {
    return Intl.message(
      '拥有',
      name: 'item_own',
      desc: '',
      args: [],
    );
  }

  /// `共需`
  String get item_total_demand {
    return Intl.message(
      '共需',
      name: 'item_total_demand',
      desc: '',
      args: [],
    );
  }

  /// `{first, select, true{已经是第一张} false{已经是最后一张} other{已经到头了}}`
  String list_end_hint(Object first) {
    return Intl.select(
      first,
      {
        'true': '已经是第一张',
        'false': '已经是最后一张',
        'other': '已经到头了',
      },
      name: 'list_end_hint',
      desc: '',
      args: [first],
    );
  }

  /// `上一张`
  String get previous_card {
    return Intl.message(
      '上一张',
      name: 'previous_card',
      desc: '',
      args: [],
    );
  }

  /// `下一张`
  String get next_card {
    return Intl.message(
      '下一张',
      name: 'next_card',
      desc: '',
      args: [],
    );
  }

  /// `画师`
  String get illustrator {
    return Intl.message(
      '画师',
      name: 'illustrator',
      desc: '',
      args: [],
    );
  }

  /// `稀有度`
  String get rarity {
    return Intl.message(
      '稀有度',
      name: 'rarity',
      desc: '',
      args: [],
    );
  }

  /// `查看卡面`
  String get view_illustration {
    return Intl.message(
      '查看卡面',
      name: 'view_illustration',
      desc: '',
      args: [],
    );
  }

  /// `获取方式`
  String get obtain_methods {
    return Intl.message(
      '获取方式',
      name: 'obtain_methods',
      desc: '',
      args: [],
    );
  }

  /// `持有技能`
  String get active_skill {
    return Intl.message(
      '持有技能',
      name: 'active_skill',
      desc: '',
      args: [],
    );
  }

  /// `职阶技能`
  String get passive_skill {
    return Intl.message(
      '职阶技能',
      name: 'passive_skill',
      desc: '',
      args: [],
    );
  }

  /// `解说`
  String get card_description {
    return Intl.message(
      '解说',
      name: 'card_description',
      desc: '',
      args: [],
    );
  }

  /// `筛选`
  String get filter {
    return Intl.message(
      '筛选',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `显示`
  String get filter_shown_type {
    return Intl.message(
      '显示',
      name: 'filter_shown_type',
      desc: '',
      args: [],
    );
  }

  /// `排序`
  String get filter_sort {
    return Intl.message(
      '排序',
      name: 'filter_sort',
      desc: '',
      args: [],
    );
  }

  /// `序号`
  String get filter_sort_number {
    return Intl.message(
      '序号',
      name: 'filter_sort_number',
      desc: '',
      args: [],
    );
  }

  /// `职阶`
  String get filter_sort_class {
    return Intl.message(
      '职阶',
      name: 'filter_sort_class',
      desc: '',
      args: [],
    );
  }

  /// `星级`
  String get filter_sort_rarity {
    return Intl.message(
      '星级',
      name: 'filter_sort_rarity',
      desc: '',
      args: [],
    );
  }

  /// `分类`
  String get filter_category {
    return Intl.message(
      '分类',
      name: 'filter_category',
      desc: '',
      args: [],
    );
  }

  /// `属性`
  String get filter_atk_hp_type {
    return Intl.message(
      '属性',
      name: 'filter_atk_hp_type',
      desc: '',
      args: [],
    );
  }

  /// `已满`
  String get filter_plan_reached {
    return Intl.message(
      '已满',
      name: 'filter_plan_reached',
      desc: '',
      args: [],
    );
  }

  /// `未满`
  String get filter_plan_not_reached {
    return Intl.message(
      '未满',
      name: 'filter_plan_not_reached',
      desc: '',
      args: [],
    );
  }

  /// `技能练度`
  String get filter_skill_lv {
    return Intl.message(
      '技能练度',
      name: 'filter_skill_lv',
      desc: '',
      args: [],
    );
  }

  /// `获取方式`
  String get filter_obtain {
    return Intl.message(
      '获取方式',
      name: 'filter_obtain',
      desc: '',
      args: [],
    );
  }

  /// `阵营`
  String get filter_attribute {
    return Intl.message(
      '阵营',
      name: 'filter_attribute',
      desc: '',
      args: [],
    );
  }

  /// `性别`
  String get filter_gender {
    return Intl.message(
      '性别',
      name: 'filter_gender',
      desc: '',
      args: [],
    );
  }

  /// `特殊特性`
  String get filter_special_trait {
    return Intl.message(
      '特殊特性',
      name: 'filter_special_trait',
      desc: '',
      args: [],
    );
  }

  /// `Free本`
  String get free_quest {
    return Intl.message(
      'Free本',
      name: 'free_quest',
      desc: '',
      args: [],
    );
  }

  /// `点击 + 添加素材`
  String get drop_calc_empty_hint {
    return Intl.message(
      '点击 + 添加素材',
      name: 'drop_calc_empty_hint',
      desc: '',
      args: [],
    );
  }

  /// `{name}已存在`
  String item_already_exist_hint(Object name) {
    return Intl.message(
      '$name已存在',
      name: 'item_already_exist_hint',
      desc: '',
      args: [name],
    );
  }

  /// `最低AP`
  String get drop_calc_min_ap {
    return Intl.message(
      '最低AP',
      name: 'drop_calc_min_ap',
      desc: '',
      args: [],
    );
  }

  /// `优化`
  String get drop_calc_optimize {
    return Intl.message(
      '优化',
      name: 'drop_calc_optimize',
      desc: '',
      args: [],
    );
  }

  /// `求解`
  String get drop_calc_solve {
    return Intl.message(
      '求解',
      name: 'drop_calc_solve',
      desc: '',
      args: [],
    );
  }

  /// `帮助`
  String get help {
    return Intl.message(
      '帮助',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `计算结果仅供参考\n>>>最低AP：\n过滤AP较低的free, 但保证每个素材至少有一个关卡\n>>>选择国服则未实装的素材将被移除\n>>>优化：最低总次数或最低总AP\n`
  String get drop_calc_help_text {
    return Intl.message(
      '计算结果仅供参考\n>>>最低AP：\n过滤AP较低的free, 但保证每个素材至少有一个关卡\n>>>选择国服则未实装的素材将被移除\n>>>优化：最低总次数或最低总AP\n',
      name: 'drop_calc_help_text',
      desc: '',
      args: [],
    );
  }

  /// `输入无效`
  String get input_invalid_hint {
    return Intl.message(
      '输入无效',
      name: 'input_invalid_hint',
      desc: '',
      args: [],
    );
  }

  /// `限时活动`
  String get limited_event {
    return Intl.message(
      '限时活动',
      name: 'limited_event',
      desc: '',
      args: [],
    );
  }

  /// `主线记录`
  String get main_record {
    return Intl.message(
      '主线记录',
      name: 'main_record',
      desc: '',
      args: [],
    );
  }

  /// `素材交换券`
  String get exchange_ticket {
    return Intl.message(
      '素材交换券',
      name: 'exchange_ticket',
      desc: '',
      args: [],
    );
  }

  /// `交换券`
  String get exchange_ticket_short {
    return Intl.message(
      '交换券',
      name: 'exchange_ticket_short',
      desc: '',
      args: [],
    );
  }

  /// `复刻活动`
  String get rerun_event {
    return Intl.message(
      '复刻活动',
      name: 'rerun_event',
      desc: '',
      args: [],
    );
  }

  /// `圣杯替换为传承结晶 {n} 个`
  String event_rerun_replace_grail(Object n) {
    return Intl.message(
      '圣杯替换为传承结晶 $n 个',
      name: 'event_rerun_replace_grail',
      desc: '',
      args: [n],
    );
  }

  /// `有限池`
  String get event_lottery_limited {
    return Intl.message(
      '有限池',
      name: 'event_lottery_limited',
      desc: '',
      args: [],
    );
  }

  /// `无限池`
  String get event_lottery_unlimited {
    return Intl.message(
      '无限池',
      name: 'event_lottery_unlimited',
      desc: '',
      args: [],
    );
  }

  /// `最多{n}池`
  String event_lottery_limit_hint(Object n) {
    return Intl.message(
      '最多$n池',
      name: 'event_lottery_limit_hint',
      desc: '',
      args: [n],
    );
  }

  /// `池`
  String get event_lottery_unit {
    return Intl.message(
      '池',
      name: 'event_lottery_unit',
      desc: '',
      args: [],
    );
  }

  /// `商店/任务/点数/关卡掉落奖励`
  String get event_item_default {
    return Intl.message(
      '商店/任务/点数/关卡掉落奖励',
      name: 'event_item_default',
      desc: '',
      args: [],
    );
  }

  /// `其他`
  String get event_item_extra {
    return Intl.message(
      '其他',
      name: 'event_item_extra',
      desc: '',
      args: [],
    );
  }

  /// `收取素材`
  String get event_collect_items {
    return Intl.message(
      '收取素材',
      name: 'event_collect_items',
      desc: '',
      args: [],
    );
  }

  /// `所有素材添加到素材仓库，并将该活动移出规划`
  String get event_collect_item_confirm {
    return Intl.message(
      '所有素材添加到素材仓库，并将该活动移出规划',
      name: 'event_collect_item_confirm',
      desc: '',
      args: [],
    );
  }

  /// `活动未列入规划`
  String get event_not_planned {
    return Intl.message(
      '活动未列入规划',
      name: 'event_not_planned',
      desc: '',
      args: [],
    );
  }

  /// `章节`
  String get main_record_chapter {
    return Intl.message(
      '章节',
      name: 'main_record_chapter',
      desc: '',
      args: [],
    );
  }

  /// `固定掉落`
  String get main_record_fixed_drop {
    return Intl.message(
      '固定掉落',
      name: 'main_record_fixed_drop',
      desc: '',
      args: [],
    );
  }

  /// `掉落`
  String get main_record_fixed_drop_short {
    return Intl.message(
      '掉落',
      name: 'main_record_fixed_drop_short',
      desc: '',
      args: [],
    );
  }

  /// `通关奖励`
  String get main_record_bonus {
    return Intl.message(
      '通关奖励',
      name: 'main_record_bonus',
      desc: '',
      args: [],
    );
  }

  /// `奖励`
  String get main_record_bonus_short {
    return Intl.message(
      '奖励',
      name: 'main_record_bonus_short',
      desc: '',
      args: [],
    );
  }

  /// `AP效率`
  String get ap_efficiency {
    return Intl.message(
      'AP效率',
      name: 'ap_efficiency',
      desc: '',
      args: [],
    );
  }

  /// `掉率`
  String get drop_rate {
    return Intl.message(
      '掉率',
      name: 'drop_rate',
      desc: '',
      args: [],
    );
  }

  /// `无Free本`
  String get item_no_free_quests {
    return Intl.message(
      '无Free本',
      name: 'item_no_free_quests',
      desc: '',
      args: [],
    );
  }

  /// `材料富余量`
  String get item_exceed {
    return Intl.message(
      '材料富余量',
      name: 'item_exceed',
      desc: '',
      args: [],
    );
  }

  /// `灵基再临`
  String get ascension_up {
    return Intl.message(
      '灵基再临',
      name: 'ascension_up',
      desc: '',
      args: [],
    );
  }

  /// `技能升级`
  String get skill_up {
    return Intl.message(
      '技能升级',
      name: 'skill_up',
      desc: '',
      args: [],
    );
  }

  /// `灵衣开放`
  String get dress_up {
    return Intl.message(
      '灵衣开放',
      name: 'dress_up',
      desc: '',
      args: [],
    );
  }

  /// `圣杯转临`
  String get grail_up {
    return Intl.message(
      '圣杯转临',
      name: 'grail_up',
      desc: '',
      args: [],
    );
  }

  /// `选择规划`
  String get select_plan {
    return Intl.message(
      '选择规划',
      name: 'select_plan',
      desc: '',
      args: [],
    );
  }

  /// `规划`
  String get plan {
    return Intl.message(
      '规划',
      name: 'plan',
      desc: '',
      args: [],
    );
  }

  /// `技能`
  String get skill {
    return Intl.message(
      '技能',
      name: 'skill',
      desc: '',
      args: [],
    );
  }

  /// `宝具`
  String get nobel_phantasm {
    return Intl.message(
      '宝具',
      name: 'nobel_phantasm',
      desc: '',
      args: [],
    );
  }

  /// `资料`
  String get card_info {
    return Intl.message(
      '资料',
      name: 'card_info',
      desc: '',
      args: [],
    );
  }

  /// `卡面`
  String get illustration {
    return Intl.message(
      '卡面',
      name: 'illustration',
      desc: '',
      args: [],
    );
  }

  /// `语音`
  String get voice {
    return Intl.message(
      '语音',
      name: 'voice',
      desc: '',
      args: [],
    );
  }

  /// `灵衣`
  String get dress {
    return Intl.message(
      '灵衣',
      name: 'dress',
      desc: '',
      args: [],
    );
  }

  /// `初始获得`
  String get svt_obtain_initial {
    return Intl.message(
      '初始获得',
      name: 'svt_obtain_initial',
      desc: '',
      args: [],
    );
  }

  /// `圣晶石常驻`
  String get svt_obtain_permanent {
    return Intl.message(
      '圣晶石常驻',
      name: 'svt_obtain_permanent',
      desc: '',
      args: [],
    );
  }

  /// `剧情限定`
  String get svt_obtain_story {
    return Intl.message(
      '剧情限定',
      name: 'svt_obtain_story',
      desc: '',
      args: [],
    );
  }

  /// `活动赠送`
  String get svt_obtain_event {
    return Intl.message(
      '活动赠送',
      name: 'svt_obtain_event',
      desc: '',
      args: [],
    );
  }

  /// `期间限定`
  String get svt_obtain_limited {
    return Intl.message(
      '期间限定',
      name: 'svt_obtain_limited',
      desc: '',
      args: [],
    );
  }

  /// `友情点召唤`
  String get svt_obtain_friend_point {
    return Intl.message(
      '友情点召唤',
      name: 'svt_obtain_friend_point',
      desc: '',
      args: [],
    );
  }

  /// `无法召唤`
  String get svt_obtain_unavailable {
    return Intl.message(
      '无法召唤',
      name: 'svt_obtain_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `拷贝自其它规划`
  String get copy_plan_menu {
    return Intl.message(
      '拷贝自其它规划',
      name: 'copy_plan_menu',
      desc: '',
      args: [],
    );
  }

  /// `选择复制来源`
  String get select_copy_plan_source {
    return Intl.message(
      '选择复制来源',
      name: 'select_copy_plan_source',
      desc: '',
      args: [],
    );
  }

  /// `基础资料`
  String get svt_info_tab_base {
    return Intl.message(
      '基础资料',
      name: 'svt_info_tab_base',
      desc: '',
      args: [],
    );
  }

  /// `羁绊故事`
  String get svt_info_tab_bond_story {
    return Intl.message(
      '羁绊故事',
      name: 'svt_info_tab_bond_story',
      desc: '',
      args: [],
    );
  }

  /// `规划{index}`
  String plan_x(Object index) {
    return Intl.message(
      '规划$index',
      name: 'plan_x',
      desc: '',
      args: [index],
    );
  }

  /// `羁绊礼装`
  String get bond_craft {
    return Intl.message(
      '羁绊礼装',
      name: 'bond_craft',
      desc: '',
      args: [],
    );
  }

  /// `情人节礼装`
  String get valentine_craft {
    return Intl.message(
      '情人节礼装',
      name: 'valentine_craft',
      desc: '',
      args: [],
    );
  }

  /// `声优`
  String get info_cv {
    return Intl.message(
      '声优',
      name: 'info_cv',
      desc: '',
      args: [],
    );
  }

  /// `性别`
  String get info_gender {
    return Intl.message(
      '性别',
      name: 'info_gender',
      desc: '',
      args: [],
    );
  }

  /// `身高`
  String get info_height {
    return Intl.message(
      '身高',
      name: 'info_height',
      desc: '',
      args: [],
    );
  }

  /// `体重`
  String get info_weight {
    return Intl.message(
      '体重',
      name: 'info_weight',
      desc: '',
      args: [],
    );
  }

  /// `筋力`
  String get info_strength {
    return Intl.message(
      '筋力',
      name: 'info_strength',
      desc: '',
      args: [],
    );
  }

  /// `耐久`
  String get info_endurance {
    return Intl.message(
      '耐久',
      name: 'info_endurance',
      desc: '',
      args: [],
    );
  }

  /// `敏捷`
  String get info_agility {
    return Intl.message(
      '敏捷',
      name: 'info_agility',
      desc: '',
      args: [],
    );
  }

  /// `魔力`
  String get info_mana {
    return Intl.message(
      '魔力',
      name: 'info_mana',
      desc: '',
      args: [],
    );
  }

  /// `幸运`
  String get info_luck {
    return Intl.message(
      '幸运',
      name: 'info_luck',
      desc: '',
      args: [],
    );
  }

  /// `宝具`
  String get info_np {
    return Intl.message(
      '宝具',
      name: 'info_np',
      desc: '',
      args: [],
    );
  }

  /// `特性`
  String get info_trait {
    return Intl.message(
      '特性',
      name: 'info_trait',
      desc: '',
      args: [],
    );
  }

  /// `属性`
  String get info_alignment {
    return Intl.message(
      '属性',
      name: 'info_alignment',
      desc: '',
      args: [],
    );
  }

  /// `人形`
  String get info_human {
    return Intl.message(
      '人形',
      name: 'info_human',
      desc: '',
      args: [],
    );
  }

  /// `被EA特攻`
  String get info_weak_to_ea {
    return Intl.message(
      '被EA特攻',
      name: 'info_weak_to_ea',
      desc: '',
      args: [],
    );
  }

  /// `数值`
  String get info_value {
    return Intl.message(
      '数值',
      name: 'info_value',
      desc: '',
      args: [],
    );
  }

  /// `配卡`
  String get info_cards {
    return Intl.message(
      '配卡',
      name: 'info_cards',
      desc: '',
      args: [],
    );
  }

  /// `NP获得率`
  String get info_np_rate {
    return Intl.message(
      'NP获得率',
      name: 'info_np_rate',
      desc: '',
      args: [],
    );
  }

  /// `出星率`
  String get info_star_rate {
    return Intl.message(
      '出星率',
      name: 'info_star_rate',
      desc: '',
      args: [],
    );
  }

  /// `即死率`
  String get info_death_rate {
    return Intl.message(
      '即死率',
      name: 'info_death_rate',
      desc: '',
      args: [],
    );
  }

  /// `暴击权重`
  String get info_critical_rate {
    return Intl.message(
      '暴击权重',
      name: 'info_critical_rate',
      desc: '',
      args: [],
    );
  }

  /// `羁绊点数`
  String get info_bond_points {
    return Intl.message(
      '羁绊点数',
      name: 'info_bond_points',
      desc: '',
      args: [],
    );
  }

  /// `点数`
  String get info_bond_points_single {
    return Intl.message(
      '点数',
      name: 'info_bond_points_single',
      desc: '',
      args: [],
    );
  }

  /// `累积`
  String get info_bond_points_sum {
    return Intl.message(
      '累积',
      name: 'info_bond_points_sum',
      desc: '',
      args: [],
    );
  }

  /// `无羁绊礼装`
  String get hint_no_bond_craft {
    return Intl.message(
      '无羁绊礼装',
      name: 'hint_no_bond_craft',
      desc: '',
      args: [],
    );
  }

  /// `无情人节礼装`
  String get hint_no_valentine_craft {
    return Intl.message(
      '无情人节礼装',
      name: 'hint_no_valentine_craft',
      desc: '',
      args: [],
    );
  }

  /// `是`
  String get yes {
    return Intl.message(
      '是',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `否`
  String get no {
    return Intl.message(
      '否',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `未关注`
  String get svt_not_planned {
    return Intl.message(
      '未关注',
      name: 'svt_not_planned',
      desc: '',
      args: [],
    );
  }

  /// `已隐藏`
  String get svt_plan_hidden {
    return Intl.message(
      '已隐藏',
      name: 'svt_plan_hidden',
      desc: '',
      args: [],
    );
  }

  /// `圣杯`
  String get grail {
    return Intl.message(
      '圣杯',
      name: 'grail',
      desc: '',
      args: [],
    );
  }

  /// `灵基`
  String get ascension {
    return Intl.message(
      '灵基',
      name: 'ascension',
      desc: '',
      args: [],
    );
  }

  /// `灵基`
  String get ascension_short {
    return Intl.message(
      '灵基',
      name: 'ascension_short',
      desc: '',
      args: [],
    );
  }

  /// `宝具等级`
  String get nobel_phantasm_level {
    return Intl.message(
      '宝具等级',
      name: 'nobel_phantasm_level',
      desc: '',
      args: [],
    );
  }

  /// `圣杯等级`
  String get grail_level {
    return Intl.message(
      '圣杯等级',
      name: 'grail_level',
      desc: '',
      args: [],
    );
  }

  /// `强化`
  String get enhance {
    return Intl.message(
      '强化',
      name: 'enhance',
      desc: '',
      args: [],
    );
  }

  /// `练度最大化(310)`
  String get skilled_max10 {
    return Intl.message(
      '练度最大化(310)',
      name: 'skilled_max10',
      desc: '',
      args: [],
    );
  }

  /// `规划最大化(999)`
  String get plan_max9 {
    return Intl.message(
      '规划最大化(999)',
      name: 'plan_max9',
      desc: '',
      args: [],
    );
  }

  /// `规划最大化(310)`
  String get plan_max10 {
    return Intl.message(
      '规划最大化(310)',
      name: 'plan_max10',
      desc: '',
      args: [],
    );
  }

  /// `强化将扣除以下素材`
  String get enhance_warning {
    return Intl.message(
      '强化将扣除以下素材',
      name: 'enhance_warning',
      desc: '',
      args: [],
    );
  }

  /// `数据管理`
  String get dataset_management {
    return Intl.message(
      '数据管理',
      name: 'dataset_management',
      desc: '',
      args: [],
    );
  }

  /// `用户数据`
  String get userdata {
    return Intl.message(
      '用户数据',
      name: 'userdata',
      desc: '',
      args: [],
    );
  }

  /// `更新数据/版本/bug较多时，建议提前备份数据，卸载应用将导致内部备份丢失，及时转移到可靠的储存位置`
  String get settings_userdata_footer {
    return Intl.message(
      '更新数据/版本/bug较多时，建议提前备份数据，卸载应用将导致内部备份丢失，及时转移到可靠的储存位置',
      name: 'settings_userdata_footer',
      desc: '',
      args: [],
    );
  }

  /// `清除`
  String get clear {
    return Intl.message(
      '清除',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `清除用户数据`
  String get clear_userdata {
    return Intl.message(
      '清除用户数据',
      name: 'clear_userdata',
      desc: '',
      args: [],
    );
  }

  /// `用户数据已清除`
  String get userdata_cleared {
    return Intl.message(
      '用户数据已清除',
      name: 'userdata_cleared',
      desc: '',
      args: [],
    );
  }

  /// `分享`
  String get share {
    return Intl.message(
      '分享',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `备份成功`
  String get backup_success {
    return Intl.message(
      '备份成功',
      name: 'backup_success',
      desc: '',
      args: [],
    );
  }

  /// `打开`
  String get open {
    return Intl.message(
      '打开',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `"文件"应用/我的iPhone/Chaldea`
  String get ios_app_path {
    return Intl.message(
      '"文件"应用/我的iPhone/Chaldea',
      name: 'ios_app_path',
      desc: '',
      args: [],
    );
  }

  /// `导入`
  String get import_data {
    return Intl.message(
      '导入',
      name: 'import_data',
      desc: '',
      args: [],
    );
  }

  /// `成功导入数据`
  String get import_data_success {
    return Intl.message(
      '成功导入数据',
      name: 'import_data_success',
      desc: '',
      args: [],
    );
  }

  /// `导入失败，Error:\n{error}`
  String import_data_error(Object error) {
    return Intl.message(
      '导入失败，Error:\n$error',
      name: 'import_data_error',
      desc: '',
      args: [error],
    );
  }

  /// `导入Guda数据`
  String get import_guda_data {
    return Intl.message(
      '导入Guda数据',
      name: 'import_guda_data',
      desc: '',
      args: [],
    );
  }

  /// `导入从者数据`
  String get import_guda_servants {
    return Intl.message(
      '导入从者数据',
      name: 'import_guda_servants',
      desc: '',
      args: [],
    );
  }

  /// `导入素材数据`
  String get import_guda_items {
    return Intl.message(
      '导入素材数据',
      name: 'import_guda_items',
      desc: '',
      args: [],
    );
  }

  /// `更新：保留本地数据并用导入的数据更新(推荐)\n覆盖：清楚本地数据再导入数据`
  String get import_guda_hint {
    return Intl.message(
      '更新：保留本地数据并用导入的数据更新(推荐)\n覆盖：清楚本地数据再导入数据',
      name: 'import_guda_hint',
      desc: '',
      args: [],
    );
  }

  /// `从者数据`
  String get guda_servant_data {
    return Intl.message(
      '从者数据',
      name: 'guda_servant_data',
      desc: '',
      args: [],
    );
  }

  /// `素材数据`
  String get guda_item_data {
    return Intl.message(
      '素材数据',
      name: 'guda_item_data',
      desc: '',
      args: [],
    );
  }

  /// `更新`
  String get update {
    return Intl.message(
      '更新',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `覆盖`
  String get overwrite {
    return Intl.message(
      '覆盖',
      name: 'overwrite',
      desc: '',
      args: [],
    );
  }

  /// `完整数据包`
  String get dataset_type_entire {
    return Intl.message(
      '完整数据包',
      name: 'dataset_type_entire',
      desc: '',
      args: [],
    );
  }

  /// `包含文本和图片，~25M`
  String get dataset_type_entire_hint {
    return Intl.message(
      '包含文本和图片，~25M',
      name: 'dataset_type_entire_hint',
      desc: '',
      args: [],
    );
  }

  /// `文本数据包`
  String get dataset_type_text {
    return Intl.message(
      '文本数据包',
      name: 'dataset_type_text',
      desc: '',
      args: [],
    );
  }

  /// `不包含图片，~5M`
  String get dataset_type_text_hint {
    return Intl.message(
      '不包含图片，~5M',
      name: 'dataset_type_text_hint',
      desc: '',
      args: [],
    );
  }

  /// `前往下载页`
  String get dataset_goto_download_page {
    return Intl.message(
      '前往下载页',
      name: 'dataset_goto_download_page',
      desc: '',
      args: [],
    );
  }

  /// `下载后手动导入`
  String get dataset_goto_download_page_hint {
    return Intl.message(
      '下载后手动导入',
      name: 'dataset_goto_download_page_hint',
      desc: '',
      args: [],
    );
  }

  /// `下载源`
  String get download_source {
    return Intl.message(
      '下载源',
      name: 'download_source',
      desc: '',
      args: [],
    );
  }

  /// `源{name}`
  String download_source_of(Object name) {
    return Intl.message(
      '源$name',
      name: 'download_source_of',
      desc: '',
      args: [name],
    );
  }

  /// `游戏数据和应用更新`
  String get download_source_hint {
    return Intl.message(
      '游戏数据和应用更新',
      name: 'download_source_hint',
      desc: '',
      args: [],
    );
  }

  /// `重置从者强化本状态`
  String get reset_svt_enhance_state {
    return Intl.message(
      '重置从者强化本状态',
      name: 'reset_svt_enhance_state',
      desc: '',
      args: [],
    );
  }

  /// `宝具本/技能本恢复成国服状态`
  String get reset_svt_enhance_state_hint {
    return Intl.message(
      '宝具本/技能本恢复成国服状态',
      name: 'reset_svt_enhance_state_hint',
      desc: '',
      args: [],
    );
  }

  /// `已重置`
  String get reset_success {
    return Intl.message(
      '已重置',
      name: 'reset_success',
      desc: '',
      args: [],
    );
  }

  /// `游戏数据`
  String get gamedata {
    return Intl.message(
      '游戏数据',
      name: 'gamedata',
      desc: '',
      args: [],
    );
  }

  /// `下载最新数据`
  String get download_latest_gamedata {
    return Intl.message(
      '下载最新数据',
      name: 'download_latest_gamedata',
      desc: '',
      args: [],
    );
  }

  /// `重新载入预装版本`
  String get reload_default_gamedata {
    return Intl.message(
      '重新载入预装版本',
      name: 'reload_default_gamedata',
      desc: '',
      args: [],
    );
  }

  /// `导入中`
  String get reloading_data {
    return Intl.message(
      '导入中',
      name: 'reloading_data',
      desc: '',
      args: [],
    );
  }

  /// `导入成功`
  String get reload_data_success {
    return Intl.message(
      '导入成功',
      name: 'reload_data_success',
      desc: '',
      args: [],
    );
  }

  /// `删除所有数据`
  String get delete_all_data {
    return Intl.message(
      '删除所有数据',
      name: 'delete_all_data',
      desc: '',
      args: [],
    );
  }

  /// `包含用户数据、游戏数据、图片资源, 并加载默认资源`
  String get delete_all_data_hint {
    return Intl.message(
      '包含用户数据、游戏数据、图片资源, 并加载默认资源',
      name: 'delete_all_data_hint',
      desc: '',
      args: [],
    );
  }

  /// `总计: {total}`
  String search_result_count(Object total) {
    return Intl.message(
      '总计: $total',
      name: 'search_result_count',
      desc: '',
      args: [total],
    );
  }

  /// `总计: {total} (隐藏: {hidden})`
  String search_result_count_hide(Object total, Object hidden) {
    return Intl.message(
      '总计: $total (隐藏: $hidden)',
      name: 'search_result_count_hide',
      desc: '',
      args: [total, hidden],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'zh'),
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'TW'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);

  @override
  Future<S> load(Locale locale) => S.load(locale);

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}
