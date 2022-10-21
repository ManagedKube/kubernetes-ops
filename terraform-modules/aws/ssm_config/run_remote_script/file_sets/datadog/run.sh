#!/bin/bash

# output run information
echo "######################################" >> run_output.txt
echo "######################################" >> run_output.txt
echo "Start of the run: $(date)" >> run_output.txt
echo "pwd: $(pwd)" >> run_output.txt

echo "Copying file to: /etc/datadog-agent/conf.d/openmetrics.d/conf.yaml" >> run_output.txt
cp ./files/openmetrics.d/conf.yaml.tpl /etc/datadog-agent/conf.d/openmetrics.d/conf.yaml

# output run information
echo "Finished: $(date)" >> run_output.txt
echo "######################################" >> run_output.txt
echo "######################################" >> run_output.txt
