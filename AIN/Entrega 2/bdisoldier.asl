//TEAM_ALLIED captura bandera
/******************************
*Creencias iniciales
******************************/
vida(60).
//capitanAct(). // Esto que se supone que es?
//medicos().
//fieldOps().

/******************************
*Objetivos iniciales
******************************/

/******************************
*Planes
******************************/

/******************************
*Ampliaciones capi
******************************/


+elegirCapi:myBackups(Soldados) & not eligiendo
 <-
  +eligiendo
  .send(Soldados,tell,eligiendoCap);
  
  .elegirAscender(Soldados,nuevoCapi);
  .send(nuevoCapi, tell, nuevoCapi).

+eligiendoCap[source(soldier)]:
    +eligiendo.

+muerteEnEleccion: threshold_health(0) & eligiendo & myBackups(Soldados):
   .send(Soldados,tell,muerteElector).

+muerteElector[source(soldier)]:
    -eligiendo.

+nuevoCapi[source(soldier)]:
    .register_service("capitan");
    +soyCapi.

+AFormar: // mirar gi
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
    .send(allied,tell,quieto).

+ordenAvanzar():.get_service("allied") & flag([X,Y,Z])
    <-
    .send(allied,tell,avanzar([X,Y,Z])). //dudas en el allied

//------------SOLDADO---------------
/******************************
*Ampli soldado normal
******************************/


+capitan(C)
    <-
    .print("Mi capitan es:", A);
    +capitanAct(C).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): position([X,Y,Z]) // ¿lo de después de :?
  <-
  .send(capitanAct, tell, solicitarAtaque(Position))
  .shoot(3,Position);

+atacar(Position)[source(capitanAct)]
    <-
     .lookAt(Position); //al girarse si lo ven ya deberían atacar, si no lo ven nada porque romerían la formacion

+solicitarParada(): //vida o municion por debajo de algo y listoCurar listoMuni
    <-
    .send(capitanAct, tell, solicitarParar)

+quieto()[source(capitanAct)]
    <-
    +parado:
    .stop.//parar no se como es

//nuevas implementaciones

bidsCura([]).
agentsCura([]).
bidsMun([]).
agentsMun([]).

+solicitarCura(): parado & threshold_health(40)
    <-
    //pedimos lista de medicos que nos pueden curar
	.get_medics(M);
    // se lo enviamos a todos los medicos
	?position(Pos);
	+ayudaPedidaCura;
    .send(M, tell, SolicitarCura(Pos)). 

+curate(Pos)[source(medico)]: ayudaPedidaCura
    <-
    ?bidsCura(B);
	.concat(B, [Pos], B1); -+bidsCura(B1);
	?agentsCura(Ag);
	.concat(Ag, [medico], Ag1); -+agentsCura(Ag1);
	-curate(Pos).

+!elegirmejorCura: bidsCura(Bi) & agentsCura(Ag)
	<-
	.print("Selecciono el mejor: ", Bi, Ag);
	.nth(0, Bi, Pos); // no elijo el mejor, me quedo con el primero
	.nth(0, Ag, A);
	.send(A, tell, acceptproposalCura);
	.delete(1, Ag, Ag1); //0 no es el mismo?no seria 1?
	.send(Ag1, tell, cancelproposalCura);
	-+bidsCura([]);
	-+agentsCura([]).

+!elegirmejorCura: not (bidsCura(Bi))
	<-
	.print("Nadie me puede ayudar");
	-ayudaPedidaCura.

+solicitarMunicion(): parado & municion(X) < 3
    <- 
    //pedimos lista de fieldops que nos pueden curar
	.get_fieldops(F);
    // se lo enviamos a todos los medicos
	?position(Pos);
	+ayudaPedidaMun;
    .send(F, tell, SolicitarMun(Pos)).

+recarga(Pos)[source(fieldop)]: ayudaPedidaMun
    <-
    ?bidsMun(B);
	.concat(B, [Pos], B1); -+bidsMun(B1);
	?agentsMun(Ag);
	.concat(Ag, [fieldop], Ag1); -+agentsMun(Ag1);
	-recarga(Pos).

+!elegirmejorMun: bidsMun(Bi) & agentsMun(Ag)
	<-
	.print("Selecciono el mejor: ", Bi, Ag);
	.nth(0, Bi, Pos); // no elijo el mejor, me quedo con el primero
	.nth(0, Ag, A);
	.send(A, tell, acceptproposalMun);
	.delete(1, Ag, Ag1); //0 no es el mismo?no seria 1?
	.send(Ag1, tell, cancelproposalMun);
	-+bidsMun([]);
	-+agentsMun([]).

+!elegirmejorMun: not (bidsMun(Bi))
	<-
	.print("Nadie me puede ayudar");
	-ayudaPedidaMun.
 
//Fin nuevas implementaciones

+avanzar(Position)[source(capitan)]
    <-
    .goto(Position).

/******************************
*Métodos normales soldados 
******************************/

+flag (F): team(100)
  <-
    
  .goto(F).

+flag_taken: team(100) & soyCapitan
  <-
  .print("In ASL, TEAM_ALLIED flag_taken");
  ?base(B);
  +returning;
  .goto(B);
  -exploring.
