import { buildServer } from './server.js';

const port = Number(process.env.PORT ?? 7000);
const host = process.env.HOST ?? '0.0.0.0';

const server = buildServer();

try {
  await server.listen({ port, host });
  server.log.info({ host, port }, 'server started');
} catch (error) {
  server.log.error(error, 'failed to start server');
  process.exit(1);
}
