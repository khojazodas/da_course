import numpy as np
import pandas as pd
import plotly
from plotly import express as px
import streamlit as st
from connector import connect_to
import time
from datetime import date

@st.cache_data
def load_data():
    with connect_to('postgres') as pg:
        time.sleep(4)
        query = """
        select * 
        from invoice
        """
        df = pd.read_sql(query, pg)
        return df
    
@st.cache_data
def load_data1():
    with connect_to('postgres') as pg:
        time.sleep(4)
        query = """
        select 
            g.name
            , i.total
        from invoice i
        join invoice_line il on il.invoice_id = i.invoice_id
        join track t on t.track_id = il.track_id
        join genre g on g.genre_id = t.genre_id
        """
        df = pd.read_sql(query, pg)
        return df
    
start_date = pd.to_datetime("2021-01-01")
end_date = pd.to_datetime("2025-12-31")

inv = load_data()
inv2 = load_data1()

filtered_invoices = inv[(inv['invoice_date'] >= start_date) & (inv['invoice_date'] <= end_date)]

countries = filtered_invoices['billing_country'].unique()
selected_country = st.selectbox('Выберите страну', options=countries)

country_filtered_data = filtered_invoices[filtered_invoices['billing_country'] == selected_country]

fig = px.line(
    data_frame=country_filtered_data,
    x='invoice_date',
    y='total',
    title='Сумма инвойсов по датам для выбранной страны',
    labels={'invoice_date': 'Дата', 'total': 'Сумма инвойсов'},
)

st.plotly_chart(fig)

genres = inv2['name'].unique()
selected_genre = st.selectbox('Выберите жанр', options=genres)

grouped_genre_data = inv2.groupby('name')['total'].sum().reset_index()

genre_filtered_data = inv2[inv2['name'] == selected_genre]

fig = px.bar(
    data_frame=genre_filtered_data,
    x='name',
    y='total',
    title='Сумма инвойсов по жанрам',
    labels={'name': 'Жанр', 'total': 'Сумма инвойсов'},
)

st.plotly_chart(fig)

