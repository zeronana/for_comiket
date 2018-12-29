#!/bin/sh

nc -l -u -p 6002 | tee -a /home/light_th.log
