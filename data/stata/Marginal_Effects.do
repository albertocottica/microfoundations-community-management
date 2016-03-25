* Studying marginal effects aftern computing alpha

* compute marginal probability of xmcrec 

ge mpcmrec = 1.250433 * exp(ncommsreceivedteam * 1.250433 + ncommsreceiveduser * .2148115 + l.activity + .1264396   +  xperience * ( -.01112) ///
+ NotMeActivity * .0374573 -  TotTeamActivity * (-.0364852) +  l.outDegree * .028095 + inDegree * (-.0028557) + l.fullbetweenness * (-107.8704) ///
+ l.pagerank * (-5.592309 ) + clusteringCoefficient *  (-.6544069) + fullavg_distance *(-4.156296) + l.fullavg_betweenness * (-9.259912) /// 
+ LM * 8.378965 + numNodes * (-.0014035) + numEdges * ( -.000326) + 8) / ( 1 + exp(ncommsreceivedteam * 1.250433 + ncommsreceiveduser * .2148115 + l.activity + .1264396   +  xperience * ( -.01112) ///
+ NotMeActivity * .0374573 -  TotTeamActivity * (-.0364852) +  l.outDegree * .028095 + inDegree * (-.0028557) + l.fullbetweenness * (-107.8704) ///
+ l.pagerank * (-5.592309 ) + clusteringCoefficient *  (-.6544069) + fullavg_distance *(-4.156296) + l.fullavg_betweenness * (-9.259912) /// 
+ LM * 8.378965 + numNodes * (-.0014035) + numEdges * ( -.000326) + 8))^2

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
