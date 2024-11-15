import numpy
import plotly
import plotly.express as px
import pandas as pd
import psycopg2
import sqlalchemy as db
import streamlit as st
from connector import connect_to

def load_data() :
    with connect_to('postgres') as pg:
        query = """ select * from invoice """
        inv = pd.read_sql(query , pg)
    return inv


inv = load_data()
country_s = inv

st.header("Chinook Sales Report")
st.write("Data frame of the table")

country_selector = st.sidebar.selectbox(
    "Select country for the invoice" ,
    options = ['All'] + country_s['billing_country'].unique().tolist(),
    index = 0
)

min_date = pd.to_datetime('2021-01-01')
max_date = pd.to_datetime('2025-12-31')

with st.sidebar :
    sdate = st.date_input(
        label = 'Select start of period' ,
        value = min_date ,
        min_value = min_date ,
        max_value = max_date
    )
    edate = st.date_input(
        label = 'Select edn of period' ,
        value = max_date ,
        min_value = min_date,
        max_value = max_date
    )

with st.expander("Click to view the dataFrame") :
    st.dataframe(inv)

if (country_selector != 'All'):
    inv = inv[inv['billing_country'] == country_selector]

filtered_inv = inv[(inv['invoice_date'] >= pd.to_datetime(sdate)) & (inv['invoice_date'] <= pd.to_datetime(edate))]

fig = px.bar(
    filtered_inv ,
    x = 'billing_country' ,
    y = 'total'
)

st.plotly_chart(fig)

fig1 = px.scatter(
    filtered_inv ,
    x = 'invoice_date' ,
    y = 'total' ,
    title = 'Total sales vs Invoice Date'
)

st.plotly_chart(fig1)

print("Hello World")
print("Data was loaded")
