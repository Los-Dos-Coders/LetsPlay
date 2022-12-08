import app from './app';
import request from 'supertest';

test('GET /', async () => {
  const response = await request(app.callback()).get('/');
  expect(response.status).toBe(200);
});
