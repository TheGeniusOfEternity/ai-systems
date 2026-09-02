# Minecraft OWL Ontology

`minecraft.owl` is an OWL 2 ontology in RDF/XML format. Open it in Protégé and
start HermiT or ELK to check consistency and infer the types inherited through
the class hierarchy.

## Model

`GameEntity` is the root class. `Mob`, `Item`, `Biome`, `Dimension`, `Block`,
and `Structure` are domain classes. Mob and item types provide a third level,
for example `PassiveMob` is a subclass of `Mob` and `Armor` is a subclass of
`Item`.

The ontology declares the main domain/range pairs from the Prolog knowledge
base. It also declares these restrictions:

* `Structure` has at least one `generatesIn` value of type `Biome`.
* `StackableItem` has exactly one non-negative integer `stackSize` value.
* The main domain classes are pairwise disjoint.

## Prolog To OWL Mapping

| Prolog | OWL | Notes |
| --- | --- | --- |
| `passive(sheep)` | `sheep rdf:type PassiveMob` | Unary predicates become class membership. |
| `is_armor(golden_helmet)` | `goldenHelmet rdf:type Armor` | Item property becomes a subclass. |
| `drops(sheep, raw_mutton)` | `sheep drops rawMutton` | Binary predicate becomes an object property assertion. |
| `spawns(sheep, plains)` | `sheep spawnsIn plains` | The property name states the direction explicitly. |
| `locates(plains, overworld)` | `plains locatedIn overworld` | The property direction is preserved. |
| `generates(end_city, end_highlands)` | `endCity generatesIn endHighlands` | Structure-to-biome relation. |
| `contains(end_city, shulker_shell)` | `endCity contains shulkerShell` | Structure-to-item relation. |
| `stack_size(Item, Count)` | `stackSize` datatype property | Range is `xsd:nonNegativeInteger`. |

## Validation

Run the structural validation from the repository root:

```sh
bash lab1/ontology/test/validate_ontology.sh
```
