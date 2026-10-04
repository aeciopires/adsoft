#!/usr/bin/env python3
# coding:utf-8
'''Example of Prometheus instrumentation.'''

import http.server
import random
import time
from prometheus_client import start_http_server
from prometheus_client import Counter
from prometheus_client import Gauge

SUM = Counter('demo_sum', 'Sum Demo requests duration.')
REQUESTS = Counter('demo_count', 'Count Demo requests.')
EXCEPTIONS = Counter('demo_exceptions_count', 'Exceptions serving Demo.')
LAST = Gauge('demo_last_time_seconds', 'The last time a Demo was served.')

class MyHandler(http.server.BaseHTTPRequestHandler):
    '''Example HTTP handler.'''

    def do_GET(self):
        '''Handle GET requests and update all the example metrics.'''
        rand = random.randrange(10)
        time.sleep(rand)
        SUM.inc(rand)
        REQUESTS.inc()
        with EXCEPTIONS.count_exceptions():
            if random.random() < 0.2:
                raise Exception
        self.send_response(200)
        self.end_headers()
        self.wfile.write(bytes("Hello World (after %ss)" % rand, "utf-8"))
        LAST.set_to_current_time()

if __name__ == "__main__":
    start_http_server(8001)
    SERVER = http.server.HTTPServer(('', 8002), MyHandler)
    SERVER.serve_forever()
