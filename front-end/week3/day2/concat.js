// Create two variables, firstName and lastName

// Concatenate the two variables into a third variable called fullName

// Log fullName to the console

let firstName = "Shawket";
let lastName = "Samir";

let fullName = firstName + " " + lastName;

console.log(fullName);

// Create a function that logs out "Hi there, Linda!" when called

function greet(greeting, name) {
  console.log(greeting + " there" + ", " + name + "!");
}

greet("Hi", "Linda");

// Create two functions, add3Points() and remove1Point(), and have them
// add/remove points to/from the myPoints variable

let myPoints = 2;

function add3Points() {
  myPoints += 3;
}

function remove1Points() {
  myPoints -= 1;
}

add3Points();
remove1Points();
