import pandas as pd
import numpy as np
import random
from faker import Faker
from datetime import datetime, timedelta
from tqdm import tqdm

fake = Faker()

# Dataset sizes
NUM_CUSTOMERS = 50000
NUM_PRODUCTS = 2000
NUM_SUPPLIERS = 50
NUM_WAREHOUSES = 5
NUM_ORDERS = 300000
MAX_ITEMS_PER_ORDER = 5

cities = [
    "Mumbai","Pune","Delhi","Bangalore",
    "Hyderabad","Ahmedabad","Chennai"
]

payment_methods = ["UPI","Credit Card","Debit Card","COD","Net Banking"]

order_statuses = [
    "placed","confirmed","packed",
    "shipped","delivered","cancelled"
]

def generate_suppliers():

    suppliers = []

    for i in range(NUM_SUPPLIERS):

        suppliers.append({
            "supplier_id": i + 1,
            "supplier_name": fake.company(),
            "supplier_city": random.choice(cities),
            "contact_email": fake.company_email(),
            "contract_start_date": fake.date_between(start_date='-5y', end_date='today')
        })

    df = pd.DataFrame(suppliers)

    df.to_csv("../data/raw/suppliers.csv", index=False)

    return df

def generate_customers():

    customers = []

    for i in tqdm(range(NUM_CUSTOMERS)):

        customers.append({
            "customer_id": i + 1,
            "customer_name": fake.name(),
            "email": fake.email(),
            "phone": fake.msisdn()[:10],
            "city": random.choice(cities),
            "state": "India",
            "signup_date": fake.date_between(start_date='-3y', end_date='today')
        })

    df = pd.DataFrame(customers)

    df.to_csv("../data/raw/customers.csv", index=False)

    return df

def generate_products():

    categories = [
        "Pain Relief","Fever","Diabetes",
        "Vitamin","Antibiotic","Skin Care"
    ]

    products = []

    for i in tqdm(range(NUM_PRODUCTS)):

        mfg = fake.date_between(start_date='-2y', end_date='-30d')
        expiry = mfg + timedelta(days=random.randint(365,900))

        products.append({
            "product_id": i + 1,
            "product_name": fake.word().capitalize() + " Tablet",
            "brand": fake.company(),
            "category": random.choice(categories),
            "mrp": round(random.uniform(50,500),2),
            "manufacture_date": mfg,
            "expiry_date": expiry,
            "requires_prescription": random.choice(["Yes","No"])
        })

    df = pd.DataFrame(products)

    df.to_csv("../data/raw/products.csv", index=False)

    return df

def generate_warehouses():

    warehouses = []

    for i in range(NUM_WAREHOUSES):

        warehouses.append({
            "warehouse_id": i + 1,
            "warehouse_city": random.choice(cities),
            "capacity": random.randint(10000,50000),
            "manager_name": fake.name()
        })

    df = pd.DataFrame(warehouses)

    df.to_csv("../data/raw/warehouses.csv", index=False)

    return df

def generate_product_suppliers(products, suppliers):

    mappings = []

    for product in products["product_id"]:

        supplier_id = random.choice(suppliers["supplier_id"].values)

        mappings.append({
            "product_supplier_id": product,
            "product_id": product,
            "supplier_id": supplier_id,
            "supply_price": round(random.uniform(30,300),2),
            "contract_date": fake.date_between(start_date='-3y', end_date='today')
        })

    df = pd.DataFrame(mappings)

    df.to_csv("../data/raw/product_suppliers.csv", index=False)

    return df

def generate_inventory(products, warehouses):

    inventory = []

    inv_id = 1

    for product in products["product_id"]:

        for wh in warehouses["warehouse_id"]:

            inventory.append({
                "inventory_id": inv_id,
                "product_id": product,
                "warehouse_id": wh,
                "stock_quantity": random.randint(0,500),
                "reorder_level": random.randint(20,100),
                "last_updated": fake.date_between(start_date='-30d', end_date='today')
            })

            inv_id += 1

    df = pd.DataFrame(inventory)

    df.to_csv("../data/raw/inventory.csv", index=False)

    return df

def generate_orders(customers):

    orders = []

    for i in tqdm(range(NUM_ORDERS)):

        orders.append({
            "order_id": i + 1,
            "customer_id": random.choice(customers["customer_id"].values),
            "order_timestamp": fake.date_time_between(start_date='-1y', end_date='now'),
            "order_status": random.choice(order_statuses),
            "payment_method": random.choice(payment_methods),
            "delivery_city": random.choice(cities)
        })

    df = pd.DataFrame(orders)

    df.to_csv("../data/raw/orders.csv", index=False)

    return df

def generate_order_items(orders, products):

    order_items = []
    item_id = 1

    for order_id in tqdm(orders["order_id"]):

        num_items = random.randint(1, MAX_ITEMS_PER_ORDER)

        selected_products = products.sample(num_items)

        for _, product in selected_products.iterrows():

            qty = random.randint(1,3)

            order_items.append({
                "order_item_id": item_id,
                "order_id": order_id,
                "product_id": product["product_id"],
                "quantity": qty,
                "item_price": product["mrp"]
            })

            item_id += 1

    df = pd.DataFrame(order_items)

    df.to_csv("../data/raw/order_items.csv", index=False)

    return df

def generate_payments(orders):

    payments = []

    for order in tqdm(orders.itertuples()):

        payments.append({
            "payment_id": f"PAY{order.order_id}",
            "order_id": order.order_id,
            "payment_method": order.payment_method,
            "payment_status": "success",
            "payment_amount": round(random.uniform(100,1500),2),
            "payment_timestamp": order.order_timestamp
        })

    df = pd.DataFrame(payments)

    df.to_csv("../data/raw/payments.csv", index=False)

    return df

def generate_prescriptions(customers):

    prescriptions = []

    for i in range(80000):

        prescriptions.append({
            "prescription_id": i + 1,
            "customer_id": random.choice(customers["customer_id"].values),
            "doctor_name": fake.name(),
            "hospital_name": fake.company(),
            "upload_date": fake.date_between(start_date='-1y', end_date='today'),
            "verification_status": random.choice(["verified","pending","rejected"])
        })

    df = pd.DataFrame(prescriptions)

    df.to_csv("../data/raw/prescriptions.csv", index=False)

    return df

def main():

    suppliers = generate_suppliers()

    customers = generate_customers()

    products = generate_products()

    warehouses = generate_warehouses()

    product_suppliers = generate_product_suppliers(products, suppliers)

    inventory = generate_inventory(products, warehouses)

    orders = generate_orders(customers)

    order_items = generate_order_items(orders, products)

    payments = generate_payments(orders)

    prescriptions = generate_prescriptions(customers)

    print("RAW pharma dataset generation complete")


if __name__ == "__main__":
    main()