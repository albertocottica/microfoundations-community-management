import csv
import time
import json

def unixTime2Period(unixTime, start, step):
	'''
	(int, int, int)=> int
	converts unixTime to a number representing the observation period, based on the Unix Time value of
	the start date of the observation interval and the length of the period
	'''
	p = ( (unixTime - start)//step) + 1
	return p

start = time.time()
dirPath = '/Users/albertocottica/github/local/microfoundations-community-management/data/'
print('Crunching...')

# read the file and build the essential objects
print ('Reading files and initialising objects...')
# the first file is the Edgesense output
jsonFile = open (dirPath + 'Edgesense output/network.min.json')
jsonStr = jsonFile.read()
jsonData = json.loads(jsonStr)
periods = jsonData['metrics'] # this is a list . Each item represents a time period.
comments = jsonData['edges'] # also a list. Each item represents a comment.
users = jsonData['nodes'] #also a list. Each item represents a user

# the second file is the return for a DB query on Drupal nodes
postsFile = open(dirPath + 'from jsonviews/edgesense_nodes_20151007_1108.json')
postsStr = postsFile.read()
postsDict = json.loads(postsStr)
posts = postsDict['nodes'] # this is a list of 4062 nodes

# build a list of users with moderator status

mods = []
for user in users:
    if user['team'] == True:
        mods.append(user['id'])

# initialise the target dictionary where everything goes.
allUsers = {}
for user in users:
	allUsers[user['id']] = {}
        
# I need to build a "time slider". 
start_ts = min (comment['ts'] for comment in comments)
timeStep = 60 *  60 * 24 * 7 # 1 week periods

# I add the computed metrics as elements in each period's metrics
print ('Computing activity metrics...')

# need to write in the dict also the user creation date

for user in users:
    egoID = user['id'] # local variable saves some computing time
    egoTeam = user['team'] # ditto
    egoCreationPeriod = unixTime2Period (user['created_ts'], start_ts, timeStep)
    print ('Now processing user ' + str (egoID))
    egoDict = allUsers[egoID] # ditto
    week = start_ts
    for t in range (len(periods)):
        egoDict[t] = {}        
        # set default values
        nPosts = 0 
        nCommsWrittenTeam = 0
        nCommsWrittenUser = 0
        nCommsReceivedTeam = 0
        nCommsReceivedUser = 0
        if user['created_ts'] < week + timeStep:
            # this loop computes comments
            for comment in comments: 
                if comment['ts']  > week and comment ['ts'] <= week + timeStep:
                    if comment['id'] == egoID:
                        if comment ['target'] in mods:
                            nCommsWrittenTeam += 1
                        else:
                            nCommsWrittenUser +=1
                    elif comment['target'] == egoID: # elif instead of if excludes double counting of loop edges
                        if comment ['source'] in mods:
                            nCommsReceivedTeam += 1 
                        else:
                            nCommsReceivedUser += 1
            # this loop computes posts
            for post in posts:
                if 'uid' in post['node'] and \
                   post['node']['uid'] == egoID and int(post['node']['created']) > week and \
                   int(post['node']['created']) <= week + timeStep:
                    nPosts += 1
                                                                           
        # at the end of the loop, write the result for this user and for this period
        # todo: add computation of nPosts
##        period['nPosts'][egoID] = 0 # data on posts are not in this json
##        period['nCommsWrittenTeam'][egoID] = nCommsWrittenTeam
##        period['nCommsWrittenUser'][egoID] = nCommsWrittenUser
##        period['nCommsReceivedTeam'][egoID] = nCommsReceivedTeam
##        period['nCommsReceivedUser'] [egoID] = nCommsReceivedUser

        egoDict[t]['nCommsWrittenTeam'] = nCommsWrittenTeam
        egoDict[t]['nCommsWrittenUser'] = nCommsWrittenUser
        egoDict[t]['nCommsReceivedTeam'] = nCommsReceivedTeam
        egoDict[t]['nCommsReceivedUser'] = nCommsReceivedUser
        egoDict[t]['nPosts'] = nPosts
        egoDict [t] ['is_team'] = egoTeam
        egoDict [t] ['created_t'] = egoCreationPeriod
        
        week += timeStep
# now reorganise the output of Edgesense into allUsers
wayPoint = time.time()
print('Activity metrics computed in ', int(wayPoint - start), ' seconds' )
print ('Reorganising the output from Edgesense...')
# top level: users
# second level: periods
# third level: metric:value
for t in range (len (periods)): # replace with (len (periods)):
    period = periods[t]
    for metric in period:
        if type(period[metric]) == dict:
                for person in period[metric]:
                    allUsers[person][t][metric] = period[metric][person]
        else:
                for person in allUsers:
                        allUsers[person][t][metric] = period[metric]

# last task is to write to csv.
# read the keys of the third-level dict to use as fieldnames:
wayPoint = time.time()
print('Reorganised in ', int(wayPoint - start), ' seconds' )
print ('Writing to file...')
csvFile = open(dirPath + 'csv/panelData.csv', 'w')

fieldNames = ['ID','t']
l = list(allUsers['34'][0].keys())
for field in l:
	fieldNames.append(field)
fN = [fieldNames[i] for i in range (len (fieldNames)) if fieldNames[i][:5] != 'user:']

writer = csv.DictWriter (csvFile, fieldnames = fN)

writer.writeheader()
# each row is a dict: specifically, it is the third-level dict with the two added fields user and time
for user in allUsers:
	for period in allUsers[user]:
		r = allUsers[user][period]
		r ={i:r[i] for i in r if i in fN}
		row = dict(r)
		row['ID'] = user
		row['t'] = period
		writer.writerow(row)
		
csvFile.close()
wayPoint = time.time()
print('Written in ', int(wayPoint - start), ' seconds' )
print ('The whole thing took ', int(time.time()-start), ' seconds')
