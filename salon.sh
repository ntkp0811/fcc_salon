#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

SERVICE_LIST(){
  if [[ ! -z $1 ]]
  then
    echo $1
  fi
  # displaying service options stored in the DB
  echo -e "\nChoose a service from our salon:\n"
  SERVICES=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES" | while read ID BAR NAME
  do
    echo -e "$ID) $NAME"
  done
  # getting user response 
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  1)VERIFY_CUSTOMER ;;
  2) VERIFY_CUSTOMER ;;
  3) VERIFY_CUSTOMER ;;
  *) SERVICE_LIST "Enter a valid service number" ;;
  esac

}

VERIFY_CUSTOMER(){
  echo -e "\nEnter your phone number:"
  read CUSTOMER_PHONE
  PHONE_RESULT=$($PSQL "SELECT customer_id FROM customers WHERE phone ='$CUSTOMER_PHONE'")
  # check if customer phone exists
  if [[ -z $PHONE_RESULT ]]
  then
    echo -e "\nEnter your name:"
    read CUSTOMER_NAME
    INSERT_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi
  # insert a row in appointements
  ## ask for appointment time
  echo -e "\nEnter the service time:"
  read SERVICE_TIME

  if [[ -z $SERVICE_TIME ]]
  then
   
    SERVICE_LIST "Enter a valid service time"
  else
     ## FETCHING THE CUSTOMER ID FOR INSERTION
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
    INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo -e "\nI have put you down for a $SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}


SERVICE_LIST