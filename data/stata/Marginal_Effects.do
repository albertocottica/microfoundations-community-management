* Studying marginal effects aftern computing alpha

* compute marginal probability of xmcrec 

ge mpcmrec = 1.250433 * exp(ncommsreceivedteam * 1.250433 + ncommsreceiveduser * .2148115 + l.activity + .1264396   +  xperience * ( -.01112) ///
+ NotMeActivity * .0374573 -  TotTeamActivity * (-.0364852) +  l.outDegree * .028095 + inDegree * (-.0028557) + l.fullbetweenness * (-107.8704) ///
+ l.pagerank * (-5.592309 ) + clusteringCoefficient *  (-.6544069) + fullavg_distance *(-4.156296) + l.fullavg_betweenness * (-9.259912) /// 
+ LM * 8.378965 + numNodes * (-.0014035) + numEdges * ( -.000326) + 8) / ( 1 + exp(ncommsreceivedteam * 1.250433 + ncommsreceiveduser * .2148115 + l.activity + .1264396   +  xperience * ( -.01112) ///
+ NotMeActivity * .0374573 -  TotTeamActivity * (-.0364852) +  l.outDegree * .028095 + inDegree * (-.0028557) + l.fullbetweenness * (-107.8704) ///
+ l.pagerank * (-5.592309 ) + clusteringCoefficient *  (-.6544069) + fullavg_distance *(-4.156296) + l.fullavg_betweenness * (-9.259912) /// 
+ LM * 8.378965 + numNodes * (-.0014035) + numEdges * ( -.000326) + 8))^2

label variable mpcmrec "Predicted prob that extra comment from comm manager results in activity. Xs at observed value."
scatter mpcmrec ncommsreceivedteam
* a mess, but negative correlation. To see this clearer, we need to bin both variables. "cat" at the end of a variable name stands for "category"


egen mpcmreccat = cut (mpcmrec), at (0, .1, .2, .3, 1)
* most mass of observations are at a marginal effect between .2 and .3 
egen ncommsrecteamcat = cut (ncommsreceivedteam), at (0, 1, 2, 3, 4, 5, 11, 100)
* most of the mass of observations is at zero and one comments received
tabulate ncommsrecteamcat mpcmreccat, summarize (mpcmrec)

tabout ncommsrecteamcat mpcmreccat using ///
"/Users/albertocottica/Documents/More PhD stuff/MyPhDdata/Thesis Paper 2/Paper 2 data/Paper 2 Stata files/table.tek", ///
replace cells (freq) format (0c 2p) style (tex)  ///
topf ("/Users/albertocottica/Documents/More PhD stuff/MyPhDdata/Thesis Paper 2/Paper 2 LATEX/top.tex") ///
botf ("/Users/albertocottica/Documents/More PhD stuff/MyPhDdata/Thesis Paper 2/Paper 2 LATEX/bot.tex") 

* same thing, but now fixing the Xs at means to get a smooth functional form

ge mpcmrecatmeans = 1.250433 * exp(ncommsreceivedteam * 1.250433 + .0876183 * .2148115 + .0337836  + .1264396   +  81.17807 * ( -.01112) ///
+ 21.28847 * .0374573 -  13.49224 * (-.0364852) +  8.257042 * .028095 + 8.674914 * (-.0028557) + .001476 * (-107.8704) ///
+ .0027679 * (-5.592309 ) + .5629708 *  (-.6544069) + 2.274266 *(-4.156296) + .0020053 * (-9.259912) /// 
+ .2991167 * 8.378965 + 487.9714 * (-.0014035) + 3123.35 * ( -.000326) + 8) / ( 1 + exp(ncommsreceivedteam * 1.250433 + .0876183 * .2148115 ///
 + .0337836 + .1264396   +  81.17807 * ( -.01112) ///
+ 21.28847 * .0374573 -  13.49224 * (-.0364852) +  8.257042 * .028095 + 8.674914 * (-.0028557) + .001476 * (-107.8704) ///
+ .0027679 * (-5.592309 ) + .5629708 *  (-.6544069) + 2.274266 *(-4.156296) + .0020053 * (-9.259912) /// 
+ .2991167 * 8.378965 + 487.9714 * (-.0014035) + 3123.35 * ( -.000326) + 8))^2

label variable mpcmrecatmeans "Predict prob that extra comment from managers => activity. Xs at means."

scatter mpcmrecatmeans ncommsreceivedteam

egen mpcmrecatmeanscat = cut (mpcmrecatmeans), at (0, .1, .2, .3, 1)

tabulate ncommsrecteamcat mpcmrecatmeanscat, summarize (mpcmrecatmeans)

* repeat the procedure for non-community managers

ge mpurec = .2148115 * exp(ncommsreceivedteam * 1.250433 + ncommsreceiveduser * .2148115 + l.activity + .1264396   +  xperience * ( -.01112) ///
+ NotMeActivity * .0374573 -  TotTeamActivity * (-.0364852) +  l.outDegree * .028095 + inDegree * (-.0028557) + l.fullbetweenness * (-107.8704) ///
+ l.pagerank * (-5.592309 ) + clusteringCoefficient *  (-.6544069) + fullavg_distance *(-4.156296) + l.fullavg_betweenness * (-9.259912) /// 
+ LM * 8.378965 + numNodes * (-.0014035) + numEdges * ( -.000326) + 8) / ( 1 + exp(ncommsreceivedteam * 1.250433 + ncommsreceiveduser * .2148115 + l.activity + .1264396   +  xperience * ( -.01112) ///
+ NotMeActivity * .0374573 -  TotTeamActivity * (-.0364852) +  l.outDegree * .028095 + inDegree * (-.0028557) + l.fullbetweenness * (-107.8704) ///
+ l.pagerank * (-5.592309 ) + clusteringCoefficient *  (-.6544069) + fullavg_distance *(-4.156296) + l.fullavg_betweenness * (-9.259912) /// 
+ LM * 8.378965 + numNodes * (-.0014035) + numEdges * ( -.000326) + 8))^2

label variable mpurec "Predicted prob extra comment from user =>activity. Xs at observed value."
scatter mpurec ncommsreceiveduser

egen mpureccat = cut (mpurec), at (0, .05, .1, .2, .3, 1)
* most mass of observations are at a marginal effect between .2 and .3 
egen ncommsrecusrcat = cut (ncommsreceiveduser), at (0, 1, 2, 3, 4, 5, 11, 100)
* most of the mass of observations is at zero and one comments received
tabulate ncommsrecusrcat mpureccat, summarize (mpurec)

twoway (histogram mpurec, color (gray))  (histogram mpcmrec, color (red)) 

* same thing, but now fixing the Xs at means to get a smooth functional form

ge mpurecatmeans = .2148115 * exp(.0819175 * 1.250433 + ncommsreceiveduser * .2148115 + .0337836  + .1264396   +  81.17807 * ( -.01112) ///
+ 21.28847 * .0374573 -  13.49224 * (-.0364852) +  8.257042 * .028095 + 8.674914 * (-.0028557) + .001476 * (-107.8704) ///
+ .0027679 * (-5.592309 ) + .5629708 *  (-.6544069) + 2.274266 *(-4.156296) + .0020053 * (-9.259912) /// 
+ .2991167 * 8.378965 + 487.9714 * (-.0014035) + 3123.35 * ( -.000326) + 8) / ( 1 + exp(.0819175 * 1.250433 + ncommsreceiveduser * .2148115 ///
 + .0337836 + .1264396   +  81.17807 * ( -.01112) ///
+ 21.28847 * .0374573 -  13.49224 * (-.0364852) +  8.257042 * .028095 + 8.674914 * (-.0028557) + .001476 * (-107.8704) ///
+ .0027679 * (-5.592309 ) + .5629708 *  (-.6544069) + 2.274266 *(-4.156296) + .0020053 * (-9.259912) /// 
+ .2991167 * 8.378965 + 487.9714 * (-.0014035) + 3123.35 * ( -.000326) + 8))^2

label variable mpurecatmeans "Predict prob that extra comment from users => activity. Xs at means."

twoway (scatter mpcmrecatmeans ncommsreceivedteam, color(red) msize (2)) (scatter mpurecatmeans ncommsreceiveduser, color (gray) msize (2))

tabulate ncommsrecusrcat mpureccat, summarize (mpurec)

tabulate mpurecatmeans if ncommsreceiveduser == 0
% change the number to compute the predicted marginal effect at means at different levels of the regressor. 
