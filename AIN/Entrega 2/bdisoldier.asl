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
noenviado.
iniciar.


+iniciar
    <-
    +capitanNuevo;
    .get_backups;
    .get_medics;
    .get_service("allied");
    .get_fieldops.



+myBackups(S): capitanNuevo
    <-

    -capitanNuevo;
    +elegirCapi(S).


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
    .random(Tiempo);
    .wait(Tiempo * 500);
    .send(Soldados,untell,noenviado);
    .elegirAscender(Soldados,NuevoCapi);
    +nuevoCapi(NuevoCapi);
    +seleccion.

+seleccion: noenviado
    <-
    -noenviado;
    ?nuevoCapi(NuevoCapi);
    .send(NuevoCapi,tell,ascender).

+ascender[source(A)]
    <-
    
    .register_service("capitan");
    .print("Soy capitán");
    .get_backups;
    ?myBackups(Soldados);
    .send(Soldados,tell,capitanElegido);
    +soyCapi;
    ?name(X);
    +capitanAct(X);
    +aFormar.


+capitanElegido[source(Capitan)]
    <-
    +capitanAct(Capitan).


+aFormar: soyCapi // mirar gi
    <-
    ?position([X,Y,Z]);
    .get_medics;
    .get_fieldops;
    .get_backups;
    ?myBackups(S);
    ?myFieldops(F);
    ?myMedics(M);
    .length(S, LenS);
    .length(M, LenM);
    .length(F, LenF);

    +loop(0);
    while(loop(I) & (I<LenM))
        {
        .nth(I, M, Medico);
        .send(Medico,tell,avanzar(X + I,Y,Z+I));
        -+loop(I+1);
        }
    -+loopF(0); 
    while(loopF(I) & (I<LenF))
        {
        .nth(I, F, Fieldop);
        .send(Fieldop,tell,avanzar(X +I+3,Y,Z+I+3));
        -+loopF(I+1);
        }
    -+loopS(0);
    while(loopS(I) & (I<LenS))
        {
        .nth(I, S, Soldado);
        .send(Soldado,tell,avanzar(X+I+6,Y,Z+I+6));
        -+loopS(I+1);
        }
    -loopS(_);
    .wait(1000);
    .print("Finalizaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaado");
    +ordenAvanzar.


+solicitarAtaque(Position)[source(Soldier)]
    <-
    .get_backups;
    myBackups(Soldados);
    .print("solicitarAtaque");
    .send(Soldados, tell, atacar(Position)).


+solicitarParar[source(Soldier)]:.get_service("allied")
    <-
    ?allied(Allied);
    .print("solicitarParar");
    .send(Allied,tell,quieto).

//+allied(L)
//    <-
//    .print("Los agentes de mi equipo con el servicio_a son: ", L).

+ordenAvanzar: flag([X,Y,Z])
    <-
    .get_service("allied");
    ?allied(L);
    .send(L,tell,avanzar([X,Y,Z]));
    .goto([X,Y,Z]).


+threshold_health(0):soyCapi
    <-
    +iniciar.



//------------SOLDADO---------------
/******************************
*Ampli soldado normal
******************************/

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): position([X,Y,Z]) // ¿lo de después de :?
    <-
    ?capitanAct(CapitanAct);
    .send(CapitanAct, tell, solicitarAtaque(Position));
    .print("Disparando");
    .print(CapitanAct);
    .shoot(3,Position).

+atacar(Position)[source(CapitanAct)]
    <-
    .print("atacar");
    .look_at(Position). //al girarse si lo ven ya deberían atacar, si no lo ven nada porque romerían la formacion

+solicitarParada//vida o municion por debajo de algo y listoCurar listoMuni
    <-
    ?capitanAct(CapitanAct);
    .send(CapitanAct, tell, solicitarParar).

+quieto[source(CapitanAct)]
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

+curate(Pos)[source(Medico)]: ayudaPedidaCura
    <-
    ?bidsCura(B);
	.concat(B, [Pos], B1); -+bidsCura(B1);
	?agentsCura(Ag);
	.concat(Ag, [Medico], Ag1); -+agentsCura(Ag1);
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

+recarga(Pos)[source(Fieldop)]: ayudaPedidaMun
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

+avanzar(Position)[source(Capitan)]
    <-
    .print("Avanzamos");
    .goto(Position).

/******************************
*Métodos normales soldados 
******************************/
+flag_taken: team(100) 
  <-
  .print("In ASL, TEAM_ALLIED flag_taken").


+flag_taken: team(100) & soyCapi
  <-
    .print("In ASL, TEAM_ALLIED flag_taken");
    ?base(B);
    +returning;
    .get_service("allied");
    ?allied(L);
    .send(L,tell,avanzar(B));
    .goto(B);
    -exploring.
