from fastapi import FastAPI
from enum import Enum

app = FastAPI()

class AvailableCuisines(str, Enum):
    indian = "indian"
    american = "american"
    italian = "italian"

food_items = {
    'indian': ["Samosa", "Dosa"],
    'american': ["Hot Dog", "Apple Pie"],
    'italian': ["Raviolo", "Pizza"]
}

@app.get("/get_items/{cuisine}") #get is used to read data. For instance, show me iphone covers
async def get_items(cuisine: AvailableCuisines):
    return food_items.get(cuisine)

coupon_code = {
    1: '10%',
    2: '20%',
    3: '30%'
}

@app.get("/get_coupon/{code}")
async def get_items(code: int):
    return { 'discount_amount': coupon_code.get(code) }

#post is used to create data. For instance, create new order

#put is used to update data. For instance, update an order

#delete is used to delete data. For instance, delete an order