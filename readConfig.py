import toml
import sys

def main(*args):
    config=toml.load('config.toml')
    for arg in args[0]:
        config=config[arg]
    return config

def getRaspbianConfig():
    config=toml.load('config.toml')
    return config['Config']

if __name__ == '__main__':
    print(main(sys.argv[1:]))
