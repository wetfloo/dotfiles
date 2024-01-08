#!/bin/bash

fd -t d -t f -d 1 -x bash -c 'rm -rf ~/.config/{} && ln -s "$(pwd)/"{} ~/.config/{}'
