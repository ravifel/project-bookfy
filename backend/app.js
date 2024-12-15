const express = require("express");
const app = express();

const PORT = 3000;
app.listen(PORT, function () {
    console.log(`O express está rodando na porta ${PORT}`);
});

app.get('/', (request, response) => {
    response.send("It is working...")
})

module.exports = app;