#!/usr/bin/env bash

set -euo pipefail

ontology_file="$(dirname "$0")/../minecraft.owl"

test -f "$ontology_file"
xmllint --noout "$ontology_file"
! rg --fixed-strings --quiet 'owl:minQualifiedCardinality' "$ontology_file"
! rg --fixed-strings --quiet 'AccessMethod' "$ontology_file"
! rg --fixed-strings --quiet 'accessedBy' "$ontology_file"
for unsupported in usesItem builtFrom minedIn usesAs majorBlock uniqueItem uniqueStructure whiteWoolBlock; do
  ! rg --fixed-strings --quiet "$unsupported" "$ontology_file"
done
rg --pcre2 --multiline --quiet '<owl:onProperty rdf:resource="#generatesIn"/>\s*<owl:onClass rdf:resource="#Biome"/>\s*<owl:qualifiedCardinality[^>]*>1</owl:qualifiedCardinality>' "$ontology_file"

for expected in \
  'owl:Class rdf:about="https://github.com/TheGeniusOfEternity/ai-systems/lab1/ontology/minecraft#Mob"' \
  'owl:ObjectProperty rdf:about="https://github.com/TheGeniusOfEternity/ai-systems/lab1/ontology/minecraft#drops"' \
  'owl:DatatypeProperty rdf:about="https://github.com/TheGeniusOfEternity/ai-systems/lab1/ontology/minecraft#stackSize"' \
  'owl:Class rdf:about="#BlockItem"' \
  'owl:NamedIndividual rdf:about="https://github.com/TheGeniusOfEternity/ai-systems/lab1/ontology/minecraft#sheep"' \
  'owl:NamedIndividual rdf:about="#rawPorkchop"' \
  'owl:NamedIndividual rdf:about="#goldenHelmet"><rdf:type rdf:resource="#CraftedItem"/><rdf:type rdf:resource="#DroppedItem"/>' \
  'rdf:Description rdf:about="#PassiveMob"' \
  'owl:onProperty rdf:resource="#locatedIn"' \
  'owl:AllDisjointClasses' \
  'owl:qualifiedCardinality'; do
  rg --fixed-strings --quiet "$expected" "$ontology_file"
done
