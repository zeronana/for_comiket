#!/usr/bin/env python

import socket
import signal
import time

import touchphat

host = '192.168.1.60'
port = 6000
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

for pad in ['Back','A','B','C','D','Enter']:
    touchphat.set_led(pad, True)
    time.sleep(0.1)
    touchphat.set_led(pad, False)
    time.sleep(0.1)

@touchphat.on_touch(['Back','A','B','C','D','Enter'])
def handle_touch(event):
    print(event.name)
    sock.sendto(event.name + '\n', (host, port))

signal.pause()
