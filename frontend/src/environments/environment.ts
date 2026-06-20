// Default (development & tests). Empty apiUrl keeps calls relative to the dev
// server, which proxies /api to the backend via proxy.conf.json.
export const environment = {
  production: false,
  apiUrl: '',
};
