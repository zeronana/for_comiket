#!/bin/sh

nc -l -u -p 6001 | tee -a /home/kyori2.log
