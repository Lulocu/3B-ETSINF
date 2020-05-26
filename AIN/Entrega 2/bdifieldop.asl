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



.get_service("capitan");
.get_medics;
.getfieldops;

/******************************
*Soldado normal
******************************/
+myFieldops(F)
    <-
    fieldOps(M); // EL orden no debería ser al revés? O tener un +
    -myFieldops().

+myMedics(M)
    <-
    medicos(M);
    -myMedics().

+capitan(C)
    <-
    .print("Mi capitan es:", A);
    -capitanAct().
    +capitanAct(C).
    -capitan(_).

+friends_in_fov(ID,Type,Angle,Distance,Health,Position): position([X,Y,Z]) // ¿lo de después de :?
  <-
  .send(capitanAct, tell, solicitarAtaque(Position))

+atacar(Position)[source(capitanAct)]
    <-
    .shoot(3,Position);

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
*Ampliaciones capi
******************************/

+mandarFormar():
    <-

+solicitarAtaque(Position)[source(soldier)]:myBackups(Soldados)
    <-
    .send(Soldados, tell, atacar(Position)).

+solicitarParar()[source(soldier)]:.get_service("allied")
    <-
    .send(allied,tell,quieto)

+ordenAvanzar():.get_service("allied") & flag([X,Y,Z])
    <-
    .send(allied,tell,avanzar([X,Y,Z])) //dudas en el allied


