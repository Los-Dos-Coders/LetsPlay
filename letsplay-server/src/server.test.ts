import app from './app';

const mockListen = jest.fn();
app.listen = mockListen;

afterEach(() => {
  mockListen.mockReset();
});

test('Server Works', async () => {
  require('./server');
  expect(mockListen.mock.calls.length).toBe(1);
  expect(mockListen.mock.calls[0][0]).toBe(process.env.PORT || 8000);
});
