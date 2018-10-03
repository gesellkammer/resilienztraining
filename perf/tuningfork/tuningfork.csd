<CsoundSynthesizer>
<CsOptions>
;odac     ;;;realtime audio out
-odac


</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs  = 1
A4 = 442

gkmidi init 69
gkshift init 0
gkorigfreq init 442

massign 0, 0

instr 1
	kmidi = gkmidi
	kshift = gkshift
	kfreq = mtof:k(kmidi+kshift)
	a0 inch 1
	korigfreq = gkorigfreq
	asig = butterbp(a0, korigfreq, 10)
	aenv = follow2(asig, 0.05, 0.01)
	aenv = butterlp(aenv, 100)
	asin = oscili(aenv, kfreq)
	anoise = pareq(a0, korigfreq, 0.0, 0.1)
	adist = oscili(aenv*0.01, kfreq*2) + oscili(aenv*0.001, kfreq*3)
	
	iratio = 2
	; aout = compress2(asin, asin, -90, -50, -30, iratio, 0.001, 0.1, 0.010) * iratio * 2
	; aout = asin * 0.9 + atransp * 0.5
	aout = asin + anoise*0.2 + adist
	outch 1, aout
endin

instr 10
	kst, kchan, k1, k2 midiin
	kshift init 0
	ktrig = changed(kshift, gkmidi, gkorigfreq)
	printf "shift: %d gkmidi: %f origfreq: %f\n", ktrig, kshift, gkmidi, gkorigfreq
	if kst != 144 kgoto _end 
	if k1 > 48 && k2 > 0 then
		if kshift == 0 then
			gkmidi = k1
		else
			gkorigfreq = mtof(k1)
		endif
	else
		kshift = k2 > 0 ? 1 : 0
	endif
_end:
endin


schedule 1, 0, 3600
schedule 10, 0, 3600
</CsInstruments>
<CsScore>
</CsScore>

</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>0</width>
 <height>0</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
