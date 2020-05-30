//TEAM_AXIS
miPos([]).
+flag (F): team(200) 
  <-
  .create_control_points(F,25,3,C);
  +control_points(C);
  .length(C,L);
  +total_control_points(L);
  +patrolling;
  +patroll_point(0).


+target_reached(T): patrolling & team(200) 
  <-

  .cure;
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

+flag_taken: team(100) 
  <-
      .get_service("allied");
    ?allied(Allied);
    .print(Allied);
  .print("In ASL, TEAM_ALLIED flag_taken").

+enemies_in_fov(ID,Type,Angle,Distance,Health,Position)
  <- 
  .shoot(3,Position).
  
//Nuevas implementaciones medicos
    


+solicitarCura(Pos)[source(Soldado)]: not (ayudando(_,_))
	<-
	?position(miPos);
	.send(Soldado, tell, curate(miPos));
	+ayudando(Soldado, Pos);
	-solicitarCura(_);
	.print("enviada propuesta de ayuda").

+acceptproposalCura[source(Soldado)]: ayudando(Soldado,Pos)
	<-
	.print("Me voy a ayudar al agente: ", Soldado, "a la posicion: ", Pos);
	.goto(Pos).

+target_reached(Pos): ayudando(Soldado, Pos)
	<-
	.print("MEDPACK! para el agente:", Soldado);
	.cure;
	//?posFormacion(P);
	.goto(miPos);
	-ayudando(Soldado, Pos).

+cancelproposalCura[source(Soldado)]: ayudando(Soldado, Pos)
	<-
	.print("Me cancelan mi proposicion");
	-ayudando(Soldado, Pos).  

  +avanzar(Position)[source(Capitan)]
    <-
    .goto(Position).
