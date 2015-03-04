(
~envs = SoundFile.collectIntoBuffers("/Users/jyang/Dropbox/grainEnv/" ++ "*");
~pro = NetAddr("127.0.0.1", 12321);
SynthDef(\grainy_live, {
	arg obs=0, ibs=0, gratemin=0.1, gratemaxlo=0.03, gratemaxhi=0.3, durmin=0.001, durmax=0.1, envbuf= -1, ingain=1.0, amp=1.0, atk = 0.01, decay=0, sus=1, rel=0.1, crv = -2, gate=0;
	var synth, grate, gfreq, gtrig, trigfreq, source, gdur, osctrig, env, onesecond, granulator, rate;
	onesecond = 1.0/(BufRateScale.kr(envbuf)*(BufSampleRate.kr(envbuf)/BufFrames.kr(envbuf)));
	env = EnvGen.ar( Env.adsr(atk, decay, sus, rel, curve:crv), gate );
	trigfreq = 1.0/(gratemin-0.001);  //slightly slower than the min grain freq
	grate = LFNoise0.ar(trigfreq).range( gratemin, \gratemax.kr(0.5, 0.05).range(gratemaxlo, gratemaxhi) );
	gfreq = 1.0/grate;
	gtrig = Impulse.ar(gfreq);
	osctrig = Impulse.kr(gfreq);
	gdur = TRand.ar(durmin, durmax, gtrig);
	source = SoundIn.ar(ibs);
	SendTrig.kr(osctrig, 0, gdur); //send a trig to sclang, the OSCFunc below which is listening for '/tr'
	granulator = PlayBuf.ar(1, envbuf, onesecond/gdur, gtrig);
	rate = SampleRate.ir()/BufFrames.kr(envbuf);
	synth = source*ingain*granulator;
	Out.ar(obs, synth*amp*env);
}).add;

//Receives trigger from granulator and sends message to processing with each grain
~mkparticle = OSCFunc({|msg| ~pro.sendMsg("/mkparticle", msg[3].asFloat)}, '/tr', s.addr);
)
a = Synth(\grainy_live);
a.set(\gratemin, 0.07, \gratemax, 0.55, \durmin, 0.07, \durmax, 0.45, \ingain, 3, \amp, 2, \obs, 1, \gate, 1);
a.set(\envbuf, 3);

a.map(\gratemax, ~kbs[0]);
a.free;
