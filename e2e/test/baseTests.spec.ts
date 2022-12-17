import {test, expect} from '@playwright/test';
test('Check Homepage Connection', async ({page}) => {
  await page.goto('https://localhost');
  expect(true).toBe(true);
});
