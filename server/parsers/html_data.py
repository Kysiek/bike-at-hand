from config.constants import LOGGED_HTML_CONTENT
from config.constants import UNORDERED_LIST_ELEMENT ,ORDERED_LIST_ELEMENT ,SPAN_ELEMENT_ELEMENT ,ACCOUNT_HISTORY_LIST_TAG_ATTRIBUTE_KEY
from config.constants import ACCOUNT_HISTORY_LIST_TAG_ATTRIBUTE_VALUE ,ACCOUNT_HISTORY_TAG_ATTRIBUTE_KEY
from config.constants import ACCOUNT_HISTORY_TAG_ATTRIBUTE_VALUE ,ACCOUNT_HISTORY_PRICE_TAG_ATTRIBUTE_KEY ,ACCOUNT_HISTORY_PRICE_TAG_ATTRIBUTE_VALUE
from dao.stations_dao import get_station_id_dict
import re
from HTMLParser import HTMLParser


class NextbikeHistoryParser(HTMLParser):
    in_account_history_list_tag = False
    in_account_history_tag = False
    account_history_entry = False
    account_history_price_entry = False
    current_account_history_entry = {}
    account_history_data = []
    station_id_name_dict = {}

    def get_account_history(self, html):
        self.station_id_name_dict = get_station_id_dict()
        self.feed(html)
        return self.account_history_data

    def swipe_station_name_to_id(self, account_history_string):
        for station_id in self.station_id_name_dict:
            account_history_string = account_history_string.replace(self.station_id_name_dict[station_id], station_id)
        return account_history_string

    def station_str_to_dic(self, station_str):
        station_str = self.swipe_station_name_to_id(station_str)
        m = re.search('(\d\d\.\d\d\.\d\d)\s{1,3}(\d\d\:\d\d)\s{1,3}([a-z|A-Z]{1,10})\s{1,3}(\d{1,6})\s{1,3}\w{1,3}\s{1,3}(\d\d:\d\d:\d\d)\s{1,3}\((\d{1,6})\s{1,3}\-\s{1,3}(\d{1,6})\)', station_str)
        if m and m.group(0):
            account_history_dict = {}
            start_day = m.group(1)
            start_day = start_day.replace(".13", ".2013")
            start_day = start_day.replace(".14", ".2014")
            start_day = start_day.replace(".15", ".2015")
            start_day = start_day.replace(".16", ".2016")
            account_history_dict["startDay"] = start_day
            account_history_dict["startTime"] = m.group(2)
            account_history_dict["endTime"] = m.group(5)
            account_history_dict["bikeNumber"] = m.group(4)
            account_history_dict["stationFrom"] = self.station_id_name_dict[m.group(6)]
            account_history_dict["stationTo"] = self.station_id_name_dict[m.group(7)]
            return account_history_dict
        return False

    # HTMLParser methods
    def handle_starttag(self, tag, attrs):
        if tag == UNORDERED_LIST_ELEMENT and (ACCOUNT_HISTORY_LIST_TAG_ATTRIBUTE_KEY, ACCOUNT_HISTORY_LIST_TAG_ATTRIBUTE_VALUE) in attrs:
            self.in_account_history_list_tag = True
        elif self.in_account_history_list_tag and tag == ORDERED_LIST_ELEMENT and (ACCOUNT_HISTORY_TAG_ATTRIBUTE_KEY, ACCOUNT_HISTORY_TAG_ATTRIBUTE_VALUE) not in attrs:
            self.in_account_history_tag = True
        elif self.in_account_history_tag and tag == SPAN_ELEMENT_ELEMENT and (ACCOUNT_HISTORY_PRICE_TAG_ATTRIBUTE_KEY, ACCOUNT_HISTORY_PRICE_TAG_ATTRIBUTE_VALUE) in attrs:
            self.account_history_price_entry = True
        elif self.in_account_history_tag and tag == SPAN_ELEMENT_ELEMENT:
            self.account_history_entry = True

    def handle_endtag(self, tag):
        if self.account_history_price_entry and tag == SPAN_ELEMENT_ELEMENT:
            self.account_history_price_entry = False
        elif self.account_history_entry and tag == SPAN_ELEMENT_ELEMENT:
            self.account_history_entry = False
        elif self.in_account_history_tag and tag == ORDERED_LIST_ELEMENT:
            self.in_account_history_tag = False
        elif not self.in_account_history_tag and self.in_account_history_list_tag and tag == UNORDERED_LIST_ELEMENT:
            self.in_account_history_list_tag = False

    def handle_data(self, data):
        if self.account_history_entry:
            station_dic = self.station_str_to_dic(data)
            if station_dic:
                self.account_history_data.append(station_dic)
        else:
            # TODO: handle cost of the route
            pass


def is_logged(html):
    return LOGGED_HTML_CONTENT in html
