#!/bin/sh
# make range for chkwidth.py
grep -e ';W' -e ';F' EastAsianWidth.txt |sed -e 's/#.*//;s/;. .*$//;s/\.\./ /'|awk '{printf("  (0x%s, 0x%s),\n",$1,$2==""?$1:$2)}'>eawwf-range.txt
#grep -e ';A' EastAsianWidth.txt |sed -e 's/#.*//;s/;. .*$//;s/\.\./ /'|awk '{printf("  0x%s, 0x%s, \\\n",$1,$2==""?$1:$2)}'>eawa-range.txt
#grep -e ';W' EastAsianWidth.txt |sed -e 's/#.*//;s/;. .*$//;s/\.\./ /'|awk '{printf("  0x%s, 0x%s, \\\n",$1,$2==""?$1:$2)}'>eaww-range.txt
#grep -e ';F' EastAsianWidth.txt |sed -e 's/#.*//;s/;. .*$//;s/\.\./ /'|awk '{printf("  0x%s, 0x%s, \\\n",$1,$2==""?$1:$2)}'>eawf-range.txt


