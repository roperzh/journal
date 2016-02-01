## Journal

This is the site for my personal journal, it's live online [here][1].

## Development

### Requisites

- [Hugo v0.15][2]
- Git

### Getting started

Clone the repository:

```
$ git clone https://github.com/roperzh/journal.git
```
run the Hugo server specifying the language (`es` or `en`)

```
$ make watch l=es
```

Finally, visit http://localhost:1313/es on your browser

### Deployment

First you need to install the [netlify](netlify.com) cli:

```
$ npm install netlify-cli -g
```

and then run the deploy:

```
$ make deploy
```

[1]: http://journal.roperzh.com
[2]: http://gohugo.io