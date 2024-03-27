import streamlit as st
import pandas as pd
from snowflake.snowpark.context import get_active_session
from snowflake.snowpark.functions import when_matched,when_not_matched



st.set_page_config(layout="centered", page_title="Admin Page", page_icon="🧮")
st.title("Simple insert example")
session = get_active_session()
with st.form("data_editor_form"):
    customer = st.text_input("CUSTOMER")
    product = st.text_input("PRODUCT")
    submit_button = st.form_submit_button("Submit")
if submit_button:
    session.sql("insert into streamlit_db.data.issues VALUES(?,?,10,CURRENT_DATE(),'region 1','USER_A','DONE')", params=[customer, product]).collect()




