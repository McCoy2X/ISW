!classDefinition: #StoreTest category: #TusLibros!
TestCase subclass: #StoreTest
	instanceVariableNames: 'aCart aCashier invalidCreditCard validCreditCard simulatedMerchantinterface'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTest methodsFor: 'Testing' stamp: 'NH 10/30/2017 20:44:21'!
test01CarritoComienzaVacio
	self assert: aCart isEmpty.! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 10/30/2017 20:46:45'!
test02CarritoNoVacioCuandoSeAgregaLibro
	
	aCart addBook: self itemSoldByTheStore.
	self deny: aCart isEmpty.! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 10/30/2017 20:47:10'!
test03NoSePuedeAgregarAlCarritoLibroQueNoEsDeEditorial
	
	self
		should: [ aCart addBook: self itemNotSoldByTheStore ]
		raise: Error
		withExceptionDo: [ :exception |
			self assert: exception messageText = 'ISBN not in catalog'.
			self assert: aCart isEmpty ].! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 10/30/2017 20:43:39'!
test04CarritoPuedeAgregarVariosUnidadesDelMismoLibroALaVez
	| aCart aBook |
	aCart _ self createCart.
	aBook _ self itemSoldByTheStore.
	aCart
		add: 50
		of: aBook.
	self assert: (aCart quantityOf: aBook) = 50.! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 10/30/2017 20:48:07'!
test05AgregarLibrosEsAcumulativo
	3 timesRepeat: [ aCart addBook: self itemSoldByTheStore].
	self assert: (aCart quantityOf: self itemSoldByTheStore) = 3.! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 10/30/2017 20:48:56'!
test06CheckoutEmptyCartShouldFail
	
	self
		should: [ aCashier checkout: aCart ]
		raise: Error
		withExceptionDo: [ :anException |
			self assert: anException messageText = 'Can not checkout an empty cart'.
			self assert: aCashier isSalesBookEmpty ].! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 10/30/2017 20:52:15'!
test07CheckoutWithInvalidCreditCardShouldFail
	aCart addBook: self itemSoldByTheStore.
	self
		should: [
			aCashier
				checkout: aCart
				withCreditCard: invalidCreditCard ]
		raise: Error
		withExceptionDo: [ :anException |
			self assert: anException messageText = 'Can not checkout with invalid credit card'.
			self assert: aCashier isSalesBookEmpty ].! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 10/30/2017 21:10:37'!
test08CheckoutaValidCartWithaValidCreditCardNumber
	aCart
		add: 20
		of: self itemSoldByTheStore.
	self assert:
		(aCashier
			checkout: aCart
			withCreditCard: validCreditCard ) = (2000 * peso).
			! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 10/30/2017 21:24:47'!
test09CheckoutShouldFailWhenCreditCardOutOfFunds
	aCart
		add: 20
		of: self itemSoldByTheStore.
	simulatedMerchantinterface addOutOfFundsCard: validCreditCard.
	self should: [aCashier checkout: aCart withCreditCard: validCreditCard]  raise:  Error withExceptionDo: [:anException|
		self assert: anException messageText = 'Credit card out of funds'.
		self assert:  nil]."TODO"! !


!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 21:03:06'!
createCart
	^Cart withCatalog: self priceCatalog keys.! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 19:10:53'!
createCashier
	^Cashier newWithPriceCatalog: (self priceCatalog).! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 10/31/2017 18:47:41'!
invalidCreditCard
	^ CreditCard withNumber: 450000000 expiringOn:( GregorianMonthOfYear current previous: GregorianMonth twoMonths ).! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:46:05'!
itemNotSoldByTheStore
	^'The Community Of The Ring'! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 20:43:39'!
itemSoldByTheStore
	^ 'A Song Of Ice And Fire'.! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 20:43:12'!
itemSoldByTheStorePrice
	^100*peso! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 20:43:39'!
priceCatalog
	| catalog |
	catalog _ Dictionary new.
	catalog
		at: self itemSoldByTheStore
		put: self itemSoldByTheStorePrice.
	^ catalog.! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 21:25:53'!
setUp
	aCart _ self createCart.
	aCashier _ self createCashier. 
	invalidCreditCard _ self invalidCreditCard .
	validCreditCard _ self validCreditCard .
	simulatedMerchantinterface _ SimulatedMerchant new.! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 10/31/2017 18:48:13'!
validCreditCard
	^CreditCard withNumber: 450000001 expiringOn:( GregorianMonthOfYear current next: GregorianMonth twoMonths ).
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

!Cart methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 19:21:39'!
contents
	^contents! !

!Cart methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 21:03:16'!
initializeWith: aBookCatalog
	catalog _ aBookCatalog.
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
	instanceVariableNames: 'books salesBook priceList'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 18:14:01'!
cartEmptyErrorDescription
	^'Can not checkout an empty cart'! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 18:13:01'!
checkout: aCart
	(aCart isEmpty ) ifTrue: [Error signal: self cartEmptyErrorDescription]! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 20:06:02'!
checkout: aCart withCreditCard: aCreditCard
	(aCart isEmpty ) ifTrue: [Error signal: self cartEmptyErrorDescription].
	(aCreditCard isInvalidAtDate: FixedGregorianDate today) ifTrue: [Error signal: self invalidCreditCardErrorDescription].
	^aCart contents inject: 0 into: [:suma :book | suma + (self priceOf: book)]! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 20:09:05'!
initializeWithCatalog: aCatalog
	salesBook _ OrderedCollection new.
	priceList _ aCatalog.! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 18:43:50'!
invalidCreditCardErrorDescription
	^'Can not checkout with invalid credit card'.! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 20:51:07'!
isSalesBookEmpty
	^salesBook isEmpty.! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 20:09:05'!
priceOf: anISBN
	^ priceList at: anISBN.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #TusLibros!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 19:12:45'!
newWithPriceCatalog: aCatalog 
	^self new initializeWithCatalog: aCatalog .! !


!classDefinition: #CreditCard category: #TusLibros!
Object subclass: #CreditCard
	instanceVariableNames: 'number expirationDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 18:41:02'!
initializeWithNumber: aCreditCardNumber andExpirationDate: aDate
	number _ aCreditCardNumber .
	expirationDate _ aDate.! !

!CreditCard methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 19:46:00'!
isInvalidAtDate: aDate
	^expirationDate < aDate! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: #TusLibros!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 18:38:32'!
withNumber: aCreditCardNumber expiringOn: aDate
	^self new initializeWithNumber: aCreditCardNumber andExpirationDate: aDate.! !


!classDefinition: #SimulatedMerchant category: #TusLibros!
Object subclass: #SimulatedMerchant
	instanceVariableNames: 'outOfFundsCards'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!SimulatedMerchant methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 21:27:09'!
addOutOfFundsCard: aCreditCard 
	outOfFundsCards add: aCreditCard.! !

!SimulatedMerchant methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 21:27:38'!
initialize
	outOfFundsCards _ OrderedCollection new.! !
