from config.constants import LOGGED_HTML_CONTENT
from HTMLParser import HTMLParser


class NextbikeHistoryParser(HTMLParser):    
    history = []    
    def get_account_history(self, html):
        self.feed(html)
        return history
    def handle_starttag(self, tag, attrs):
        print "Encountered a start tag:", tag
    def handle_endtag(self, tag):
        print "Encountered an end tag :", tag
    def handle_data(self, data):
        print "Encountered some data  :", data

def is_logged(html):
    return LOGGED_HTML_CONTENT in html