import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

var cache = new Map();

class Sig {
  static final jsVarStr = "[a-zA-Z_\\\$][a-zA-Z_0-9]*";
  static final jsSingleQuoteStr = "'[^'\\\\]*(:?\\\\[\\s\\S][^'\\\\]*)*'";
  static final jsDoubleQuoteStr = '"[^"\\\\]*(:?\\\\[\\s\\S][^"\\\\]*)*"';
  static final jsQuoteStr = '(?:$jsSingleQuoteStr|$jsDoubleQuoteStr)';
  static final jsKeyStr = '(?:$jsVarStr|$jsQuoteStr)';
  static final jsPropStr = '(?:\\.$jsVarStr|\\[$jsQuoteStr\\])';
  static final jsEmptyStr = '(?:' '|"")';
  // static final reverseStr =
  //     ':function\\(a\\)\\{' + '(?:return )?a\\.reverse\\(\\)' + '\\}';
  static final reverseStr =
      ':function\\(a\\)\\{' + '(?:return )?a\\.reverse\\(\\)' + '\\}';
  static final sliceStr =
      ':function\\(a,b\\)\\{' + 'return a\\.slice\\(b\\)' + '\\}';
  static final spliceStr =
      ':function\\(a,b\\)\\{' + 'a\\.splice\\(0,b\\)' + '\\}';
  static final swapStr = ':function\\(a,b\\)\\{' +
      'var c=a\\[0\\];a\\[0\\]=a\\[b(?:%a\\.length)?\\];a\\[b(?:%a\\.length)?\\]=c(?:;return a)?' +
      '\\}';
  static RegExp actionsObjRegexp = RegExp('var ($jsVarStr)=\\{((?:(?:' +
      jsKeyStr +
      reverseStr +
      '|' +
      jsKeyStr +
      sliceStr +
      '|' +
      jsKeyStr +
      spliceStr +
      '|' +
      jsKeyStr +
      swapStr +
      '),?\\r?\\n?)+)\\};');
  static RegExp actionsFuncRegexp = RegExp('function(?: $jsVarStr)?\\(a\\)\\{' +
      'a=a\\.split\\($jsEmptyStr\\);\\s*' +
      '((?:(?:a=)?$jsVarStr' +
      jsPropStr +
      '\\(a,\\d+\\);)+)' +
      'return a\\.join\\($jsEmptyStr\\)' +
      '\\}');
  static RegExp reverseRegexp =
      RegExp('(?:^|,)($jsKeyStr)$reverseStr', multiLine: true);
  static RegExp sliceRegexp =
      RegExp('(?:^|,)($jsKeyStr)$sliceStr', multiLine: true);
  static RegExp spliceRegexp =
      RegExp('(?:^|,)($jsKeyStr)$spliceStr', multiLine: true);
  static RegExp swapRegexp =
      RegExp('(?:^|,)($jsKeyStr)$swapStr', multiLine: true);

  /**
 * Extract signature deciphering tokens from html5player file.
 *
 * @param {string} html5playerfile
 * @param {Object} options
 * @return {Promise<Array.<string>>}
 */
  static getTokens(html5playerfile) async {
    var cachedTokens = cache['html5playerfile'];
    if (cachedTokens != null) {
      return cachedTokens;
    } else {
      // let [, body] = await miniget.promise(html5playerfile, options.requestOptions);
      var _client = http.Client();
      var res = await _client.get(html5playerfile);
      var body = res.body;
      var tokens = extractActions(body);
      if (tokens == null || tokens.isEmpty) {
        throw Exception('Could not extract signature deciphering actions');
      }
      cache['html5playerfile'] = tokens;
      return tokens;
    }
  }

/**
 * Extracts the actions that should be taken to decipher a signature.
 *
 * This searches for a function that performs string manipulations on
 * the signature. We already know what the 3 possible changes to a signature
 * are in order to decipher it. There is
 *
 * * Reversing the string.
 * * Removing a number of characters from the beginning.
 * * Swapping the first character with another position.
 *
 * Note, 'Array#slice()' used to be used instead of 'Array#splice()',
 * it's kept in case we encounter any older html5player files.
 *
 * After retrieving the function that does this, we can see what actions
 * it takes on a signature.
 *
 * @param {string} body
 * @return {Array.<string>}
 */
  static extractActions(String body) {
    var objResultEx = actionsObjRegexp.allMatches(body);
    var funcResultEx = actionsFuncRegexp.allMatches(body);
    if (objResultEx == null || funcResultEx == null) {
      return null;
    }
    RegExpMatch objRes = objResultEx.first;
    RegExpMatch funcRes = funcResultEx.first;

    String obj = objRes.group(1).replaceAll(RegExp('r"\$"'), '\\\$');
    String objBody = objRes.group(2).replaceAll(RegExp('r"\$"'), '\\\$');
    String funcBody = funcRes.group(1).replaceAll(RegExp('r"\$"'), '\\\$');

    // print('objBody $objBody');
    // print('objBody ${reverseRegexp.hasMatch(objBody)}');
    // print('abcs ${objBody.contains(reverseRegexp)}');
    var resultEx = reverseRegexp.allMatches(objBody);
    // print('resultEx $resultEx');
    var result;
    var reverseKey;
    if (resultEx != null && resultEx.isNotEmpty) {
      result = resultEx.first;
      reverseKey = result
          .group(1)
          .replaceAll(RegExp('r"\$"'), '\\\$')
          .replaceAll(RegExp('r"\$|^\'|^"|\'\$|"\$"'), '');
    }

    var resultEx2 = sliceRegexp.allMatches(objBody);
    var sliceKey;
    if (resultEx2 != null && resultEx2.isNotEmpty) {
      result = resultEx2.first;
      sliceKey = result
          .group(1)
          .replaceAll(RegExp('r"\$"'), '\\\$')
          .replaceAll(RegExp('r"\$|^\'|^"|\'\$|"\$"'), '');
    }
    var resultEx3 = spliceRegexp.allMatches(objBody);
    var spliceKey;
    if (resultEx3 != null && resultEx3.isNotEmpty) {
      result = resultEx3.first;
      spliceKey = result
          .group(1)
          .replaceAll(RegExp('r"\$"'), '\\\$')
          .replaceAll(RegExp('r"\$|^\'|^"|\'\$|"\$"'), '');
    }

    var resultEx4 = swapRegexp.allMatches(objBody);
    var swapKey;
    if (resultEx4 != null && resultEx4.isNotEmpty) {
      result = resultEx4.first;
      swapKey = result
          .group(1)
          .replaceAll(RegExp('r"\$"'), '\\\$')
          .replaceAll(RegExp('r"\$|^\'|^"|\'\$|"\$"'), '');
    }

    var keys = '(${[
      reverseKey ?? '',
      sliceKey ?? '',
      spliceKey ?? '',
      swapKey ?? ''
    ].join('|')})';

    print('keys $keys');

    var myreg =
        '(?:a=)?$obj(?:\\.$keys|\\[\'$keys\'\\]|\\["$keys"\\])\\(a,(\\d+)\\)';

    var tokenizeRegexp = RegExp(myreg);
    var tokens = [];
    var resultEx5 = tokenizeRegexp.allMatches(funcBody);

    if (resultEx5 != null) {
      for (RegExpMatch item in resultEx5) {
        result = item.groups([0, 1, 2, 3, 4]);
        var key = result[1] ?? result[2] ?? result[3];
        if (key == swapKey) {
          tokens.add('w' + result[4]);
        } else if (key == reverseKey) {
          tokens.add('r');
        } else if (key == sliceKey) {
          tokens.add('s' + result[4]);
        } else if (key == spliceKey) {
          tokens.add('p' + result[4]);
        }
      }
    }
    print('while (result != null) $tokens');
    return tokens;
  }

  /**
 * @param {Object} format
 * @param {string} sig
 * @param {boolean} debug
 */
  static setDownloadURL(format, sig, {debug = true}) {
    var decodedUrl;
    if (format['url'] != null) {
      decodedUrl = format['url'];
    } else {
      if (debug) {
        print('Download url not found for itag ' + format['itag']);
        // console.warn('Download url not found for itag ' + format.itag);
      }
      return;
    }

    try {
      decodedUrl = Uri.decodeComponent(decodedUrl);
      debugPrint('setDownloadURLdecodedUrl $decodedUrl', wrapWidth: 100000);
    } catch (err) {
      if (debug) {
        print('Could not decode url: ' + err.message);
        // console.warn('Could not decode url: ' + err.message);
      }
      return;
    }

    // Make some adjustments to the final url.
    var parsedUrl = Uri.parse(decodedUrl);

    // debugPrint('setDownloadURLparsedUrl $parsedUrl', wrapWidth: 100000);

    // Deleting the 'search' part is necessary otherwise changes to
    // 'query' won't reflect when running 'url.format()'
    // delete parsedUrl.search;

    Map<String, String> query = {};
    query.addAll(parsedUrl.queryParameters);
    debugPrint('setDownloadURLquery $query', wrapWidth: 100000);
    // This is needed for a speedier download.
    // See https://github.com/fent/node-ytdl-core/issues/127
    query['ratebypass'] = 'yes';
    if (sig != null) {
      // When YouTube provides a 'sp' parameter the signature 'sig' must go
      // into the parameter it specifies.
      // See https://github.com/fent/node-ytdl-core/issues/417
      if (format['sp'] != null) {
        query[format['sp']] = sig;
      } else {
        query['signature'] = sig;
      }
    }
    parsedUrl.replace(queryParameters: query);
    String url = UriData.fromUri(parsedUrl).toString();
    debugPrint('setDownloadURLparsedUrl $url', wrapWidth: 100000);

    format['url'] = url;
  }

  /**
 * Applies 'sig.decipher()' to all format URL's.
 *
 * @param {Array.<Object>} formats
 * @param {Array.<string>} tokens
 * @param {boolean} debug
 */
  static decipherFormats(List formats, tokens) {
    for (int i = 0; i < formats.length; i++) {
      var format = formats[i];
      // log('decipherFormats  $format');
      if (format['cipher'] != null) {
        var cipher = Uri.splitQueryString(format['cipher']);
        // log('format.cipher ${format['cipher']}');
        // log('querystring.parse(format.cipher)  $cipher');
        format.addAll(cipher);
        format.remove('cipher');
      }
      var sig = tokens != null && format['s'] != null
          ? decipher(tokens, format['s'])
          : null;
      debugPrint('decipherFormatssig $sig', wrapWidth: 1000000);
      setDownloadURL(format, sig);
    }

    // formats.forEach((Map format) {
    //   if (format['cipher'] !=null) {
    //     Object.assign(format, Uri.parse(format['cipher']));
    //     delete format.cipher;
    //   }
    //   var sig = tokens && format.s ? decipher(tokens, format['s']) : null;
    //   setDownloadURL(format, sig);
    // });
  }

  /**
 * Decipher a signature based on action tokens.
 *
 * @param {Array.<string>} tokens
 * @param {string} sig
 * @return {string}
 */
  static String decipher(tokens, String sigStr) {
    debugPrint('deciphersigStr $sigStr', wrapWidth: 1000000);
    List<String> sig = sigStr.split('');
    for (int i = 0, len = tokens.length; i < len; i++) {
      var token = tokens[i];
      int pos;
      switch (token[0]) {
        case 'r':
          sig.reversed;
          break;
        case 'w':
          try {
            pos = int.parse(token.substring(1));
            sig = swapHeadAndPosition(sig, pos);
          } catch (e) {}
          break;
        case 's':
          try {
            pos = int.parse(token.substring(1));
            sig = swapHeadAndPosition(sig, pos);
          } catch (e) {}
          // pos = ~~token.slice(1);
          sig = sig.sublist(pos);
          break;
        case 'p':
          try {
            pos = int.parse(token.substring(1));
            sig = swapHeadAndPosition(sig, pos);
          } catch (e) {}
          // pos = ~~token.slice(1);
          sig.sublist(0, pos);
          break;
      }
      debugPrint('decipherpos $pos', wrapWidth: 1000000);
    }
    return sig.join('');
  }

/**
 * Swaps the first element of an array with one of given position.
 *
 * @param {Array.<Object>} arr
 * @param {number} position
 * @return {Array.<Object>}
 */
  static swapHeadAndPosition(arr, int position) {
    var first = arr[0];
    arr[0] = arr[position % arr.length];
    arr[position] = first;
    return arr;
  }
}
