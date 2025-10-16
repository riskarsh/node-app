require('dotenv').config(); // loads .env if present

var express = require('express');
var app = express();

const PORT = process.env.PORT || 3000;

app.get('/', function (req, res) {
  res.send(`Hello World!! Running on port ${PORT} <br> Updated code`);
});

app.listen(PORT, function () {
  console.log(`Example app listening on port ${PORT}!`);
});
