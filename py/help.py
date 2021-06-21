
import requests #this may need to be downloaded in your R session with something like import("requests") in R.

# I choose to access the api's through python since it is 1.5x faster.



#this function gets artworks that are lowlights, this is not used in alpha 1
def get_lowlights(name):
  urls = list()
  url = "https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&artistOrCulture=true&q=" + name
  r = requests.get(url)
  j = r.json()
  t = j['objectIDs']
  if t == None:
    return(1)
  else:
    for i in t:
      url = url = "https://collectionapi.metmuseum.org/public/collection/v1/objects/" + str(i)
      req = requests.get(url)
      j = req.json()
      if j['artistDisplayName'] == name:
        t = j['primaryImage']
        urls.append(t)
  return(urls)
      


# this function gets artworks that are highlights
def get_highlights(name):
  urls = list()
  url = "https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&isHighlight=true&artistOrCulture=true&q=" + name
  r = requests.get(url)
  j = r.json()
  t = j['objectIDs']
  if t == None:
    return(1)
  for i in t:
      url = "https://collectionapi.metmuseum.org/public/collection/v1/objects/" + str(i)
      req = requests.get(url)
      j = req.json()
      t = j['primaryImage']
      urls.append(t)
  return(urls)


#this function gets the titles from the hightlights
def get_titles(name):
  titles = list()
  url = "https://collectionapi.metmuseum.org/public/collection/v1/search?hasImages=true&isHighlight=true&artistOrCulture=true&q=" + name
  r = requests.get(url)
  j = r.json()
  t = j['objectIDs']
  if t == None:
    return(1)
  for i in t:
      url = "https://collectionapi.metmuseum.org/public/collection/v1/objects/" + str(i)
      req = requests.get(url)
      j = req.json()
      t = j['title']
      titles.append(t)
  return(titles)

