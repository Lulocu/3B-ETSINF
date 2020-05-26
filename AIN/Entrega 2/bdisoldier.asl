//TEAM_ALLIED captura bandera
/******************************
*Creencias iniciales
******************************/
vida(60).
capitanAct(). // Esto que se supone que es?
medicos().
fieldOps().

/******************************
*Objetivos iniciales
******************************/

/******************************
*Planes
******************************/

/******************************
*Ampliaciones capi
******************************/
+Ascender:
  +Soycapitan;
  .register_service("capitan").

+AFormar: // mirar git
<-
  .get_medics(M);
  .get_fieldops(F);
  .get_backups(S);
  .Formar(M); //+ guardar su return
  .Formar(F); //+ guardar su return
  .Formar(S); //+ guardar su return

  .send(F,tell,Ordenar); //Pasar posicion a los médicos
  .send(F,tell,Ordenar); //Pasar posicion a fieldop
  .send(F,tell,Ordenar); //Pasar posicion a soldados
  .wait(1000).

+solicitarAtaque(Position)[source(soldier)]:myBackups(Soldados)
    <-
    .send(Soldados, tell, atacar(Position)).


+solicitarParar()[source(soldier)]:.get_service("allied")
    <-
    .send(allied,tell,quieto)

+ordenAvanzar():.get_service("allied") & flag([X,Y,Z])
    <-
    .send(allied,tell,avanzar([X,Y,Z])) //dudas en el allied

//------------SOLDADO---------------
/******************************
*Ampli soldado normal
******************************/


+capitan(C)
    <-
    .print("Mi capitan es:", A);
    -capitanAct().
    +capitanAct(C).
    -capitan(_).
+friends_in_fov(ID,Type,Angle,Distance,Health,Position): position([X,Y,Z]) // ¿lo de después de :?
  <-
  .send(capitanAct, tell, solicitarAtaque(Position))
  .shoot(3,Position);
+atacar(Position)[source(capitanAct)]
    <-
     .lookAt(Position); //al girarse si lo ven ya deberían atacar, si no lo ven nada porque romerían la formacion


+solicitarParada(): solicitarParar
    <-
    -solicitarParar //¿esta creencia?
    .send(capitanAct, tell, solicitarParar)

+quieto()[source(capitanAct)]
    <-
    .stop;  //parar no se como es


+solicitarCura(): vida(X) < 30
    <-
    .send(capitanAct, tell, Solicitar cura)

+curate()[source(capitanAct)]
    <-
    .send(medicos, tell, Solicitar cura);

+solicitarMunicion(): municion(X) < 3
    <-
    .send(capitanAct, tell, Solicitar municion)

+recarga()[source(capitanAct)]
    <-
    .send(fieldops, tell, Solicitar municion);

+avanzar(Position)
    <-
    .goto(Position)

/******************************
*Métodos normales soldados 
******************************/

+flag (F): team(100)
  <-
    
  .goto(F).

+flag_taken: team(100)
  <-
  .print("In ASL, TEAM_ALLIED flag_taken");
  ?base(B);
  +returning;
  .goto(B);
  -exploring.
