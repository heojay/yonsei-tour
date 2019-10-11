# 추후 Crawler와 합칠 예정

import requests
from bs4 import BeautifulSoup
import csv
import webbrowser
import io
import pandas as pd

def display(content, filename='output.html'):
    with open(filename, 'wb') as f:
        f.write(content)
        webbrowser.open(filename)

def get_soup(session, url, show=False):
    r = session.get(url)
    if show:
        display(r.content, 'temp.html')
    if r.status_code != 200: # not OK
        print('[get_soup] status code:', r.status_code)
    else:
        return BeautifulSoup(r.text, 'html.parser')

def post_soup(session, url, params, show=False):
    '''Read HTML from server and convert to Soup'''

    r = session.post(url, data=params)

    if show:
        display(r.content, 'temp.html')

    if r.status_code != 200: # not OK
        print('[post_soup] status code:', r.status_code)
    else:
        return BeautifulSoup(r.text, 'html.parser')

def scrape(url, lang='ALL'):

    # create session to keep all cookies (etc.) between requests
    session = requests.Session()

    session.headers.update({
        'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:57.0) Gecko/20100101 Firefox/57.0',
    })


    items = parse(session, url)

    return items

def parse(session, url):
    '''Get number of reviews and start getting subpages with reviews'''

    print('[parse] url:', url)

    soup = get_soup(session, url)

    if not soup:
        print('[parse] no soup:', url)
        return

    url_template = url
    '''
    url_template = url.replace('oa30', 'oa{}')
    print('[parse] url_template:', url_template)
    '''

    items = []

    offset = 30

    while(True):
        subpage_url = url_template.format(offset)
        subpage_items = parse_urls(session, subpage_url)

        if not subpage_items:
            break

        items += subpage_items

        if len(subpage_items) < 30:
            break

        offset += 30
        break

    return items

def parse_urls(session, url):
    '''Get all reviews from one page'''

    print('[parse_urls] url:', url)

    soup = get_soup(session, url)

    if not soup:
        print('[parse_urls] no soup:', url)
        return

    items = []

    for title in soup.find_all('div', class_='tracking_attraction_title listing_title'):

        item = {
            'url' : title.select('a')[0].get('href'),
            'title' : title.select('a')[0].text
            # 리뷰 날짜
            # 'review_date': review.find('span', class_='ratingDate')['title'],
       }

        items.append(item)
        '''
        print('\n--- review ---\n')
        for key,val in item.items():
            print(' ', key, ':', val)
        '''

    return items

def write_in_csv(items, filename='results.csv',
                  headers=['hotel name', 'review title', 'review body',
                           'review date', 'contributions', 'helpful vote',
                           'user name' , 'user location', 'rating'],
              mode='w'):

    print('--- CSV ---')

    with io.open(filename, mode, encoding="utf-8") as csvfile:
        csv_file = csv.DictWriter(csvfile, headers)

        if mode == 'w':
            csv_file.writeheader()

        csv_file.writerows(items)

start_urls = [
    'https://www.tripadvisor.com/Attractions-g294197-Activities-a_allAttractions.true-Seoul.html'
]

headers = ['url','title']

for url in start_urls:

    # get all reviews for 'url'
    items = scrape(url)

    if not items:
        print('No reviews')
    else:
        # write in CSV
        filename = 'Seoul_URL'
        print('filename:', filename)
        write_in_csv(items, filename + '.csv', headers, mode='w')