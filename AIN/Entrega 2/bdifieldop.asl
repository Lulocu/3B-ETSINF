//TEAM_AXIS
miPos([]).
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
  .print("AMMOPACK!");
  .reload;
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
  .reload;
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
  
// nuevas implementaciones



+solicitarMunicion(Pos)[source(soldado)]: not (ayudando(_,_))
	<-
	?position(miPos);
	.send(soldado, tell, recarga(miPos));
	+ayudando(soldado, Pos);
	-solicitarMunicion(_);
	.print("enviada propuesta de ayuda").

+acceptproposalMun[source(solado)]: ayudando(soldado,Pos)
	<-
	.print("Me voy a ayudar al agente: ", soldado, "a la posicion: ", Pos);
	.goto(Pos).

+target_reached(Pos): ayudando(soldado, Pos)
	<-
	.print("Recargar! para el agente:", soldado);
	.reload;
	//?posFormacion(P);
	.goto(miPos);
	-ayudando(soldado, Pos).

+cancelproposalMun[source(solado)]: ayudando(soldado, Pos)
	<-
	.print("Me cancelan mi proposicion");
	-ayudando(soldado, Pos).
