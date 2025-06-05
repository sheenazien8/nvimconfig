<?php

// make sorting array function using loop
function sortingArray($array)
{
    $length = count($array);
    for ($i = 1; $i < $length; $i++) {
        for ($j = $i + 1; $j < $length; $j++) {
            if ($array[$i] > $array[$j]) {
                $temp = $array[$i];
                $array[$i] = $array[$j];
                $array[$j] = $temp;

            }
        }
    }
    return $array;
}

$array = [5, 3, 8, 6, 7, 2];
print_r(sortingArray($array));
