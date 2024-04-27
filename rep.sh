#!/bin/bash

ffmpeg -framerate 24 -i input_%03d.png -vf showinfo -an -f null - > ffmpeg_output.txt 2>&1
grep "checksum:" ffmpeg_output.txt | awk -F'[: ]+' '{match($0, /checksum:([A-F0-9]+)/, a); print $5 " " a[1]}' > checksums.txt



# Initialize last_checksum variable
last_checksum=0

# Read frame and checksum from the file
while IFS=' ' read -r frame checksum_hex
do
  # Convert hexadecimal checksum to decimal integer
  checksum=$((16#$checksum_hex))

  if [[ $last_checksum != 0 ]]; then  # Skip the first frame for comparison
    # Calculate absolute difference between checksums
    diff=$((checksum - last_checksum))
    if [ ${diff#-} -gt 10000000 ]; then  # Assuming any change is significant
      echo "Faulty frame: input_$(printf "%03d" $frame).png"
    fi
  fi
  last_checksum=$checksum  # Update last_checksum as decimal integer
done < checksums.txt