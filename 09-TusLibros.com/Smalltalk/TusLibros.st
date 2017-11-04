!classDefinition: #OnlineInterfaceTest category: #TusLibros!
TestCase subclass: #OnlineInterfaceTest
	instanceVariableNames: 'interface nonRegisteredClient nonRegisteredClientPassword registeredClient registeredClientPassword aRegisteredBook factory priceCatalog'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 20:01:45'!
clientRegister
	| register |
	register _ Dictionary new.
	register at: registeredClient put: registeredClientPassword.
	^register! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:17:37'!
createInterface
	^ OnlineInterface newWithClientRegister: self clientRegister withPriceBook: factory priceBook.! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'NH 11/3/2017 11:06:27'!
setUp
	factory _ TestObjectFactory new.
	registeredClient _ 'PepeSanchez'.
	registeredClientPassword _ 'cabildo45678'.
	nonRegisteredClient _ 'easyBotnet23'.
	nonRegisteredClientPassword _ '1234'.
	interface _ self createInterface.

! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'NH 11/3/2017 12:59:24'!
test01CreatingCartForNonRegisteredClientFails
	self
		should: [
			interface
				createCartFor: nonRegisteredClient
				withPassword: nonRegisteredClientPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anException |
			self assert: anException messageText = 'Client not found' ].! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'NH 11/3/2017 12:57:44'!
test02CreatingCartFailsForRegisteredClientAndWrongPassword
	self
		should: [
			interface
				createCartFor: registeredClient
				withPassword: nonRegisteredClientPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anException |
			self assert: anException messageText = 'Client and Password do not match' ].! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 20:26:36'!
test03AuthenticatedClientCanCreateCart
	| aCartId |
	aCartId _ interface createCartFor: registeredClient withPassword: registeredClientPassword.
	self assert: ((interface listCart: aCartId) isEmpty).! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 20:39:14'!
test04CanAddBooksToCartThroughInterface
	| aCartId |
	aCartId _ interface
		createCartFor: registeredClient
		withPassword: registeredClientPassword.
	interface
		addToCart: aCartId
		m1: 20
		ofBook: aRegisteredBook.
	self assert: ((interface listCart: aCartId) occurrencesOf: aRegisteredBook) = 20.! !


!classDefinition: #StoreTest category: #TusLibros!
TestCase subclass: #StoreTest
	instanceVariableNames: 'aCart aCashier invalidCreditCard validCreditCard simulatedMerchantinterface merchantBehaviour factory'
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

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/3/2017 14:59:40'!
test04CarritoPuedeAgregarVariosUnidadesDelMismoLibroALaVez
	|  aBook |
	aBook _ factory itemSoldByTheStore.
	aCart
		add: 50
		of: aBook.
	self assert: (aCart quantityOf: aBook) = 50.! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/3/2017 15:02:15'!
test05AgregarLibrosEsAcumulativo
	| aBook |
	aBook _ factory itemSoldByTheStore.
	3 timesRepeat: [ aCart addBook: aBook].
	self assert: (aCart quantityOf: aBook) = 3.! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/2/2017 17:44:06'!
test06CheckoutEmptyCartShouldFail
	
	self
		should: [ aCashier checkout: aCart withCreditCard: validCreditCard]
		raise: Error
		withExceptionDo: [ :anException |
			self assert: anException messageText = 'Can not checkout an empty cart'.
			self assert: aCashier isSalesBookEmpty ].! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/2/2017 18:54:08'!
test07CheckoutWithExpiredCreditCardShouldFail
	aCart addBook: self itemSoldByTheStore.
	merchantBehaviour _ [:anAmount :aCreditCard | self fail].
	self
		should: [
			aCashier
				checkout: aCart
				withCreditCard: invalidCreditCard ]
		raise: Error
		withExceptionDo: [ :anException |
			self assert: anException messageText = 'Can not checkout with expired credit card'.
			self assert: aCashier isSalesBookEmpty ].! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/2/2017 19:21:12'!
test08CheckoutaValidCartWithaValidCreditCard
	| debitedFrom totalDebited |
	aCart
		add: 20
		of: self itemSoldByTheStore.
	merchantBehaviour _ [ :anAmount :aCreditCard |
	totalDebited _ anAmount.
	debitedFrom _ aCreditCard ].
	self assert:
		(aCashier
			checkout: aCart
			withCreditCard: validCreditCard) = (2000 * peso).
	self assert: aCashier isSalesBookEmpty not.
	self assert: totalDebited = (2000 * peso).
	self assert: debitedFrom = validCreditCard.! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/2/2017 19:01:58'!
test09CheckoutShouldFailWhenCreditCardOutOfFunds
	aCart
		add: 20
		of: self itemSoldByTheStore.
	merchantBehaviour _ [:anAmount :aCreditCard | self error: self outOfFundsErrorDescription ].
	self should: [aCashier checkout: aCart withCreditCard: validCreditCard]  raise:  Error - MessageNotUnderstood withExceptionDo: [:anException|
		self assert: anException messageText = 'Credit card out of funds'.
		self assert: aCashier isSalesBookEmpty].
		! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/2/2017 19:01:14'!
test10CheckoutShouldFailWhenCreditCardStolen
	aCart
		add: 20
		of: self itemSoldByTheStore.
	merchantBehaviour _ [:anAmount :aCreditCard | self error: self stolenCreditCardErrorDescription].
	self should: [aCashier checkout: aCart withCreditCard: validCreditCard]  raise:  Error - MessageNotUnderstood withExceptionDo: [:anException|
		self assert: anException messageText = 'Credit card stolen'.
		self assert: aCashier isSalesBookEmpty].
		! !


!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:18:37'!
createCart
	^ Cart withCatalog: self priceBook keys.! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 18:43:22'!
debit: aSimpleMeasure from: aCreditCard 
	merchantBehaviour value: aSimpleMeasure value: aCreditCard.! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 18:34:36'!
expiredCreditCard
	^ CreditCard
		withNumber: 450000000
		expiringOn: (GregorianMonthOfYear current previous: GregorianMonth twoMonths).! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 10/27/2017 13:46:05'!
itemNotSoldByTheStore
	^'The Community Of The Ring'! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 20:43:39'!
itemSoldByTheStore
	^ 'A Song Of Ice And Fire'.! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 20:43:12'!
itemSoldByTheStorePrice
	^100*peso! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 18:48:56'!
outOfFundsErrorDescription
	^'Credit card out of funds'! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:18:37'!
priceBook
	| catalog |
	catalog _ Dictionary new.
	catalog
		at: self itemSoldByTheStore
		put: self itemSoldByTheStorePrice.
	^ catalog.! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 11/3/2017 12:28:00'!
setUp
	factory _ TestObjectFactory new.
	aCart _ factory createCart.
	aCashier _ factory createCashierWithMerchantProcessor: self.
	invalidCreditCard _ factory expiredCreditCard.
	validCreditCard _ factory validCreditCard.
	merchantBehaviour _ [:anAmount :aCreditCard | ].! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 19:01:33'!
stolenCreditCardErrorDescription
	^'Credit card stolen'! !

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
	instanceVariableNames: 'books salesBook priceList merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 18:14:01'!
cartEmptyErrorDescription
	^'Can not checkout an empty cart'! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 18:55:16'!
checkout: aCart withCreditCard: aCreditCard
	| total |
	aCart isEmpty ifTrue: [ Error signal: self cartEmptyErrorDescription ].
	(aCreditCard isInvalidAtDate: GregorianMonthOfYear current) ifTrue: [ Error signal: self expiredCreditCardErrorDescription ].
	total _ aCart contents
		inject: 0
		into: [ :suma :book |
			suma + (self priceOf: book) ].
	merchantProcessor
		debit: total
		from: aCreditCard.
	salesBook add: aCart.
	^ total.! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 18:58:30'!
expiredCreditCardErrorDescription
	^ 'Can not checkout with expired credit card'.! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 10/30/2017 20:09:05'!
initializeWithCatalog: aCatalog
	salesBook _ OrderedCollection new.
	priceList _ aCatalog.! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 17:43:07'!
initializeWithCatalog: aCatalog andMerchantProcessor: aMerchant
	salesBook _ OrderedCollection new.
	priceList _ aCatalog.
	merchantProcessor _ aMerchant.! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 11/4/2017 17:02:40'!
initializeWithCatalog: aCatalog withSalesBook: anOrderedCollection andMerchantProcessor: aMerchant 
	salesBook _ OrderedCollection new.
	priceList _ aCatalog.
	merchantProcessor _ aMerchant.! !

!Cashier methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 18:55:36'!
invalidCreditCardErrorDescription
	^'Can not checkout with expired credit card'.! !

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

!Cashier class methodsFor: 'as yet unclassified' stamp: 'NH 11/3/2017 14:53:50'!
newWithPriceCatalog: aCatalog withSalesBook: aSalesBook withMerchantProcessor: aMerchant
	^self new initializeWithCatalog:  aCatalog withSalesBook: aSalesBook andMerchantProcessor: aMerchant.! !


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


!classDefinition: #OnlineInterface category: #TusLibros!
Object subclass: #OnlineInterface
	instanceVariableNames: 'clients editorialPriceBook carts'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!OnlineInterface methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 20:57:16'!
addToCart: aCartId m1: amount ofBook: anISBN
	| aCart |
	aCart _ self cartFor: aCartId.
	aCart add: amount of: anISBN.! !

!OnlineInterface methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 20:20:51'!
authenticate: aClientId withPassword: aPassword.
	(clients includesKey: aClientId) ifFalse: [ Error signal: self clientNotFoundErrorDescription ].
	( (clients at: aClientId) = aPassword) ifFalse: [ Error signal: self wrongPasswordErrorDescription ].! !

!OnlineInterface methodsFor: 'as yet unclassified' stamp: 'NH 11/3/2017 11:17:07'!
cartFor: aCartId
	^ carts at: aCartId.! !

!OnlineInterface methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 19:48:43'!
clientNotFoundErrorDescription
	^'Client not found'! !

!OnlineInterface methodsFor: 'as yet unclassified' stamp: 'NH 11/3/2017 11:34:19'!
createCartFor: aClientId withPassword: aPassword
	| aCart cartId |
	self authenticate: aClientId withPassword: aPassword.
	aCart _ Cart withCatalog: editorialPriceBook keys.
	cartId _ self idFor: aCart.
	carts at: cartId put: aCart .
	^cartId! !

!OnlineInterface methodsFor: 'as yet unclassified' stamp: 'NH 11/3/2017 11:07:53'!
idFor: aCart 
	^'1'! !

!OnlineInterface methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 19:59:31'!
initializeWith: aClientRegister
	clients _ aClientRegister.! !

!OnlineInterface methodsFor: 'as yet unclassified' stamp: 'NH 11/3/2017 11:18:02'!
initializeWith: aClientRegister withPriceBook: aPriceBook
	clients _ aClientRegister.
	editorialPriceBook _ aPriceBook .
	carts _ Dictionary new.
	! !

!OnlineInterface methodsFor: 'as yet unclassified' stamp: 'NH 11/3/2017 16:08:57'!
listCart: aCartId 
	| cart |
	cart := self cartFor: aCartId. 
	^cart contents.! !

!OnlineInterface methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 20:10:57'!
wrongPasswordErrorDescription
	^'Client and Password do not match'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OnlineInterface class' category: #TusLibros!
OnlineInterface class
	instanceVariableNames: ''!

!OnlineInterface class methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 20:48:47'!
newWithClientRegister: aDictionary
	^ self new initializeWith: aDictionary.! !

!OnlineInterface class methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:02:26'!
newWithClientRegister: aDictionary withPriceBook: aPriceBook
	^ self new initializeWith: aDictionary withPriceBook: aPriceBook.! !


!classDefinition: #TestObjectFactory category: #TusLibros!
Object subclass: #TestObjectFactory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:18:37'!
createCart
	^ Cart withCatalog: self priceBook keys.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/3/2017 14:54:49'!
createCashierWithMerchantProcessor: aMerchant
	^ Cashier
		newWithPriceCatalog: self priceBook
		withSalesBook: self salesBook
		withMerchantProcessor: aMerchant.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:08:38'!
expiredCreditCard
	^ CreditCard
		withNumber: 450000000
		expiringOn: (GregorianMonthOfYear current previous: GregorianMonth twoMonths).! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:09:10'!
itemNotSoldByTheStore
	^'The Community Of The Ring'! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:07:49'!
itemSoldByTheStore
	^ 'A Song Of Ice And Fire'.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:08:01'!
itemSoldByTheStorePrice
	^100*peso! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:18:37'!
priceBook
	| catalog |
	catalog _ Dictionary new.
	catalog
		at: self itemSoldByTheStore
		put: self itemSoldByTheStorePrice.
	^ catalog.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/4/2017 16:59:57'!
salesBook
	^OrderedCollection new.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:08:25'!
validCreditCard
	^CreditCard withNumber: 450000001 expiringOn:( GregorianMonthOfYear current next: GregorianMonth twoMonths ).
	! !
