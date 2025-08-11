// Fichier de test pour ESLint et Prettier
// Ce fichier contient volontairement des erreurs de style et de syntaxe

const message="Hello World"
let unused_variable = 42

function badFunction(){
if(true){
console.log(message)
}
}

const obj = {
a: 1,
b: 2,
c: 3,
};

// Semi-colon manquant
const test = "test"

// Espacement incorrect
if(true){badFunction()}

// Export mal formaté
export{badFunction,obj} 