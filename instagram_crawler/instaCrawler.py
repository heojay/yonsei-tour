from selenium import webdriver
from selenium.common.exceptions import NoSuchElementException
from bs4 import BeautifulSoup
import pandas as pd

'''
To Do: remove tags from content / infinity scroll
'''


tb = pd.DataFrame(columns=['username','content','location'])
d = webdriver.Chrome('/Users/yerinkwon/yonsei-bus/instagram_crawler/chromedriver')
d.implicitly_wait(3)
d.get('https://www.instagram.com/explore/tags/seoultrip/')

html = d.page_source
soup = BeautifulSoup(html, 'html.parser')
links = soup.select('#react-root > section > main > article > div:nth-child(3) > div > div > div > a')

i=0
for link in links:
	username = ''
	content = ''
	location = ''
	d.get('https://www.instagram.com'+link.get('href'))
	try:
		username = d.find_element_by_css_selector('#react-root > section > main > div > div > article > header > div.o-MQd.z8cbW > div.PQo_0.RqtMr > div.e1e1d > h2 > a').get_attribute("text")
	except NoSuchElementException:
		print("exception name")

	try:
		content = d.find_element_by_css_selector('#react-root > section > main > div > div > article > div.eo2As > div.EtaWk > ul > div > li > div > div > div.C4VMK > span').get_attribute("innerHTML")
	except NoSuchElementException:
		print("exception content")
		
	try:
		location = d.find_element_by_css_selector('#react-root > section > main > div > div > article > header > div.o-MQd.z8cbW > div.M30cS > div.JF9hh > a').get_attribute("text")
	except NoSuchElementException:
		print("exception location")

	tb.loc[i] = [username,content,location]
	i+=1
		
tb.to_csv("result.csv")
