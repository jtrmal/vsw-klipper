#!/bin/sh
# /etc/init.d/mainsail-stream.sh
### BEGIN INIT INFO
# Provides:          mainsail-stream.sh
# Required-Start:    $network
# Required-Stop:     $network
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: mjpg_streamer for webcam
# Description:       Streams /dev/video0 to http://IP/?action=stream
### END INIT INFO
f_message(){
        echo "[+] $1"
}
 
# Carry out specific functions when asked to by the system
case "$1" in
        start)
                f_message "Starting ustreamer"
		/home/pi/ustreamer/ustreamer -p 8081 -l 1 -q 30 -f 15 --gain=10   --format=yuyv  --encoder=omx --workers=3     --drop-same-frames=30 --tcp-nodelay --allow-origin '*' --host=0.0.0.0 &
                #/usr/local/bin/mjpg_streamer -b -i "input_uvc.so -f 15 -r 640x480 -timeout 15" -o "output_http.so -w /usr/local/share/mjpg-streamer/www"-b 
                sleep 2
                f_message "ustreamer started"
                ;;
        stop)
                f_message "Stopping ustreamer…"
                killall  /home/pi/ustreamer/ustreamer
		sleep 3s
		killall -9 /home/pi/ustreamer/ustreamer
                f_message "ustreamer stopped"
                ;;
        restart)
                f_message "Restarting daemon: ustreamer"
                killall /home/pi/ustreamer/ustreamer
		sleep 3s
		killall -9 /home/pi/ustreamer/ustreamer
		/home/pi/ustreamer/ustreamer -p 8081 -l 1 -q 30 -f 15 --gain=10   --format=yuyv  --encoder=omx --workers=3     --drop-same-frames=30 --tcp-nodelay --allow-origin '*' --host=0.0.0.0 &
                #/usr/local/bin/mjpg_streamer -b -i "input_uvc.so -f 15 -r 640x480 -timeout 15" -o "output_http.so -w /usr/local/share/mjpg-streamer/www"
                sleep 2
                f_message "Restarted daemon: ustreamer"
                ;;
        *)
                f_message "Usage: $0 {start|stop|restart}"
                exit 1
                ;;
esac
exit 0
