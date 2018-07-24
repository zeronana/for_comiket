#!/bin/sh

nc -l -u -p 6000 | tee -a /home/6000.log
