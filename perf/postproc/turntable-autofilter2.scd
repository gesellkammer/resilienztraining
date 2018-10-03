/*

Resilienztraining - Turntable postprocessing

This patch is designed to filter out noise and unwanted harmonics (distortion), commonly created
during the pressing process when working with pure sine tones.

The signal path should be (up to down):

Turntable | Pedal | DI-Box | Mixer | Computer (Supercollider) | Mixer return | Loudspeaker

At the Mixer stage, all inputs should be calibrated to come into the mixer at the same level when
playing the same disc/sound, in order to even out differences between the preamplifiers. After
setting the input level, eq should be applied, filtering out frequencies below 80 Hz and above 8000 Hz
The lowest sine tone present in the discs is 120 Hz, so this frequency should not be affected
by the low-shelf.

Usage
=====

1) Make sure that the server is running
2) Set the in and out channels for all 4 turntables (A.settings)
3) Evaluate region A
4) To change any parameter, change and evaluate region B

TODO: replace the BLowPass4 with a series of BPeakEQ notching down the possible overtones of
the detected freq.

*/

// Region A
(

// settings
~inchannels  = [0, 1, 2, 3];
~outchannels = [0, 1, 2, 3];

fork {
	SynthDef(\autofilter, {|inbus, outbus, fftsize=1024, wet=0.7, shelfdb= -30, rq=0.6, boostrq=0.9,
		boostdb=6, lowcut=70, hicut=8000, gain= -6, noise=0|
		var freq, mag;
		var wnoise = WhiteNoise.ar * 0.1;
		var a0 = SoundIn.ar(inbus) * (1-noise) + (noise*wnoise);
		var adry = a0;
		var chain = FFT(LocalBuf(fftsize), a0);
		var rq1 = 0.5;
		var gainamp = gain.dbamp;
		# freq, mag = FFTPeak.kr(chain, freqlo:90, freqhi:4500);
		freq = freq.lag2ud(0.5, 0.2);
		// comment out the shelf filters if not doing eq in mixer
		// a0 = BHiShelf.ar(a0, hicut, rs:0.9, db:shelfdb);
		// a0 = BLowShelf.ar(a0, lowcut, rs:1.0, db:shelfdb);
		a0 = BHiPass4.ar(a0, freq * 0.6, rq:rq);
		a0 = BLowPass4.ar(a0, freq*1.7, rq:rq);
		a0 = BPeakEQ.ar(a0, freq, boostrq, boostdb);
		a0 = a0 * (wet*gainamp) + ((1-wet)*gainamp*adry);
		Out.ar(outbus, a0);
	}).add;

	s.sync;

	a = Synth(\autofilter, args:[inbus:~inchannels[0], outbus:~outchannels[0]]);
	b = Synth(\autofilter, args:[inbus:~inchannels[1], outbus:~outchannels[1]]);
	c = Synth(\autofilter, args:[inbus:~inchannels[2], outbus:~outchannels[2]]);
	d = Synth(\autofilter, args:[inbus:~inchannels[3], outbus:~outchannels[3]]);
}
)


// Region B
(
a.set(*[wet: 0.7, gain:-6, boostdb: 6, boostrq: 0.6, rq:1, shelfdb: -12, lowcut: 70, hicut:8000]);
b.set(*[wet: 0.7, gain:-6, boostdb: 6, boostrq: 0.6, rq:1, shelfdb: -12, lowcut: 70, hicut:8000]);
c.set(*[wet: 0.7, gain:-6, boostdb: 6, boostrq: 0.6, rq:1, shelfdb: -12, lowcut: 70, hicut:8000]);
d.set(*[wet: 0.7, gain:-6, boostdb: 6, boostrq: 0.6, rq:1, shelfdb: -12, lowcut: 70, hicut:8000]);
)



