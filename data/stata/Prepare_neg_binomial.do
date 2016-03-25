use "/Users/albertocottica/github/local/microfoundations-community-management/data/stata/Panel_data_Edgeryders.dta"

* rename some variables
rename fulldensity density
rename fullout_degree outDegree
rename fullnodes_count numNodes
rename fulllouvain_modularity LM
rename fullbetweenness_count BTW
rename fullin_degree inDegree
rename fullclustering clusteringCoefficient
rename fullpagerank pagerank


* label some variables 
label variable ncommsreceivedteam "n Comms received byt moderators"
label variable ncommsreceivedteam "n Comms received by moderators"
label variable ncommsreceiveduser "n Comms received by non-moderators"
label variable nposts "n Posts written"
label variable ncommswrittenteam "n Comms Written to moderators"
label variable ncommsreceiveduser "n Comms received from non-moderators"
label variable ncommswrittenuser "n Comms Written to non-moderators"
label variable created_t "account creation period"
label variable CC "clustering coefficient (undirected)"
label variable PR "pagerank"

ge activity = nposts + ncommswrittenuser - ncommswrittenteam
label variable activity "number of posts + total comments written"
* The following gets rid of the Boolean variable, read as string by Stata.
ge mod = 0
replace mod = 1 if (is_team == "True")
label variable mod "takes value 1 if the user has moderators role"

* generate activity variables
label variable activity "total units of content written by this user"
egen TotTeamActivity = sum(activity*mod),by(t)
label variable TotTeamActivity "total activity of moderators in the period"
egen TotActivity = sum(activity),by(t)
ge TotUserActivity = TotActivity - TotTeamActivity
label variable TotUserActivity "total activity of non-moderators in the period"
ge NotMeActivity = TotUserActivity - activity
label variable NotMeActivity "total non-moderator activity in the community, except for that by ego"

* this variables measures experience as an Edgeryders user   

ge xperience = t - created_t if t >= created_t
label variable xperience "Weeks of using the platform"

