import toml
import sys

def main(arg):
	config=toml.load('config.toml')
	return config[arg]
	
if __name__ == '__main__':
	main(sys.argv[1])

