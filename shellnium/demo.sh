#!/usr/bin/env bash
#source ./lib/selenium.sh --headless
source ./lib/selenium.sh

main() {
	navigate_to 'https://bitbucket.org'

	#json=$(sqlite3 $HOME/.config/google-chrome/Default/Cookies '.mode json' 'select * from cookies where host_key like "%bitbucket%"')
	json=$(cat bitbucket.org_cookies.json)

	length=$(echo $json | jq '. | length')

	for i in $(seq 0 "$((length - 1))"); do
		cookie=$(
			echo "$json" |
				jq -r ".[$i] |
			{
				\"name\": .name,
				\"value\": .value,
			}"
		)
		add_cookie "$cookie" 1>/dev/null
	done

	navigate_to 'https://bitbucket.org/<>/<>/pipelines/results/page/1'

	sleep 3

	get_link() {
		cat <<-EOF
			function getLink() {
				const firstRow = document.querySelector('table tr:first-child');
				const link = document.querySelector('td:nth-child(3) a').href;
				return link;
			}
			return getLink();
		EOF
	}

	link=$(exec_script "$(get_link)" | jq -r '.value')

	navigate_to $link

	sleep 3

	get_button() {
		cat <<-EOF
			function getButton() {
				const button = document.querySelector('button span[aria-label=\"download logs\"]').closest('button');
				return button;
			}
			return getButton();
		EOF
	}

	button=$(exec_script "$(get_button)" | jq -r '.value' | jq -r '.ELEMENT')

echo $button
	click $button

	sleep 10

	delete_session
}

main
