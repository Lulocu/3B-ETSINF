//TEAM_ALLIED captura bandera
/******************************
*Creencias iniciales
******************************/
vida(60).
bidsCura([]).
agentsCura([]).
bidsMun([]).
agentsMun([]).
/******************************
*Objetivos iniciales
******************************/

/******************************
*Planes
******************************/

/******************************
*Ampliaciones capi
******************************/

iniciar.

+iniciar
<-
+capitanNuevo;
.get_backups.



+myBackups(M): capitanNuevo
<-
 -capitanNuevo;

+elegirCapi(M).
//Con otra condicion
//+myBackups(M)
//<-
// .print("Pido ayuda");


//+mi_capitan(cap)
//<-
//.send(capitan, tell, nuevoCapi);
//    .print("HECHO").

+elegirCapi(Soldados): not eligiendo
    <-
    +eligiendo;
    ?name(X);
    .concat(Soldados,X,TusMuertos);
    .print("Eligo capitan");
    .send(Soldados,tell,eligiendoCap);
    .elegirAscender(TusMuertos);
    ?mi_capitan(capAct);
    .send(capAct,tell,nuevoCapi).
    

+eligiendoCap[source(soldier)]
    <-
    .print("Eligiendo");
    +eligiendo.

+muerteEnEleccion: threshold_health(0) & eligiendo & myBackups(Soldados)
    <-
   .send(Soldados,tell,muerteElector).

+muerteElector[source(soldier)]
    <- 
    -eligiendo.

+nuevoCapi[source(soldier)]
    <-
    .register_service("capitan");
    .print("Soy capitán");
    .get_backups;
    .send(Soldados,tell,capitanElegido);
    +soyCapi.

+capitanElegido[source(capitan)]
<-
    +capitanAct(capitan).

+aFormar // mirar gi
<-
    .print("formado").
  //.get_medics(M);
  //.get_fieldops(F);
  //.get_backups(S);
  //.Formar(M); //+ guardar su return
  //.Formar(F); //+ guardar su return
  //.Formar(S); //+ guardar su return
//
  //.send(F,tell,Ordenar); //Pasar posicion a los médicos
  //.send(F,tell,Ordenar); //Pasar posicion a fieldop
  //.send(F,tell,Ordenar); //Pasar posicion a soldados
  //.wait(1000).

+solicitarAtaque(Position)[source(soldier)]: myBackups(Soldados)
    <-
    .send(Soldados, tell, atacar(Position)).


+solicitarParar[source(soldier)]:.get_service("allied")
    <-
    .send(allied,tell,quieto).

+ordenAvanzar:.get_service("allied") & flag([X,Y,Z])
    <-
    .send(allied,tell,avanzar([X,Y,Z])). //dudas en el allied

//------------SOLDADO---------------
/******************************
*Ampli soldado normal
******************************/


//+capitan(C)
//    <-
//    .print("Mi capitan es:", A);
//    +capitanAct(C).
//Creo que no es necesario porque hago un broadcast del capi
+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): position([X,Y,Z]) // ¿lo de después de :?
    <-
    .send(capitanAct, tell, solicitarAtaque(Position));
    .shoot(3,Position).

+atacar(Position)[source(capitanAct)]
    <-
    .lookAt(Position). //al girarse si lo ven ya deberían atacar, si no lo ven nada porque romerían la formacion

+solicitarParada//vida o municion por debajo de algo y listoCurar listoMuni
    <-
    .send(capitanAct, tell, solicitarParar).

+quieto[source(capitanAct)]
    <-
    +parado;
    .stop.//parar no se como es

//nuevas implementaciones



+solicitarCura: parado & threshold_health(40)
    <-
    //pedimos lista de medicos que nos pueden curar
    +activaCura;
	.get_medics.
    // se lo enviamos a todos los medicos
	

+myMedics(M): activaCura
<-
    -activaCura;
    ?position(Pos);
	+ayudaPedidaCura;
    .send(M, tell, solicitarCura(Pos)). 

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
	.delete(0, Ag, Ag1); //0 no es el mismo?no seria 1?
	.send(Ag1, tell, cancelproposalCura);
	-+bidsCura([]);
	-+agentsCura([]).

+!elegirmejorCura: not (bidsCura(Bi))
	<-
	.print("Nadie me puede ayudar");
	-ayudaPedidaCura.

+solicitarMunicion: parado & municion(X) < 3
    <- 
    //pedimos lista de fieldops que nos pueden curar
    +activarField;
	.get_fieldops.
    // se lo enviamos a todos los medicos
	

+myFieldops(F): activarField
<-
    -activarField;
    ?position(Pos);
	+ayudaPedidaMun;
    .send(F, tell, solicitarMun(Pos)).

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
	.delete(0, Ag, Ag1); //0 no es el mismo?no seria 1?
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

+flag (F): team(100) & soyCapi
  <-
    .goto(F).

+flag_taken: team(100) & soyCapi
  <-
    .print("In ASL, TEAM_ALLIED flag_taken");
    ?base(B);
    +returning;
    .goto(B);
    -exploring.
