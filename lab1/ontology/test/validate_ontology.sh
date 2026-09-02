#!/usr/bin/env bash

set -euo pipefail

ontology_file="$(dirname "$0")/../minecraft.owl"

test -f "$ontology_file"
xmllint --noout "$ontology_file"

for expected in \
  'owl:Class rdf:about="https://github.com/TheGeniusOfEternity/ai-systems/lab1/ontology/minecraft#Mob"' \
  'owl:ObjectProperty rdf:about="https://github.com/TheGeniusOfEternity/ai-systems/lab1/ontology/minecraft#drops"' \
  'owl:DatatypeProperty rdf:about="https://github.com/TheGeniusOfEternity/ai-systems/lab1/ontology/minecraft#stackSize"' \
  'owl:NamedIndividual rdf:about="https://github.com/TheGeniusOfEternity/ai-systems/lab1/ontology/minecraft#sheep"' \
  'owl:AllDisjointClasses' \
  'owl:qualifiedCardinality'; do
  rg --fixed-strings --quiet "$expected" "$ontology_file"
done
