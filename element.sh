#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# check if argument entered, if not ask user to provide one
if [[ -z "$1" ]]
then 
  echo "Please provide an element as an argument."
  exit
fi

# if the argument is a number
if [[ $1 =~ ^[0-9]+$ ]]
then
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = '$1'")
# if argument is a string
else
  ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
fi

# if argument is not an element
if [[ -z $ELEMENT ]]
then
  echo -e "I could not find that element in the database."
  exit
fi

echo -e $ELEMENT | while read AN BAR SYM BAR NAME BAR AM BAR MP BAR BP BAR TP
do
  echo "The element with atomic number $AN is $NAME ($SYM). It's a $TP, with a mass of $AM amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
done
