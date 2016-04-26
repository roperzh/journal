+++
Description = ""
Tags = []
date = "2016-04-13T10:53:55-03:00"
title = "strict mode a fondo"

+++

`Strict mode` es una variante de JavaScript que nos permite ejecutar nuestro código en un contexto donde se excluyen algunas caracteristicas<!--more--> sintacticas y semanticas del lenguaje, este contexto nos limita en ciertas acciones y [tira mas excepciones]. De esta manera prevenimos errores comunes y limitamos ciertas acciones consideradas inseguras.

El modo estricto fue definido en [ECMA-262-5](http://www.ecma-international.org/ecma-262/5.1), una especificación del lenguaje que salió a la luz oficialmente en Diciembre de 2009. Una lista completa con todos los pormenores de strict mode puede se puede consultar en el [anexo C de la especificación](http://www.ecma-international.org/ecma-262/5.1/#sec-C).

Antes de entrar en detalles, hay que considerar que strict mode no esta presente desde la primera especificación del lenguaje, por lo tanto los navegadores que no la soporten pueden llegar a tener algunos problemas en casos muy puntuales. Una lista detallada sobre la compatiblidad en distintos navegadores se puede encontrar [aquí](http://caniuse.com/#feat=use-strict). Como siempre el mejor remedio es testear nuestro código en los navegadores que soportemos.

### Directivas y strict mode

Formalmente, una directiva es una [expresión](https://developer.mozilla.org/es/docs/Web/JavaScript/Guide/Expressions_and_Operators#String_operators) de tipo string literal: uno o mas caracteres entre comillas simples (`'`) o dobles (`"`) proseguidos opcionalmente por un punto y coma.

La función de una directiva es dar instrucciones al interprete de como debe ser manejado un bloque de código. Si bien el spec define una única directiva (`use strict`) puede darse el caso de que necesitemos usar otras directivas, por ejemplo si estamos usando [asm](http://asmjs.org/) o algún editor de texto que [así lo requiera](http://blog.atom.io/2015/02/04/built-in-6to5.html).

Podemos poner tantas directivas juntas como necesitemos (el spec llama a esto `Directive Prologue`).

```javascript
'use strict';
'use asm';
```

**Invocando strict mode**

Ahora que tenemos en claro que es una directiva, podemos activar strict mode
incluyendo la directiva `use strict`, pero ¿donde?. Lo interesante es podemos activar `strict mode` para todo nuestro código, pero también únicamente para una sección particular.

De esta manera podemos elegir que cierta porción de código sea estricta teniendo en cuenta ciertas reglas de scope. Esto nos puede ser útil por ejemplo si estamos escribiendo alguna libreria [explicar por que].

Si queremos activar strict mode para _todo_ nuestro codigo, basta con poner la directiva como primera declaración en nuestro archivo:

```javascript
'use strict';
```

Si queremos activar strict mode _en un contexto especifico_ de nuestro codigo, basta con poner la directiva dentro de una función, todo el codigo contenido en ella sera evaluado en modo estricto

```javascript
var eval = 10; // OK, no estamos en strict mode

function foo() {
  'use strict';
  alert(eval);  // 10
  eval = 20;    // SyntaxError, estamos en strict mode
}

foo();
```
### Restricciones en strict mode

***Restricciones en nombres de identificadores***

La idea es evitar usar identificadores que podrían ser usados en futuras especificaciones del lenguaje, de esta manera en ECMA-262-5 estan prohibidos los siguientes identificadores: `implements`, `interface`, `let`, `package`, `private`, `protected`, `public`, `static`, `yield`.

Vale la pena notar que algunos de ellos ya fueron implementados en ECMA-262-6.

***Todas las variables deben ser declaradas***

Fuera de strict mode, asignar una variable no declarada previamente implica
declarar una variable global. Strict mode nos fuerza a declarar todas las variables tirando una excepción cuando no es el caso:

```javascript
function noStrictFunc() {
  globalVar = 123;
}

function strictFunc() {
  'use strict';
  strictVar = 123;
}

noStrictFunc();           // crea la variable global `globalVar`
console.log(globalVar);   // 123

strictFunc();             // ReferenceError: strictVar is not defined
```

***Duplicaciones***

Estan prohibidas las propiedades duplicadas cuando se inicializa un objeto

_nota_: a partir de [ECMA-262-6](http://www.ecma-international.org/ecma-262/6.0/), esta regla no es válida.

```javascript
'use strict';

// SyntaxError
var obj = {
  x: 10,
  x: 10
};
```

Asimismo usar el mismo nombre de parámetro en una función esta prohibido.

```javascript
function parametrosDuplicados(a, b, a) {
  'use strict';
  console.log(a, b, a);
}

parametrosDuplicados(); // SyntaxError: Duplicate parameter name not allowed in this context
```

***Shadowing inherited read-only properties***

Notice, that it relates to inherited properties as well. If we try to shadow some read-only inherited property via assignment we also get TypeError. And again, if we shadow the property via Object.defineProperty it’s made normally — thus, a configurable attribute of the inherited property doesn’t matter in this case:

```javascript
"use strict";

var foo = Object.defineProperty({}, "x", {
  value: 10,
  writable: false
});

// "bar" inherits from "foo"

var bar = Object.create(foo);

console.log(bar.x); // 10, inherited

// try to shadow "x" via assignment

bar.x = 20; // TypeError
```

***Creating a new property of non-extensible objects***

Restricted assignment also relates to augmenting non-extensible objects, i.e. objects having [[Extensible]] property as false:

```javascript
"use strict";

var foo = {};
foo.bar = 20; // OK

Object.preventExtensions(foo);
foo.baz = 30; // TypeError
```

***`eval` and `arguments` restrictions***

In strict mode these names — eval and arguments are treated as kind of “keywords” (while they are not) and not allowed in several cases.

They cannot appear as a variable declaration or as a function name:

```javascript
"use strict";

// SyntaxError in both cases
var arguments;
var eval;

// also SyntaxError
function eval() {}
var foo = function arguments() {};
```

They are not allowed as function argument names:

```javascript
"use strict";

// SyntaxError
function foo(eval, arguments) {}
```

It is impossible to assign new values to them (thus, arguments is restricted in the global scope also, but not only in functions):

```javascript
"use strict";

// SyntaxError
eval = 10;
arguments = 20;

(function (x) {
  alert(arguments[0]); // 30
  arguments = 40; // TypeError
})(30);
```

They cannot be used with prefix and postfix increment/decrement expressions:

```javascript
"use strict";

// SyntaxError
++eval;
arguments--;
```

Regarding objects and their properties, eval and arguments are allowed in assignment expressions and may be used as property names of objects:

```javascript
"use strict";

// OK
var foo = {
  eval: 10,
  arguments: 20
};

// OK
foo.eval = 10;
foo.arguments = 20;
```

However, eval and arguments are not allowed as parameter names of declarative view of a setter:

```javascript
"use strict";

// SyntaxError
var foo = {
  set bar (eval, arguments) {
    ...
  }
};
```

### Fuentes y links de interes

- [ECMA-262-5 spec](http://www.ecma-international.org/ecma-262/5.1)
- [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode)
- [ECMA-262 in detail by Dmitry Soshnikov](http://dmitrysoshnikov.com/ecmascript/es5-chapter-2-strict-mode/)
- [John Resig blog's](http://ejohn.org/blog/ecmascript-5-strict-mode-json-and-more/)