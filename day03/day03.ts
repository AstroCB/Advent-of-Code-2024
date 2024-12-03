import {readFileSync} from 'fs';

const data = readFileSync('input.txt').toString();
const mul_regex = /mul\((\d{1,3}),(\d{1,3})\)/;

// part 1
const matches = [...data.matchAll(new RegExp(mul_regex, 'g'))];

const sum = matches.reduce((sum, match) => {
  const a = parseInt(match[1]);
  const b = parseInt(match[2]);
  return sum + a * b;
}, 0);

console.log(`part 1: ${sum}`);

// part 2
const do_regex = /do\(\)/;
const dont_regex = /don't\(\)/;

let cmdEnabled = true;
let remainingStr = data;
let sum2 = 0;

while (remainingStr.length > 0) {
  const nextDo = remainingStr.search(do_regex);
  const nextDont = remainingStr.search(dont_regex);
  const nextMul = remainingStr.search(mul_regex);

  const cmds = {
      "do": nextDo,
      "dont": nextDont,
      "mul": nextMul
  }

  const validCmds = Object.keys(cmds).filter(key => cmds[key] !== -1);
  if (validCmds.length === 0) {
    break;
  }

  const minCmd: string | null = validCmds.reduce((minKey, key) => cmds[key] < cmds[minKey] ? key : minKey, validCmds[0]);

  if (minCmd === "do") {
    cmdEnabled = true;
    remainingStr = remainingStr.slice(nextDo + 4);
  } else if (minCmd === "dont") {
    cmdEnabled = false;
    remainingStr = remainingStr.slice(nextDont + 6);
  } else if (minCmd === "mul") {
    const match = remainingStr.match(mul_regex);

    const a = parseInt(match[1]);
    const b = parseInt(match[2]);
    
    if (cmdEnabled){
        sum2 += a * b;
    }

    remainingStr = remainingStr.slice(nextMul + match[0].length);
  }
}

console.log(`part 2: ${sum2}`);