#!/usr/local/bin/red
Red[
	Author: "Francois Jouen"
	needs: 	view
]
;--Windows and Linux users can use espeak
;--https://espeak.sourceforge.net

vol: 100 	;--0 to 200
pitch: 50	;--0..99
speed: 175	;--500 max
lang: "en"
fstr: "Bonjour, je m'appelle Thomas. Je suis une voix française."
estr: "Hello, my name is Daniel. I am a British-English voice."
command: copy "espeak -v"

win: layout [
	title "espeak test"
	text 100 "Language" 
	drop-down 200 data ["English" "French"]
	select 1
	on-change [
		switch face/selected [
			1 [lang: "en" sentence/text: estr]
			2 [lang: "fr-fr" sentence/text: fstr]
		]
		f0/text: lang
	]
	
	f0: field 50 "en"
	return 
	text 100 "Volume" 
	sl1: slider 200 [
		vol: to-integer face/data * 200 
		f1/text: form vol
	]
	f1: field 50 "100" 
	return
	text 100 "Pitch" sl2: slider 200 [
		pitch: to-integer face/data * 99
		f2/text: form pitch
	]
	f2: field 50 "50"
	return
	text 100 "Speed" sl3: slider 200 
	[
		speed: to-integer face/data * 500
		f3/text: form speed
	]
	
	f3: field 50 "175"
	return
	sentence: area 375x48 estr
	return
	button "Tester" [
		clear command
		append command "espeak -v"
		append command rejoin [lang  " "]
		append command rejoin ["-a" vol " -p" pitch " -s" speed " "]
		append command #"^""
		append command sentence/text 
		append command #"^""
		;print command 
		ret: call/shell/show command
	]
	button "Quit" [quit]
	do [sl1/data: sl2/data: 50% sl3/data: 35%]
]

view win 