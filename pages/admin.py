import streamlit as st
import pandas as pd
from snowflake.snowpark.context import get_active_session


st.set_page_config(layout="centered", page_title="Admin Page", page_icon="🧮")
st.title("Admin Page for App")
st.caption("This is a demo of the admin page and `st.experimental_data_editor`")
st.text("This is a typo error - fix it!")
session = get_active_session()


sql = f"select * from streamlit_db.data.users;"
users_df = session.sql(sql).collect()

def is_admin(df,user):
    for item in df:
        if item[0] == user and item[1] == True:
            return True
    return False

user_login_name = st.experimental_user.login_name
query = f"select * from streamlit_db.data.issues where assigned_user_name = '{user_login_name}'"
if is_admin(users_df,user_login_name):
    st.header('Im in Admin Mode')
    query = f"select * from streamlit_db.data.issues"
    issues_df = session.sql(query).collect()
    with st.form("data_editor_form"):
        st.subheader('App Users:')
        users = st.experimental_data_editor(users_df, use_container_width=True, num_rows="dynamic")
        st.subheader('Issues:')
        edited = st.experimental_data_editor(issues_df, use_container_width=True, num_rows="dynamic")
        submit_button = st.form_submit_button("Submit")
    
else:
    st.header('Not Admin Mode')
    # st.subheader('App Users:')
    # st.dataframe(users_df)
    st.subheader(f"User {user_login_name} Issues:")
    issues_df = session.sql(query).collect()
    st.dataframe(issues_df)



# if submit_button:
#     try:
#         #Note the quote_identifiers argument for case insensitivity
#         session.write_pandas(edited, "ESG_SCORES_DEMO", overwrite=True, quote_identifiers=False)
#         st.success("Table updated")
#         time.sleep(5)
#     except:
#         st.warning("Error updating table")
#     #display success message for 5 seconds and update the table to reflect what is in Snowflake
#     st.experimental_rerun()



