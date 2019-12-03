import toml
import sys

def main(*args):
    config=toml.load('config.toml')
    for arg in args[0]:
        config=config[arg]
    return config

if __name__ == '__main__':
    print(main(sys.argv[1:]))

