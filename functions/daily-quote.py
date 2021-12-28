import shared
import urllib3
import xml.etree.ElementTree as ET


def lambda_handler(event, context):
    rss_feed = 'https://www.brainyquote.com/link/quotebr.rss'
    quote = read_quote_rss(rss_feed)
    return shared.update_item('daily', quote, called_by_daily=True)


def read_quote_rss(feed_url):
    http = urllib3.PoolManager()
    xml_response = http.request('GET', feed_url).data
    root = ET.fromstring(xml_response)
    quote = root[0].find('item')
    quote_text = quote.find('description').text.lstrip('"').rstrip('"')
    return {'Author': quote.find('title').text, 'Text': quote_text}
