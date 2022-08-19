#!/bin/bash
input=${1:-access.log}
if [[ -f ${input} ]]; then
	while IFS= read -r line
	do
		curl -u elastic:admin1234 -H "Content-Type: application/json" http://localhost:9200/test/_doc -d "{\"ip\": \"${line}\"}"
	done <<< "$(cat $input | awk '{print $1}')"
fi

