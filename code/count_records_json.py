# counts the number of records in the JSON files

import json
dirPath = '/Users/albertocottica/github/local/microfoundations-community-management/data/from jsonviews/'
jsonFileName = 'edgesense_comments_20151007_1108.json'
# to compute the number of Drupal nodes instead, change above to
#jsonFileName = 'edgesense_comments_20151007_1108.json' 
f = open (dirPath + jsonFileName, 'r')
fStr = f.read()
jsonDict = json.loads(fStr)

# then do this in the Python shell:
# len (jsonDict['comments']) for counting the number of records in the comments JSON file
# len (jsonDict ['nodes']) for counting the number of records in the nodes JSON file
