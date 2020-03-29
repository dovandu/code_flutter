class Util {
  static int indexOf(haystack, needle) {
    return needle is RegExp
        ? haystack.search(needle)
        : haystack.indexOf(needle);
  }

  static String between(String haystack, String left, String right) {
    int pos = indexOf(haystack, left);
    if (pos == -1) {
      return '';
    }
    // print(pos);
    haystack = haystack.substring(pos + left.length);
    pos = indexOf(haystack, right);
    if (pos == -1) {
      return '';
    }
    haystack = haystack.substring(0, pos);
    return haystack;
  }

  static String stripHTML(String html) {
    return html
        .replaceAll(RegExp('r"[\n\r]'), ' ')
        .replaceAll(RegExp('r"\s*<\s*br\s*\/?\s*>\s*"', caseSensitive: false), '\n')
        .replaceAll(RegExp('r"<\s*\/\s*p\s*>\s*<\s*p[^>]*>"', caseSensitive: false), '\n')
        .replaceAll(RegExp('r"<.*?>"', caseSensitive: false), '')
        .trim();
  }

  static List parseFormats(Map info) {
    List formats = [];
    var stream = info['player_response']['streamingData'];
    if (stream != null) {
      if (stream['formats'] != null) {
        formats.addAll(stream['formats']);
      }
      if (stream['adaptiveFormats'] != null) {
        formats.addAll(stream['adaptiveFormats']);
      }
    }
    return formats;
  }

//   static addFormatMeta(format) {
//   format = Object.assign({}, FORMATS[format.itag], format);
//   format.container = format.mimeType ?
//     format.mimeType.split(';')[0].split('/')[1] : null;
//   format.codecs = format.mimeType ?
//     exports.between(format.mimeType, 'codecs="', '"') : null;
//   format.live = /\/source\/yt_live_broadcast\//.test(format.url);
//   format.isHLS = /\/manifest\/hls_(variant|playlist)\//.test(format.url);
//   format.isDashMPD = /\/manifest\/dash\//.test(format.url);
//   return format;
// }
}