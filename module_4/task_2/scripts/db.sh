#!/usr/bin/env bash 

FILE=../data/users.db

checkFileExists() {
	if [[ ! -f "$FILE" ]]; then
		read -p "File ${FILE} does not exists, please enter the file name: " FILE
		touch $FILE
		chmod 755 $FILE
	fi
}

add() {
	checkFileExists

	read -p "Enter username: " USERNAME
	read -p "Enter role: " ROLE
  	
	if [[ ! $USERNAME =~ ^[a-zA-Z]+$ ]] || [[ ! $ROLE =~ ^[a-zA-Z]+$ ]]; then
		echo "Username and Role must contain only latin characters"
		exit 1
	fi
        
	RECORD="${USERNAME},${ROLE}"

	if grep $RECORD $FILE; then
		echo "$RECORD exists"
		exit 1
	fi

	echo "${USERNAME},${ROLE}" >> $FILE
}

backup() {
	checkFileExists

	FILE_DIRECTORY=`dirname $FILE`

	cp $FILE "$FILE_DIRECTORY/$(date +%F_%T)-users.db.backup"
}

restore() {
	checkFileExists

	FILE_DIRECTORY=`dirname $FILE`
	BACKUP_FILE_NAME=`ls -r $FILE_DIRECTORY/2???-* | head -1`

	if [[ ! -f "$$FILE_DIRECTORY/$BACKUP_FILE_NAME " ]]; then
		echo "No backup file found"
		exit 1
	fi
	
	cat $FILE_DIRECTORY/$BACKUP_FILE_NAME > $FILE 
}

find() {
	checkFileExists

	read -p "Enter username: " USERNAME
	RECORD=`grep $USERNAME $FILE`

	if [[ ! $RECORD ]]; then
		echo "User not found"
		exit 1;
	fi

	echo $RECORD
}

list() {
	checkFileExists

	if [[ $1 == "-i" ]] || [[ $1 == "--inverse" ]]; then
		cat -n $FILE | tac
		exit 0;
	fi
	cat -n $FILE
}

help() {
	echo
	echo "List of all commands:"
	echo
	echo "add"
	echo "Creates a new user in the database."
	echo "You will be prompted to enter username and role. They should contain only latin characters."
	echo
	echo "backup"
	echo "Creates a backup for the database."
	echo
	echo "restore"
	echo "Takes the latest backup and overrides the database file."
	echo
	echo "find"
	echo "Finds a record in the database by username."
	echo
	echo "list"
	echo "Lists all the records in the database."
	echo "options:"
	echo "-i or --inverse: Returns all the records in the inversed order."
}

case $1 in
	add) add ;;
	backup) backup ;;
	restore) restore ;;
	find) find ;;
	list) list $2 ;;
	help) help ;;
	*) help ;;
esac

