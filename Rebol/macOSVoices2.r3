#!/usr/local/bin/r3
REBOL [ 
] 

volume: 	10			;--default volume
returnStr: 	""			;--selected voice
ret: 		-1			;--error value
volume: 	30			;--default volume

;--you need zenity (https://formulae.brew.sh/formula/zenity)

;--get MacOS voices 
getVoicesList: does [
    voicesList: ""
    command: "say -v '?'"
    call/shell/output command voicesList			;--get voices list as a string series
    save %nvoices.txt voicesList
    prog: "cat nvoices.txt | zenity"
	commands: [
		" --title 'MacOS Voices'"
		" --list"
		" --text 'Pick a voice'"
		" --column 'Voices'"
		" --width '500'"
		" --height '500'"
	]
	append prog commands
	ret: call/shell/output prog returnStr
	if ret = 0 [
		trim/with returnStr "{"
		trim/with returnStr "}"
		tmp: split returnStr "#"
		trim/head tmp/2	
		trim/lines tmp/1
		voice: first split tmp/1 space
		language: second split tmp/1 space
		sentence: trim/lines tmp/2	
	]
]
generate: does [
	call/wait/shell rejoin ["osascript -e 'set volume output volume " volume  "'"]
	command: rejoin ["say -v " voice  " --interactive=/red " sentence]
	call/shell/wait command
]

getVoicesList
if ret = 0 [generate]
