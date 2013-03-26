#!/bin/sh

#SPLIT DUMP FILE INTO INDIVIDUAL TABLE DUMPS

TARGET_DIR="."
DUMP_FILE=$1
TABLE_COUNT=0

if [ $# = 0 ]; then
        echo "Usage: MyDumpSplitter.sh DUMP-FILE-NAME -- Extract all tables as a separate file from dump."
        echo "       MyDumpSplitter.sh DUMP-FILE-NAME TABLE-NAME -- Extract single table from dump."
        echo "       MyDumpSplitter.sh DUMP-FILE-NAME -S TABLE-NAME-REGEXP -- Extract tables from dump for specified regular expression."
        exit;
elif [ $# = 1 ]; then
        #Loop for each tablename found in provided dumpfile
        for tablename in $(grep "Table structure for table " $1 | awk -F"\`" {'print $2'})
        do
                #Extract table specific dump to tablename.sql
                sed -n "/^-- Table structure for table \`$tablename\`/,/^-- Table structure for table/p" $1 > $TARGET_DIR/$tablename.sql
                TABLE_COUNT=$((TABLE_COUNT+1))
        done;
elif [ $# = 2  ]; then
        for tablename in $(grep -E "Table structure for table \`$2\`" $1| awk -F"\`" {'print $2'})
        do
                echo "Extracting $tablename..."
                #Extract table specific dump to tablename.sql
                sed -n "/^-- Table structure for table \`$tablename\`/,/^-- Table structure for table/p" $1 > $TARGET_DIR/$tablename.sql
                TABLE_COUNT=$((TABLE_COUNT+1))
        done;
elif [ $# = 3  ]; then

        if [ $2 = "-S" ]; then
                for tablename in $(grep -E "Table structure for table \`$3" $1| awk -F"\`" {'print $2'})
                do
                        echo "Extracting $tablename..."
                        #Extract table specific dump to tablename.sql
                        sed -n "/^-- Table structure for table \`$tablename\`/,/^-- Table structure for table/p" $1 > $TARGET_DIR/$tablename.sql
                        TABLE_COUNT=$((TABLE_COUNT+1))
                done;
        else
                echo "Please provide proper parameters.";
        fi
fi

#Summary
echo "$TABLE_COUNT Table extracted from $DUMP_FILE at $TARGET_DIR"
                                                                