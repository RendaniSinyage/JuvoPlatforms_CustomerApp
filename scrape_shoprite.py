import requests
from bs4 import BeautifulSoup

# URL of the Shoprite page
url = "https://www.shoprite.co.za/c-2256/All-Departments?sort=name-asc&q=%3Arelevance%3AbrowseAllStoresFacetOff%3AbrowseAllStoresFacetOff&page=0"

# Fetch the content of the page
response = requests.get(url)

# Check if the request was successful
if response.status_code == 200:
    soup = BeautifulSoup(response.content, 'html.parser')

    # Find all product elements (assuming products are in 'div' elements with class 'product')
    products = soup.find_all('div', class_='product', limit=5)

    for product in products:
        # Extract image URL (src attribute of img tag)
        img_tag = product.find('img')
        if img_tag and 'src' in img_tag.attrs:
            img_url = img_tag['src']
            # Extracting just the filename part from the URL
            img_filename = img_url.split('/')[-1]
        else:
            img_filename = 'No image'

        # Extract title
        title_tag = product.find('a', class_='product-title')
        title = title_tag.text.strip() if title_tag else 'No title'

        # Extract special price
        price_tag = product.find('span', class_='special-price_price')
        special_price = price_tag.text.strip() if price_tag else 'No special price'

        print(f'Image Filename: {img_filename}')
        print(f'Title: {title}')
        print(f'Special Price: {special_price}')
        print('------')
else:
    print(f'Failed to retrieve the page. Status code: {response.status_code}')
