const { Client } = require('pg');
require('dotenv').config();

const client = new Client({
    host: "localhost",
    user: process.env.DATABASE_USER,
    port: 5432,
    password: process.env.DATABASE_PASSWORD,
    database: "bookfy-project-01"
});

client.connect();

client.query(`SELECT * FROM users`, (err, res) => {
    if (err) {
        console.error('Erro ao executar a query:', err.message); // Mostra a mensagem de erro
    } else {
        console.log('Resultado da query:', res.rows); // Exibe os resultados se não houver erro
    }
    client.end(); // Finaliza a conexão corretamente
});
