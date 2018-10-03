(
var a = "3A 3G+".transp(0);
var gt = 8;
var interval = -1;
var pitch = Mus.glissd(a, 2, a, gt, a+interval, gt, a+interval, gt*0.5, a, 2, a);
var pitch2 = Mus.glissd(a, 2, a, gt, a+interval-0.1, gt, a+interval-0.1, gt*0.5, a, 2, a);
var pitch3 = Mus.glissd(a, 2, a, gt, a+interval-0.15, gt, a+interval-0.15, gt*0.5, a, 2, a);
var dt = 0.67;
var gain = 0.02;
var dur = Mus.envDur(pitch);
{ Mus.listen(pitch, chan:0, gain:gain, fade:0.5) }.play;
// { Mus.listen(a, chan:0, dur:dur, gain:0.05, fade:0.5) }.play;
{ Mus.listen(pitch, chan:1, gain:gain, fade:0.5) }.playLater(dt*1);
{ Mus.listen(pitch2, chan:0, gain:gain, fade:0.5) }.playLater(dt*2);
{ Mus.listen(pitch, chan:1, gain:gain, fade:0.5) }.playLater(dt*3);


)

if( 60.isKindOf(Array) && 60[0] == 1 ) { "waw".postln }

Mus.glissd("3A", 3, "3C")
a = "3A 3Bb"
Mus.glissd(a, 3, a, 1, a.transp(-0.5), 1, a)

"4C 4E 4G".transp(-0.5)

1.02.r2i
m2f

a = [1, 2, 3]
all{:x, x <- a, x%2==0}
[, 2, 3].every{|x| x%2==0}

{ Mus.listen(60) }.playLater(2)

Mus.parseChord("C4 E4 G4")