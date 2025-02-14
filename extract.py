import requests

url = "https://spotify23.p.rapidapi.com/playlist_tracks/"

querystring = {"id":"insert playlist id here","offset":"0"}

headers = {
	"x-rapidapi-key": "insert key",
	"x-rapidapi-host": "insert host url"
}

response = requests.get(url, headers=headers, params=querystring)

print(response.json())