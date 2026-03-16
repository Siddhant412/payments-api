import Fastify from 'fastify';

export function buildServer() {
  const server = Fastify({
    logger: {
      level: process.env.LOG_LEVEL ?? 'info',
    },
  });

  server.get('/', async () => ({
    service: 'payments-api',
    description: 'API for payment operations',
  }));

  server.get('/health/live', async () => ({
    status: 'ok',
    service: 'payments-api',
  }));

  server.get('/health/ready', async () => ({
    status: 'ready',
    service: 'payments-api',
  }));

  return server;
}
