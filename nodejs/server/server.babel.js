import React from 'react';
import ReactDOM from 'react-dom';
import express from 'express';
import path from 'path';
import ReactDOMServer from 'react-dom/server';
import bodyParser from 'body-parser';

const app = express();
app.use(bodyParser.json());

app.get('/', (req, res) => {
  res.status(200).send('Hello');
});

app.post('/', (req, res) => {
  try {
    const view = path.resolve('./views/' + req.query.component);
    const Component = require(view).default;
    const props = req.body || null;
    res.status(200).send(
      ReactDOMServer.renderToString(
        React.createElement(Component, props)
      )
    );
  } catch (error) {
     res.status(500).send(error.message);
  }
});

app.listen(3000, () => {
  console.log('Example app listening on port 3000!');
});
