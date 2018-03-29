minja
=====
Simple way to manage tournaments. 

Demo: [minja.net](http://www.minja.net)  
Demo User:
* email: test@example.com 
* password: test


## Technologies used

### Frontend
-  jQuery
-  [EmberJs](http://emberjs.com/)
-  [Twitter Bootstrap](http://twitter.github.com/bootstrap/index.html)
-  [ThreeJS](http://mrdoob.github.com/three.js/)

### Backend
-  [NodeJs](https://nodejs.org/en/) v5.2.0
-  [Coffeescript](http://coffeescript.org/) v1.4.0
-  [ExpressJs](http://expressjs.com/)
-  [CouchDB](http://couchdb.apache.org/)

## Deployment

1. Install NodeJs, CouchDB and Coffeescript
2. In project directory run: ```npm install```
3. Copy ```app/server-config.coffee.template``` to ```app/server-config.coffee```
4. Update ```app/server-config.coffee``` with DB credentials, email SMTP settings for email service
5. Run: ```coffee server.coffee```
