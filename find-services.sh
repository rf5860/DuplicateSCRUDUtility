#!/bin/sh

function findContext() {
    git grep -C10 "ownedActual.*name=\"${*}\"\ value=\"${*}\""  Model/UMLModel;
}

function extractServiceLine() {
   grep "\<actual .*uml:Class" <<< "${*}";
}

function extractServiceId() {
    sed 's/^[^#]*#\([^?]*\).*$/\1/g' <<< "${*}"
}

function referenceCount() {
    git grep "actual .*Class.*${*}" | wc -l | tr -d ' '
}

while read actual; do
    context=$(findContext "${actual}");
    serviceLine=$(extractServiceLine "${context}");
    id=$(extractServiceId "${serviceLine}");
    numberOfRerences=$(referenceCount "${id}");
    if [[ ${numberOfRerences} -ne 1 ]]; then
	    echo "${actual} (ID={${id}}) used in ${numberOfRerences} SCRUD Patterns.";
    fi
done < scrud-refs.in
