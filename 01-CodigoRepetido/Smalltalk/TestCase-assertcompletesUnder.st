'From Cuis 5.0 of 7 November 2016 [latest update: #3161] on 6 September 2017 at 11:04:52 pm'!

!TestCase methodsFor: 'Accessing' stamp: 'ISW 9/6/2017 22:47:03'!
assert: aBlock completesUnder: anAmountOfTime

	| timeBeforeRunning timeAfterRunning |
	
	timeBeforeRunning := Time millisecondClockValue * millisecond.
	aBlock value.
	timeAfterRunning := Time millisecondClockValue * millisecond.
	
	self assert: (timeAfterRunning - timeBeforeRunning) < anAmountOfTime! !
