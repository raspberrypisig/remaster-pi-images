#!/usr/bin/env python3

import chevron
import sys
import readConfig

input_filename=sys.argv[1]
output_filename=sys.argv[2]

content=''

with open(input_filename, 'r') as f:
    config = readConfig.getRaspbianConfig()
    content = chevron.render(f.read(), config)

with open(output_filename, 'w') as f:
    f.write(content)
