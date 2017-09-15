!classDefinition: #OOStackTest category: #'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'Something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:31'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'Something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/8/2012 08:20'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:33'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'First'.
	secondPushedObject := 'Second'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:35'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:36'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:36'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'Something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #OOStack category: #'Stack-Exercise'!
Object subclass: #OOStack
	instanceVariableNames: 'topOfTheStack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'accessing' stamp: 'NH 9/15/2017 16:52:44'!
isEmpty
	^self size = 0.	! !

!OOStack methodsFor: 'accessing' stamp: 'NH 9/15/2017 16:59:03'!
size
	^topOfTheStack count.! !

!OOStack methodsFor: 'accessing' stamp: 'NH 9/15/2017 16:59:24'!
top
	| raiseEmptyError |
	raiseEmptyError := [self error: self class stackEmptyErrorDescription].
	^topOfTheStack elementWhenNotPresent: raiseEmptyError.! !


!OOStack methodsFor: 'adding' stamp: 'NH 9/15/2017 16:57:39'!
push: anObject
	| newTop |
	newTop := (StackElement with: anObject above: topOfTheStack ). 
	topOfTheStack := newTop.! !


!OOStack methodsFor: 'initialization' stamp: 'NH 9/15/2017 17:32:04'!
initialize
	topOfTheStack _ StackBottom new.! !


!OOStack methodsFor: 'removing' stamp: 'NH 9/15/2017 17:30:06'!
pop
	| top |
	top := self top.
	topOfTheStack := topOfTheStack nextNode.
	^top.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: #'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'HernanWilkinson 5/7/2012 11:51'!
stackEmptyErrorDescription
	
	^ 'Stack is empty'! !



!classDefinition: #StackNode category: #'Stack-Exercise'!
Object subclass: #StackNode
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!StackNode methodsFor: 'accessing' stamp: 'NH 9/15/2017 17:12:56'!
count
	^self subclassResponsibility.! !

!StackNode methodsFor: 'accessing' stamp: 'NH 9/15/2017 17:05:57'!
elementWhenNotPresent: blockWhenEmpty
	^self subclassResponsibility.! !


!classDefinition: #StackBottom category: #'Stack-Exercise'!
StackNode subclass: #StackBottom
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!StackBottom methodsFor: 'accessing' stamp: 'NH 9/15/2017 17:13:32'!
count
	^0.! !

!StackBottom methodsFor: 'accessing' stamp: 'NH 9/15/2017 16:17:13'!
elementWhenNotPresent: blockWhenEmpty
	^blockWhenEmpty value.! !


!classDefinition: #StackElement category: #'Stack-Exercise'!
StackNode subclass: #StackElement
	instanceVariableNames: 'content next'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!StackElement methodsFor: 'initialization' stamp: 'NH 9/15/2017 17:22:51'!
initializeWith: anObject above: aStackNode 
	content  := anObject.
	next := aStackNode.
	^self.! !


!StackElement methodsFor: 'accessing' stamp: 'NH 9/15/2017 17:30:36'!
count
	^ 1 + next count.! !

!StackElement methodsFor: 'accessing' stamp: 'NH 9/15/2017 17:05:10'!
elementWhenNotPresent: blockWhenEmpty
	^content.! !

!StackElement methodsFor: 'accessing' stamp: 'NH 9/15/2017 17:29:17'!
nextNode
	^next! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StackElement class' category: #'Stack-Exercise'!
StackElement class
	instanceVariableNames: ''!

!StackElement class methodsFor: 'instance creation' stamp: 'NH 9/15/2017 17:20:39'!
with: anObject above: anStackNode
	^self basicNew initializeWith: anObject above: anStackNode.! !
