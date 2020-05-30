//TEAM_ALLIED captura bandera
/******************************
*Creencias iniciales
******************************/
vida(100).
bidsCura([]). //lista posiciones médicos que ayudan
agentsCura([]). //lista de médicos que ayudan
bidsMun([]). //lista posiciones fieldops que ayudan
agentsMun([]). //lista fieldops que ayudan
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


+aFormar: soyCapi
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
    .wait(3000);
    .print("Finalizaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaado");
    ?flag(Bandera);
    .print(Bandera);
    +ordenAvanzar(Bandera).


+solicitarAtaque(Position)[source(Soldier)]
    <-
    .get_backups;
    myBackups(Soldados);
    .send(Soldados, tell, atacar(Position)).


+solicitarParar[source(Soldier)]:.get_service("allied")
    <-
    ?allied(Allied);
    .print("solicitarParar");
    .send(Allied,tell,quieto).

+ordenAvanzar([X,Y,Z])//: flag([X,Y,Z])
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
    .shoot(3,Position).

+atacar(Position)[source(CapitanAct)]
    <-
    .look_at(Position). //al girarse si lo ven ya deberían atacar, si no lo ven nada porque romerían la formacion

+solicitarParada//vida o municion por debajo de algo y listoCurar listoMuni
    <-
    ?capitanAct(CapitanAct);
    .send(CapitanAct, tell, solicitarParar).

+quieto[source(CapitanAct)]
    <-
    +parado;
    .stop.
//nuevas implementaciones



+threshold_health(40)
    <-
    .print("Pedimos parar");
    +activaCura;
	.get_medics.	

+myMedics(M): activaCura
<-
    -activaCura;
    ?position(Pos);
	+ayudaPedidaCura;
    .send(M, tell, solicitarCura(Pos)). 

+curate(Pos)[source(Medico)]: ayudaPedidaCura
    <-
    .print("Tenemos respuesta medico");
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

+threshold_ammo(90) //deberia ser 30
    <- 
    //pedimos lista de fieldops que nos pueden curar
    .print("pedimos muni");
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
    .print("Tenemos  respuesta muni");
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
    .goto(Position).

/******************************
*Métodos normales soldados 
******************************/
+flag_taken: team(100) & not soyCapi
  <-
  ?capitanAct(CapitanAct);
  .send(CapitanAct,tell,tenemosBandera);
  ?base(B);
  .goto(B);


    .get_service("allied");
    ?allied(Allied);
    .print(Allied);


  .print("In ASL, TEAM_ALLIED flag_taken SOLDADO").

+tenemosBandera[source(Bandera)]
    <-
    .wait(1000);
    .get_service("allied");
    ?allied(Allied);
    ?base(B);
    +ordenAvanzar(B).

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
