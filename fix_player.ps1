$marker = '<!-- ===================== FLOATING MUSIC PLAYER ===================== -->'

$player = @'
    <!-- ===================== FLOATING MUSIC PLAYER ===================== -->
    <style>
        #gjk-player { position: fixed; bottom: 24px; right: 24px; z-index: 9999; display: flex; flex-direction: column; align-items: flex-end; gap: 10px; font-family: 'Inter', sans-serif; }
        #gjk-player-card { background: rgba(11,15,26,0.95); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); border: 1px solid rgba(201,162,75,0.25); border-radius: 20px; padding: 16px 18px; width: 320px; box-shadow: 0 24px 60px -12px rgba(0,0,0,0.7); transition: transform .35s cubic-bezier(.2,.7,.2,1), opacity .35s ease; }
        #gjk-player-card.collapsed { transform: translateY(120%); opacity: 0; pointer-events: none; }
        html[data-theme='light'] #gjk-player-card { background: rgba(247,244,236,0.97); border-color: rgba(176,141,62,0.3); }
        .gjk-song-badge { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; }
        .gjk-badge-left { display: flex; align-items: center; gap: 6px; }
        .gjk-song-dot { width: 7px; height: 7px; border-radius: 999px; background: #C9A24B; animation: gjk-pulse 1.6s ease-in-out infinite; }
        .gjk-song-dot.paused { animation: none; background: rgba(201,162,75,0.4); }
        @keyframes gjk-pulse { 0%,100%{opacity:1;transform:scale(1)} 50%{opacity:.5;transform:scale(.7)} }
        .gjk-now-label { font-size: 10px; font-weight: 600; letter-spacing: .08em; text-transform: uppercase; color: #C9A24B; }
        .gjk-time-label { font-size: 10px; color: rgba(237,234,224,0.5); }
        #gjk-song-title { font-size: 14px; font-weight: 600; color: #EDEAE0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; margin-bottom: 2px; }
        html[data-theme='light'] #gjk-song-title { color: #1B2338; }
        #gjk-song-artist { font-size: 11px; color: rgba(237,234,224,0.5); margin-bottom: 12px; }
        html[data-theme='light'] #gjk-song-artist { color: rgba(27,35,56,0.55); }
        #gjk-progress-wrap { height: 5px; background: rgba(201,162,75,0.15); border-radius: 999px; margin-bottom: 12px; cursor: pointer; overflow: hidden; }
        #gjk-progress-bar { height: 100%; background: linear-gradient(90deg,#C9A24B,#E8D190); border-radius: 999px; width: 0%; transition: width .2s linear; }
        .gjk-controls { display: flex; align-items: center; justify-content: space-between; gap: 8px; margin-bottom: 12px; }
        .gjk-ctrl-btn { background: none; border: none; cursor: pointer; padding: 6px; border-radius: 99px; color: rgba(237,234,224,0.6); display: flex; align-items: center; justify-content: center; transition: color .2s; }
        .gjk-ctrl-btn:hover { color: #C9A24B; }
        #gjk-play-btn { width: 40px; height: 40px; border-radius: 999px; background: linear-gradient(135deg,#C9A24B,#8C7031); border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; color: #0B0F1A; box-shadow: 0 4px 14px rgba(201,162,75,0.35); transition: transform .2s; flex-shrink: 0; }
        #gjk-play-btn:hover { transform: scale(1.08); }
        .gjk-songs-row { display: flex; gap: 6px; flex-wrap: wrap; }
        .gjk-song-chip { font-size: 10px; padding: 4px 10px; border-radius: 999px; border: 1px solid rgba(201,162,75,0.25); color: rgba(237,234,224,0.5); background: transparent; cursor: pointer; transition: all .2s; }
        .gjk-song-chip:hover,.gjk-song-chip.active { border-color: #C9A24B; color: #C9A24B; }
        .gjk-song-chip.active { background: rgba(201,162,75,0.15); }
        #gjk-toggle-btn { width: 44px; height: 44px; border-radius: 999px; background: rgba(11,15,26,0.92); backdrop-filter: blur(12px); border: 1px solid rgba(201,162,75,0.3); cursor: pointer; display: flex; align-items: center; justify-content: center; color: #C9A24B; box-shadow: 0 8px 24px rgba(0,0,0,0.4); transition: transform .2s; }
        #gjk-toggle-btn:hover { transform: scale(1.1); }
        #gjk-file-picker { display: none; }
    </style>
    <div id='gjk-player'>
        <div id='gjk-player-card' class='collapsed'>
            <div class='gjk-song-badge'>
                <div class='gjk-badge-left'>
                    <div class='gjk-song-dot paused' id='gjk-dot'></div>
                    <span class='gjk-now-label' id='gjk-status-text'>Music Player</span>
                </div>
                <span class='gjk-time-label' id='gjk-time-display'>0:00 / 0:00</span>
            </div>
            <div id='gjk-song-title'>Rayuan Perempuan Gila</div>
            <div id='gjk-song-artist'>Nadin Amizah (Full Music)</div>
            <div id='gjk-progress-wrap'><div id='gjk-progress-bar'></div></div>
            <div class='gjk-controls'>
                <button class='gjk-ctrl-btn' id='gjk-prev' title='Lagu Sebelumnya'><svg width='18' height='18' viewBox='0 0 24 24' fill='currentColor'><path d='M6 6h2v12H6zm3.5 6 8.5 6V6z'/></svg></button>
                <button id='gjk-play-btn' title='Putar / Jeda'>
                    <svg id='gjk-icon-play' width='18' height='18' viewBox='0 0 24 24' fill='currentColor'><path d='M8 5v14l11-7z'/></svg>
                    <svg id='gjk-icon-pause' width='18' height='18' viewBox='0 0 24 24' fill='currentColor' style='display:none'><path d='M6 19h4V5H6v14zm8-14v14h4V5h-4z'/></svg>
                </button>
                <button class='gjk-ctrl-btn' id='gjk-next' title='Lagu Berikutnya'><svg width='18' height='18' viewBox='0 0 24 24' fill='currentColor'><path d='M6 18l8.5-6L6 6v12zm2-8.14L11.03 12 8 14.14V9.86zM16 6h2v12h-2z'/></svg></button>
                <label for='gjk-file-picker' class='gjk-ctrl-btn' title='Buka MP3 Lokal Lain'>
                    <svg width='18' height='18' viewBox='0 0 24 24' fill='currentColor'><path d='M9 16h6v-6h4l-7-7-7 7h4v6zm-4 2h14v2H5v-2z'/></svg>
                </label>
                <input type='file' id='gjk-file-picker' accept='audio/*'>
            </div>
            <div class='gjk-songs-row'>
                <button class='gjk-song-chip active' data-gjk-idx='0'>Rayuan Perempuan (Full)</button>
                <button class='gjk-song-chip' data-gjk-idx='1'>Best Part (Full)</button>
                <button class='gjk-song-chip' data-gjk-idx='2'>Sam Smith (Full)</button>
                <button class='gjk-song-chip' data-gjk-idx='3'>Love Yourself</button>
            </div>
        </div>
        <button id='gjk-toggle-btn' title='Buka Pemutar Musik'><svg width='20' height='20' viewBox='0 0 24 24' fill='currentColor'><path d='M12 3v10.55A4 4 0 1 0 14 17V7h4V3h-6z'/></svg></button>
    </div>

    <!-- Hidden HTML5 Audio Element for Full MP3 -->
    <audio id='gjk-audio-element' preload='metadata'></audio>

    <script>
    (function(){
        var audio = document.getElementById('gjk-audio-element');
        var filePicker = document.getElementById('gjk-file-picker');

        /* Piano synth for chord melody fallback */
        var _ac = null;
        function getAC() {
            if (!_ac) _ac = new (window.AudioContext || window.webkitAudioContext)();
            if (_ac.state === 'suspended') _ac.resume();
            return _ac;
        }

        function pianoNote(ac, semi, startT, beatSec, volScale) {
            if (semi <= -50) return;
            var v = volScale || 1.0;
            var f = 261.63 * Math.pow(2, semi / 12);
            var dur = beatSec * 0.92;
            var master = ac.createGain();
            master.connect(ac.destination);
            var harmonics = [1, 2, 3, 4, 5, 7];
            var volumes   = [0.50, 0.25, 0.12, 0.06, 0.03, 0.01];
            harmonics.forEach(function(h, i) {
                var osc = ac.createOscillator();
                osc.type = 'sine';
                osc.frequency.value = f * h;
                var g = ac.createGain();
                g.gain.value = volumes[i] * v;
                osc.connect(g);
                g.connect(master);
                osc.start(startT);
                osc.stop(startT + dur + 1.0);
            });
            var peak = 0.35 * v;
            master.gain.setValueAtTime(0.001, startT);
            master.gain.linearRampToValueAtTime(peak, startT + 0.007);
            master.gain.exponentialRampToValueAtTime(peak * 0.5, startT + 0.08);
            master.gain.setValueAtTime(peak * 0.5, startT + Math.max(0.01, dur - 0.03));
            master.gain.exponentialRampToValueAtTime(0.001, startT + dur + 0.95);
        }

        function playStep(ac, item, startT, beatSec) {
            if (typeof item === 'number') {
                pianoNote(ac, item, startT, beatSec, 1.0);
            } else if (Array.isArray(item)) {
                var vol = 0.7;
                item.forEach(function(n) { pianoNote(ac, n, startT, beatSec, vol); });
            }
        }

        var TRACKS = [
            {
                type: 'mp3',
                title: "Rayuan Perempuan Gila",
                artist: "Nadin Amizah (Full Music)",
                url: "Nadin Amizah - Rayuan Perempuan Gila (Lyric Video).mp3"
            },
            {
                type: 'mp3',
                title: "Best Part",
                artist: "H.E.R. ft. Daniel Caesar (Full Music)",
                url: "H.E.R. - Best Part (Lyrics) Ft. Daniel Caesar.mp3"
            },
            {
                type: 'mp3',
                title: "I'm Not The Only One",
                artist: "Sam Smith (Full Music)",
                url: "Sam Smith - I'm Not The Only One (Lyric Video).mp3"
            },
            {
                type: 'synth',
                title: 'Love Yourself',
                artist: 'Justin Bieber',
                bpm: 100,
                notes: [
                    [[-7, 4, 8, 11], 1.0], [[8, 11], 0.5], [[11, 13], 0.5],
                    [[-7, 4, 8, 11], 1.0], [[9, 11], 0.5], [[8, 9], 0.5],
                    [[-1, 11, 15, 18], 1.0], [[15, 18], 0.5], [[18, 20], 0.5],
                    [[-1, 11, 15, 18], 1.0], [[16, 18], 0.5], [[15, 16], 0.5],
                    [[-9, 13, 16, 20], 1.0], [[16, 20], 0.5], [[20, 21], 0.5],
                    [[-9, 13, 16, 20], 1.0], [[18, 20], 0.5], [[16, 18], 0.5],
                    [[-5, 6, 9, 13], 1.0], [[9, 13], 0.5], [[13, 14], 0.5],
                    [[-5, 6, 9, 13], 1.0], [[11, 13], 0.5], [[9, 11], 0.5]
                ]
            }
        ];

        /* DOM */
        var card     = document.getElementById('gjk-player-card'),
            toggleBtn= document.getElementById('gjk-toggle-btn'),
            playBtn  = document.getElementById('gjk-play-btn'),
            iconPlay = document.getElementById('gjk-icon-play'),
            iconPause= document.getElementById('gjk-icon-pause'),
            dot      = document.getElementById('gjk-dot'),
            titleEl  = document.getElementById('gjk-song-title'),
            artistEl = document.getElementById('gjk-song-artist'),
            pWrap    = document.getElementById('gjk-progress-wrap'),
            pBar     = document.getElementById('gjk-progress-bar'),
            timeDisp = document.getElementById('gjk-time-display'),
            statTxt  = document.getElementById('gjk-status-text'),
            chips    = document.querySelectorAll('.gjk-song-chip');

        var curIdx = 0, playing = false, cardOpen = false;
        var schedulerTick = null;
        var noteIdx = 0, nextNoteAC = 0;
        var sessionStartAC = 0, sessionOffset = 0;
        var LOOKAHEAD = 0.2;

        toggleBtn.addEventListener('click', function() {
            cardOpen = !cardOpen;
            card.classList.toggle('collapsed', !cardOpen);
        });

        function fmt(s) {
            s = Math.max(0, s | 0);
            return (s / 60 | 0) + ':' + ('0' + (s % 60)).slice(-2);
        }

        function songTotalSec(song) {
            if (song.type === 'mp3') return audio.duration || 0;
            var bd = 60 / song.bpm;
            return song.notes.reduce(function(a, n) { return a + n[1] * bd; }, 0);
        }

        function setUI(p) {
            playing = p;
            iconPlay.style.display  = p ? 'none'  : 'block';
            iconPause.style.display = p ? 'block' : 'none';
            dot.classList.toggle('paused', !p);
            statTxt.textContent = p ? 'Now Playing' : 'Paused';
        }

        function stopAll() {
            audio.pause();
            if (schedulerTick) { clearInterval(schedulerTick); schedulerTick = null; }
        }

        function startSynthScheduler() {
            var ac = getAC();
            sessionStartAC = ac.currentTime;
            nextNoteAC = ac.currentTime + 0.04;

            schedulerTick = setInterval(function() {
                if (!playing) return;
                var ac = getAC();
                var song = TRACKS[curIdx];
                var bd = 60 / song.bpm;
                var td = songTotalSec(song);

                while (nextNoteAC < ac.currentTime + LOOKAHEAD) {
                    if (noteIdx >= song.notes.length) {
                        noteIdx = 0;
                        sessionOffset = 0;
                        sessionStartAC = nextNoteAC;
                    }
                    var item = song.notes[noteIdx];
                    playStep(ac, item[0], nextNoteAC, item[1] * bd);
                    nextNoteAC += item[1] * bd;
                    noteIdx++;
                }

                var elapsed = sessionOffset + (ac.currentTime - sessionStartAC);
                elapsed = elapsed % td;
                pBar.style.width = (elapsed / td * 100) + '%';
                timeDisp.textContent = fmt(elapsed) + ' / ' + fmt(td);
            }, 50);
        }

        function playCurrentTrack() {
            stopAll();
            var song = TRACKS[curIdx];
            if (song.type === 'mp3') {
                audio.play().then(function() {
                    setUI(true);
                }).catch(function(err) {
                    console.warn("MP3 Play error:", err);
                    setUI(false);
                });
            } else {
                setUI(true);
                startSynthScheduler();
            }
        }

        function selectSong(idx, autoPlay) {
            curIdx = idx;
            var song = TRACKS[idx];
            titleEl.textContent  = song.title;
            artistEl.textContent = song.artist;
            chips.forEach(function(c) { c.classList.toggle('active', +c.dataset.gjkIdx === idx); });

            stopAll();
            noteIdx = 0; sessionOffset = 0;
            pBar.style.width = '0%';

            if (song.type === 'mp3') {
                audio.src = song.url;
                audio.load();
                timeDisp.textContent = '0:00 / 0:00';
            } else {
                timeDisp.textContent = '0:00 / ' + fmt(songTotalSec(song));
            }

            if (autoPlay) { playCurrentTrack(); }
            else { setUI(false); }
        }

        /* MP3 event listeners */
        audio.addEventListener('timeupdate', function() {
            if (TRACKS[curIdx].type === 'mp3' && audio.duration) {
                pBar.style.width = (audio.currentTime / audio.duration * 100) + '%';
                timeDisp.textContent = fmt(audio.currentTime) + ' / ' + fmt(audio.duration);
            }
        });

        audio.addEventListener('ended', function() {
            if (TRACKS[curIdx].type === 'mp3') {
                selectSong((curIdx + 1) % TRACKS.length, true);
            }
        });

        /* File picker for user local MP3 files */
        filePicker.addEventListener('change', function(e) {
            var file = e.target.files[0];
            if (file) {
                var objectUrl = URL.createObjectURL(file);
                TRACKS[0] = {
                    type: 'mp3',
                    title: file.name.replace(/\.[^/.]+$/, ""),
                    artist: 'File MP3 Lokal',
                    url: objectUrl
                };
                selectSong(0, true);
            }
        });

        /* Play/Pause Button */
        playBtn.addEventListener('click', function() {
            var song = TRACKS[curIdx];
            if (playing) {
                if (song.type === 'mp3') { audio.pause(); }
                else {
                    var ac = getAC();
                    sessionOffset = (sessionOffset + (ac.currentTime - sessionStartAC)) % songTotalSec(song);
                    stopAll();
                }
                setUI(false);
            } else {
                playCurrentTrack();
            }
        });

        document.getElementById('gjk-prev').addEventListener('click', function() {
            selectSong((curIdx - 1 + TRACKS.length) % TRACKS.length, playing);
        });
        document.getElementById('gjk-next').addEventListener('click', function() {
            selectSong((curIdx + 1) % TRACKS.length, playing);
        });
        chips.forEach(function(c) {
            c.addEventListener('click', function() { selectSong(+c.dataset.gjkIdx, true); });
        });

        pWrap.addEventListener('click', function(e) {
            var r = pWrap.getBoundingClientRect();
            var pct = (e.clientX - r.left) / r.width;
            var song = TRACKS[curIdx];

            if (song.type === 'mp3') {
                if (audio.duration) audio.currentTime = pct * audio.duration;
            } else {
                sessionOffset = pct * songTotalSec(song);
                if (playing) { stopAll(); setUI(true); startSynthScheduler(); }
            }
        });

        /* Initialize with Rayuan Perempuan Gila MP3 */
        selectSong(0, false);
    })();
    </script>
</body>
</html>
'@

$files = @('index.html','profil.html','bindo.html','informatika.html')
foreach ($file in $files) {
    $content = [System.IO.File]::ReadAllText($file, [System.Text.Encoding]::UTF8)
    $idx = $content.IndexOf($marker)
    if ($idx -ge 0) {
        [System.IO.File]::WriteAllText($file, $content.Substring(0, $idx) + $player, [System.Text.Encoding]::UTF8)
        Write-Host ("OK: " + $file)
    } else {
        Write-Host ("MARKER NOT FOUND: " + $file)
    }
}
Write-Host "All done."
