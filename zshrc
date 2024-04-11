alias vpn='sshuttle -r root@filmsbytom.com -x filmsbytom.com 0/0'
alias wip='curl -s https://icanhazip.com'
function getemoji() {
	cat $HOME/Documents/emojis | fzf --print0 | awk '{print $NF}' | xclip -selection c
}
alias emoji="getemoji"
alias forgot='echo "#khal new --interactive, DD-MM-YY HH:MM DD-MM-YY HH:MM
#todo new -l default <>
#khard new
#mpv --http-header-fields
#ffmpeg -headers \"\$(cat headers)\"
"'
