#!/bin/bash

# configuring how the script will run - with extra debug info and exiting on errors right away
set -e

# defining constants
WIKI_URL_LIST='https://en.wikipedia.org/wiki/List_of_municipalities_of_Norway'
# SCRIPT_DIR="$( pwd )"
SCRIPT_DIR="$( dirname "$0" )"
TMP_DIR="${SCRIPT_DIR}/tmp"
UTIL_DIR="${SCRIPT_DIR}/utilities"

# importing our utilities
source "${UTIL_DIR}/get.page.sh"
source "${UTIL_DIR}/extract.elements.sh"

# extracting places and URLs to per-place Wiki pages -- as <a> elements
# # cat "${TMP_DIR}/1.html"|\
# get_page "$WIKI_URL_LIST" |\
    # extract_elements 'table' 'class="sortable wikitable"' |\
    # extract_elements 'tr' |\
    # sed '1d' |\
    # get_inner_html |\
    # tags2columns 'td' '\t' |\
    # cut -d $'\t' -f 2 > "$TMP_DIR/places.as.a.txt"

# extracting URLs and places as data
# awk '
#     match($0, /href="[^"]*"/){
#             url=substr($0, RSTART+6, RLENGTH-7)
#         }
#     match($0, />[^<]*<\/a>/){
#             printf("%s%s\t%s\n", "https://en.wikipedia.org", url, substr($0, RSTART+1, RLENGTH-5))
#         } ' "$TMP_DIR/places.as.a.txt"  > "$TMP_DIR/places.as.data.txt"
# echo "Extracted places as data"

# getting place coordinates per place
while read -r url place; do
    page=$(get_page "$url")
    lat=$(extract_elements 'span' 'class="latitude"' <<< "$page" |\
        head -n 1 |\
        get_inner_html)
    lon=$(extract_elements 'span' 'class="longitude"' <<< "$page" |\
        head -n 1 |\
        get_inner_html)
	printf "%s\t%s\t%s\t%s\n" $url $place $lat $lon >> "$TMP_DIR/places.with.coords.txt"
done < "$TMP_DIR/places.as.data.txt"

# restoring the initial script-running configuration
set +e


# sed -E 's/.*<table class="sortable wikitable">(.*)<\/table>.*/\1/g' wiki.list.no.newlines.html | sed 's/<\/table>/\n/g' | sed -n '1p' | grep -o '<tbody[ >].*<\/tbody>' | sed -E 's/<tbody[^>]*>(.*)<\/tbody>/\1/g' | sed -E 's/<tr[^>]*>//g' | sed 's/<\/tr>/\n/g' | sed -E 's/<td[^>]*>//g' | sed 's/<\/td>/\t/g' | sed '1d' > table.txt