"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const app_js_1 = require("./app.js");
const env_js_1 = require("./config/env.js");
app_js_1.app.listen(env_js_1.ENV.PORT, () => {
    console.log(`[AlphaCart Backend] Server listening on port ${env_js_1.ENV.PORT}`);
    console.log(`[AlphaCart Backend] Environment: ${env_js_1.ENV.NODE_ENV}`);
});
