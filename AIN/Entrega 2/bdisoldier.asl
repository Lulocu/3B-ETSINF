//TEAM_ALLIED captura bandera

vida(100).
min(80).

noenviado.
iniciar.
+threshold_health(min)
    <-
    .print("Capitan ha muerto");
    +iniciar.

+iniciar
    <-
    +capitanNuevo;
    .get_backups;
    .get_service("allied").

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
    ?flag(Bandera);
    +aFormar(Bandera).


+capitanElegido[source(Capitan)]
    <-
    +capitanAct(Capitan).


+aFormar(Destino): soyCapi
    <-
    ?position([X,Y,Z]);
    .get_backups;
    ?myBackups(S);
    .length(S, LenS);
    +loopS(0); 
    while(loopS(I) & (I<LenS))
        {
        .nth(I, S, Soldado);
		if(I == 0 |I == 2 |I == 4 |I == 6 |I == 8){
			.send(Soldado,tell,avanzar(X+I*1.5,Y,Z));
		}
		if(I == 1 |I == 3 |I == 5 |I == 7 |I == 9){
			.send(Soldado,tell,avanzar(X,Y,Z+I*1.5));
		}
        -+loopS(I+1);
        }
    -loopS(_);
    .goto([X-5,Y,Z]);
    ?flag(Bandera);
    if(Destino==Bandera){
        .wait(8000);
    }
    +ordenAvanzar(Destino).


+solicitarAtaque(Position)[source(Soldier)]
    <-
    .get_backups;
    myBackups(Soldados);
    .send(Soldados, tell, atacar(Position)).

+ordenAvanzar([X,Y,Z])//: flag([X,Y,Z])
    <-
    .get_service("allied");
    ?allied(L);
    .send(L,tell,avanzar([X,Y,Z]));
    .goto([X,Y,Z]).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): friends_in_fov(ID1,Type1,Angle1,Distance1,Health1,Position1)
    <-
    .fuegoAmigo(Position,Position1,Permiso);
    ?capitanAct(CapitanAct);
    .send(CapitanAct, tell, solicitarAtaque(Position));
    if(Permiso == true){
        
        .shoot(10,Position);
    }.
+enemies_in_fov(ID,Type,Angle,Distance,Health,Position): not friends_in_fov(ID1,Type1,Angle1,Distance1,Health1,Position1)
    <-
    ?capitanAct(CapitanAct);
    .send(CapitanAct, tell, solicitarAtaque(Position));
    .shoot(10,Position).


+atacar(Position)[source(CapitanAct)]
    <-
    .look_at(Position).

+avanzar(Position)[source(Capitan)]: not abanderado
    <-
    .goto(Position).

+flag_taken: team(100)
    <-
    +soyCapi;
    ?base(B);
    .goto(B);
    +aFormar(B).
    +abanderado.