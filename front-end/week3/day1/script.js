let countEl = document.getElementById("count-el");
let saveEl = document.getElementById("save-el");

let count = 0;
function increment() {
  count++;
  countEl.innerText = count;
}

function save() {
  let countStr = count + " - ";
  saveEl.textContent += countStr;
  countEl.innerText = 0;
  count = 0;
}
