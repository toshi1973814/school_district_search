#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
brew install yajl

Requirements:
  pip install elasticsearch
  pip install geojson
  pip install ijson
  pip install simplejson
"""
from elasticsearch import helpers
from elasticsearch.client import Elasticsearch
from geojson.feature import Feature
from geojson.geometry import MultiPolygon, Polygon
import ijson.backends.yajl2_cffi as ijson
import sys

args = sys.argv

class JpCityProperties(object):

    def __init__(self,
                 a27_005=None,
                 a27_006=None,
                 a27_007=None,
                 a27_008=None):
        self.a27_005 = a27_005
        self.a27_006 = a27_006
        self.a27_007 = a27_007
        self.a27_008 = a27_008


def load_geojson(file_name):
    with open(file_name, 'r') as fd:
        parser = ijson.parse(fd)
        for prefix, event, value in parser:
            if (prefix, event) == ('features.item', 'start_map'):
                feature = Feature()
            elif (prefix, event) == ('features.item', 'end_map'):
                yield feature
            if (prefix, event) == ('features.item.properties', 'start_map'):
                properties = JpCityProperties()
            elif (prefix, event) == ('features.item.properties', 'end_map'):
                feature.properties = properties.__dict__
            elif (prefix, event, value) == ('features.item.properties', 'map_key', 'A27_005'):
                properties.a27_005 = parser.next()[2]
            elif (prefix, event, value) == ('features.item.properties', 'map_key', 'A27_006'):
                properties.a27_006 = parser.next()[2]
            elif (prefix, event, value) == ('features.item.properties', 'map_key', 'A27_007'):
                properties.a27_007 = parser.next()[2]
            elif (prefix, event, value) == ('features.item.properties', 'map_key', 'A27_008'):
                properties.a27_008 = parser.next()[2]
            elif (prefix, event) == ('features.item.geometry', 'start_map'):
                geometry = MultiPolygon()
            elif (prefix, event) == ('features.item.geometry.type', 'string'):
                if value == "MultiPolygon":
                    geometry = MultiPolygon()
                elif value == "Polygon":
                    geometry = Polygon()
                else:
                    raise Exception
            elif (prefix, event) == ('features.item.geometry', 'end_map'):
                feature.geometry = geometry
            elif (prefix, event) == ('features.item.geometry.coordinates', 'start_array'):
                coordinates = []
            elif (prefix, event) == ('features.item.geometry.coordinates', 'end_array'):
                geometry.coordinates = coordinates
            elif (prefix, event) == ('features.item.geometry.coordinates.item', 'start_array'):
                coordinates_item = []
            elif (prefix, event) == ('features.item.geometry.coordinates.item', 'end_array'):
                coordinates.append(coordinates_item)
            elif (prefix, event) == ('features.item.geometry.coordinates.item.item', 'start_array'):
                if isinstance(geometry, MultiPolygon):
                    coordinates_item_item = []
                else:
                    coordinates_item.append((parser.next()[2], parser.next()[2]))
            elif (prefix, event) == ('features.item.geometry.coordinates.item.item', 'end_array'):
                if isinstance(geometry, MultiPolygon):
                    coordinates_item.append(coordinates_item_item)
            elif (prefix, event) == ('features.item.geometry.coordinates.item.item.item', 'start_array'):
                if isinstance(geometry, MultiPolygon):
                    coordinates_item_item.append((parser.next()[2], parser.next()[2]))


def main(host, port, index, type, chunk_size, geojson_file):

    def _charge_doc():
        for feature in load_geojson(geojson_file):
            yield {
                '_index': index,
                '_type': type,
                '_source': feature
            }

    es = Elasticsearch(host=host, port=port)
    helpers.bulk(es, _charge_doc(), chunk_size=chunk_size, request_timeout=6000)


if __name__ == '__main__':
    main(host='localhost',
         port=9200,
         index='primary_schools',
         type='FeatureCollection',
         chunk_size=1000,
         geojson_file=args[1])
