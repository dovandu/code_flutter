const express = require('express')
const router = express.Router()
module.exports = router

const ytdl = require('../helpers/ytdl');

router.get('/', function (req, res) {
	res.send('UpBeat')
})



router.post('/info', async (req, res) => {
	try {
		const info_extrac = req.body.info_extrac;
		// console.log(abc);
		let data = await ytdl.getInfo(info_extrac);
		let format = ytdl.chooseFormat(data.formats, { quality: '18' });
		console.log(format);
		new Response({res, data: format}).sendSuccess()
	}
	catch (e) {
		new Response({res, message: e.message}).sendError()
	}
})