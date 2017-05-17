// Agent participant in project orgCoordinationMAS

/* Initial beliefs and rules */

+!bid[scheme(Sch)]
   <- ?goalArgument(Sch,auction,"Id",Id); // retrieve auction id and focus on the artifact
      lookupArtifact(Id,AId);
      focus(AId);
      .wait(math.random * 2000 + 500); 
       bid(math.random * 100 + 10).
        
+best_bid(Value)[artifact_id(AId)]:running(true)[artifact_id(AId)]
   <- 
   	  .wait(1000)
   	  !bidNewOffer(Value,AId).

+!bidNewOffer(Value,ArtId)[source(self)]:running(true)[artifact_id(ArtId)]
   <-
	?task(AuctionItem)[artifact_id(AId)]; 
	.println("Best current offer for ",AuctionItem," is ",Value, ", offering new one");
	?running(AuctionRunningState)[artifact_id(AId)];
	if (AuctionRunningState == true) {
		bid(Value * 0.9)[artifact_id(AId)]	
	}.

//Plan to handle bidNewOffer goal fails when an agent bids at closed auction
   		
-!bidNewOffer(Value,ArtId)[source(self)]:true
	<- 
	if(.fail_goal(bidNewOffer(Value,ArtId)[source(self)])) {
		?task(AuctionItem)[artifact_id(ArtId)] //Retrieve the auction task belief about current artifact observable property.
		?running(AuctionState)[artifact_id(ArtId)] // The same to running observable property. 
		println(
			"Fail to offer at Auction ",AuctionItem,
			" when auction state running is ",AuctionState
		)
	}.

+running(Value)[artifact_id(AId)] : Value == false & .desire(bidNewOffer(Value,ArtId)[artifact_id(AId)])
   <- 
	?task(AuctionItem)[artifact_id(AId)];
	.println("auction ",AuctionItem, " finished, cancel my offer intention");
	.drop_intention(bid(ServDesc)[artifact_id(AId)]).

+running(Value)[artifact_id(AId)] : Value == false & .desire(bid(Value)[artifact_id(AId)])
   <- 
	?task(AuctionItem)[artifact_id(AId)];
	.println("auction ",AuctionItem, " finished, cancel my offer intention");
	.drop_intention(bid(ServDesc)[artifact_id(AId)]).
	


+winner(W) : .my_name(W) <- .print("I Won!").

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have a agent that always complies with its organization  
{ include("$jacamoJar/templates/org-obedient.asl") }
