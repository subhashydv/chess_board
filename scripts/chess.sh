#! /bin/bash

function generate_tag {
    local tag=$1
    local class=$2
    local content=$3

    echo "<${tag} class=\"${class}\">${content}</${tag}>"
}

function generate_single_row () {
    local color1="$1"
    local color2="$2"
    local grids

    local count=0
    while [[ $count < 4 ]]
    do
        grids+=$(generate_tag "div" "block $color1" "")
        grids+=$(generate_tag "div" "block $color2" "")
        count=$(( $count + 1 ))
    done
    echo "$grids"
}

function generate_board () {
    local color1="$1"
    local color2="$2"
    local grids

    local count=0
    while [[ $count < 4 ]]
    do
        grids+=$( generate_single_row "$color1" "$color2" )
        grids+=$( generate_single_row "$color2" "$color1" )
        count=$(( $count + 1 ))
    done
    generate_tag "div" "board" "$grids"
}

function generate_html () {
    local color1="$1"
    local color2="$2"
    local template="$3"

    local chessboard=$(generate_board "$color1" "$color2")
    
    sed "s;_CHESSBOARD_;$chessboard;" <<< "$template" 
}

function generate_css () {
    local width="$1"
    local color1="$2"
    local color2="$3"
    local template="$4"

    local sqr_size=$( echo "$width / 8" | bc -l )
    sed "s,_WIDTH_,$width, ; s,_SQR_SIZE_,$sqr_size, ; s,_COLOR1_,$color1, ; s,_COLOR2_,$color2," <<< "${template}"
}

function main () {
    local size="$1"
    local color1="$2"
    local color2="$3"
    local html_template="$4"
    local css_template="$5"
    local target_dir="$6"

    html_template=$( cat $html_template )
    css_template=$( cat $css_template )

    generate_html "$color1" "$color2" "$html_template" > $target_dir/index.html
    generate_css "$size" "$color1" "$color2" "$css_template" > $target_dir/styles.css
}