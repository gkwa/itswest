set shell := ["bash", "-uec"]

default:
    @just --list

fmt:
    cue fmt .
    cue fmt --files *
    just --unstable --fmt
    prettier --config=.prettierrc.json --write *.json

vet:
    cue vet schemas.cue

hamster:
    cue export --force schemas.cue -e hamster -o hamster.json --out json

cat:
    cue export --force schemas.cue -e cat -o cat.json --out json

dog:
    cue export --force schemas.cue -e dog -o dog.json --out json

owl:
    cue export --force schemas.cue -e owl -o owl.json --out json

monkey:
    cue export --force schemas.cue -e monkey -o monkey.json --out json

export: hamster cat dog owl monkey

clean:
    rm -f *.json

all: vet export fmt
