#!/bin/bash

ffmpeg -framerate 24 -i input_%03d.png -vf showinfo -an -f null - > ffmpeg_output.txt 2>&1
grep "checksum:" ffmpeg_output.txt | awk '{match($0, /checksum:([A-F0-9]+)/, a); print a[1]}' > checksums.txt



last_checksum=0
while IFS=' ' read -r frame checksum
do
  if [[ $last_checksum != 0 ]]; then  # Skip the first frame for comparison
    # Calculate absolute difference between checksums
    if [ ${checksum#-} -ne ${last_checksum#-} ]; then  # Assuming any change is significant
      echo "Faulty frame: input_$(printf "%03d" $frame).png"
    fi
  fi
  last_checksum=$checksum
done < checksums.txt
