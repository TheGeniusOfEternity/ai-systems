# Lab 1 Defense Guide

This guide provides a repeatable demonstration of both Lab 1 parts.

## Preparation

```sh
swipl -q -s lab1/prolog/test/run_tests.pl
bash lab1/ontology/test/validate_ontology.sh
```

Both commands must exit with code zero. The first runs seven logical-inference
tests; the second checks the required OWL structure and XML validity.

## Prolog Demonstration

Run the prepared examples from the repository root:

```sh
swipl -q -s lab1/defense/run_prolog_examples.pl
```

The interpreter prints these actual answers:

```text
?- passive(sheep).
true.

?- spawns(Mob, plains).
[sheep,pig,chicken]

?- drops(sheep, Item), dropped(Item).
[raw_mutton,white_wool]

?- hostile_mob(Mob).
[zombie,skeleton,zombie_piglin]

?- non_hostile_mob(Mob).
[sheep,pig,chicken,villager]

?- mob_dimension(Mob, Dimension).
[sheep-overworld,pig-overworld,chicken-overworld]

?- item_dimension_from_structure(shulker_shell, Dimension).
[end]

?- available_item_in_dimension(Item, overworld).
[raw_mutton,white_wool,raw_chicken,carrot,golden_helmet]
```

The examples cover a fact query, variables, conjunction, disjunction,
negation, and rule composition.

## Protégé Demonstration

1. Open `lab1/ontology/minecraft.owl` in Protégé.
2. Select `Reasoner > HermiT > Start reasoner`.
3. Run `Reasoner > Classify ontology`.
4. Confirm that the ontology is consistent and no class is unsatisfiable.
5. Open the `DL Query` tab and enter the competency queries below.

The ontology was also checked with HermiT 1.4.3.517 from its CLI. The check
reported `owl:Thing is satisfiable`; the only class equivalent to
`owl:Nothing` was `owl:Nothing` itself. This confirms consistency and the
absence of unsatisfiable named classes.

| DL Query | Expected instances | Knowledge checked |
| --- | --- | --- |
| `PassiveMob` | `sheep`, `pig`, `chicken`, `villager` | Mob subclass hierarchy. |
| `AggressiveMob` | `zombie`, `skeleton` | Aggressive mob assertions. |
| `Mob and (spawnsIn value plains)` | `sheep`, `pig`, `chicken` | Mob-to-biome object property. |
| `Structure and (generatesIn value endHighlands)` | `endCity` | Structure-to-biome object property. |
| `Item and (inverse contains some Structure)` | `carrot`, `goldenHelmet`, `shulkerShell` | Inverse structure-content lookup. |
| `Biome and (locatedIn value nether)` | `basaltDeltas`, `soulSandValley` | Biome-to-dimension object property. |

## Traceability

| Prolog | OWL | Explanation |
| --- | --- | --- |
| `passive(sheep)` | `sheep : PassiveMob` | Unary predicate is a class assertion. |
| `is_armor(golden_helmet)` | `goldenHelmet : Armor` | Item kind is a subclass. |
| `drops(sheep, raw_mutton)` | `sheep drops rawMutton` | Binary predicate is an object-property assertion. |
| `spawns(sheep, plains)` | `sheep spawnsIn plains` | Mob spawn relation. |
| `locates(plains, overworld)` | `plains locatedIn overworld` | Biome location relation. |
| `stack_size(Item, Count)` | `stackSize` | Datatype property with non-negative integer range. |

## Files

* `lab1/knowledge_base.pl`: facts and seven inference rules.
* `lab1/prolog/queries/examples.pl`: interactive query examples.
* `lab1/ontology/minecraft.owl`: OWL 2 ontology.
* `lab1/ontology/README.md`: model and complete mapping reference.
