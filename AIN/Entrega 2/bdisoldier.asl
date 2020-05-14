//TEAM_AXIS


//Míos
+Ascender:
  +Soycapitan;
  .register_service("capitan").

+AFormar:
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

+AAtacar(Position):
  <-
  .get_service()//indicar de que equipo pdf1 pg7
  .send(,tell,Atacar(Position))

+AParar:
  <-
  .get_service()//indicar de que equipo pdf1 pg7
  .send(,tell,Parar)

+AAvanzar(Position):
  .get_service()//indicar de que equipo pdf1 pg7
  .send(tell,Avanzar(Position))

//------------SOLDADO---------------
+Ordenar(Position)[sourceA]
<-
  .goto(Postion)
+Atacar(Position)[sourceA]
<- 
  .lookAt(Position); //al girarse si lo ven ya deberían atacar, si no lo ven nada porque romerían la formacion

+Parar[sourceA]
<-
  .stop
//FIN
+flag (F): team(200)
  <-
  .create_control_points(F,25,3,C);
  +control_points(C);
  .length(C,L);
  +total_control_points(L);
  +patrolling;
  +patroll_point(0);
  .print("Got control points").


+target_reached(T): patrolling & team(200)
  <-
  ?patroll_point(P);
  -+patroll_point(P+1);
  -target_reached(T).

+patroll_point(P): total_control_points(T) & P<T
  <-
  ?control_points(C);
  .nth(P,C,A);
  .goto(A).

+patroll_point(P): total_control_points(T) & P==T
  <-
  -patroll_point(P);
  +patroll_point(0).


//TEAM_ALLIED

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

+heading(H): exploring
  <-
  .wait(2000);
  .turn(0.375).

//+heading(H): returning
//  <-
//  .print("returning").

+target_reached(T): team(100)
  <-
  .print("target_reached");
  +exploring;
  .turn(0.375).

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .shoot(3,Position).