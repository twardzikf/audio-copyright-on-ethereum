const express = require('express')
const fpcalc = require('fpcalc')
const bodyParser = require('body-parser')
const fileUpload = require('express-fileupload')
const cors = require('cors')
const app = express()

app.use(fileUpload({
    createParentPath: true
}));
app.use(bodyParser.urlencoded({extended: true}));
app.use(bodyParser.json());
app.use(cors());
const port = 3000


function calculateFingerprint() {
    const fingerprint = fpcalc("./audio.mp3", function (err, result) {
        if (err) throw err;
        return result.fingerprint;
    });
    return fingerprint;
}

// app.post('/', (req, res) => {
//     console.log('Got body:', req.body);
//     console.log(req.files);
//     res.send();
//     // res.send(calculateFingerprint());
// })

app.post('/', (req, res) => {
    try {
        if(!req.files) {
            res.send({
                status: false,
                message: 'No file uploaded'
            });
        } else {
            let song = req.files.song;
            song.mv('./audio_files/' + song.name);
            fpcalc("./audio_files/" + song.name, function (err, result) {
                if (err) throw err;
                console.log(result.fingerprint);
                res.send({
                    status: 200,
                    data: {
                        fingerprint: result.fingerprint
                    }
                });
            });
        }
    } catch (err) {
        res.status(500).send(err);
    }
});

app.listen(port, () => console.log(`Example app listening at http://localhost:${port}`))