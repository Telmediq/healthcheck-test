import os

TARGET_HOST = os.environ['TARGET_HOST']
TARGET_PORT = int(os.getenv('TARGET_PORT', '9097'))
TARGET_PATH = os.getenv('TARGET_PATH', '/health/')
TARGET_USE_HTTPS = os.getenv('TARGET_USE_HTTPS', 'False').lower() == 'true'
