const express = require('express');
const router = express.Router();

const Carro = require('../models/Carro');

// Retorna um array com todos os documentos do banco de dados
router.get('/', (req, res) => {
  Carro.find()
    .then(carros => {
      res.json(carros);
    })
    .catch(error => res.status(500).json(error));
});

// Cria um novo documento e salva no banco
router.post('/novo', (req, res) => {
  const novoCarro = new Carro({
    marca: req.body.marca,
    modelo: req.body.modelo
  });

  novoCarro
    .save()
    .then(carro => {
      res.json(carro);
    })
    .catch(error => {
      res.status(500).json(error);
    });
});

// Atualizando dados de um carro já existente
router.put('/editar/:id', (req, res) => {
  const novosDados = { marca: req.body.marca, modelo: req.body.modelo };

  Carro.findOneAndUpdate({ _id: req.params.id }, novosDados, { new: true })
    .then(carro => {
      res.json(carro);
    })
    .catch(error => res.status(500).json(error));
});

// Deletando um carro do banco de dados
router.delete('/delete/:id', (req, res) => {
  Carro.findOneAndDelete({ _id: req.params.id })
    .then(carro => {
      res.json(carro);
    })
    .catch(error => res.status(500).json(error));
});

module.exports = router;
