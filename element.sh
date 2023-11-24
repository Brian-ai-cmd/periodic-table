#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

if [[ -z $1 ]] 
then
  echo -e "\nPlease provide an element as an argument"
  exit
fi

if [[ $1 =~ ^[1-9]+$ ]]
then 
  # Fetch data for atomic number
  ELEMENT_RESPONSE=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements join properties using(atomic_number) join types using(type_id) WHERE atomic_number = '$1'")
           
else
  ELEMENT_RESPONSE=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements join properties using(atomic_number) join types using(type_id) WHERE atomic_number = '$1' OR name = '$1'")
           
fi

if [[ -z $ELEMENT_RESPONSE ]]
then
  echo -e "\nI could not find that element in the database."
  exit
fi

echo $ELEMENT_RESPONSE | while IFS=" |" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELTING_POINT BOILING_POINT 
do
  echo -e "\nThe element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done