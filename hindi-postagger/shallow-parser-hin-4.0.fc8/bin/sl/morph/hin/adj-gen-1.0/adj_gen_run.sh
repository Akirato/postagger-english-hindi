if [ $# -le 0 ]
then
        echo "Error - Arguments missing!!"
        echo -e "Syntax :\nsh $0 < input-file-name";
        echo -e "e.g.:\nsh $0 --input=input-file-name";
exit
fi
perl -C adj_gen.pl -i $1 
