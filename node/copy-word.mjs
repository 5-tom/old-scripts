#!/usr/bin/env node

import chalk from "chalk";
import clipboard from "clipboardy";
import fs from "node:fs/promises";
import minimist from "minimist";

const argv = minimist(process.argv.slice(2));
if (!argv.file) {
	console.log("Exiting...");
	process.exit();
}

const text = (await fs.readFile(argv.file)).toString();

let count = 0;
let wordToCopy;

process.stdin.setRawMode(true);
process.stdin.resume();
process.stdin.setEncoding("utf8");

process.stdout.write("\x1b[2J");

process.stdin.on("data", function (key) {
	if (key === "\u0003") {
		process.exit();
	}

	if (key === "\t") {
		process.stdout.write("\x1b[1;1H");

		const textArr = text.split(" ").filter((v) => v !== "");
		textArr.forEach((word, index) => {
			if (index === count) {
				wordToCopy = word;
				process.stdout.write(" " + chalk.bgWhite(word));
			} else {
				process.stdout.write(" " + word);
			}
		});

		if (count === textArr.length - 1) {
			count = 0;
		} else {
			count++;
		}
	}

	if (key === "\r") {
		clipboard.writeSync(wordToCopy);
		process.exit();
	}
});

// https://stackoverflow.com/questions/5006821/nodejs-how-to-read-keystrokes-from-stdin
