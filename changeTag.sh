#!/bin/bash
sed "s/currentBuild.number/$1/g" docker-compose-pipeline.yml > docker-compose.yml
