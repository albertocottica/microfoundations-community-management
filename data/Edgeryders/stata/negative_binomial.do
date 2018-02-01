* xtset tells Stata that the panel variable is "nodeid" and the time variable is "period".
xtset id t

/* try my own model. Expected coefficients: 
positive on cluster (social embeddedness
inverted-U shaped on InDegree (social embeddeness, then redundancy effect
no prior on density
positive on betweenness centrality (in an ideal world people are willing to act as go-betweens)
positive normalized PageRank (authoritativeness is rewarded by moderators)
positive on modularity (more orderly conversation, more fun to participate)
no prior on Nnode (controlling for it because it correlates with modularity)
inverted U-shaped for xperience (user life cycle)
*/



* the negative binomial model is computed on total activity 

macro def activityVars numNodes l.LM l.ncommsreceivedteam  l.ncommsreceiveduser ///
				c.l.BTW##c.l.BTW inDegree l.outDegree density l.CC l.PR ///
				c.xperience##c.xperience TotTeamActivity NotMeActivity 

xtnbreg activity $activityVars if mod != 1, fe
outreg2 using "/Users/albertocottica/github/local/microfoundations-community-management/results/estimation", stats(coef se pval)  excel dec(3) ctitle (neg binomial) replace
xtlogit activity $activityVars if mod !=1, fe
outreg2 using "/Users/albertocottica/github/local/microfoundations-community-management/results/estimation", stats(coef se pval) excel dec(3) ctitle (logit)

				
