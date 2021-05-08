#!/bin/bash

# This script displays various information to the screen.

# Diplay 'Hello'
echo 'Hello'

# assign a variable
WORD='script'

# display Variable 
echo "$WORD"

# display that single quotes doesn't cause variable to expand
echo '$WORD'

# templated messages
echo "This is a shell $WORD"

# alternate syntax
echo "This is alternate shell ${WORD}"

# append text to variable
echo "${WORD}ing is fun"

# how not to append
echo "$WORDing is fun"

# create a new variable
ENDING='ed'
echo "This is ${WORD}${ENDING}"

# changin the value
ENDING='ing'
echo "This is ${WORD}${ENDING}"