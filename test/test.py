from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import unittest


URL = 'http://grpc-gateway-swagger-ui:3000/'


class Test(unittest.TestCase):
    driver = None

    @classmethod
    def setUpClass(cls):
        options = webdriver.ChromeOptions()
        options.add_argument('--headless')
        cls.driver = webdriver.Chrome(options=options)
        cls.driver.get(URL)
        WebDriverWait(cls.driver, 10).until(EC.presence_of_element_located((By.CLASS_NAME, 'swagger-ui')))

    @classmethod
    def tearDownClass(cls):
        cls.driver.quit()

    def test_redirect(self):
        self.assertEqual(URL + '?url=/api/apidocs.swagger.json', self.driver.current_url)

    def test_title(self):
        expected = 'example.proto\n version not set '
        got = self.driver.find_element_by_css_selector('h2.title').text
        self.assertEqual(expected, got)


if __name__ == '__main__':
    unittest.main()
