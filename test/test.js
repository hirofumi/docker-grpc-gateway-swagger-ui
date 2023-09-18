const assert = require('node:assert');
const puppeteer = require('puppeteer');

const URL = 'http://grpc-gateway-swagger-ui:3000/';

(async () => {
    const browser = await puppeteer.launch({ headless: 'new' });
    const page = await browser.newPage();

    await page.goto(URL);
    await page.waitForSelector('.swagger-ui');
    assert.equal(
        await page.evaluate(() => document.querySelector('h2.title').innerText),
        'example.proto\n version not set ',
    );

    await browser.close();
})();
