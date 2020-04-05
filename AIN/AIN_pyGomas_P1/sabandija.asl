//EJEMPLO LUCHADOR 

//Creencias base
vida(100).
quieto.


+flag(F): team(200)
  <-
  .create_control_points(F,100,3,C);
  +control_points(C);
  //.wait(5000);
  .length(C,L);
  +total_control_points(L);
  +patrolling;
  +patroll_point(0);
  .print("Got control points:", C).


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
 // .print("Voy a Pos: ", A).

+patroll_point(P): total_control_points(T) & P==T
  <-
  -patroll_point(P);
  +patroll_point(0).
 
 /*  En modo arena no hace falta disparar al enemigo  
  +enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .shoot(3,Position).
*/
+threshold_health(vida) : health(X)
  <- +move. //actualizar vida
  
  -vida.
  +vida(X).

  
+move : position([X,Y,Z])
  <- 
  -quieto;
  +andar;
  .goto([X+3,Y,Z+3]);
  -andar;
  +vigilar.


+friends_in_fov(ID,Type,Angle,Distance,Health,Position)
  <-
  .shoot(10,Position);
  +move.

+vigilar
  <-
  .turn(3.14);
  -vigilar;
  +quieto.

+packs_in_fov(ID,Type,Angle,Distance,Health,Position): Type < 1003
  <-
  .goto(Position).

+girar
  <-
  .turn(3.14).
