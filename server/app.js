var net = require('net');
var sockets = [];
var game = require("./game.js")

console.log("Server waiting for connections")

var server = net.createServer(function(socket) {
    var nSocket = socket;
    var id;
    console.log(nSocket.address(), " Connected.");
    nSocket.on("data", function(data){
        var res = onData(data);
        if(res){id = res}
    });
    nSocket.on("close", function(hadError){
        onClose(id, nSocket, hadError);
    });
    sockets.push(nSocket)
});

function broadcast(message) {
    console.log("broadcasting message", message.trim())
    for(i = 0; i < sockets.length ; i++){
        var socket = sockets[i]
        socket.write(message + "\r\n", 'utf8');
    }
}

function onClose(id, socket, hadError) {
    sockets.splice(sockets.indexOf(socket),1);
    game.removePlayer(id,broadcast);
    broadcast(id + "\t" + "LOST_CONNECTION" + "\t" + hadError);
}

function onConnect(socket) {
    console.log(socket.address(), " Connected.");
}

function onData(data) {
    data = data + ""
    var split = data.split("\t",3)
    var from = split[0];
    var event = split[1];
    var info = split[2];
    switch(event){
        case "CONNECT": game.addPlayer(from,broadcast); return from;
        case "SUBMIT": game.finishTurn(from,info,broadcast); return;
        default: broadcast(from + "\t" + event + "\t" + (info || ""));
    }
}

server.listen(50000, "localhost");