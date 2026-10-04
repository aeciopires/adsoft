#!/usr/bin/env python3
# Prometheus exporter to get the size of a group of indices and the document count of them.
# The script is different from elasticsearch_exporter because it summarizes data to give a unique metric
# for a group of indices (defined by the regex). This works better for time series data of specific ranges.
#
# Requirements: pip install prometheus-client requests
#
# Environment variables:
#   ES_ENDPOINT       Elasticsearch endpoint (default: http://localhost:9200)
#   ES_INDEX_PATTERN  Regex with one group used to group the indices (default: (.*-metrics).*)
#   EXPORTER_PORT     Port of the exporter (default: 9099)
#
# The legacy variable names 'es.endpoint' and 'es.index.pattern' are still accepted.

import os
import re
import time

import requests
from prometheus_client import REGISTRY, start_http_server
from prometheus_client.core import GaugeMetricFamily

# Define values
port = int(os.getenv('EXPORTER_PORT', '9099'))
endpoint = os.getenv('ES_ENDPOINT', os.getenv('es.endpoint', 'http://localhost:9200'))
indicesPattern = os.getenv('ES_INDEX_PATTERN', os.getenv('es.index.pattern', '(.*-metrics).*'))

if not re.match(r'^https?://', endpoint):
    endpoint = 'http://' + endpoint


def fetchIndices(endpoint):
    '''Return the list of indices of Elasticsearch with name, size in bytes and document count.'''
    response = requests.get(
        endpoint.rstrip('/') + '/_cat/indices',
        params={'format': 'json', 'bytes': 'b', 'h': 'index,store.size,docs.count'},
        timeout=30,
    )
    response.raise_for_status()
    return response.json()


def toInt(value):
    '''Convert a value of the _cat API to integer. Closed indices return null values.'''
    try:
        return int(value)
    except (TypeError, ValueError):
        return 0


def summarizeIndices(indices, indicesPattern):
    '''Return a dict with the first group of the regex as key and the sum of size and document count as value.

    For example, for a group of indices called customer-metrics-*, a regex like '(.*-metrics).*'
    will return 'customer-metrics'.
    '''
    groups = {}
    for indice in indices:
        indice_search = re.search(indicesPattern, indice['index'], re.IGNORECASE)
        if indice_search is None:
            continue
        group = groups.setdefault(indice_search.group(1), {'size': 0, 'docs': 0})
        group['size'] += toInt(indice.get('store.size'))
        group['docs'] += toInt(indice.get('docs.count'))
    return groups


class IndicesGroupCollector(object):
    '''Collector of the size and document count of groups of indices.'''

    def __init__(self, endpoint, indicesPattern):
        self._endpoint = endpoint
        self._indicesPattern = indicesPattern

    def collect(self):
        groups = summarizeIndices(fetchIndices(self._endpoint), self._indicesPattern)

        size = GaugeMetricFamily('es_group_indices_size', 'Size of a group of indices in bytes', labels=['group'])
        docs = GaugeMetricFamily('es_group_indices_docs_count', 'Document count of a group of indices', labels=['group'])
        for group, values in groups.items():
            size.add_metric([group], values['size'])
            docs.add_metric([group], values['docs'])

        yield size
        yield docs


if __name__ == '__main__':
    print('Starting collector at port', port)
    print('Endpoint ES:', endpoint)
    print('Regex to search:', indicesPattern)

    REGISTRY.register(IndicesGroupCollector(endpoint, indicesPattern))
    start_http_server(port)

    while True:
        time.sleep(1)
