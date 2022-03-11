from selenium import webdriver
from selenium.webdriver.common.by import By
from time import sleep

base_url = 'https://www.xphobia.net'
sleep_time = 0.1

def get_reservation(driver):
    url = base_url + '/reservation/reservation_check.php'
    driver.get(url); sleep(sleep_time)
    num_days = len(driver.find_elements(By.XPATH, '//*[@data-handler="selectDay"]'))
    for day_i in range(num_days):
        day = driver.find_elements(By.XPATH, '//*[@data-handler="selectDay"]')[day_i]
        date = day.get_attribute('data-year') + '-' + day.get_attribute('data-month') + '-' + day.text
        day.click(); sleep(sleep_time)
        print(date)

        num_categories = len(driver.find_element(By.ID, 'ji_category').find_elements(By.TAG_NAME, 'li'))
        for category_i in range(num_categories):
            category = driver.find_element(By.ID, 'ji_category').find_elements(By.TAG_NAME, 'li')[category_i]
            if category.text == '미션 브레이크':
                continue
            category.click(); sleep(sleep_time)
            print(' '*1, category.text)

            num_cafes = len(driver.find_element(By.ID, 'cl1').find_elements(By.TAG_NAME, 'li'))
            for cafe_i in range(num_cafes):
                cafe = driver.find_element(By.ID, 'cl1').find_elements(By.TAG_NAME, 'li')[cafe_i]
                cafe.click(); sleep(sleep_time)
                try:
                    driver.switch_to.alert.accept()
                    continue
                except:
                    pass
                print(' '*3, cafe.text)

                num_themes = len(driver.find_element(By.ID, 'cl2').find_elements(By.TAG_NAME, 'li'))
                for theme_i in range(num_themes):
                    theme = driver.find_element(By.ID, 'cl2').find_elements(By.TAG_NAME, 'li')[theme_i]
                    theme.click(); sleep(sleep_time)
                    print(' '*5, theme.text)

                    num_times = len(driver.find_element(By.ID, 'cl3').find_elements(By.TAG_NAME, 'li'))
                    for time_i in range(num_times):
                        each_time = driver.find_element(By.ID, 'cl3').find_elements(By.TAG_NAME, 'li')[time_i]
                        print(' '*7, each_time.text, each_time.get_attribute('class').split(' '))

if __name__ == '__main__':
    options = webdriver.ChromeOptions()
    options.add_argument('headless')
    options.add_argument('window-size=1920x1080')
    options.add_argument("disable-gpu")
    driver = webdriver.Chrome('../confidential/chromedriver', options=options)

    get_reservation(driver)

    driver.quit()