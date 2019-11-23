import toml
import sys

def main(*args):
    config=toml.load('config.toml')
    for arg in args[0]:
        config=config[arg]
    print(config)
	    
	
if __name__ == '__main__':
    main(sys.argv[1:])
