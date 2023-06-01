#!/bin/bash

flux bootstrap github \
--owner=mkoellges \
--repository=flux \
--branch=main \
--path=./clusters/MBP-von-Manfred.fritz.box/kind \
--personal
