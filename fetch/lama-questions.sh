#!/bin/bash
for i in {1..400} 
do
   wget "http://www.lama-ole-nydahl.de/fragen/?p="$i
done

grep -l "Du hast eine Seite aufgerufen, auf der keine Inhalte zu finden sind" * | xargs rm

j=1
for i in $( ls -1f index.*); do
  mv $i question$j.html
  let j++
done
