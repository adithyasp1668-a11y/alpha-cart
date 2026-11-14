import { app } from './app.js';
import { ENV } from './config/env.js';

app.listen(ENV.PORT, () => {
  console.log(`[AlphaCart Backend] Server listening on port ${ENV.PORT}`);
  console.log(`[AlphaCart Backend] Environment: ${ENV.NODE_ENV}`);
});

