!classDefinition: #OnlineInterfaceTest category: #TusLibros!
TestCase subclass: #OnlineInterfaceTest
	instanceVariableNames: 'interface nonRegisteredClient nonRegisteredClientPassword registeredClient registeredClientPassword aRegisteredBook factory priceCatalog merchantBehaviour timerIncrement'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 20:01:45'!
clientRegister
	| register |
	register _ Dictionary new.
	register at: registeredClient put: registeredClientPassword.
	^register! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 15:26:46'!
createInterface
	^ OnlineInterface newWithClientRegister: self clientRegister withPriceBook: factory priceBook withMerchantProcessor: self.! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 17:04:30'!
debit: anAmountOfMoney from: aCreditCard 
	merchantBehaviour value: anAmountOfMoney value: aCreditCard.! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'ISW 11/6/2017 00:42:18'!
expireTimer
	
	timerIncrement _ 30.! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'ISW 11/6/2017 00:40:58'!
minutesElapsedSinceStart
	^ timerIncrement.! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'ISW 11/6/2017 00:42:28'!
restartTimer

	timerIncrement _ 0.! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'ISW 11/6/2017 00:40:43'!
setUp
	factory _ TestObjectFactory new.
	registeredClient _ factory registeredClient.
	registeredClientPassword _ 'cabildo45678'.
	nonRegisteredClient _ 'easyBotnet23'.
	nonRegisteredClientPassword _ '1234'.
	aRegisteredBook _ factory itemSoldByTheStore.
	interface _ self createInterface.
	merchantBehaviour _ factory defaultMerchantBehaviour.
	
	timerIncrement _ 0.

! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'ISW 11/5/2017 23:53:22'!
test01CreatingCartForNonRegisteredClientFails
	self
		should: [
			interface
				createCartFor: nonRegisteredClient
				withPassword: nonRegisteredClientPassword
			
				withTimer: self. ]
				
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anException |
			self assert: anException messageText = 'Client not found' ].! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'ISW 11/5/2017 23:53:44'!
test02CreatingCartFailsForRegisteredClientAndWrongPassword
	self
		should: [
			interface
				createCartFor: registeredClient
				withPassword: nonRegisteredClientPassword
				
				withTimer: self ]
			
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anException |
			self assert: anException messageText = 'Client and Password do not match' ].! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'ISW 11/5/2017 23:54:04'!
test03AuthenticatedClientCanCreateCart
	| aCartId |
	aCartId _ interface createCartFor: registeredClient withPassword: registeredClientPassword withTimer: self.
	
	self assert: ((interface listCart: aCartId) isEmpty).! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'ISW 11/5/2017 23:54:23'!
test04CanAddBooksToCartThroughInterface
	| aCartId |
	aCartId _ interface
		createCartFor: registeredClient
		withPassword: registeredClientPassword
		
		withTimer: self.
		
	interface
		addToCart: aCartId
		anAmount: 20
		ofBook: aRegisteredBook.
	self assert: ((interface listCart: aCartId) occurrencesOf: aRegisteredBook) = 20.! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'ISW 11/6/2017 00:16:50'!
test05CheckoutCartThroughInterfaceShouldBeRegisteredOnSalesBook
	| aCartId ccn expirationDate transaction purchaseList |
	aCartId _ interface
		createCartFor: registeredClient
		withPassword: registeredClientPassword
		
		withTimer: self.
	interface
		addToCart: aCartId
		anAmount: 20
		ofBook: aRegisteredBook.
	ccn _ factory validCreditCardNumber.
	expirationDate _ factory validCreditCardExpirationDate.
	transaction _ interface checkoutCart: aCartId  withCreditCardNumber: ccn expiringOn: expirationDate ownedBy: registeredClient. 
	
	purchaseList _ (interface listPurchasesOf: registeredClient withPassword: registeredClientPassword).
	self assert: (purchaseList atWrap: 1 ) = (transaction atWrap: 1).
	self assert: (purchaseList atWrap: 2 ) = (transaction atWrap: 2).
	! !

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'ISW 11/6/2017 00:41:53'!
test06CartExpiresAfter30Minutes

	| aCartId |
	
	aCartId _ interface
		createCartFor: registeredClient
		withPassword: registeredClientPassword
		withTimer: self.
	
	self expireTimer.
		
	self should:
			[interface
			addToCart: aCartId
			anAmount: 20
			ofBook: aRegisteredBook.]
		  raise: Error
		  withExceptionDo:
			[ :anException |
				self assert: anException messageText = 'Cart has expired'.
				self restartTimer]! !


!classDefinition: #StoreTest category: #TusLibros!
TestCase subclass: #StoreTest
	instanceVariableNames: 'aCart aCashier invalidCreditCard validCreditCard simulatedMerchantinterface merchantBehaviour factory salesBook'
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

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/5/2017 09:34:04'!
test06CheckoutEmptyCartShouldFail
	
	self
		should: [ aCashier checkout: aCart withCreditCard: validCreditCard]
		raise: Error
		withExceptionDo: [ :anException |
			self assert: anException messageText = 'Can not checkout an empty cart'.
			self assert: salesBook isEmpty ].! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/5/2017 09:34:44'!
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
			self assert: salesBook isEmpty ].! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/5/2017 09:35:08'!
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
	self assert: salesBook isEmpty not.
	self assert: totalDebited = (2000 * peso).
	self assert: debitedFrom = validCreditCard.! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/5/2017 09:35:30'!
test09CheckoutShouldFailWhenCreditCardOutOfFunds
	aCart
		add: 20
		of: self itemSoldByTheStore.
	merchantBehaviour _ [:anAmount :aCreditCard | self error: self outOfFundsErrorDescription ].
	self should: [aCashier checkout: aCart withCreditCard: validCreditCard]  raise:  Error - MessageNotUnderstood withExceptionDo: [:anException|
		self assert: anException messageText = 'Credit card out of funds'.
		self assert: salesBook isEmpty].
		! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/5/2017 09:35:52'!
test10CheckoutShouldFailWhenCreditCardStolen
	aCart
		add: 20
		of: self itemSoldByTheStore.
	merchantBehaviour _ [:anAmount :aCreditCard | self error: self stolenCreditCardErrorDescription].
	self should: [aCashier checkout: aCart withCreditCard: validCreditCard]  raise:  Error - MessageNotUnderstood withExceptionDo: [:anException|
		self assert: anException messageText = 'Credit card stolen'.
		self assert: salesBook isEmpty].
		! !


!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:18:37'!
createCart
	^ Cart withCatalog: self priceBook keys.! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 18:43:22'!
debit: aSimpleMeasure from: aCreditCard 
	merchantBehaviour value: aSimpleMeasure value: aCreditCard.! !

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 17:33:11'!
expiredCreditCard
	^ CreditCard
		withNumber: 450000000
		expiringOn: (GregorianMonthOfYear current previous: GregorianMonth twoMonths)
		ownedBy: self.! !

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

!StoreTest methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 17:06:26'!
setUp
	factory _ TestObjectFactory new.
	aCart _ factory createCart.
	salesBook _ factory salesBook.
	aCashier _ factory createCashierWithMerchantProcessor: self withSalesBook: salesBook.
	invalidCreditCard _ factory expiredCreditCard.
	validCreditCard _ factory validCreditCard.
	merchantBehaviour _ factory defaultMerchantBehaviour.! !

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

!Cart methodsFor: 'adding' stamp: 'NH 10/26/2017 20:54:04'!
add: anAmount of: aBook 
	contents add: aBook withOccurrences: anAmount. ! !

!Cart methodsFor: 'adding' stamp: 'NH 10/27/2017 13:43:34'!
addBook: anISBN
	(catalog includes: anISBN) ifFalse: [ Error signal: 'ISBN not in catalog' ].
	contents
		add: anISBN
		withOccurrences: 1.! !


!Cart methodsFor: 'initialization' stamp: 'NH 10/30/2017 21:03:16'!
initializeWith: aBookCatalog
	catalog _ aBookCatalog.
	contents _ Bag new.! !


!Cart methodsFor: 'testing' stamp: 'NH 10/26/2017 20:36:33'!
isEmpty
	^contents isEmpty .! !


!Cart methodsFor: 'enumerating' stamp: 'ISW 11/5/2017 19:29:46'!
itemsDo: aBlock
	
	| contentsCopy |
	
	contentsCopy _ contents copy.
	
	^ contentsCopy do: aBlock! !

!Cart methodsFor: 'enumerating' stamp: 'NH 10/26/2017 20:57:24'!
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

!Cashier methodsFor: 'error description' stamp: 'NH 10/30/2017 18:14:01'!
cartEmptyErrorDescription
	^'Can not checkout an empty cart'! !

!Cashier methodsFor: 'error description' stamp: 'NH 11/2/2017 18:58:30'!
expiredCreditCardErrorDescription
	^ 'Can not checkout with expired credit card'.! !

!Cashier methodsFor: 'error description' stamp: 'NH 11/2/2017 18:55:36'!
invalidCreditCardErrorDescription
	^'Can not checkout with expired credit card'.! !


!Cashier methodsFor: 'initialization' stamp: 'NH 11/5/2017 09:46:20'!
initializeWithCatalog: aCatalog withSalesBook: aSalesBook andMerchantProcessor: aMerchant 
	salesBook _ aSalesBook.
	priceList _ aCatalog.
	merchantProcessor _ aMerchant.! !


!Cashier methodsFor: 'checkout' stamp: 'NH 11/5/2017 21:15:45'!
checkout: aCart withCreditCard: aCreditCard
	| total |
	
	aCart isEmpty ifTrue: [ Error signal: self cartEmptyErrorDescription ].
	(aCreditCard isInvalidAtDate: GregorianMonthOfYear current) ifTrue: [ Error signal: self expiredCreditCardErrorDescription ].
	total _ 0.
	aCart itemsDo: [ :book |
		total _ total + (self priceOf: book) ].
	merchantProcessor
		debit: total
		from: aCreditCard.
	(salesBook
		at: aCreditCard owner
		ifAbsent: [
			salesBook
				at: aCreditCard owner
				put: OrderedCollection new ]) add: aCart.
	^ total.! !


!Cashier methodsFor: 'enumerating' stamp: 'NH 10/30/2017 20:09:05'!
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
	instanceVariableNames: 'number expirationDate owner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'initialization' stamp: 'NH 11/5/2017 17:30:26'!
initializeWithNumber: aCreditCardNumber withExpirationDate: aDate withOwner: aClient
	number _ aCreditCardNumber .
	expirationDate _ aDate.
	owner _ aClient.! !


!CreditCard methodsFor: 'testing' stamp: 'NH 10/30/2017 19:46:00'!
isInvalidAtDate: aDate
	^expirationDate < aDate! !


!CreditCard methodsFor: 'inspecting' stamp: 'NH 11/5/2017 17:29:18'!
owner
	^owner.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: #TusLibros!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 17:31:36'!
withNumber: aCreditCardNumber expiringOn: aDate ownedBy: aClient
	^self new initializeWithNumber: aCreditCardNumber withExpirationDate: aDate withOwner: aClient.! !


!classDefinition: #OnlineInterface category: #TusLibros!
Object subclass: #OnlineInterface
	instanceVariableNames: 'clients editorialPriceBook carts salesBook merchant timer cartTimers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!OnlineInterface methodsFor: 'interface' stamp: 'ISW 11/5/2017 23:49:39'!
addToCart: aCartId anAmount: amount ofBook: anISBN
	| aCart |
	self cartHasExpired: aCartId.

	aCart _ carts at: aCartId.
	aCart
		add: amount
		of: anISBN.! !

!OnlineInterface methodsFor: 'interface' stamp: 'ISW 11/5/2017 23:49:57'!
checkoutCart: aCartId withCreditCardNumber: aCreditCardNumber expiringOn: anExpirationDate ownedBy: aClient 
	| cart creditCard cashier transactionTotal transactionItems |
	
	self cartHasExpired: aCartId.
	
	cart _ carts at: aCartId.
	creditCard _ CreditCard withNumber: aCreditCardNumber expiringOn: anExpirationDate ownedBy: aClient .
	cashier _ Cashier newWithPriceCatalog: editorialPriceBook withSalesBook: salesBook withMerchantProcessor: merchant.
	transactionTotal _ cashier checkout: cart withCreditCard: creditCard.
	transactionItems _ Bag new.
	cart itemsDo: [:book | transactionItems add: book withOccurrences: 1].
	^{transactionTotal. transactionItems}! !

!OnlineInterface methodsFor: 'interface' stamp: 'ISW 11/5/2017 23:45:24'!
createCartFor: aClientId withPassword: aPassword withTimer: aTimer

	| aCart cartId |
	self authenticate: aClientId withPassword: aPassword.
	aCart _ Cart withCatalog: editorialPriceBook keys.
	cartId _ self idFor: aCart.
	carts at: cartId put: aCart .
	cartTimers at: cartId put: aTimer.

	^cartId! !

!OnlineInterface methodsFor: 'interface' stamp: 'ISW 11/5/2017 19:24:51'!
listCart: aCartId 
	| cart contents |
	cart := carts at: aCartId. 	
	contents := Bag new.
	
	cart itemsDo: [ :book | contents add: book ].
	
	^contents.! !

!OnlineInterface methodsFor: 'interface' stamp: 'NH 11/5/2017 22:25:07'!
listPurchasesOf: aClient withPassword: aPassword
	| transactions total itemBag |
	self
		authenticate: aClient
		withPassword: aPassword.
	transactions _ salesBook at: aClient.
	"en teoria combinamos todos los carts y devolvemos un total?"
	"How to devolver 2 cosas en smalltalk"
	total _ transactions inject: 0 into: [:acum :cart  |
		 |acum2| acum2 _ 0.
		 cart itemsDo: [:book | acum2 _ acum2 + (editorialPriceBook at: book) ].
		acum + acum2].
	itemBag _ transactions inject: Bag new into: [:items :cart  | cart itemsDo: [:book | items add: book withOccurrences: 1]].
	^{total. itemBag}
	! !


!OnlineInterface methodsFor: 'private' stamp: 'NH 11/2/2017 20:20:51'!
authenticate: aClientId withPassword: aPassword.
	(clients includesKey: aClientId) ifFalse: [ Error signal: self clientNotFoundErrorDescription ].
	( (clients at: aClientId) = aPassword) ifFalse: [ Error signal: self wrongPasswordErrorDescription ].! !

!OnlineInterface methodsFor: 'private' stamp: 'ISW 11/6/2017 00:47:36'!
cartHasExpired: aCart

	| cartTimer |
	cartTimer := cartTimers at: aCart.
	
	(cartTimer minutesElapsedSinceStart >= 30) ifTrue: [Error signal: self cartHasExpired].! !

!OnlineInterface methodsFor: 'private' stamp: 'NH 11/3/2017 11:07:53'!
idFor: aCart 
	^'1'! !


!OnlineInterface methodsFor: 'initialization' stamp: 'ISW 11/5/2017 23:44:06'!
initializeWith: aClientRegister withPriceBook: aPriceBook withMerchantProcessor: aMerchant

	clients _ aClientRegister.
	editorialPriceBook _ aPriceBook .
	carts _ Dictionary new.
	merchant _ aMerchant.
	salesBook _ Dictionary new.	
	cartTimers _ Dictionary new.! !


!OnlineInterface methodsFor: 'error descriptions' stamp: 'ISW 11/6/2017 00:39:08'!
cartHasExpired

	^'Cart has expired'! !

!OnlineInterface methodsFor: 'error descriptions' stamp: 'NH 11/2/2017 19:48:43'!
clientNotFoundErrorDescription
	^'Client not found'! !

!OnlineInterface methodsFor: 'error descriptions' stamp: 'NH 11/2/2017 20:10:57'!
wrongPasswordErrorDescription
	^'Client and Password do not match'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OnlineInterface class' category: #TusLibros!
OnlineInterface class
	instanceVariableNames: ''!

!OnlineInterface class methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 15:25:13'!
newWithClientRegister: aDictionary withPriceBook: aPriceBook withMerchantProcessor: aMerchant
	^ self new initializeWith: aDictionary withPriceBook: aPriceBook withMerchantProcessor: aMerchant.! !


!classDefinition: #PurchaseList category: #TusLibros!
Object subclass: #PurchaseList
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!classDefinition: #TestObjectFactory category: #TusLibros!
Object subclass: #TestObjectFactory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:18:37'!
createCart
	^ Cart withCatalog: self priceBook keys.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 09:30:57'!
createCashierWithMerchantProcessor: aMerchant withSalesBook: aSalesBook
	^ Cashier
		newWithPriceCatalog: self priceBook
		withSalesBook: aSalesBook 
		withMerchantProcessor: aMerchant.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 17:07:19'!
defaultMerchantBehaviour
	^[:aMoneyAmount :aCreditCard | ]! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 17:34:48'!
expiredCreditCard
	^ CreditCard
		withNumber: 450000000
		expiringOn: (GregorianMonthOfYear current previous: GregorianMonth twoMonths)
		ownedBy: self registeredClient.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:09:10'!
itemNotSoldByTheStore
	^'The Community Of The Ring'! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:07:49'!
itemSoldByTheStore
	^ 'A Song Of Ice And Fire'.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:08:01'!
itemSoldByTheStorePrice
	^100*peso! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'ISW 11/5/2017 23:59:31'!
minutesElapsedSinceStart
	^ 30.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:18:37'!
priceBook
	| catalog |
	catalog _ Dictionary new.
	catalog
		at: self itemSoldByTheStore
		put: self itemSoldByTheStorePrice.
	^ catalog.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 17:36:23'!
registeredClient
	^'PepeSanchez'.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 17:42:42'!
salesBook
	^Dictionary new.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 17:35:14'!
validCreditCard
	^CreditCard 
		withNumber: self validCreditCardNumber 
		expiringOn: self validCreditCardExpirationDate
		ownedBy: self registeredClient.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 16:29:32'!
validCreditCardExpirationDate
	^( GregorianMonthOfYear current next: GregorianMonth twoMonths ).! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 16:29:01'!
validCreditCardNumber
	^450000001! !
