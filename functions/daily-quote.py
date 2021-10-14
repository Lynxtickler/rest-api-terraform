#import responses
import requests
import xml.etree.ElementTree as ET


def lambda_handler(event, context):
    rss_feed = 'https://www.brainyquote.com/link/quotebr.rss'
    quote = read_quote_rss(rss_feed)
    return responses.update_item('daily', quote, called_by_daily=True)


def read_quote_rss(feed_url):
    xml_response = requests.get(feed_url)
    root = ET.fromstring(xml_response.content)
    quote = root[0].find('item')
    return {'Author': quote.find('title').text, 'Text': quote.find('description').text}


if __name__ == '__main__':
    lambda_handler(None, None)
