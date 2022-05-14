#!/bin/bash
# Run CNA-TFPN analysis of all available methods: canary-kurtz-cytobands, canary-kurtz-arms, canary-mse-cytobands, canary-mse-arms, wisecondor, cnvkit-cns, cnvkit-cnr, ichorcna-cns,ichorcna-cnr
python3 generateTFPN.py canary-kurtz-cytobands yes
python3 generateTFPN.py canary-kurtz-arms yes
python3 generateTFPN.py canary-mse-cytobands yes
python3 generateTFPN.py canary-mse-arms yes
python3 generateTFPN.py wisecondor yes
python3 generateTFPN.py cnvkit-cns yes
python3 generateTFPN.py cnvkit-cnr yes
python3 generateTFPN.py ichorcna-cns yes
python3 generateTFPN.py ichorcna-cnr yes
