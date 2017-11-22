#parte 4
-tests de control de errores 

-armar bien la jerarquia de systems y sacar codigo repetido entre ellos. No decidi donde va ERPSystem y convendria armar un "System" que seria solamente abstracto.(ERPSystem es tan poco ortodoxo que no cumpliria con la interfaz igual.)

-Sacar codigo repetido entre tests (es un monton). Se podria armar un factory como en el ejercicio anterior. O una superclase para los tests?ERPSystemTest??

-ERPimporter

-Por ahi mejorar un poco el modelo. Ejemplos Identification, Customer y Supplier son muy estructuras de datos. Estaria bueno que reciban los parametros que necesitan en la creacion para ser mas "objetosos". En todos los lugares donde se crean objetos el codigo es mas o menos parecido, por ahi un extractMethod de todos los lugares donde se crean, despues cambiar el codigo del metodo extraido funciona.

-Sacar cuallquier codigo repetido que quede
