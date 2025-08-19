module.exports = {
  apps: [
    {
      name: "node-app",
      script: "app.js",
      env: {
        PORT: process.env.PORT || 3000
      }
    }
  ]
};
