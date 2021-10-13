# heroku-docker-nginx-example

Barebones example of deploying
[the official nginx Docker image](https://github.com/docker-library/docs/tree/master/nginx)
to Heroku. Serves an example html file at the root directory.

## Try it now!

Fire up an nginx proxy on [Heroku](https://www.heroku.com/) with a single click:

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Manual deployment

You will need to create a Heroku account and install the Heroku CLI, eg.
`brew install heroku`.

```
git clone git@github.com:rjoonas/heroku-docker-nginx-example.git
cd heroku-docker-nginx-example
heroku container:login
heroku create
heroku container:push web
heroku container:release web
heroku open
```


## cloudflare 
`workers`

```
addEventListener("fetch", (event) => {
  event.respondWith(handleRequest(event));
});


var nodes = [
  "",
  ""
  ];
var nodeIndex = 0;

async function handleRequest(event) {

   var time = new Date();
     if(time.getHours() >= 4  && time.getHours() <= 16 ){
        nodeIndex = 1;
     } else {
        nodeIndex = 0;
     }

  const url=new URL(event.request.url);
    url.hostname = nodes[nodeIndex];
  const request=new Request(url,event.request);
  const resp = await fetch(request);

  const newResponse = new Response(resp.body, resp);
  newResponse.headers.set("nodeIndex", nodeIndex)
  return newResponse;
}
```
