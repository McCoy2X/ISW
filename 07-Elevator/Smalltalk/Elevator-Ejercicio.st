!classDefinition: #ElevatorEmergency category: #'Elevator-Ejercicio'!
Error subclass: #ElevatorEmergency
	instanceVariableNames: 'errorMessage'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorEmergency methodsFor: 'as yet unclassified' stamp: 'NH 10/3/2017 16:43:50'!
messageText 
	^ errorMessage.! !

!ElevatorEmergency methodsFor: 'as yet unclassified' stamp: 'NH 10/3/2017 16:43:04'!
withMessage: anErrorMessage 
	errorMessage := anErrorMessage.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ElevatorEmergency class' category: #'Elevator-Ejercicio'!
ElevatorEmergency class
	instanceVariableNames: ''!

!ElevatorEmergency class methodsFor: 'as yet unclassified' stamp: 'NH 10/3/2017 16:46:12'!
cabinSensor
	^ self new withMessage: 'Sensor de cabina desincronizado'.! !

!ElevatorEmergency class methodsFor: 'as yet unclassified' stamp: 'NH 10/3/2017 16:45:45'!
doorSensor
	^self new withMessage: 'Sensor de puerta desincronizado'.! !


!classDefinition: #ElevatorTest category: #'Elevator-Ejercicio'!
TestCase subclass: #ElevatorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:38'!
test09RequestToGoUpAreEnqueueWhenRequestedWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinWaitingForPeople.
	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test10CabinDoorStartClosingAfterWaitingForPeople

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test11StopsWaitingForPeopleIfCloseDoorIsPressed

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinWaitingForPeople.
	self assert: elevatorController isCabinDoorOpened.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.
! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test12CloseDoorDoesNothingIfIdle

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController closeCabinDoor.

	self assert: elevatorController isIdle.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:40'!
test13CloseDoorDoesNothingWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:40'!
test14CloseDoorDoesNothingWhenOpeningTheDoorToWaitForPeople

	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !


!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:42'!
test15ElevatorHasToEnterEmergencyIfStoppedAndOtherFloorSensorTurnsOn

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [ elevatorController cabinOnFloor:0 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado' ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:47'!
test16ElevatorHasToEnterEmergencyIfFalling

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [ elevatorController cabinOnFloor:0 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:47'!
test17ElevatorHasToEnterEmergencyIfJumpsFloors

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:3.
	elevatorController cabinDoorClosed.
	self 
		should: [ elevatorController cabinOnFloor: 3 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:48'!
test18ElevatorHasToEnterEmergencyIfDoorClosesAutomatically
	| elevatorController |
	elevatorController := ElevatorController new.
	
	self 
		should: [ elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado' ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:48'!
test19ElevatorHasToEnterEmergencyIfDoorClosedSensorTurnsOnWhenClosed

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	self 
		should: [elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:49'!
test20ElevatorHasToEnterEmergencyIfDoorClosesWhenOpening
	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado'.]! !


!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:35'!
test06DoorKeepsOpenedWhenOpeningIsRequested

	| elevatorController |
	elevatorController := ElevatorController new.
	
	self assert: elevatorController isCabinDoorOpened.
	
	elevatorController openCabinDoor.

	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 6/16/2014 13:24'!
test07DoorMustBeOpenedWhenCabinIsStoppedAndClosingDoors

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
		
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.
		
	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.
! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:36'!
test08CanNotOpenDoorWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.

	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:51'!
test09DoorKeepsOpeneingWhenItIsOpeneing

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.

	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !


!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test21CabinHasToStopOnTheFloorsOnItsWay
	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinOnFloor:1.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test22ElevatorCompletesAllTheRequests
	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinOnFloor:1.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:2.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test23CabinHasToStopOnFloorsOnItsWayNoMatterHowTheyWellCalled

	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinOnFloor:1.
		
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:51'!
test24CabinHasToStopAndWaitForPeopleOnFloorsOnItsWayNoMatterHowTheyWellCalled

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinOnFloor:1.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.! !


!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/10/2011 17:33'!
test01ElevatorStartsIdleWithDoorOpenOnFloorZero

	| elevatorController |
		
	elevatorController := ElevatorController new.
		
	self assert: elevatorController isIdle.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpened.
	self assert: elevatorController cabinFloorNumber = 0
! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 17:53'!
test02CabinDoorStartsClosingWhenElevatorGetsCalled

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor: 1.
	
	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.
	
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.
	
	self deny: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self assert: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 17:57'!
test03CabinStartsMovingWhenDoorGetsClosed

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	
	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.

	self deny: elevatorController isCabinStopped.
	self assert: elevatorController isCabinMoving.
	
	self deny: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 18:00'!
test04CabinStopsAndStartsOpeningDoorWhenGetsToDestination

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor: 1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor: 1.

	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.
	
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.
			
	self deny: elevatorController isCabinDoorOpened.
	self assert: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.

	self assert: elevatorController cabinFloorNumber = 1
! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 18:00'!
test05ElevatorGetsIdleWhenDoorGetOpened

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor: 1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor: 1.
	elevatorController cabinDoorOpened.
		
	self assert: elevatorController isIdle.
	self deny: elevatorController isWorking.
		
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.

	self assert: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.
		
	self assert: elevatorController cabinFloorNumber = 1! !


!classDefinition: #CabinState category: #'Elevator-Ejercicio'!
Object subclass: #CabinState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinState methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:37:27'!
isMoving
	self subclassResponsibility.! !

!CabinState methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:28:14'!
isStopped
	self subclassResponsibility.! !


!classDefinition: #Moving category: #'Elevator-Ejercicio'!
CabinState subclass: #Moving
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Moving methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:05:34'!
isMoving
	^true.! !

!Moving methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:04:57'!
isStopped
	^false.! !


!classDefinition: #Stopped category: #'Elevator-Ejercicio'!
CabinState subclass: #Stopped
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Stopped methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:38:44'!
isMoving
	^false! !

!Stopped methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:28:37'!
isStopped
	^true.! !


!classDefinition: #DoorState category: #'Elevator-Ejercicio'!
Object subclass: #DoorState
	instanceVariableNames: 'state cabinState floorsToGo door floorNumber'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorState methodsFor: 'associating' stamp: 'NH 10/4/2017 18:28:56'!
isOpened
	self subclassResponsibility.! !


!DoorState methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:42:58'!
isClosed
	self subclassResponsibility.! !

!DoorState methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:42:10'!
isClosing
	self subclassResponsibility.! !

!DoorState methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:40:28'!
isOpening
	self subclassResponsibility.! !


!classDefinition: #Closed category: #'Elevator-Ejercicio'!
DoorState subclass: #Closed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Closed methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:08:32'!
isClosed
	^true.! !

!Closed methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:08:16'!
isClosing
	^false.! !

!Closed methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:07:17'!
isOpened
	^false.! !

!Closed methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:07:46'!
isOpening
	^false.! !


!classDefinition: #Closing category: #'Elevator-Ejercicio'!
DoorState subclass: #Closing
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Closing methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:43:14'!
isClosed
	^false.! !

!Closing methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:42:37'!
isClosing
	^true.! !

!Closing methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:40:06'!
isOpened
	^false.! !

!Closing methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:41:31'!
isOpening
	^false! !


!classDefinition: #Open category: #'Elevator-Ejercicio'!
DoorState subclass: #Open
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Open methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:14:36'!
isClosed
	^false.! !

!Open methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:14:17'!
isClosing
	^false.! !

!Open methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:29:07'!
isOpened
	^true.! !

!Open methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:13:49'!
isOpening
	^false.! !


!classDefinition: #Opening category: #'Elevator-Ejercicio'!
DoorState subclass: #Opening
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Opening methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:11:53'!
isClosed
	^false.! !

!Opening methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:11:36'!
isClosing
	^false.! !

!Opening methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:11:01'!
isOpened
	^false.! !

!Opening methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:11:17'!
isOpening
	^true.! !


!classDefinition: #ElevatorController category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorController
	instanceVariableNames: 'state cabinState floorsToGo door floorNumber'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorController methodsFor: 'automatic behaviour' stamp: 'NH 10/5/2017 18:04:16'!
cabinDoorClosed
	self isCabinDoorClosing ifFalse: [ElevatorEmergency doorSensor signal].
	door := Closed new.
	cabinState := Moving new.! !

!ElevatorController methodsFor: 'automatic behaviour' stamp: 'NH 10/5/2017 18:12:51'!
cabinDoorOpened
	state _ (floorsToGo = 0) ifTrue: Idle new ifFalse: Working new. "queda en working si todavia hay que recorrer pisos"
	door _ Open new.! !

!ElevatorController methodsFor: 'automatic behaviour' stamp: 'NH 10/5/2017 18:10:25'!
cabinOnFloor: aFloorNumber
	aFloorNumber = (floorNumber + 1) ifFalse: [ ElevatorEmergency cabinSensor signal ].
	floorNumber _ aFloorNumber.
	cabinState _ Stopped new.
	door _ Opening new.
	state _ Working new.
	floorsToGo _ floorsToGo - 1.! !

!ElevatorController methodsFor: 'automatic behaviour' stamp: 'NH 10/5/2017 18:17:18'!
waitForPeopleTimedOut
	door _ Closing new.! !


!ElevatorController methodsFor: 'as yet unclassified' stamp: 'NH 10/3/2017 16:28:09'!
closeCabinDoor
	((self isIdle or: self isCabinMoving) or: self isCabinDoorOpening ) 
		ifFalse: [self waitForPeopleTimedOut].
	"Fun fact: el complemento de la condicion es (????)"! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:32:14'!
goUpPushedFromFloor: aFloorNumber 
	
	state := Working new.
	door := Closing new.
	floorsToGo _ floorsToGo + 1.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:16:12'!
openCabinDoor
	door _ cabinState isMoving
		ifTrue: [ Closed new ]
		ifFalse: [
			door isOpened 
				ifTrue: [ Open new ]
				ifFalse: [ Opening new ]].! !


!ElevatorController methodsFor: 'initialization' stamp: 'NH 10/4/2017 18:20:32'!
initialize

	state _ Idle new.
	door _ Open new.
	floorNumber _ 0.
	cabinState _ Stopped new.
	floorsToGo _ 0.! !


!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/2/2017 21:26:31'!
cabinFloorNumber

	^floorNumber ! !

!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/4/2017 18:23:55'!
isCabinDoorClosed
	^ door isClosed.! !

!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/4/2017 18:24:05'!
isCabinDoorClosing
	^ door isClosing.! !

!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/4/2017 18:24:25'!
isCabinDoorOpened
	
	^ door isOpened.! !

!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/4/2017 18:24:35'!
isCabinDoorOpening
	^ door isOpening.! !

!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/4/2017 18:23:42'!
isCabinMoving
	
	^ cabinState isMoving.! !

!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/4/2017 18:23:27'!
isCabinStopped
	
	^ cabinState isStopped.! !

!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/3/2017 15:28:50'!
isCabinWaitingForPeople
	^floorsToGo > 0.! !

!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/4/2017 18:21:45'!
isIdle
	^ state isIdle.! !

!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/4/2017 18:26:12'!
isWorking
	^ state isWorking.! !


!classDefinition: #ElevatorState category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorState
	instanceVariableNames: 'state cabinState floorsToGo door floorNumber'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorState methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:22:11'!
isIdle
	self subclassResponsibility.! !

!ElevatorState methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:35:45'!
isWorking
	self subclassResponsibility.! !


!classDefinition: #Idle category: #'Elevator-Ejercicio'!
ElevatorState subclass: #Idle
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Idle methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:22:32'!
isIdle
	^true.! !

!Idle methodsFor: 'as yet unclassified' stamp: 'NH 10/5/2017 18:13:30'!
isWorking
	^false.! !


!classDefinition: #Working category: #'Elevator-Ejercicio'!
ElevatorState subclass: #Working
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Working methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:34:29'!
isIdle
	^false.! !

!Working methodsFor: 'as yet unclassified' stamp: 'NH 10/4/2017 18:36:34'!
isWorking
	^true.! !
