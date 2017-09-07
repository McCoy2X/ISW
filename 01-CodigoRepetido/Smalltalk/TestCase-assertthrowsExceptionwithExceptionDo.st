'From Cuis 5.0 of 7 November 2016 [latest update: #3161] on 7 September 2017 at 4:25:44 pm'!

!TestCase methodsFor: 'Accessing' stamp: 'ISW 9/7/2017 16:22:18'!
assert: aBlock throwsException: anExceptonHandlingCondition withExceptionDo: assertionsBlock

	^[aBlock value.
 	self fail ] 
		on: anExceptonHandlingCondition
		do: assertionsBlock ! !
