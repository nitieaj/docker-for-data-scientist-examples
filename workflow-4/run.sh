#!/bin/bash
set -e

echo docker pull neo4j:3.4
docker pull neo4j:3.4

echo "(re)creating data and log directories"
rm -rf ./data ./logs
mkdir ./data
mkdir ./logs

pushd  ./graph-import-files
for f in nodes-*.csv
  do
      echo "Processing $f"
      NODES_ARGS="$NODES_ARGS --nodes /imports/$f"
 done
  for f in edges-*_to_*.csv
  do
      echo "Processing $f"
      EDGES_ARGS="$EDGES_ARGS --relationships /imports/$f"
  done
popd

echo "Running the database import"
echo 'docker run -it --rm \'
echo '  --volume=`pwd`/data:/data \'
echo '  --volume=`pwd`/graph-import-files:/imports \'
echo '  --volume=`pwd`/logs:/logs \'
echo '  --env=NEO4J_AUTH=neo4j/test \'
echo '  neo4j:3.4 bin/neo4j-admin import \'
echo '    $NODES_ARGS \'
echo '    $EDGES_ARGS'
docker run -it --rm \
   --volume=`pwd`/data:/data \
   --volume=`pwd`/graph-import-files:/imports \
   --volume=`pwd`/logs:/logs \
   --env=NEO4J_AUTH=neo4j/test \
   neo4j:3.4 bin/neo4j-admin import $NODES_ARGS $EDGES_ARGS

echo "Starting the database server"
echo 'docker run -d \'
echo '   --volume=`pwd`/data:/data \'
echo '   --volume=`pwd`/logs:/logs \'
echo '   --env=NEO4J_AUTH=neo4j/test \'
echo '   -p 7474:7474 -p 7687:7687 \'
echo '   --name pybay-neo4j neo4j:3.4'
docker run -d \
   --volume=`pwd`/data:/data \
   --volume=`pwd`/logs:/logs \
   --env=NEO4J_AUTH=neo4j/test \
   -p 7474:7474 -p 7687:7687 \
   --name pybay-neo4j neo4j:3.4 

