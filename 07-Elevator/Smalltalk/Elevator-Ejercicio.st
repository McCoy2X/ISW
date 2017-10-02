!classDefinition: #ElevatorEmergency category: #'Elevator-Ejercicio'!
Error subclass: #ElevatorEmergency
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!


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


!classDefinition: #CabinDoorState category: #'Elevator-Ejercicio'!
Object subclass: #CabinDoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'NH 10/2/2017 11:39:47'!
X1
	self subclassResponsibility.! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 13:53:22'!
isClosed
	self subclassResponsibility.! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 13:53:31'!
isClosing
	self subclassResponsibility.! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 13:53:17'!
isOpen
	self subclassResponsibility.! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 13:53:36'!
isOpening
	self subclassResponsibility.! !


!classDefinition: #ClosedDoorState category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #ClosedDoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ClosedDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 15:35:28'!
isClosed
	^true.! !

!ClosedDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 15:28:54'!
isClosing
	^false.! !

!ClosedDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 15:35:54'!
isOpen
	^false.! !

!ClosedDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 15:28:29'!
isOpening
	^false.! !


!classDefinition: #ClosingDoorState category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #ClosingDoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ClosingDoorState methodsFor: 'as yet unclassified' stamp: 'NH 10/2/2017 11:41:37'!
X1
	^OpeningDoorState new.! !

!ClosingDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:19:43'!
isClosed
	^false! !

!ClosingDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:13:17'!
isClosing
	^true.! !

!ClosingDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:31:52'!
isOpen
	^false! !

!ClosingDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:13:46'!
isOpening
	^false! !

!ClosingDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:31:00'!
nextState
	"DEPRECATED"
	^ClosedDoorState new.! !


!classDefinition: #OpenDoorState category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #OpenDoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!OpenDoorState methodsFor: 'as yet unclassified' stamp: 'NH 10/2/2017 11:40:31'!
X1
	^ self.! !

!OpenDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 13:57:57'!
isClosed
	^false.! !

!OpenDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 13:58:17'!
isClosing
	^false.! !

!OpenDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 13:54:29'!
isOpen
	^true! !

!OpenDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 13:59:32'!
isOpening
	^false.! !

!OpenDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:32:45'!
nextState
	"DEPRECATED"
	^ClosingDoorState new.! !


!classDefinition: #OpeningDoorState category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #OpeningDoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!OpeningDoorState methodsFor: 'as yet unclassified' stamp: 'NH 10/2/2017 11:42:19'!
X1
	^self.! !

!OpeningDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:26:02'!
isClosed
	
	^false! !

!OpeningDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:24:50'!
isClosing
	^false! !

!OpeningDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:25:36'!
isOpen
	^false! !

!OpeningDoorState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:25:16'!
isOpening
	^true! !


!classDefinition: #CabinState category: #'Elevator-Ejercicio'!
Object subclass: #CabinState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinState methodsFor: 'as yet unclassified' stamp: 'NH 10/2/2017 11:50:53'!
X2: aDoorState
	self subclassResponsibility ! !

!CabinState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 15:56:40'!
isMoving
	self subclassResponsibility ! !

!CabinState methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 15:56:47'!
isStopped
	self subclassResponsibility ! !


!classDefinition: #CabinStateMoving category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinStateMoving
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinStateMoving methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:17:30'!
isMoving
	^true! !

!CabinStateMoving methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:17:57'!
isStopped
	^false! !


!classDefinition: #CabinStateStopped category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinStateStopped
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinStateStopped methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:00:49'!
isMoving
	^false! !

!CabinStateStopped methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:01:00'!
isStopped
	^true! !


!classDefinition: #ElevatorController category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorController
	instanceVariableNames: 'state cabinState cabinDoorState cabinFloorNumber floorsToGo'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorController methodsFor: 'initialization' stamp: 'NH 9/30/2017 16:11:03'!
initialize
	cabinFloorNumber := 0.
	cabinState := CabinStateStopped new.
	cabinDoorState := OpenDoorState new.! !


!ElevatorController methodsFor: 'elevator state' stamp: 'NH 9/30/2017 13:13:09'!
cabinFloorNumber
	
	^cabinFloorNumber! !

!ElevatorController methodsFor: 'elevator state' stamp: 'NH 9/30/2017 16:18:59'!
isCabinDoorClosed
	^cabinDoorState isClosed.! !

!ElevatorController methodsFor: 'elevator state' stamp: 'NH 9/30/2017 15:26:12'!
isCabinDoorClosing
	^cabinDoorState isClosing.! !

!ElevatorController methodsFor: 'elevator state' stamp: 'NH 9/30/2017 13:52:44'!
isCabinDoorOpened
	^cabinDoorState isOpen.! !

!ElevatorController methodsFor: 'elevator state' stamp: 'NH 9/30/2017 15:26:30'!
isCabinDoorOpening
	^cabinDoorState isOpening.! !

!ElevatorController methodsFor: 'elevator state' stamp: 'NH 9/30/2017 16:16:07'!
isCabinMoving
	"Bad smell de sobrediseño"
	^ self isCabinStopped not.! !

!ElevatorController methodsFor: 'elevator state' stamp: 'NH 9/30/2017 16:14:51'!
isCabinStopped
	^cabinState isStopped ! !

!ElevatorController methodsFor: 'elevator state' stamp: 'NH 9/30/2017 16:02:26'!
isIdle
	^self isWorking not.! !

!ElevatorController methodsFor: 'elevator state' stamp: 'NH 9/30/2017 16:06:14'!
isWorking
	^ (cabinState isMoving or: cabinDoorState isClosing) or: cabinDoorState isOpening.! !


!ElevatorController methodsFor: 'automatic behaviour' stamp: 'NH 9/30/2017 16:30:03'!
cabinDoorClosed
	"closes the door and moves the elevator"
	cabinDoorState := ClosedDoorState new.
	cabinState := CabinStateMoving new.! !

!ElevatorController methodsFor: 'automatic behaviour' stamp: 'NH 9/30/2017 16:28:34'!
cabinDoorOpened
	cabinDoorState := OpenDoorState new.
	! !

!ElevatorController methodsFor: 'automatic behaviour' stamp: 'NH 9/30/2017 16:23:41'!
cabinOnFloor: aFloorNumber
	cabinFloorNumber := aFloorNumber.
	cabinState := CabinStateStopped new.
	cabinDoorState := OpeningDoorState new.! !

!ElevatorController methodsFor: 'automatic behaviour' stamp: 'NH 10/2/2017 11:44:44'!
waitForPeopleTimedOut
	cabinDoorState := ClosingDoorState new.! !


!ElevatorController methodsFor: 'as yet unclassified' stamp: 'NH 10/2/2017 10:24:41'!
closeCabinDoor
	"bad smell"
	self shouldBeImplemented.! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'NH 9/30/2017 16:30:38'!
goUpPushedFromFloor: aFloor 
	cabinDoorState _ ClosingDoorState new.
	! !

!ElevatorController methodsFor: 'as yet unclassified' stamp: 'NH 10/2/2017 11:50:26'!
openCabinDoor

	"check cabin  not moving"
	^cabinDoorState := cabinState X2: cabinDoorState.! !
