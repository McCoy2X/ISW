!classDefinition: #OnlineInterfaceTest category: #TusLibros!
TestCase subclass: #OnlineInterfaceTest
	instanceVariableNames: 'interface nonRegisteredClient nonRegisteredClientPassword registeredClient registeredClientPassword aRegisteredBook factory priceCatalog merchantBehaviour timerMinutes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!OnlineInterfaceTest methodsFor: 'timer stub' stamp: 'NH 11/6/2017 13:03:03'!
expireTimer
	timerMinutes _ 30.! !

!OnlineInterfaceTest methodsFor: 'timer stub' stamp: 'NH 11/6/2017 13:03:03'!
fifteenMinutesElapsed
	timerMinutes _ 15.! !

!OnlineInterfaceTest methodsFor: 'timer stub' stamp: 'NH 11/6/2017 13:03:03'!
minutesElapsedSinceStart
	^ timerMinutes.! !

!OnlineInterfaceTest methodsFor: 'timer stub' stamp: 'NH 11/6/2017 13:03:03'!
restartTimer
	timerMinutes _ 0.! !


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

!OnlineInterfaceTest methodsFor: 'as yet unclassified' stamp: 'NH 11/6/2017 13:03:03'!
setUp
	factory _ TestObjectFactory new.
	registeredClient _ factory registeredClient.
	registeredClientPassword _ 'cabildo45678'.
	nonRegisteredClient _ 'easyBotnet23'.
	nonRegisteredClientPassword _ '1234'.
	aRegisteredBook _ factory itemSoldByTheStore.
	interface _ self createInterface.
	merchantBehaviour _ factory defaultMerchantBehaviour.
	timerMinutes _ 0.! !


!OnlineInterfaceTest methodsFor: 'testing' stamp: 'ISW 11/5/2017 23:53:22'!
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

!OnlineInterfaceTest methodsFor: 'testing' stamp: 'ISW 11/5/2017 23:53:44'!
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

!OnlineInterfaceTest methodsFor: 'testing' stamp: 'ISW 11/5/2017 23:54:04'!
test03AuthenticatedClientCanCreateCart
	| aCartId |
	aCartId _ interface createCartFor: registeredClient withPassword: registeredClientPassword withTimer: self.
	
	self assert: ((interface listCart: aCartId) isEmpty).! !

!OnlineInterfaceTest methodsFor: 'testing' stamp: 'ISW 11/5/2017 23:54:23'!
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

!OnlineInterfaceTest methodsFor: 'testing' stamp: 'NH 11/6/2017 12:10:55'!
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

!OnlineInterfaceTest methodsFor: 'testing' stamp: 'NH 11/6/2017 11:02:10'!
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
				self assert: (interface listCart: aCartId) isEmpty].! !

!OnlineInterfaceTest methodsFor: 'testing' stamp: 'NH 11/6/2017 11:23:14'!
test07CartTimerGetsResetAfterSuccessfulOperation
	| aCartId |
	aCartId _ interface
		createCartFor: registeredClient
		withPassword: registeredClientPassword
		withTimer: self.
	self fifteenMinutesElapsed.
	interface
		addToCart: aCartId
		anAmount: 20
		ofBook: aRegisteredBook.
	self assert: (self minutesElapsedSinceStart = 0).! !


!classDefinition: #StoreTest category: #TusLibros!
TestCase subclass: #StoreTest
	instanceVariableNames: 'aCart aCashier invalidCreditCard validCreditCard simulatedMerchantinterface merchantBehaviour factory salesBook anotherCart registeredClient'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTest methodsFor: 'Testing' stamp: 'NH 10/30/2017 20:44:21'!
test01CarritoComienzaVacio
	self assert: aCart isEmpty.! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/6/2017 10:54:20'!
test02CarritoNoVacioCuandoSeAgregaLibro
	
	aCart addBook: factory itemSoldByTheStore.
	self deny: aCart isEmpty.! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/6/2017 10:55:31'!
test03NoSePuedeAgregarAlCarritoLibroQueNoEsDeEditorial
	
	self
		should: [ aCart addBook: factory itemNotSoldByTheStore ]
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

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/6/2017 12:58:26'!
test06CheckoutEmptyCartShouldFail
	
	self
		should: [ aCashier checkout: aCart withCreditCard: validCreditCard forClient: registeredClient]
		raise: Error
		withExceptionDo: [ :anException |
			self assert: anException messageText = 'Can not checkout an empty cart'.
			self assert: salesBook isEmpty ].! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/6/2017 12:58:44'!
test07CheckoutWithExpiredCreditCardShouldFail
	aCart addBook: factory itemSoldByTheStore.
	merchantBehaviour _ [:anAmount :aCreditCard | self fail].
	self
		should: [
			aCashier
				checkout: aCart
				withCreditCard: invalidCreditCard
				forClient: registeredClient ]
		raise: Error
		withExceptionDo: [ :anException |
			self assert: anException messageText = 'Can not checkout with expired credit card'.
			self assert: salesBook isEmpty ].! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/6/2017 12:59:05'!
test08CheckoutaValidCartWithaValidCreditCard
	| debitedFrom totalDebited |
	aCart
		add: 20
		of: factory itemSoldByTheStore.
	merchantBehaviour _ [ :anAmount :aCreditCard |
	totalDebited _ anAmount.
	debitedFrom _ aCreditCard ].
	self assert:
		(aCashier
			checkout: aCart
			withCreditCard: validCreditCard
			forClient: registeredClient ) = (2000 * peso).
	self assert: salesBook isEmpty not.
	self assert: ((salesBook at: factory registeredClient ) includes: aCart).
	self assert: totalDebited = (2000 * peso).
	self assert: debitedFrom = validCreditCard.! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/6/2017 12:59:37'!
test09CheckoutShouldFailWhenCreditCardOutOfFunds
	aCart
		add: 20
		of: factory itemSoldByTheStore.
	merchantBehaviour _ [:anAmount :aCreditCard | self error: self outOfFundsErrorDescription ].
	self should: [aCashier checkout: aCart withCreditCard: validCreditCard forClient: registeredClient ]  raise:  Error - MessageNotUnderstood withExceptionDo: [:anException|
		self assert: anException messageText = 'Credit card out of funds'.
		self assert: salesBook isEmpty].
		! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/6/2017 12:59:54'!
test10CheckoutShouldFailWhenCreditCardStolen
	aCart
		add: 20
		of: factory itemSoldByTheStore.
	merchantBehaviour _ [:anAmount :aCreditCard | self error: self stolenCreditCardErrorDescription].
	self should: [aCashier checkout: aCart withCreditCard: validCreditCard forClient: registeredClient ]  raise:  Error - MessageNotUnderstood withExceptionDo: [:anException|
		self assert: anException messageText = 'Credit card stolen'.
		self assert: salesBook isEmpty].
		! !

!StoreTest methodsFor: 'Testing' stamp: 'NH 11/6/2017 13:01:39'!
test11CheckoutCartsWithaCreditCardButDifferentClients
	| debitedFrom totalDebited |
	totalDebited _ 0.
	aCart
		add: 20
		of: factory itemSoldByTheStore.
	anotherCart
		add: 40
		of: factory itemSoldByTheStore.
	merchantBehaviour _ [ :anAmount :aCreditCard |
	totalDebited _ totalDebited + anAmount.
	debitedFrom _ aCreditCard ].
	self assert:
		(aCashier
			checkout: aCart
			withCreditCard: validCreditCard
			forClient: registeredClient) = (2000 * peso).
	self assert:
		(aCashier
			checkout: anotherCart
			withCreditCard: validCreditCard
			forClient: factory anotherRegisteredClient) = (4000 * peso).
	self assert: salesBook isEmpty not.
	self assert: ((salesBook at: factory registeredClient) includes: aCart).
	self assert: ((salesBook at: factory anotherRegisteredClient) includes: anotherCart).
	self assert: totalDebited = (6000 * peso).
	self assert: debitedFrom = validCreditCard.! !


!StoreTest methodsFor: 'error descriptions' stamp: 'NH 11/2/2017 18:48:56'!
outOfFundsErrorDescription
	^'Credit card out of funds'! !

!StoreTest methodsFor: 'error descriptions' stamp: 'NH 11/2/2017 19:01:33'!
stolenCreditCardErrorDescription
	^'Credit card stolen'! !


!StoreTest methodsFor: 'merchant stub' stamp: 'NH 11/2/2017 18:43:22'!
debit: aSimpleMeasure from: aCreditCard 
	merchantBehaviour value: aSimpleMeasure value: aCreditCard.! !


!StoreTest methodsFor: 'set up' stamp: 'NH 11/6/2017 13:01:22'!
setUp
	factory _ TestObjectFactory new.
	aCart _ factory createCart.
	anotherCart _ factory createCart.
	salesBook _ factory salesBook.
	aCashier _ factory createCashierWithMerchantProcessor: self withSalesBook: salesBook.
	invalidCreditCard _ factory expiredCreditCard.
	validCreditCard _ factory validCreditCard.
	merchantBehaviour _ factory defaultMerchantBehaviour.
	registeredClient _ factory registeredClient.! !


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


!Cashier methodsFor: 'checkout' stamp: 'NH 11/6/2017 12:42:34'!
checkout: aCart withCreditCard: aCreditCard forClient: aClient 
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
		at: aClient
		ifAbsent: [
			salesBook
				at: aClient
				put: OrderedCollection new ]) add: aCart.
	^ total.! !


!Cashier methodsFor: 'pricing' stamp: 'NH 10/30/2017 20:09:05'!
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

!CreditCard methodsFor: 'initialization' stamp: 'NH 11/6/2017 13:13:27'!
initializeWithNumber: aCreditCardNumber withExpirationDate: aDate
	number _ aCreditCardNumber .
	expirationDate _ aDate.
! !


!CreditCard methodsFor: 'testing' stamp: 'NH 10/30/2017 19:46:00'!
isInvalidAtDate: aDate
	^expirationDate < aDate! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: #TusLibros!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'as yet unclassified' stamp: 'NH 11/6/2017 13:13:49'!
withNumber: aCreditCardNumber expiringOn: aDate
	^self new initializeWithNumber: aCreditCardNumber withExpirationDate: aDate.! !


!classDefinition: #OnlineInterface category: #TusLibros!
Object subclass: #OnlineInterface
	instanceVariableNames: 'clients editorialPriceBook carts salesBook merchant timer cartTimers random'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!OnlineInterface methodsFor: 'interface' stamp: 'NH 11/6/2017 11:27:15'!
addToCart: aCartId anAmount: amount ofBook: anISBN
	| aCart |
	self cartHasExpired: aCartId.

	aCart _ carts at: aCartId.
	aCart
		add: amount
		of: anISBN.
	self restartCartTimer: aCartId.! !

!OnlineInterface methodsFor: 'interface' stamp: 'NH 11/6/2017 13:14:19'!
checkoutCart: aCartId withCreditCardNumber: aCreditCardNumber expiringOn: anExpirationDate ownedBy: aClient 
	| cart creditCard cashier transactionTotal transactionItems |
	
	self cartHasExpired: aCartId.
	
	cart _ carts at: aCartId.
	creditCard _ CreditCard withNumber: aCreditCardNumber expiringOn: anExpirationDate.
	cashier _ Cashier newWithPriceCatalog: editorialPriceBook withSalesBook: salesBook withMerchantProcessor: merchant.
	transactionTotal _ cashier checkout: cart withCreditCard: creditCard forClient: aClient.
	transactionItems _ Bag new.
	cart itemsDo: [:book | transactionItems add: book withOccurrences: 1].
	self restartCartTimer: aCartId.
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

!OnlineInterface methodsFor: 'interface' stamp: 'NH 11/6/2017 12:17:18'!
listPurchasesOf: aClient withPassword: aPassword
	| transactions total itemBag |
	self
		authenticate: aClient
		withPassword: aPassword.
	transactions _ salesBook at: aClient.
	total _ transactions
		inject: 0
		into: [ :clientTotal :cart | | cartTotal |
			cartTotal _ 0.
			cart itemsDo: [ :book |
				cartTotal _ cartTotal + (editorialPriceBook at: book) ].
			clientTotal + cartTotal ].
	itemBag _ transactions
		inject: Bag new
		into: [ :items :cart |
			cart itemsDo: [ :book |
				items
					add: book
					withOccurrences: 1 ]].
	^ {total. itemBag}.! !


!OnlineInterface methodsFor: 'private' stamp: 'NH 11/2/2017 20:20:51'!
authenticate: aClientId withPassword: aPassword.
	(clients includesKey: aClientId) ifFalse: [ Error signal: self clientNotFoundErrorDescription ].
	( (clients at: aClientId) = aPassword) ifFalse: [ Error signal: self wrongPasswordErrorDescription ].! !

!OnlineInterface methodsFor: 'private' stamp: 'ISW 11/6/2017 00:47:36'!
cartHasExpired: aCart

	| cartTimer |
	cartTimer := cartTimers at: aCart.
	
	(cartTimer minutesElapsedSinceStart >= 30) ifTrue: [Error signal: self cartHasExpired].! !

!OnlineInterface methodsFor: 'private' stamp: 'NH 11/6/2017 12:04:41'!
idFor: aCart 
	^(random next* SmallInteger maxVal) rounded. ! !

!OnlineInterface methodsFor: 'private' stamp: 'NH 11/6/2017 12:07:37'!
restartCartTimer: aCartId 
	(cartTimers at: aCartId) restartTimer.! !


!OnlineInterface methodsFor: 'initialization' stamp: 'NH 11/6/2017 12:05:06'!
initializeWith: aClientRegister withPriceBook: aPriceBook withMerchantProcessor: aMerchant

	clients _ aClientRegister.
	editorialPriceBook _ aPriceBook .
	carts _ Dictionary new.
	merchant _ aMerchant.
	salesBook _ Dictionary new.	
	cartTimers _ Dictionary new.
	random _ Random new.! !


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


!classDefinition: #TestObjectFactory category: #TusLibros!
Object subclass: #TestObjectFactory
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TestObjectFactory methodsFor: 'credit cards' stamp: 'NH 11/6/2017 13:15:28'!
expiredCreditCard
	^ CreditCard
		withNumber: 450000000
		expiringOn: (GregorianMonthOfYear current previous: GregorianMonth twoMonths).! !

!TestObjectFactory methodsFor: 'credit cards' stamp: 'NH 11/6/2017 13:15:45'!
validCreditCard
	^CreditCard 
		withNumber: self validCreditCardNumber 
		expiringOn: self validCreditCardExpirationDate.! !

!TestObjectFactory methodsFor: 'credit cards' stamp: 'NH 11/5/2017 16:29:32'!
validCreditCardExpirationDate
	^( GregorianMonthOfYear current next: GregorianMonth twoMonths ).! !

!TestObjectFactory methodsFor: 'credit cards' stamp: 'NH 11/5/2017 16:29:01'!
validCreditCardNumber
	^450000001! !


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

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/2/2017 21:18:37'!
priceBook
	| catalog |
	catalog _ Dictionary new.
	catalog
		at: self itemSoldByTheStore
		put: self itemSoldByTheStorePrice.
	^ catalog.! !

!TestObjectFactory methodsFor: 'as yet unclassified' stamp: 'NH 11/5/2017 17:42:42'!
salesBook
	^Dictionary new.! !


!TestObjectFactory methodsFor: 'store items' stamp: 'NH 11/2/2017 21:09:10'!
itemNotSoldByTheStore
	^'The Community Of The Ring'! !

!TestObjectFactory methodsFor: 'store items' stamp: 'NH 11/2/2017 21:07:49'!
itemSoldByTheStore
	^ 'A Song Of Ice And Fire'.! !

!TestObjectFactory methodsFor: 'store items' stamp: 'NH 11/2/2017 21:08:01'!
itemSoldByTheStorePrice
	^100*peso! !


!TestObjectFactory methodsFor: 'clients' stamp: 'NH 11/6/2017 12:45:27'!
anotherRegisteredClient
	^'MariaGonzalez'! !

!TestObjectFactory methodsFor: 'clients' stamp: 'NH 11/5/2017 17:36:23'!
registeredClient
	^'PepeSanchez'.! !
