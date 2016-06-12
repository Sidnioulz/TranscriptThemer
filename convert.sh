#!/bin/sh

if [ $# -ne 2 ]; then
  echo -e "$0: invalid parameters:\n\t\$1 must be the participant anonymous ID,\n\t\$2 the raw transcript name\n"
  exit -1
fi

echo "Converting raw transcript for participant $1, file named $2"

input="text/$2.transcript"
output="html/$1.html"

echo "Copying file to $output"
mkdir "html/" -p || exit
cp "$input" "$output" || exit

echo "Processing file..."
sed -i 's@"\([^"]*\)"@<q>\1</q>@g' $output
sed -i 's@XXX -\(.*\)@ <p themes="" class="Interviewer interrupt" id="stmt##">-\1<span class="stmtid">###</span></p>@' $output
sed -i 's@XXX \(.*\)@ <p themes="" class="Interviewer" id="stmt##">\1<span class="stmtid">###</span></p>@' $output
sed -i 's@YYY -\(.*\)@ <p themes="" class="Participant interrupt" id="stmt##">-\1<span class="stmtid">###</span></p>@' $output
sed -i 's@YYY \(.*\)@ <p themes="" class="Participant" id="stmt##">\1<span class="stmtid">###</span></p>@' $output
sed -i 's@CONTEXT \(.*\)@ <p themes="" class="Context">\1</p>@' $output

sed -i 's@\[@~~~@g' $output
sed -i 's@\]@~~~@g' $output

sed -i 's@INAUDIBLE ~~~\([^~]*\)~~~@<span class="semi-deaf"><i class="fa fa-deaf"></i> \1</span>@g' $output
sed -i 's@~~~\([^~]*\)~~~@<span class="context">[\1]</span>@g' $output

sed -i 's@LAUGH@<span class="context">laughs</span>@g' $output
sed -i 's@NERVOUS CHUCKLE@<span class="context">nervous chuckle</span>@g' $output
sed -i 's@CHUCKLE@<span class="context">chuckles</span>@g' $output
sed -i 's@COUGH@<span class="context">coughs</span>@g' $output
sed -i 's@SIGH@<span class="context">sighs</span>@g' $output
sed -i 's@INAUDIBLE@<i class="fa fa-deaf deaf"></i>@g' $output
sed -i "s@PARTICIPANT@$1@g" $output
sed -i '/^\s*$/d' $output
awk -i inplace '{gsub("###","#"NR,$0);print}' $output
awk -i inplace '{gsub("##",NR,$0);print}' $output

cp $output $output.tmp
echo "<html>" > $output
echo "<head>" >> $output
echo "  <link rel=\"stylesheet\" href=\"css/style.css\"/></head>" >> $output
echo "  <link rel=\"stylesheet\" href=\"css/font-awesome.css\">" >> $output
echo "  <link rel=\"stylesheet\" href=\"https://maxcdn.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css\">" >> $output
echo "  <meta charset=\"UTF-8\">" >> $output

echo "</head>" >> $output
echo "<body><h1 id=\"meta\">Interview with $1 ($2)</h1><div id=\"interview\" participant=\"$1\" realname=\"$2\">" >> $output
echo "<div id=\"labels\"><h3 class=\"label-int\">Interviewer</h3><h3 class=\"label-part\">$1</h3></div>" >> $output
cat $output.tmp >> $output
rm $output.tmp
echo "</div></body>" >> $output
echo "</html>" >> $output

echo "Done!"

