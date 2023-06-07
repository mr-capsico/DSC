#!/bin/bash

killall picom && sleep 1 && picom -b --no-fading-openclose --fade-in-step=1 --fade-out-step=1 --fade-delta=0
