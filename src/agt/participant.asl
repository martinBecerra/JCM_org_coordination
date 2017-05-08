// Agent participant in project orgCoordinationMAS

/* Initial beliefs and rules */

+!bid[scheme(Sch)]
   <- ?goalArgument(Sch,auction,"Id",Id); // retrieve auction id and focus on the artifact
      lookupArtifact(Id,AId);
      focus(AId);
      if (math.random  < 0.5) {              // bid in 50% of the cases
        .wait(math.random * 2000 + 500);     // to simulate some "decision" reasoning
       bid(math.random * 100 + 10);
      } else {
        .fail;                               // fail otherwise
      }.
        
+best_bid(Value)[artifact_id(AId)]:running(true)[artifact_id(AId)]
   <- 
   	  .wait(1000)
   	  !bidNewOffer(Value,AId).

+!bidNewOffer(Value,ArtId):running(true)[artifact_id(ArtId)]
   <-
	?task(AuctionItem)[artifact_id(AId)]; 
	.print("Best current offer for ",AuctionItem," is ",Value, ", offering new one");
	bid(Value * 0.9)[artifact_id(AId)].
		

+running(Value)[artifact_id(AId)] : Value == false & .desire(bidNewOffer(Value,ArtId)[artifact_id(AId)])
   <- 
	?task(AuctionItem)[artifact_id(AId)];
	.print("auction ",AuctionItem, " finished, cancel my offer intention");
	.drop_intention(bid(ServDesc)[artifact_id(AId)]).

+running(Value)[artifact_id(AId)] : Value == false & .desire(bid(Value)[artifact_id(AId)])
   <- 
	?task(AuctionItem)[artifact_id(AId)];
	.print("auction ",AuctionItem, " finished, cancel my offer intention");
	.drop_intention(bid(ServDesc)[artifact_id(AId)]).

+winner(W) : .my_name(W) <- .print("I Won!").

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have a agent that always complies with its organization  
{ include("$jacamoJar/templates/org-obedient.asl") }
