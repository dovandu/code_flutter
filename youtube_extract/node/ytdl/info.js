const urllib      = require('url');
const util        = require('./util');
const sig         = require('./sig');
const Cache       = require('./cache');

const VIDEO_URL = 'https://www.youtube.com/watch?v=';

/**
 * Gets info from a video additional formats and deciphered URLs.
 *
 * @param {string} id
 * @param {Object} options
 * @return {Promise<Object>}
 */
exports.getFullInfo = async (infoStr, options) => {
  // let info = await exports.getBasicInfo(id, options);
  let info = JSON.parse(infoStr);
  const hasManifest =
    info.player_response && info.player_response.streamingData && (
      info.player_response.streamingData.dashManifestUrl ||
      info.player_response.streamingData.hlsManifestUrl
    );
  if (!info.formats.length && !hasManifest) {
    throw Error('This video is unavailable');
  }
  // console.log('info.html5player', info.html5player)
  const html5playerfile = urllib.resolve(VIDEO_URL, info.html5player);
  // console.log('html5playerfile', html5playerfile)
  let tokens = await sig.getTokens(html5playerfile, options);
  // console.log('tokens')
  // console.log(tokens)
  // console.log('info.formats', info.formats);

  sig.decipherFormats(info.formats, tokens, false);

  // console.log('decipherFormats info.formats', info.formats);
  // console.log('decipherFormats tokens', tokens);

  info.formats = info.formats.map(util.addFormatMeta);
  info.formats.sort(util.sortFormats);
  info.full = true;
  // console.log('infoutilsortFormat', info.formats);
  return info;
};



// Cached for getting basic/full info.
exports.cache = new Cache();


