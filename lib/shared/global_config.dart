//Jhispter
//localhost when external ip is 172.17.167.225 and jhipster backend is listening to port 8080
const SERVER_AUTH_URL = 'http://172.17.167.225:8080/api/authenticate';
// Truth is, endpoint is "websocket/tracker/" for WS_URL, but adding websocket is needed or connection won't be upgraded to websocket.
// see https://stackoverflow.com/questions/31817135/connect-with-ios-and-android-clients-to-sockjs-backend
const WS_URL = 'ws://172.17.167.225:8080/websocket/tracker/websocket?access_token='; 
const USERNAME = 'admin';
const PASSWORD = 'admin';
const REMEMBER_ME = true;