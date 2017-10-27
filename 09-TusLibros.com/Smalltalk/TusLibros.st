!classDefinition: #XXXTest category: #TusLibros!
TestCase subclass: #XXXTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:40:01'!
bookCatalog
	| catalog |
	catalog _ OrderedCollection new.
	catalog add: self itemSellByTheStore.
	catalog add: 'something'.
	^catalog.! !

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:29:54'!
createCart
	^Cart withCatalog: self bookCatalog.! !

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:46:05'!
itemNotSoldByTheStore
	^'The Community Of The Ring'! !

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:40:49'!
itemSellByTheStore
	^'A Song Of Ice And Fire'! !

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:14:24'!
test01CarritoComienzaVacio
	| aCart |
	aCart _ self createCart.
	self assert: aCart isEmpty.! !

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:38:16'!
test02CarritoNoVacioCuandoSeAgregaLibro
	| aCart aBook |
	aCart _ self createCart .
	aBook _ self itemSellByTheStore.
	aCart addBook: aBook.
	self deny: aCart isEmpty.! !

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:54:14'!
test03NoSePuedeAgregarAlCarritoLibroQueNoEsDeEditorial
	| aCart aBook |
	aCart _ self createCart.
	aBook _ self itemNotSoldByTheStore.
	
	self
		should: [ aCart addBook: aBook ]
		raise: Error
		withExceptionDo: [ :exception |
			self assert: exception messageText = 'ISBN not in catalog'.
			self assert: aCart isEmpty ].! !

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:47:36'!
test04CarritoPuedeAgregarVariosUnidadesDelMismoLibroALaVez
	| aCart aBook |
	aCart _ self createCart .
	aBook _ self itemSellByTheStore.
	aCart add: 50 of: aBook.
	self assert: (aCart quantityOf: aBook) = 50. ! !

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:48:51'!
test05AgregarLibrosEsAcumulativo
	| aCart aBook |
	aCart _ self createCart .
	aBook _ self itemSellByTheStore.
	3 timesRepeat: [aCart addBook: aBook].
	self assert: (aCart quantityOf: aBook) = 3. ! !

!XXXTest methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:52:45'!
test06CheckoutEmptyCartShouldFail
"TODO IMPLEMENTAR"
	| aCart |
	aCart _ self createCart.
! !


!classDefinition: #Cart category: #TusLibros!
Object subclass: #Cart
	instanceVariableNames: 'contents catalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 20:54:04'!
add: anAmount of: aBook 
	contents add: aBook withOccurrences: anAmount. ! !

!Cart methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:43:34'!
addBook: anISBN
	(catalog includes: anISBN) ifFalse: [ Error signal: 'ISBN not in catalog' ].
	contents
		add: anISBN
		withOccurrences: 1.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:42:45'!
initializeWith: aPublisher
	catalog _ aPublisher.
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

!Cart class methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:41:54'!
withCatalog: aBookCatalog 
	^self new initializeWith: aBookCatalog.! !


!classDefinition: #Cashier category: #TusLibros!
Object subclass: #Cashier
	instanceVariableNames: 'books'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 10/26/2017 21:11:23'!
checkout: aCart
	^(aCart contents) inject: 0 into: [:acumulator :asociation |  acumulator + (self priceOf: (asociation key)  ) * asociation value ].! !
