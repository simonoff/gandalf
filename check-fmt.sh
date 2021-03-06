#!/bin/bash -e

# Copyright 2014 tsuru authors. All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# This script was copied from tsuru, that's why the Copyright note above refers
# to "tsuru authors" instead of "gandalf authors".

status=0
out=`gofmt -s -l .`
if [ "${out}" != "" ]
then
    echo "ERROR: there are files that need to be formatted with gofmt"
    echo
    echo "Files:"
    for file in $out
    do
        echo "- ${file}"
    done
    echo
    status=1
fi

go get golang.org/x/tools/cmd/goimports
out=`goimports -l .`
if [ "${out}" != "" ]
then
    echo "ERROR: there are files that need to be formatted with goimports"
    echo
    echo "Files:"
    for file in $out
    do
        echo "- ${file}"
    done
    status=1
fi


go get golang.org/x/tools/cmd/vet
`go vet ./... > .vet 2>&1`
out=`cat .vet`
if [ "${out}" != "" ]
then
    echo "ERROR: go vet failures:"
    echo
    cat <<END
${out}
END
    status=1
fi

rm .vet || true
exit $status
