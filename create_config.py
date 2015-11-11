import base64
import json
import os


CURRENT_DIR_PATH= os.path.abspath(os.path.dirname(__file__))


def get_encryption_key():
    '''Automate the inconvenient task of generating and maintaining a consistent 
       encryption key.'''
    # Attempt to get the key from an environment variable.
    encryption_key= os.environ.get('ENKETO_ENCRYPTION_KEY')

    # If the key wasn't in the environment, attempt to get it from disk.
    encryption_key_file_path= os.path.join(CURRENT_DIR_PATH, 'secrets/enketo_encryption_key.txt')
    if not encryption_key and os.path.isfile(os.path.join(encryption_key_file_path)):
        with open(encryption_key_file_path, 'r') as encryption_key_file:
            encryption_key= encryption_key_file.read().strip()
    # If the key couldn't be retrieved, generate and store a new one.
    elif not encryption_key:
        encryption_key= base64.b64encode(os.urandom(256))
        with open(encryption_key_file_path, 'w') as encryption_key_file:
            encryption_key_file.write(encryption_key)

    return encryption_key


def create_config():
    config= dict()

    offline_enabled= os.environ.get('ENKETO_OFFLINE_SURVEYS', 'True').lower() == 'true'
    if offline_enabled:
        config['offline enabled']= 'True'

    config.setdefault('linked form and data server',{})['server url']= \
        os.environ.get('FORM_DATA_SERVER_URL', 'kobocat')
    api_key= os.environ.get('ENKETO_API_KEY')
    if api_key is not None:
        config['linked form and data server']['api key']= api_key
    config['linked form and data server']['encryption key']= get_encryption_key()

    config.setdefault('redis',{})['main']= {'host': os.environ.get('ENKETO_REDIS_MAIN_HOST', 'redis_main'), 
                                            'port': os.environ.get('ENKETO_REDIS_MAIN_PORT', '6379'),
                                            'password': os.environ.get('ENKETO_REDIS_MAIN_PASSWORD', None),
                                           }
    config['redis']['cache']= {'host': os.environ.get('ENKETO_REDIS_CACHE_HOST', 'redis_cache'),
                               'port': os.environ.get('ENKETO_REDIS_CACHE_PORT', '6379'),
                               'password': os.environ.get('ENKETO_REDIS_CACHE_PASSWORD', None),
                              }

    CONFIG_FILE_PATH= os.environ.get('ENKETO_CONFIG_FILE_PATH', os.path.join(CURRENT_DIR_PATH, 'config/config.json'))
    with open(CONFIG_FILE_PATH, 'w') as config_file:
        config_file.write(json.dumps(config, indent=4))

if __name__ == '__main__':
    create_config()
