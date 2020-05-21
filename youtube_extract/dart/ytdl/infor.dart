import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutterapp/ytdl/info_model.dart';
import 'package:flutterapp/ytdl/sig.dart';
import 'package:flutterapp/ytdl/util.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Infor {
  static final String VIDEO_URL = 'https://www.youtube.com/watch?v=';
  static final String EMBED_URL = 'https://www.youtube.com/embed/';
  static final String VIDEO_EURL = 'https://youtube.googleapis.com/v/';
  static final String INFO_HOST = 'www.youtube.com';
  static final String INFO_PATH = '/get_video_info';
  static final String SERVER_INFO = 'server/info';
  static final int EXPIRE = 4;

  static Infor instance;
  static SharedPreferences prefs;

  static Infor getInstance() {
    if (instance == null) {
      instance = Infor();
    }
    return instance;
  }

  Future _getBasicInfo(String id) async {
    const params = 'hl=en';
    var url = VIDEO_URL +
        id +
        '&' +
        params +
        '&bpctr=${(DateTime.now().millisecondsSinceEpoch / 1000).toInt()}';

    // Remove header from watch page request.
    // Otherwise, it'll use a different framework for rendering content.
    var headers = {'User-Agent': ''};
    var _client = http.Client();
    var res = await _client.get(url, headers: headers);
    var body = res.body;
    // print(body);

    String unavailableMsg =
        Util.between(body, '<div id="player-unavailable"', '>');
    // print(RegExp('r"!/\bhid\b/"')
    //         .hasMatch(between(unavailableMsg, 'class="', '"')));
    if (unavailableMsg != null &&
        RegExp('r"!\bhid\b"')
            .hasMatch(Util.between(unavailableMsg, 'class="', '"'))) {
      // Ignore error about age restriction.
      if (!body.contains('<div id="watch7-player-age-gate-content"')) {
        throw Exception(Util.between(
                body, '<h1 id="unavailable-message" class="message">', '</h1>')
            .trim());
      }
    }

    String jsonStr = Util.between(body, 'ytplayer.config = ', '</script>');
    // print(jsonStr);
    var config;
    if (jsonStr != null) {
      config = jsonStr.substring(0, jsonStr.lastIndexOf(';ytplayer.load'));
      // print(config);
      return await _gotConfig(id, null, null, config, false);
    } else {
      // If the video page doesn't work, maybe because it has mature content.
      // and requires an account logged in to view, try the embed page.
      url = EMBED_URL + id + '?' + params;
      // let [, body] = await miniget.promise(url, options.requestOptions);
      var res2 = await _client.get(url, headers: headers);
      var body2 = res2.body;
      config = Util.between(
          body2, 't.setConfig({\'PLAYER_CONFIG\': ', "\}(,'|\}\);)");
      return await _gotConfig(id, null, null, config, true);
    }
  }

  /**
 * @param {Object} id
 * @param {Object} options
 * @param {Object} additional
 * @param {Object} config
 * @param {boolean} fromEmbed
 * @return {Promise<Object>}
 */
  Future _gotConfig(id, options, additional, configStr, fromEmbed) async {
    if (configStr == null) {
      throw Exception('Could not find player config');
    }
    Map config;
    try {
      config = json.decode(configStr + (fromEmbed ? '}' : ''));
      // print(config);
    } catch (err) {
      throw Exception('Error parsing config: ' + err.message);
    }
    String url =
        'https://$INFO_HOST$INFO_PATH?video_id=$id&eurl=${VIDEO_EURL + id}&ps=default&gl=US&hl=en';
    if (config != null && config.containsKey('sts')) {
      url = url + '&sts=${config['sts']}';
    }
    // var query = {
    //     'video_id': id,
    //     'eurl': VIDEO_EURL + id,
    //     'ps': 'default',
    //     'gl': 'US',
    //     'hl':  'en',
    //     'sts': config.sts,
    //   };
    var _client = http.Client();
    var res = await _client.get(url);
    var body = res.body;
    // let info = querystring.parse(body);
    var infoOb = Uri.splitQueryString(body);
    Map info = {};
    info.addAll(infoOb);

    var playerResponse =
        config['args']['player_response'] ?? info['player_response'];

    if (info['status'] == 'fail') {
      throw Exception(
          'Code ${info['errorcode']}: ${Util.stripHTML(info['reason'])}');
    } else
      try {
        info['player_response'] = json.decode(playerResponse);
      } catch (err) {
        throw Exception('Error parsing `player_response`: ' + err.message);
      }

    var playability = info['player_response']['playabilityStatus'];
    if (playability != null && playability['status'] == 'UNPLAYABLE') {
      throw Exception(Util.stripHTML(playability['reason']));
    }

    info['formats'] = Util.parseFormats(info);
    // debugPrint('info.formats ${info['formats']}', wrapWidth: 100000);

    // info.addAll(additional);

    info['video_id'] = id;
    info['video_url'] = VIDEO_URL + id;
    info['length_seconds'] = info['player_response']['videoDetails'] != null
        ? info['player_response']['videoDetails']['lengthSeconds']
        : '';
    info['title'] = info['player_response']['videoDetails'] != null
        ? info['player_response']['videoDetails']['title']
        : '';
    info['age_restricted'] = fromEmbed;
    info['html5player'] = config['assets']['js'];
    // print(info);
    return info;
  }

/**
 * Gets info from a video additional formats and deciphered URLs.
 *
 * @param {string} id
 * @param {Object} options
 * @return {Promise<Object>}
 */
  Future<InfoModel> getFullInfo(id) async {
    prefs ??= await SharedPreferences.getInstance();
    String inforStr = prefs.getString(id);
    print('inforStr ==> $inforStr');
    if (inforStr != null) {
      var obJson = json.decode(inforStr);
      InfoModel ob = InfoModel.fromJson(obJson);
      DateTime ex = ob.expire;
      if (ex.difference(DateTime.now()).inHours < EXPIRE) {
        return ob;
      }
    }

    var info = await _getBasicInfo(id);

    var _client = http.Client();
    var res = await _client
        .post(SERVER_INFO, body: {'info_extrac': json.encode(info)});
    var body = res.body;
    Map resJson = json.decode(body);
    if (!resJson['success']) {
      throw Exception('Video not found');
    }
    String url = resJson['data']['url'];
    InfoModel mode = InfoModel(id: id, url: url, expire: DateTime.now());
    prefs.setString(id, json.encode(mode.toJson()));
    return mode;

//    var playerResponse = info['player_response'];
//    bool hasManifest = playerResponse != null &&
//        playerResponse['streamingData'] != null &&
//        (playerResponse['streamingData']['dashManifestUrl'] != null ||
//            playerResponse['streamingData']['hlsManifestUrl'] != null);
//    List formats = info['formats'];
//    if ((formats == null || formats.isEmpty) && !hasManifest) {
//      throw Exception('This video is unavailable');
//    }
//    var html5playerfile = Uri.parse(VIDEO_URL).resolve(info['html5player']);
//    print('html5playerfile $html5playerfile');

//    var tokens = await Sig.getTokens(html5playerfile);
//
//    log('tokens $tokens');
//
//    Sig.decipherFormats(formats, tokens);
//
//    debugPrint('format, $formats');

    // let funcs = [];
    // if (hasManifest && info.player_response.streamingData.dashManifestUrl) {
    //   let url = info.player_response.streamingData.dashManifestUrl;
    //   funcs.push(getDashManifest(url, options));
    // }
    // if (hasManifest && info.player_response.streamingData.hlsManifestUrl) {
    //   let url = info.player_response.streamingData.hlsManifestUrl;
    //   funcs.push(getM3U8(url, options));
    // }

    // let results = await Promise.all(funcs);
    // if (results[0]) { mergeFormats(info, results[0]); }
    // if (results[1]) { mergeFormats(info, results[1]); }

    // info.formats = info.formats.map(Util.addFormatMeta);
    // info.formats.sort(Util.sortFormats);
    // info.full = true;
  }
}
