//EJEMPLO LUCHADOR 

//Creencias base
vida(60).
quieto.


+flag(F): team(200)
  <-
  .create_control_points(F,60,6,C);
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
  .shoot(6,Position).
*/
+threshold_health(vida) : health(X)
  <- //+move. //actualizar vida
  +girar;
  -vida.
  +vida(X).

  
//+move : position([X,Y,Z])
//  <- 
//  -quieto;
//  +andar;
//  .goto([X+6,Y,Z+6]);
//  -andar;
//  +vigilar.


+friends_in_fov(ID,Type,Angle,Distance,Health,Position): position([X,Y,Z])
  <-
  .shoot(6,Position);
  +move(Position, [X,Y,Z]).

+move([X1,Y1,Z1],[X2,Y2,Z2]): X1 < X2 & Z1 > Z2 & X2 <239 &  Z2 > 16
<- -quieto;
+andar;
.goto([X2+6,Y2,Z2-6]);
-andar;
+vigilar.

+move(([X1,Y1,Z1]),([X2,Y2,Z2])): X1 > X2 & Z1 < Z2 & X2 >16 &  Z2 < 239
<- -quieto;
+andar;
.goto([X2-6,Y2,Z2+6]);
-andar;
+vigilar.

+move(([X1,Y1,Z1]),([X2,Y2,Z2])): X1 < X2 & Z1 < Z2 & X2 <239 &  Z2 < 239
<- -quieto;
+andar;
.goto([X2+6,Y2,Z2+6]);
-andar;
+vigilar.

+move(([X1,Y1,Z1]),([X2,Y2,Z2])): X1 > X2 & Z1 > Z2 & X2 > 16 &  Z2 > 16
<- -quieto;
+andar;
.goto([X2-6,Y2,Z2-6]);
-andar;
+vigilar.

+move([X1,Y1,Z1],[X2,Y2,Z2])
<- -quieto;
+andar;
.goto([125,Y2,125]);
-andar;
+vigilar.

+vigilar
  <-
  .turn(3.14);
  -vigilar;
  +quieto.

+packs_in_fov(ID,Type,Angle,Distance,Health,Position): Type < 606
  <-
  .goto(Position).

+girar
  <-
  .turn(3.14/2).