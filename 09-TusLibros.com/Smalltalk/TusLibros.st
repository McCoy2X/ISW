!classDefinition: #XXXTest category: #TusLibros!
TestCase subclass: #XXXTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:28:16'!
test01CarritoComienzaVacio
	| aCart aPublisher |
	aPublisher _ Publisher new.
	aCart _ Cart newOf: aPublisher.
	self assert: aCart isEmpty.! !

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:30:47'!
test02CarritoNoVacioCuandoSeAgregaLibro
	| aCart aPublisher aBook |
	aPublisher _ Publisher new.
	aCart _ Cart newOf: aPublisher.
	aBook _ 'hola'.
	aPublisher addBook: aBook.
	aCart addBook: aBook.
	self deny: aCart isEmpty.! !

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:33:38'!
test03NoSePuedeAgregarAlCarritoLibroQueNoEsDeEditorial

	| aCart aPublisher aBook |
	aPublisher _ Publisher new.
	aCart _ Cart newOf: aPublisher.
	aBook _ 'hola'.
	self should: [aCart addBook: aBook] raise: Error withExceptionDo: [:exception | (exception messageText) = 'ISBN not in catalog'].
! !

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:48:34'!
test04CarritoPuedeAgregarVariosUnidadesDelMismoLibroALaVez
	| aCart aPublisher aBook |
	aPublisher _ Publisher new.
	aCart _ Cart newOf: aPublisher.
	aBook _ 'hola'.
	aPublisher addBook: aBook.
	aCart add: 50 of: aBook.
	self assert: (aCart quantityOf: aBook) = 50. ! !

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:59:49'!
test05AgregarLibrosEsAcumulativo
	| aCart aPublisher aBook |
	aPublisher _ Publisher new.
	aCart _ Cart newOf: aPublisher.
	aBook _ 'hola'.
	aPublisher addBook: aBook.
	3 timesRepeat: [aCart addBook: aBook].
	self assert: (aCart quantityOf: aBook) = 3. ! !

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 21:12:27'!
test06CheckoutWorksxxxxxxxxxxxxx

	| aCart aPublisher aBook |
	aPublisher _ Publisher new.
	aCart _ Cart newOf: aPublisher.
	aBook _ 'hola'.
	aPublisher addBook: aBook.
	aCart add: 50 of: aBook.
	self assert: (aCart quantityOf: aBook) = 50. ! !


!classDefinition: #Cart category: #TusLibros!
Object subclass: #Cart
	instanceVariableNames: 'publisher contents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:54:04'!
add: anAmount of: aBook 
	contents add: aBook withOccurrences: anAmount. ! !

!Cart methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:55:47'!
addBook: anISBN
	(publisher isOnCatalog: anISBN) ifFalse: [Error signal: 'ISBN not in catalog'].
	contents add: anISBN withOccurrences: 1.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:55:57'!
initializeWith: aPublisher 
	publisher _ aPublisher.
	contents _ Bag new.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:36:33'!
isEmpty
	^contents isEmpty .! !

!Cart methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:57:24'!
quantityOf: aBook
	^ contents occurrencesOf: aBook.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #TusLibros!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:36:11'!
newOf: aPublisher 
	^self new initializeWith: aPublisher.! !


!classDefinition: #Cashier category: #TusLibros!
Object subclass: #Cashier
	instanceVariableNames: 'books'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 21:11:23'!
checkout: aCart
	^(aCart contents) inject: 0 into: [:acumulator :asociation |  acumulator + (self priceOf: (asociation key)  ) * asociation value ].! !


!classDefinition: #Publisher category: #TusLibros!
Object subclass: #Publisher
	instanceVariableNames: 'books'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Publisher methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:37:18'!
addBook: anISBN
	books add: anISBN.! !

!Publisher methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:37:42'!
initialize
	books _ OrderedCollection new.! !

!Publisher methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:40:32'!
isOnCatalog: anISBN
	^books includes: anISBN.! !
