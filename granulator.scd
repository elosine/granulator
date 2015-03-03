(
~envs = SoundFile.collectIntoBuffers("/Users/jyang/Dropbox/grainEnv/" ++ "*");
SynthDef(\grainy_live, {
	arg obs=0, ibs=0, gratemin=0.1, gratemax=0.5, durmin=0.001, durmax=0.1, envbuf= -1, ingain=1.0, amp=1.0;
	var synth, grate, gfreq, gtrig, trigfreq, source, gdur;
	trigfreq = 1.0/(gratemin-0.001);  //slightly slower than the min grain freq
	grate = LFNoise0.ar(trigfreq).range(gratemin, gratemax);
	gfreq = 1.0/grate;
	gtrig = Impulse.ar(gfreq);
	gdur = TRand.ar(durmin, durmax, gtrig);
	source = SoundIn.ar(ibs);
	synth = GrainIn.ar(1, gtrig, gdur, source*ingain, envbuf);
	Out.ar(obs, synth*amp);
}).add;
)
a = Synth(\grainy_live);
a.set(\gratemin, 0.013, \gratemax, 0.2, \durmin, 0.02, \durmax, 0.15, \ingain, 3, \amp, 2, \obs, 1);
a.set(\envbuf, ~envs[8]);
//fsr, visualizer?
//presets
