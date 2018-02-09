import json

from requests import RequestException
from urllib3.exceptions import NewConnectionError

from healthchecktest import settings
import requests
import unittest


PROTOCOL = 'https' if settings.TARGET_USE_HTTPS else 'http'
PORT = settings.TARGET_PORT
HOST = settings.TARGET_HOST
PATH = settings.TARGET_PATH


class HealthCheckTestCase(unittest.TestCase):

    def setUp(self):
        self.url = '{scheme}://{host}:{port}{path}'.format(
            scheme=PROTOCOL,
            host=HOST,
            port=PORT,
            path=PATH)

    def test__healthcheck_returns_http_response(self):

        try:
            response = requests.get(self.url, timeout=1)
        except (RequestException, NewConnectionError) as e:
            self.fail("Could not fetch response from url %s: %s" % (self.url, e))
        self.assertEqual(200, response.status_code, response.status_code)
        try:
            json.dumps(response.content.decode())
        except ValueError:
            self.fail('Should have received a JSON response.')
