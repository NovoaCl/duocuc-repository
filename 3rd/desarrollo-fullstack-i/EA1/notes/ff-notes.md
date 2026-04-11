### Fernando's notes

Paso a paso (donde me trabo y necesito reforzar)

1.- Generar Proyecto en Spring
2.- Crear Paquetes y clases
   -> model y dto Response son iguales
   -> CreateRequest tiene todas las validaciones / UpdateRequest lo mismo sin el id
3.- Repository
   -> Arreglo -> GuardarObjeto (recibe reserva) -> ListarTodas(no recibe, devuelve lista)
   -> BuscarPorId (Optional<OBJ>) -> Actualizar(recibe OBJ actualizar -> setObjOriginal con actualizar)
      return obj original -> Eliminar (recibeID / foreach IF (true elimina / false no encontró)).
4.- Service
   -> Instancia Repository
   -> Crear Obj: * Recibe Request devuelve Response
                  * Instancia vacia Obj
                  * set Obj con request
                  * verificar (Optional) si existe (buscarPor Id)
                  * if buscarObj.isPresent return null
                  * crear ObjGuardado con Obj original
                  * return new ObjResponse (obtiene datos de ObjGuardado y ID de original)
   -> Listar Todo: * No recibe nada / Lista Objeto -> repository.obtener
                   * Lista ObjResponse vacio
                   * foreach Obj -> Armar response con obj -> add response a respuesta
                   * devolver respuesta
   -> BuscarPorID: * Instancia Obj (ObjRepository.buscarID orElse(null))
                   * if Obj null return null
                   * return new ObjResponse (obtiene datos de objOriginal)
   -> Actualizar: * Recibe Id y CreateRequest
                  * instanciar obj vacio
                  * setear Obj con request
                  * instanciar ObjActualizado con repository.actualizarObj(obj)
                  * if ObjActualizado == null return null
                  * return new ObjResponse (obtiene datos de ObjActualizado y ID de original)
   -> Eliminar:
      public boolean elimina[Obj](Integer idObj){
          return ObjRepository.eliminarObj(idObj);
      }

5.- Controller
   -> @RestController @RequestMapping("/api/v1/[nombreProyecto]")
   -> @PostMapping
      * public ResponseEntity<?> guardarReserva (@Valid @RequestBody ObjCreateRequest request)
        * Instanciar ObjResponse guardado = ObjService.guardarObj(request)
        If null -> return ResponseEntity.status(HttpStatus.CONFLICT).build();
        else -> return ResponseEntity.status(HttpStatus.CREATED).body(reservaGuardada);
   -> @GetMapping
      * Instanciar Lista Response con service.obtenertodo
      * return listaResponse
   -> @GetMapping("/{idObj}")
      * @PathVariable Integer idObj
      * Instanciar ObjResponse obj = ObjService.buscarPorID(IdObj)
      * if obj == null return notFound.build();
      * return ResponseEntity.ok(Obj)
   -> @PutMapping("/{idObj}")
      * @PathVariable Integer idObj // @Valid @RequestBody requestObj
      * Instanciar ObjActualizado service.actualizarObj(idObj, request)
      * if obj == null return notFound.build();
      * return ResponseEntity.ok(Obj)
   -> @Delete
      * reponseEntity<Void> eliminarObj -> Recibe ID (@PathVariable)
        boolean recibe respuesta de service.eliminarObj(idObj)
        * if obj == null return notFound.build();
        * return ResponseEntity.noContent().build()