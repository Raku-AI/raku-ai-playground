#!/usr/bin/env bash

g++ -c lodepng.cpp -Wall -Wextra -pedantic -ansi -O3 -std=c++11

g++ -dynamiclib -o liblodepng.dylib lodepng.o

rm lodepng.o
