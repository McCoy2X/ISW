#parte3



customerSystem(persistent, transient)
environment current
produccion y desarrollo(ambientes)

isCurrent
customer identifiedAs: ofType:

transient no hace mucho en open y close(start y stop)
commit y transaction no hacen nada en transient.

#parte 4
No solo trabaja con customers, sino con suppliers.
Supplier conoce clientes y direcciones.
newCustomer (NC), existingCustomer (EC).
(composicion de customerSystem y supplierSystem) cada uno transient y persistent.
(tipo y numero de identificacion son un solo objeto).

No generalizar la solucion de entrada. (copy de client a supplier ycustomersystem a suppliersystem)
