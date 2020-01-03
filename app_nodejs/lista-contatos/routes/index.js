// INICIANDO ==============================================
// Define as bibliotecas que iremos utilizar
var express = require('express');
var mongoose = require('mongoose');
var router = express.Router();
var Contato = mongoose.model('Contato');
 
// ROTA BUSCAR ============================================
router.get('/api/contatos', function(req, res) {
    // utilizaremos o mongoose para buscar todos os contatos no BD
    Contato.find(function(err, contatos) {
        // Em caso de erros, envia o erro na resposta
        if (err)
            res.send(err)
        // Retorna todos os contatos encontrados no BD
        res.json(contatos); 
    });
});
 
// ROTA CRIAR =============================================
router.post('/api/contatos', function(req, res) {
    // Cria um contato, as informações são enviadas por uma requisição AJAX pelo Angular
    Contato.create({
        nome : req.body.nome,
        email : req.body.email,
        telefone : req.body.telefone,
        done : false
    }, function(err, contato) {
        if (err)
            res.send(err);
        // Busca novamente todos os contatos após termos inserido um novo registro
        Contato.find(function(err, contatos) {
            if (err)
                res.send(err)
            res.json(contatos);
        });
    });
 
});
 
// ROTA DELETAR ============================================
router.delete('/api/contatos/:contato_id', function(req, res) {
    // Remove o contato no Model pelo parâmetro _id
    Contato.remove({
        _id : req.params.contato_id
    }, function(err, contato) {
        if (err)
            res.send(err);
        // Busca novamente todos os contatos após termos removido o registro
        Contato.find(function(err, contatos) {
            if (err)
                res.send(err)
            res.json(contatos);
        });
    });
});
 
// ROTA EDITAR =============================================
router.get('/api/contatos/:contato_id', function(req, res) {
    // Busca o contato no Model pelo parâmetro id
    Contato.findOne({
        _id : req.params.contato_id
    }, function(err, contato) {
        if (err)
            res.send(err);
        res.json(contato);
    });
});
 
// ROTA ATUALIZAR ==========================================
router.put('/api/contatos/:contato_id', function(req, res) {
    // Busca o contato no Model pelo parâmetro id
    var contatoData = req.body;
    var id = req.params.contato_id;
 
    Contato.update( 
        {_id: id }, 
        contatoData, 
        { upsert: true}, 
        function(err, contato) {
            if (err) res.send(err);
            res.json(contato);
    });
    
});
 
// DEFININDO NOSSA ROTA PARA O ANGULARJS/FRONT-END =========
router.get('*', function(req, res) {
    // Carrega nossa view index.html que será a única da nossa aplicação
    // O Angular irá lidar com as mudanças de páginas no front-end
    res.sendfile('./public/index.html');
});
 
module.exports = router;