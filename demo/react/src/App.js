import React from 'react';
import ReactDOM, { createRoot } from 'react-dom/client';
import createReactClass from 'create-react-class';

// Set React and ReactDOM on the window object for scripts that expect it to be globally available
window.React = React;
window.ReactDOM = ReactDOM;
window.createReactClass = createReactClass;

const loadScript = (src, callback) => {
    const script = document.createElement('script');
    script.type = 'text/javascript';
    script.onload = () => callback();
    script.src = src;
    document.head.appendChild(script);
};

const startApp = () => {
    // Import the DemoApp component only after the literallycanvas.js has been loaded
    import('./DemoApp.jsx').then(DemoAppModule => {
        console.log("starting app")
        const DemoApp = DemoAppModule.default;
        const container = document.getElementById('app-container');
        const root = createRoot(container);
        root.render(<DemoApp />);
    });
};

// Load LiterallyCanvas script and then start the app
loadScript('/lib/js/literallycanvas.js', startApp);