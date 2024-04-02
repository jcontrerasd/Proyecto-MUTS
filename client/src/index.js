import React from 'react';
// import ReactDOM from 'react-dom';
import ReactDOM from 'react-dom/client'; // Importa client desde react-dom
import './index.css';
import App from './components/App';

// ReactDOM.render(<App />, document.getElementById('root'));

// Utiliza createRoot para montar tu aplicación
const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(<App />);
