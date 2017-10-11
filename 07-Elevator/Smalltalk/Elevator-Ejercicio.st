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

!CabinState methodsFor: 'state' stamp: 'NH 10/4/2017 18:37:27'!
isMoving
	self subclassResponsibility.! !

!CabinState methodsFor: 'state' stamp: 'NH 10/4/2017 18:28:14'!
isStopped
	self subclassResponsibility.! !


!CabinState methodsFor: 'controller interaction' stamp: 'NH 10/11/2017 10:17:55'!
checkCabinSensorMoving
	self subclassResponsibility.! !

!CabinState methodsFor: 'controller interaction' stamp: 'NH 10/10/2017 19:01:35'!
closeButtonPushedIn: anElevatorController 
	self subclassResponsibility.! !

!CabinState methodsFor: 'controller interaction' stamp: 'NH 10/5/2017 20:11:46'!
openButtonPushedIn: anElevatorController
	self subclassResponsibility.! !


!classDefinition: #Moving category: #'Elevator-Ejercicio'!
CabinState subclass: #Moving
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Moving methodsFor: 'controller interaction' stamp: 'NH 10/11/2017 10:18:35'!
checkCabinSensorMoving
	"OK"
	^nil! !

!Moving methodsFor: 'controller interaction' stamp: 'NH 10/10/2017 23:23:36'!
closeButtonPushedIn: anElevatorController 
	anElevatorController closeWhenMoving.! !

!Moving methodsFor: 'controller interaction' stamp: 'NH 10/5/2017 20:11:46'!
openButtonPushedIn: anElevatorController
	anElevatorController openWhenMovingCabin.! !


!Moving methodsFor: 'state' stamp: 'NH 10/5/2017 18:05:34'!
isMoving
	^true.! !

!Moving methodsFor: 'state' stamp: 'NH 10/5/2017 18:04:57'!
isStopped
	^false.! !


!classDefinition: #Stopped category: #'Elevator-Ejercicio'!
CabinState subclass: #Stopped
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Stopped methodsFor: 'controller interaction' stamp: 'NH 10/11/2017 10:21:32'!
checkCabinSensorMoving
	ElevatorEmergency cabinSensor signal.! !

!Stopped methodsFor: 'controller interaction' stamp: 'NH 10/10/2017 19:02:17'!
closeButtonPushedIn: anElevatorController 
	anElevatorController closeWhenStopped.! !

!Stopped methodsFor: 'controller interaction' stamp: 'NH 10/5/2017 20:11:46'!
openButtonPushedIn: anElevatorController
	anElevatorController openWhenStoppedCabin.! !


!Stopped methodsFor: 'state' stamp: 'NH 10/4/2017 18:38:44'!
isMoving
	^false! !

!Stopped methodsFor: 'state' stamp: 'NH 10/4/2017 18:28:37'!
isStopped
	^true.! !


!classDefinition: #DoorState category: #'Elevator-Ejercicio'!
Object subclass: #DoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorState methodsFor: 'controller interaction' stamp: 'NH 10/5/2017 19:13:03'!
checkDoorSensorClosed
	self subclassResponsibility.! !

!DoorState methodsFor: 'controller interaction' stamp: 'NH 10/10/2017 19:03:53'!
closeButtonPushedIn: anElevatorController 
	self subclassResponsibility.! !

!DoorState methodsFor: 'controller interaction' stamp: 'NH 10/5/2017 20:11:46'!
openButtonPushedIn: anElevatorController
	self subclassResponsibility.! !


!DoorState methodsFor: 'state' stamp: 'NH 10/4/2017 18:42:58'!
isClosed
	self subclassResponsibility.! !

!DoorState methodsFor: 'state' stamp: 'NH 10/4/2017 18:42:10'!
isClosing
	self subclassResponsibility.! !

!DoorState methodsFor: 'state' stamp: 'NH 10/4/2017 18:28:56'!
isOpened
	self subclassResponsibility.! !

!DoorState methodsFor: 'state' stamp: 'NH 10/4/2017 18:40:28'!
isOpening
	self subclassResponsibility.! !


!classDefinition: #Closed category: #'Elevator-Ejercicio'!
DoorState subclass: #Closed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Closed methodsFor: 'state' stamp: 'NH 10/5/2017 18:08:32'!
isClosed
	^true.! !

!Closed methodsFor: 'state' stamp: 'NH 10/5/2017 18:08:16'!
isClosing
	^false.! !

!Closed methodsFor: 'state' stamp: 'NH 10/5/2017 18:07:17'!
isOpened
	^false.! !

!Closed methodsFor: 'state' stamp: 'NH 10/5/2017 18:07:46'!
isOpening
	^false.! !


!Closed methodsFor: 'controller interaction' stamp: 'NH 10/5/2017 19:13:03'!
checkDoorSensorClosed
	ElevatorEmergency doorSensor signal.! !


!classDefinition: #Closing category: #'Elevator-Ejercicio'!
DoorState subclass: #Closing
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Closing methodsFor: 'state' stamp: 'NH 10/4/2017 18:43:14'!
isClosed
	^false.! !

!Closing methodsFor: 'state' stamp: 'NH 10/4/2017 18:42:37'!
isClosing
	^true.! !

!Closing methodsFor: 'state' stamp: 'NH 10/4/2017 18:40:06'!
isOpened
	^false.! !

!Closing methodsFor: 'state' stamp: 'NH 10/4/2017 18:41:31'!
isOpening
	^false! !


!Closing methodsFor: 'controller interaction' stamp: 'NH 10/5/2017 19:13:03'!
checkDoorSensorClosed
	^ nil.! !

!Closing methodsFor: 'controller interaction' stamp: 'NH 10/5/2017 20:11:46'!
openButtonPushedIn: anElevatorController
	anElevatorController openWhenDoorIsClosing.! !


!classDefinition: #Open category: #'Elevator-Ejercicio'!
DoorState subclass: #Open
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Open methodsFor: 'state' stamp: 'NH 10/5/2017 18:14:36'!
isClosed
	^false.! !

!Open methodsFor: 'state' stamp: 'NH 10/5/2017 18:14:17'!
isClosing
	^false.! !

!Open methodsFor: 'state' stamp: 'NH 10/4/2017 18:29:07'!
isOpened
	^true.! !

!Open methodsFor: 'state' stamp: 'NH 10/5/2017 18:13:49'!
isOpening
	^false.! !


!Open methodsFor: 'controller interaction' stamp: 'NH 10/5/2017 19:13:03'!
checkDoorSensorClosed
	ElevatorEmergency doorSensor signal.! !

!Open methodsFor: 'controller interaction' stamp: 'NH 10/10/2017 19:04:21'!
closeButtonPushedIn: anElevatorController 
	anElevatorController closeWhenOpen.! !

!Open methodsFor: 'controller interaction' stamp: 'NH 10/5/2017 20:11:46'!
openButtonPushedIn: anElevatorController
	anElevatorController openWhenDoorIsOpen.! !


!classDefinition: #Opening category: #'Elevator-Ejercicio'!
DoorState subclass: #Opening
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Opening methodsFor: 'state' stamp: 'NH 10/5/2017 18:11:53'!
isClosed
	^false.! !

!Opening methodsFor: 'state' stamp: 'NH 10/5/2017 18:11:36'!
isClosing
	^false.! !

!Opening methodsFor: 'state' stamp: 'NH 10/5/2017 18:11:01'!
isOpened
	^false.! !

!Opening methodsFor: 'state' stamp: 'NH 10/5/2017 18:11:17'!
isOpening
	^true.! !


!Opening methodsFor: 'controller interaction' stamp: 'NH 10/5/2017 19:13:03'!
checkDoorSensorClosed
	ElevatorEmergency doorSensor signal.! !

!Opening methodsFor: 'controller interaction' stamp: 'NH 10/11/2017 00:10:44'!
closeButtonPushedIn: anElevatorController 
	anElevatorController closeWhenOpening.! !

!Opening methodsFor: 'controller interaction' stamp: 'NH 10/5/2017 20:11:46'!
openButtonPushedIn: anElevatorController
	anElevatorController openWhenDoorIsOpening.! !


!classDefinition: #ElevatorController category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorController
	instanceVariableNames: 'state cabinState floorsToGo floorNumber doorState'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorController methodsFor: 'automatic behaviour' stamp: 'NH 10/11/2017 10:50:24'!
cabinDoorClosed
	doorState checkDoorSensorClosed.
	doorState _ Closed new.
	cabinState _ Moving new.! !

!ElevatorController methodsFor: 'automatic behaviour' stamp: 'NH 10/11/2017 10:50:24'!
cabinDoorOpened
	"queda en working si todavia hay que recorrer pisos"
	state _ floorsToGo = 0
		ifTrue: Idle new
		ifFalse: Working new.
	doorState _ Open new.! !

!ElevatorController methodsFor: 'automatic behaviour' stamp: 'NH 10/11/2017 10:50:24'!
cabinOnFloor: aFloorNumber
	cabinState checkCabinSensorMoving.
	cabinState _ Stopped new.
	self checkForJumpingFloors: aFloorNumber.
	floorNumber _ aFloorNumber.
	doorState _ Opening new.
	state _ Working new.
	floorsToGo _ floorsToGo - 1.! !

!ElevatorController methodsFor: 'automatic behaviour' stamp: 'NH 10/11/2017 10:27:54'!
checkForJumpingFloors: aFloorNumber
	aFloorNumber = (self cabinFloorNumber + 1) ifFalse: [ ElevatorEmergency cabinSensor signal ].
! !

!ElevatorController methodsFor: 'automatic behaviour' stamp: 'NH 10/11/2017 10:50:24'!
waitForPeopleTimedOut
	doorState _ Closing new.! !


!ElevatorController methodsFor: 'open door' stamp: 'NH 10/11/2017 10:50:24'!
openWhenDoorIsClosing
	doorState _ Opening new.! !

!ElevatorController methodsFor: 'open door' stamp: 'NH 10/11/2017 10:50:24'!
openWhenDoorIsOpen
	"La puerta sigue abierta"
	doorState _ Open new.! !

!ElevatorController methodsFor: 'open door' stamp: 'NH 10/11/2017 10:50:24'!
openWhenDoorIsOpening
	doorState _ Opening new.! !

!ElevatorController methodsFor: 'open door' stamp: 'NH 10/11/2017 10:50:24'!
openWhenMovingCabin
	doorState _ Closed new.! !

!ElevatorController methodsFor: 'open door' stamp: 'NH 10/11/2017 10:50:24'!
openWhenStoppedCabin
	doorState openButtonPushedIn: self.! !


!ElevatorController methodsFor: 'close door' stamp: 'NH 10/10/2017 18:59:55'!
closeWhenIdle
	"Do nothing"
	^nil! !

!ElevatorController methodsFor: 'close door' stamp: 'NH 10/10/2017 23:24:21'!
closeWhenMoving
	"Do nothing"
	^nil! !

!ElevatorController methodsFor: 'close door' stamp: 'NH 10/11/2017 10:50:24'!
closeWhenOpen
	^ doorState _ Closing new.! !

!ElevatorController methodsFor: 'close door' stamp: 'NH 10/11/2017 00:21:49'!
closeWhenOpening
	"Do nothing"
	^nil! !

!ElevatorController methodsFor: 'close door' stamp: 'NH 10/11/2017 10:50:24'!
closeWhenStopped
	doorState closeButtonPushedIn: self.! !

!ElevatorController methodsFor: 'close door' stamp: 'NH 10/10/2017 19:01:16'!
closeWhenWorking
	cabinState closeButtonPushedIn: self.! !


!ElevatorController methodsFor: 'button pushed' stamp: 'NH 10/11/2017 00:22:20'!
closeCabinDoor
	state closeButtonPushedIn: self.
! !

!ElevatorController methodsFor: 'button pushed' stamp: 'NH 10/11/2017 10:50:24'!
goUpPushedFromFloor: aFloorNumber
	state _ Working new.
	doorState _ Closing new.
	floorsToGo _ floorsToGo + 1.! !

!ElevatorController methodsFor: 'button pushed' stamp: 'NH 10/5/2017 20:11:46'!
openCabinDoor
	cabinState openButtonPushedIn: self.! !


!ElevatorController methodsFor: 'initialization' stamp: 'NH 10/11/2017 10:50:24'!
initialize
	state _ Idle new.
	doorState _ Open new.
	floorNumber _ 0.
	cabinState _ Stopped new.
	floorsToGo _ 0.! !


!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/2/2017 21:26:31'!
cabinFloorNumber

	^floorNumber ! !

!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/11/2017 10:50:24'!
isCabinDoorClosed
	^ doorState isClosed.! !

!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/11/2017 10:50:24'!
isCabinDoorClosing
	^ doorState isClosing.! !

!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/11/2017 10:50:24'!
isCabinDoorOpened
	^ doorState isOpened.! !

!ElevatorController methodsFor: 'elevator status' stamp: 'NH 10/11/2017 10:50:24'!
isCabinDoorOpening
	^ doorState isOpening.! !

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

!ElevatorState methodsFor: 'state' stamp: 'NH 10/4/2017 18:22:11'!
isIdle
	self subclassResponsibility.! !

!ElevatorState methodsFor: 'state' stamp: 'NH 10/4/2017 18:35:45'!
isWorking
	self subclassResponsibility.! !


!ElevatorState methodsFor: 'controller interaction' stamp: 'NH 10/10/2017 23:20:51'!
closeButtonPushedIn: anElevatorController 
	self subclassResponsibility.! !


!classDefinition: #Idle category: #'Elevator-Ejercicio'!
ElevatorState subclass: #Idle
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Idle methodsFor: 'state' stamp: 'NH 10/4/2017 18:22:32'!
isIdle
	^true.! !

!Idle methodsFor: 'state' stamp: 'NH 10/5/2017 18:13:30'!
isWorking
	^false.! !


!Idle methodsFor: 'controller interaction' stamp: 'NH 10/10/2017 23:21:16'!
closeButtonPushedIn: anElevatorController 
	anElevatorController closeWhenIdle.! !


!classDefinition: #Working category: #'Elevator-Ejercicio'!
ElevatorState subclass: #Working
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Working methodsFor: 'state' stamp: 'NH 10/4/2017 18:34:29'!
isIdle
	^false.! !

!Working methodsFor: 'state' stamp: 'NH 10/4/2017 18:36:34'!
isWorking
	^true.! !


!Working methodsFor: 'controller interaction' stamp: 'NH 10/10/2017 23:23:00'!
closeButtonPushedIn: anElevatorController 
	anElevatorController closeWhenWorking.! !
