# transform from probability to log-odds ratio

import csv
import numpy

dirPath = '/Users/albertocottica/Documents/More PhD stuff/MyPhDdata/Thesis Paper 2/Paper 2 data/'


with open(dirPath + 'logOdds.csv', "w") as csvfile:

    oddsWriter = csv.writer(csvfile, delimiter = ",")

    for p in numpy.arange (0, 1, .01):
        oddsRatio = p/(1-p)
        row = [p, oddsRatio, numpy.log(oddsRatio)]
        oddsWriter.writerow(row)
    

    
