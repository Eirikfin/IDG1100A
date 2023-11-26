#!/bin/bash

# requests a page, follwing redirects, and preps it for sed processing
function get_page(){
    local url fname html one_line_html
    url=$1
    fname=$2

    html="$(curl -s -L "$url")"

    # removing all newline and tab characters - so we can process the entire page as a single string -- because sed, awk, cut, and grep work line by line
    one_line_html="$( echo "$html" | tr -d '\n\t' )" 

    if [ -z "$fname" ]; then
        # returning the result as standard output
        echo "$one_line_html"
    else
        # a filename was supplied - saving the output in a file
        printf "%s" "$one_line_html" > "$fname"
    fi
    echo "We've received the page: ${url}" >&2
}