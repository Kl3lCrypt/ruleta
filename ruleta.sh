#!/bin/bash
#Colors
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"


function ctrl_c(){
  echo -e "\n\n[!] Saliendo...\n"
  tput cnorm; exit 1
}

#Ctrl+c
trap ctrl_c INT


#Funciones
function helpPanel(){
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}\n"
  echo -e "\t${blueColour}m)${endColour} ${grayColour}Dinero con el que se desa jugar${endColour}\n"
  echo -e "\t${blueColour}t)${endColour}${grayColour} Tecnica a utilizar${endColour} ${purpleColour}(martingala/inverseLabrouchere)${endColour}\n"
  exit 1
}

function martingala(){
  echo -e "${yellowColour}[+]${endColour}${grayColour} Dinero actuál:${endColour}${yellowColour} $money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} Cuanto dinero tienes pensado apostar ==>${endColour} " && read initial_bet
  echo -ne "${yellowColour}[+]${endColour}${grayColour} A que tienes pensado apostar continuamente (par/impar) ==> ${endColour}" && read par_impar
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Vamos a jugar con una cantidad inical de${endColour} ${yellowColour}$initial_bet€${endColour}${grayColour} a${endColour} ${yellowColour}$par_impar${endColour}\n"

  backup_bet=$initial_bet
  play_counter=1
  jugadas_malas=""

  tput civis #Ocultar cursor
  while true; do
    money=$(($money-$initial_bet))
#    echo -e "${yellowColour}[+]${endColour}${grayColour} Acabas de apostar ${endColour}${yellowColour}$initial_bet€${endColour}${grayColour} y tienes${endColour} ${yellowColour}$money€${endColour}$"

    random_number=$((RANDOM % 37))
#    echo -e "${yellowColour}[+]${endColour} Ha salido el número ${yellowColour}$random_number${endColour}"
    if [ ! $money -lt 0 ]; then
#      echo $random_number
      if [ $par_impar == par ]; then
        if [ $(($random_number % 2)) -eq 0 ]; then
          if [ $random_number -eq 0 ]; then
#            echo -e "${yellowColour}[+]${endColour}${redColour} Ha salido cero, ¡perdiste!${endColour}"
            initial_bet=$(($initial_bet*2))
#            echo -e "${yellowColour}[+]${endColour}${grayColour}Ahora mismo te qudas en ${yellowColour}$money€${endColour}\n"
            jugadas_malas+="$random_number "
          else
#            echo -e "${yellowColour}[+]${endColour}${greenColour} El númmero que ha salido es par, ¡ganas!${endColour}"
            reward=$(($initial_bet*2))
            money=$(($reward+$money))
            initial_bet=$backup_bet
            jugadas_malas=""
#            echo -e "${yellowColour}[+]${endColour}${grayColour} Tines:${endColour}${yellowColour} $money€${endColour}\n"
          fi
        else
#          echo -e "${yellowColour}[+]${endColour}${redColour} El numero que ha salido es impar, ¡pierdes!${endColour}"
          initial_bet=$(($initial_bet*2))
          jugadas_malas+="$random_number "
#          echo -e "${yellowColour}[+]${endColour}${grayColour}Ahora mismo te qudas en ${yellowColour}$money€${endColour}\n"
        fi
      else
        if [ $(($random_number % 2)) -eq 0 ]; then
#            echo -e "${yellowColour}[+]${endColour}${redColour} Ha salido cero o par, ¡perdiste!${endColour}"
          initial_bet=$(($initial_bet*2))
#            echo -e "${yellowColour}[+]${endColour}${grayColour}Ahora mismo te qudas en ${yellowColour}$money€${endColour}\n"
          jugadas_malas+="$random_number "
        else
          reward=$(($initial_bet*2))
          money=$(($reward+$money))
          initial_bet=$backup_bet
          jugadas_malas=""
        fi
      fi
    else
      echo -e "\n${redColour}[!] Te has quedado sin pasta cabrón${endColour}\n"
      echo -e "${yellowColour}[+]${endColour}${grayColour} Han habido un total de${endColour}${yellowColour} $(($play_counter-1))${endColour}${grayColour} jugadas${endColour}"

      echo -e "\n${yellowColour}[+]${endColour}${grayColour} A continuación se van a representar las jugadas malas conscutivas que han salido:${endColour}\n"
      echo -e "${blueColour}[ $jugadas_malas]${endColour}"
      tput cnorm; exit 0
    fi
    let play_counter+=1
  done

  tput cnorm #Recuperar cursor
}

function inverseLabrouchere(){
  echo -e "${yellowColour}[+]${endColour}${grayColour} Dinero actuál:${endColour}${yellowColour} $money€${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} A que tienes pensado apostar continuamente (par/impar) ==> ${endColour}" && read par_impar

  declare -a myArray=(1 2 3 4)

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia${endColour}${purpleColour} ${myArray[@]}${endColour}"

  bet=$((${myArray[0]}+${myArray[-1]}))

  jugadas_malas=0
  bet_to_renew=$(($money+50)) #Dienro tras el cual renovamos nuestra secuencia a [1 2 3 4]

  echo -e "[+] El tope a renovar la secuencia esta establecido por encima de $bet_to_renew€"
  tput civis

  while true; do
    let jugadas_malas+=1
    random_number=$(($RANDOM % 37))
    money=$(($money-$bet))
    if [ ! "$money" -lt 0 ]; then
      echo -e "${yellowColour}\n[+]${endColour}${grayColour} Invertimos ${yellowColour}$bet€${endColour}"
      echo -e "${yellowColour}[+]${endColour}${grayColour} Tenemos${endColour}${yellowColour} $money€${endColour}\n"

      echo -e "${yellowColour}[+]${endColour}${grayColour} Ha salido el número${blueColour} $random_number${endColour}"
      if [ "$par_impar" == "par" ]; then
        if [ "$(($random_number % 2))" -eq 0 ] && [ $random_number -ne 0 ]; then
          echo -e "${greenColour}[+] Ha salido un número par, por lo tanto Ganas.${endColour}"

          reward=$(($bet*2))
          let money+=$reward

          echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes un total de${endColour}${yellowColour} $money€${endColour}"
            if [ $money -gt $bet_to_renew ]; then
              echo -e "${yellowColour}[+]${endColour}${grayColour} Se ha superado el tope establecido de $bet_to_renew€ para renovar nuestra secuencia${endColour}"
              let bet_to_renew+=50
              echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope se ha establecido en $bet_to_renew${endColour}"
              myArray=(1 2 3 4)
              bet=$((${myArray[0]}+${myArray[-1]}))
              echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a ${myArray[@]}${endColour}"
            else
              myArray+=($bet)
              myArray=(${myArray[@]})

              echo -e "${yellowColour}[+]${endColour}${grayClour} Continuamos con la secuencia${endColour}${purpleColour} ${myArray[@]}\n${endColour}"
                if [ ${#myArray[@]} -ne 1 ]; then
                  bet=$((${myArray[0]}+${myArray[-1]}))
                elif [ ${#myArray[@]} -eq 1 ]; then
                  bet=${myArray[0]}
                fi
            fi
        elif [ $(($random_number%2)) -eq 1 ] || [ $random_number -eq 0 ]; then
          if [ $(($random_number%2)) -eq 1 ]; then
            echo -e "${redColour}[!] Ha salido impar, por lo tanto Pierdes!${endColour}"
          else
            echo -e "${redColour}[+] Ha salido el número 0, Pierdes!${endoColour}"
          fi
          if [ "$money" -lt $(($bet_to_renew-100)) ]; then
            echo -e "${yellowColour}[+]${endColour}${grayColour} Hemos alcanzado un mínimo critico, se procede a reajustar el tope${endColour}"
            bet_to_renew=$(($bet_to_renew - 50))
            echo -e "${yellowColour}[+]${endColour}${grayColour} El tope ha sido renovado a $bet_to_renew ${endColour} "
            unset myArray[0]
            unset myArray[-1] 2>/dev/null
            myArray=(${myArray[@]})
            echo -e "${yellowColour}[+]${endColour}${grayColour} Continuamos con la secuencia${endColour}${purpleColour} ${myArray[@]}\n${endColour}"
              if [ ${#myArray[@]} -ne 1 ] && [ ${#myArray[@]} -ne 0 ]; then
                bet=$((${myArray[0]}+${myArray[-1]}))
              elif [ ${#myArray[@]} -eq 1 ]; then
                bet=${myArray[0]}
              else
                echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                myArray=(1 2 3 4)
                echo -e "[+] Restablecemos la secuencia a ${myArray[@]}"
                bet=$((${myArray[0]}+${myArray[-1]}))
              fi
          else
            unset myArray[0]
            unset myArray[-1] 2>/dev/null

            myArray=(${myArray[@]})

            echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia se queda con la siguiente estructura ==>${endColour}${purpleColour}[${myArray[@]}]${endColour}"
            if [ "${#myArray[@]}" -ne 1 ] && [ "${#myArray[@]}" -ne 0 ]; then 
              bet=$((${myArray[0]} + ${myArray[-1]}))
            elif [ "${#myArray[@]}" -eq 1 ]; then
              bet=${myArray[0]}
            else
              echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
              myArray=(1 2 3 4)
              echo -e "[+] Restablecemos la secuencia a ${myArray[@]}"
              bet=$((${myArray[0]}+${myArray[-1]}))
            fi
          fi
        fi
      fi
    else
      echo -e "${redColour}\n[!] Te has quedado sin pasta cabron${endColour}"
      echo -e "${yellowColour}\t[+]${endColour}${grayColour} Ha habido un total de $jugadas_malas jugadas ${endColour}"
      tput cnorm; exit 1
    fi
    sleep 0
  done
  tput cnorm

}

#Argumentos
while getopts "m:t:h" args; do
  case $args in
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpPanel;;
  esac
done


#Logica de sistema
if [ $money ] && [ $technique ]; then
  if [ "$technique" == "martingala" ]; then
    martingala
  elif [ "$technique" == 'inverseLabrouchere' ]; then
    inverseLabrouchere
  else
    echo -e "\n[!] La tecnica introducida no existe\n"
    helpPanel
  fi
else
 helpPanel
fi
