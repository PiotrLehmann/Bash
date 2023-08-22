#!/usr/bin/env bash


# FUNCTIONS
repeat(){
	for i in {1..60}; do 
    echo -n "$1";
  done
  echo ""
}

echo $(clear)

# FREESPACE VARIABLES
freespace=$(df -h | awk 'NR==2 {print $4}')
freespace_procentage=$(df -h | awk 'NR==2 {print $5}')
declare -i freespace_procentage_number=$(("${freespace_procentage//%}"/10))

# FREEMEM VARIABLES
freemem=$(free -h | awk 'NR==2 {print $3}' | tr 'Mi' 'MB' | tr 'Gi' 'GB')
freemem_number=$(free -h | awk 'NR==2 {print $3}' | tr -d '[:alpha:]')
freemem_total=$(free -h | awk 'NR==2 {print $2}' | tr 'Mi' 'MB' | tr 'Gi' 'GB')
freemem_total_number=$(free -h | awk 'NR==2 {print $2}' | tr -d '[:alpha:]')

# FONTS AND COLORS
bold="\033[1m"
magenta="\033[30;102m"
normal="\033[0;0m"
data_color="\033[32;49m"

# PRINT ALL DATA
echo -e "$bold$magenta""    SYSTEM REPORT    $data_color" $(date) "$normal"
repeat '-'
echo -e "$data_color""User: $normal$HOSTNAME"
repeat '-'
echo -n -e "$data_color""Available disk space: $normal"$freespace"B ("$freespace_procentage") " 

for i in $(seq $freespace_procentage_number)
do
  printf "\U1F7E9"
done

for i in $(seq $((10-$freespace_procentage_number)))
do
  printf "\U1F7E5"
done

printf "\n"
repeat '-'
echo -n -e "$data_color""RAM Usage: $normal"$freemem" / "$freemem_total

if [[ "$freemem" == *"MB" ]] && [[ "$freemem_total" == *"MB" ]]; then
  float=$(bc <<<"scale=3; ($freemem_number / $freemem_total_number) * 10")
  int=${float%.*}
  
elif [[ "$freemem" == *"MB" ]] && [[ "$freemem_total" == *"GB" ]]; then
  float=$(bc <<<"scale=3; (($freemem_number / 1024) $freemem_total_number) * 10")
  int=${float%.*}

elif [[ "$freemem" == *"GB" ]] && [[ "$freemem_total" == *"MB" ]]; then
  float=$(bc <<<"scale=3; ($freemem_number / ($freemem_total_number / 1024)) * 10")
  int=${float%.*}

elif [[ "$freemem" == *"GB" ]] && [[ "$freemem_total" == *"GB" ]]; then
  float=$(bc <<<"scale=3; ($freemem_number / $freemem_total_number) * 10")
  int=${float%.*}
fi

freemem_procentage_number=$(bc <<<"scale=2; $float * 10")
printf " (%.2s" $freemem_procentage_number
echo -n "%) "

for i in $(seq $int)
do
  printf "\U1F7E9"
done

for i in $(seq $((10-$int)))
do
  printf "\U1F7E5"
done

echo ""
repeat '-'

printf "$data_color""Kernel Release: $normal%s\n" "$(uname -r)"
repeat '-'

printf "$data_color""Bash Version: $normal%s\n" "$BASH_VERSION"
repeat '-'
