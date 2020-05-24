#!/usr/bin/env bash

eval_type=$1

echo $eval_type

if [[ $eval_type == "UNIT" ]]; then
	echo "abcd"
	mvn surefire-report:report 
fi

if [[ $eval_type == "MUTATION" ]]; then
	echo "abcdef"
	mvn org.pitest:pitest-maven:mutationCoverage
fi

java -Xmx256m -jar target/spring-boot-in-docker.jar