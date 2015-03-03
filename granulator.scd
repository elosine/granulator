(
~envs = SoundFile.collectIntoBuffers("/Users/jyang/Dropbox/grainEnv/" ++ "*");
~pro = NetAddr("127.0.0.1", 12321);
SynthDef(\grainy_live, {
	arg obs=0, ibs=0, gratemin=0.1, gratemax=0.5, durmin=0.001, durmax=0.1, envbuf= -1, ingain=1.0, amp=1.0;
	var synth, grate, gfreq, gtrig, trigfreq, source, gdur, osctrig;
	trigfreq = 1.0/(gratemin-0.001);  //slightly slower than the min grain freq
	grate = LFNoise0.ar(trigfreq).range(gratemin, gratemax);
	gfreq = 1.0/grate;
	gtrig = Impulse.ar(gfreq);
	osctrig = Impulse.kr(gfreq);
	gdur = TRand.ar(durmin, durmax, gtrig);
	source = SoundIn.ar(ibs);
	SendTrig.kr(osctrig, 0, gdur);
	synth = GrainIn.ar(1, gtrig, gdur, source*ingain, envbuf);
	Out.ar(obs, synth*amp);
}).add;

//Receives trigger from granulator and sends message to processing with each grain
~mkparticle = OSCFunc({|msg| ~pro.sendMsg("/mkparticle", msg[3].asFloat)}, '/tr', s.addr);
)
a = Synth(\grainy_live);
a.set(\gratemin, 0.083, \gratemax, 0.35, \durmin, 0.02, \durmax, 0.2, \ingain, 3, \amp, 2, \obs, 1);
a.set(\envbuf, ~envs[8]);
//fsr, visualizer?
//presets
