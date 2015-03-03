(
SynthDef(\grainy_live, {
	arg obs=0, gratemin=0.1, gratemax=0.5, durmin=0.001, durmax=0.1, envbuf= -1;
	var synth, grate, gfreq, gtrig, trigfreq, source, gdur;
	trigfreq = 1.0/(gratemin-0.001);  //slightly slower than the min grain freq
	grate = LFNoise0.ar(trigfreq).range(gratemin, gratemax);
	gfreq = 1.0/grate;
	gtrig = Impulse.ar(gfreq);
	gdur = TRand.ar(durmin, durmax, gtrig).poll;
	synth = GrainIn.ar(1, gtrig, gdur, SinOsc.ar(), envbuf);
	Out.ar(obs, synth);
}).add;
)
a = Synth(\grainy_live);
a.set(\gratemin, 0.01, \gratemax, 0.2, \durmin, 0.001, \durmax, 0.01);
//next envelopes and hook up mic
//fsr, visualizer?
//presets