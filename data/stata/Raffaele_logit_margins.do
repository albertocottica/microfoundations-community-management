* load data

use "/Users/albertocottica/github/local/microfoundations-community-management/data/stata/Panel_data_Edgeryders_processed.dta"


* run logit estimation for margins to work 
macro def activityVars ncommsreceivedteam ncommsreceiveduser l.activity xperience NotMeActivity ///
 TotTeamActivity l.outDegree inDegree l.fullbetweenness l.pagerank clusteringCoefficient fullavg_distance ///
 l.fullavg_betweenness LM numNodes numEdges

xtset id t
xtlogit activity $activityVars if mod !=1, fe level(99)
outtex, level

test ncommsreceivedteam == ncommsreceiveduser

margins, predict(pu0) dydx(ncommsreceivedteam ncommsreceiveduser)
* nu0 predicts the coefficient on the marginal number of events
* my notes where to use the nu0 option, but Stata does not run it. 

predict En, pu0
* creates a new variable En (default name: yhat) that encodes the number of events predicted by the model
* beware! This is not a REAL predicted number of events, because the dependent variable is itself
* a probability. 
* my notes were to use the nu0 option, but Stata does not run it. 

predict xb, xb
* creates a new variable xb that encodes the linear predictions, i.e. the sum of each beta
* multiplied by the value of the correspondent independent variable x

scatter En xb
* charts the relationship between the actual number of events and the linear prediction
* useful to figure out how many actual events a unit increase in the linear prediction
* (i.e. the coefficient) buys you

summarize xb, det
scatter En xb if xb<1
scatter En xb if xb<1 & xb >-5
scatter En xb if xb<3 & xb>-3

* these commands are a way to get an intuition for the relationship between the number of events
* and the linear predictions. The if conditions "zoom in" to study certain parts of the
* relationship

* now run the logit model again with fixed effects

margins, predict(pu0) dydx(ncommsreceivedteam ncommsreceiveduser) atmeans
* this computes the marginal number of events again. Atmean means that such effect is computed
* at the mean value of each dependent variable.

* all marginal effects are nonsignificant! But this can means that a substantial multiplier,
* multiplied by a mean of x very close to zero, will yield a number in turn close to zero.
* this is a result of using the pu0 option on margins, which tells Stata to predict the
* absolute number of extra events instead of the increase in probability.

* To correct for this, we estimate the predicted elasticity instead of number of events:
margins, predict(pu0) eyex(ncommsreceivedteam ncommsreceiveduser) atmeans
* elasticities are highly significant.

* QUESTION. According to Cameron-Trivedi (p.470), a simpler procedure for interpretation is possible. 
* beta = 1.25, so a unit increase in the regressor increases the odds ratio by exp (1.25) = 3.49.
* This means a proportionate increase of 2.49 in the initial odds ratio. The relative probability of a positive
* outcome increases by 249%. Is this acceptable?

predict prob, pu0
* generates a variable prob, the probability of a positive outcome assuming fixed effects are 0

summarize prob activity
* the dependent variable activity varies between 0 and 33; prob between 0 and 1 (doh)
* the large number of observations in which activity is equal to zero is in the way.
* to study the behaviour of prob when users actually do something, we do this:

generate active=activity >0
summarize prob active if prob != .
* active takes value 1 if the user is active in the period.
* the number of people who are active divided by total users should be the same as 
* prob, the probability of a a positive outcome. But we see this is not the case: 
* the two variable active and prob have different statistics.

* QUESTION. The number of observations for which prob is not missing value is 84,262. The number of observations for activity is instead 168,057.
* It seems that prob is only generated for a user after a certain number of periods have passed. However, there are plenty of observations for which
* activity is 0 and prob is not a missing value. What's going on? What is the rationale for dropping 84,000 observations?


* we already have in memory a variable called xb, so we drop and re-generate: QUESTION. Why?
drop xb
predict xb, xb
summarize xb
* the mean of xb is not zero: this accounts for the discrepancy between prob and active. 
* to correct for this, we need to compute a corrected logit, whose argument is 
* xb + alpha, where alpha is a constant that will get the mean of (xb + alpha) = 0.
* this is done by substitution:
* logit (mean(xb) + alpha) = mean (active)
* logit (-3.32 + alpha) = 0.18
* use Mathematica or some other function plotter to compute the value of alpha, which turns out to be
* 0.88

* QUESTION. mean(xb) is -9.51. This means that the approximate value of alpha is 8.	

* after determining alpha = 8 (not .88)

* the following expression does not run

* margins, expression ( invlogit (_b[ncommsreceivedteam] * ncommsreceivedteam + _b[ncommsreceiveduser] * ncommsreceiveduser + ///
*  _b[l.activity] * l.activity + _b[xperience] * xperience + _b[NotMeActivity] * NotMeActivity + _b[TotTeamActivity] * TotTeamActivity + ///
*  _b[l.outDegree] * l.outDegree + _b[inDegree] * inDegree + _b[l.fullbetweenness] * l.fullbetweenness + _b[l.pagerank] * l.pagerank + ///
*  _b[clusteringCoefficient] * clusteringCoefficient + _b[fullavg_distance] * fullavg_distance + 8)) dydx (ncommsreceivedteam ncommsreceiveduser) atmeans







