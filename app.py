import streamlit as st
import pandas as pd
import time

# --- Page Configurations ---
st.set_page_config(
    page_title="CompareKart - Product Price Comparison",
    page_icon="🛒",
    layout="wide",
    initial_sidebar_state="expanded"
)

# --- CSS Styling System (White Background & Deep Blue Theme) ---
st.markdown("""
<style>
    /* Primary brand colors */
    :root {
        --primary-blue: #0D47A1;
        --secondary-blue: #1976D2;
        --light-blue: #E3F2FD;
        --dark-grey: #212121;
        --light-grey: #F8F9FA;
    }
    
    /* Background adjustments */
    .stApp {
        background-color: #FFFFFF;
        color: #212121;
    }
    
    /* Premium Title Banner */
    .brand-title {
        color: #0D47A1;
        font-family: 'Outfit', sans-serif;
        font-weight: 800;
        font-size: 2.2rem;
        display: flex;
        align-items: center;
        gap: 10px;
    }
    
    /* Cards */
    .product-card {
        background-color: #FFFFFF;
        border: 1px solid #E0E0E0;
        border-radius: 12px;
        padding: 16px;
        box-shadow: 0 4px 12px rgba(13, 71, 161, 0.03);
        margin-bottom: 16px;
        transition: transform 0.2s, box-shadow 0.2s;
    }
    
    .product-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 16px rgba(13, 71, 161, 0.08);
        border-color: #0D47A1;
    }
    
    /* Platform badges */
    .badge-amazon { background-color: #FF9900; color: white; padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 11px; }
    .badge-flipkart { background-color: #2874F0; color: white; padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 11px; }
    .badge-meesho { background-color: #E72B70; color: white; padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 11px; }
    .badge-myntra { background-color: #E61B58; color: white; padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 11px; }
    .badge-croma { background-color: #00B9B0; color: white; padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 11px; }
    .badge-reliance { background-color: #E4252A; color: white; padding: 4px 8px; border-radius: 4px; font-weight: bold; font-size: 11px; }
    
    .best-deal-box {
        background-color: #E8F5E9;
        border: 1.5px solid #4CAF50;
        border-radius: 8px;
        padding: 10px;
    }
</style>
""", unsafe_allow_html=True)

# --- Mock Dataset Engine ---
BASE_PRODUCTS = [
    {
        'id': 'iphone15',
        'name': 'Apple iPhone 15 (128 GB) - Black',
        'category': 'Electronics',
        'imageUrl': 'https://images.unsplash.com/photo-1510557880182-3d4d3cba35a5?q=80&w=400',
        'platforms': {
            'Amazon': {'price': 71200.0, 'originalPrice': 79900.0, 'rating': 4.6, 'deliveryCharge': 0.0, 'buyLink': 'https://www.amazon.in/dp/B0CHX1W1XY'},
            'Flipkart': {'price': 70999.0, 'originalPrice': 79900.0, 'rating': 4.5, 'deliveryCharge': 40.0, 'buyLink': 'https://www.flipkart.com/apple-iphone-15-black-128-gb/p/itm2d73c24d4370a'},
            'Croma': {'price': 71900.0, 'originalPrice': 79900.0, 'rating': 4.4, 'deliveryCharge': 0.0, 'buyLink': 'https://www.croma.com/apple-iphone-15-128gb-black/p/300652'},
            'Reliance Digital': {'price': 71500.0, 'originalPrice': 79900.0, 'rating': 4.5, 'deliveryCharge': 0.0, 'buyLink': 'https://www.reliancedigital.in/apple-iphone-15-128-gb-black/p/494229999'},
        }
    },
    {
        'id': 'macbookair',
        'name': 'Apple MacBook Air Laptop M2 (8GB RAM, 256GB SSD)',
        'category': 'Electronics',
        'imageUrl': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?q=80&w=400',
        'platforms': {
            'Amazon': {'price': 89900.0, 'originalPrice': 99900.0, 'rating': 4.7, 'deliveryCharge': 0.0, 'buyLink': 'https://www.amazon.in/dp/B0B3C56SKB'},
            'Flipkart': {'price': 88490.0, 'originalPrice': 99900.0, 'rating': 4.6, 'deliveryCharge': 99.0, 'buyLink': 'https://www.flipkart.com/apple-2022-macbook-air-m2-8-gb-256-gb-ssd/p/itm12345'},
            'Croma': {'price': 89100.0, 'originalPrice': 99900.0, 'rating': 4.5, 'deliveryCharge': 0.0, 'buyLink': 'https://www.croma.com/apple-macbook-air-m2/p/256789'},
            'Reliance Digital': {'price': 89500.0, 'originalPrice': 99900.0, 'rating': 4.6, 'deliveryCharge': 0.0, 'buyLink': 'https://www.reliancedigital.in/apple-macbook-air-m2/p/4923456'},
        }
    },
    {
        'id': 'sonywh1000xm4',
        'name': 'Sony WH-1000XM4 Wireless Noise Cancelling Headphones',
        'category': 'Electronics',
        'imageUrl': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=400',
        'platforms': {
            'Amazon': {'price': 19990.0, 'originalPrice': 29990.0, 'rating': 4.6, 'deliveryCharge': 0.0, 'buyLink': 'https://www.amazon.in/dp/B08C56GNEK'},
            'Flipkart': {'price': 20990.0, 'originalPrice': 29990.0, 'rating': 4.5, 'deliveryCharge': 40.0, 'buyLink': 'https://www.flipkart.com/sony-wh-1000xm4-active-noise-cancellation/p/itm123'},
            'Croma': {'price': 19999.0, 'originalPrice': 29990.0, 'rating': 4.4, 'deliveryCharge': 0.0, 'buyLink': 'https://www.croma.com/sony-wh-1000xm4/p/1234'},
            'Reliance Digital': {'price': 20490.0, 'originalPrice': 29990.0, 'rating': 4.5, 'deliveryCharge': 0.0, 'buyLink': 'https://www.reliancedigital.in/sony-wh-1000xm4/p/5678'},
        }
    },
    {
        'id': 'nike_air_max',
        'name': 'Nike Air Max Men\'s Running Shoes',
        'category': 'Footwear',
        'imageUrl': 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=400',
        'platforms': {
            'Amazon': {'price': 7495.0, 'originalPrice': 9995.0, 'rating': 4.3, 'deliveryCharge': 100.0, 'buyLink': 'https://www.amazon.in/dp/nike-air-max'},
            'Flipkart': {'price': 7299.0, 'originalPrice': 9995.0, 'rating': 4.2, 'deliveryCharge': 50.0, 'buyLink': 'https://www.flipkart.com/nike-air-max'},
            'Myntra': {'price': 6996.0, 'originalPrice': 9995.0, 'rating': 4.4, 'deliveryCharge': 0.0, 'buyLink': 'https://www.myntra.com/nike-air-max'},
            'Meesho': {'price': 6499.0, 'originalPrice': 9995.0, 'rating': 3.9, 'deliveryCharge': 0.0, 'buyLink': 'https://www.meesho.com/nike-air-max'},
        }
    },
    {
        'id': 'levis_jeans',
        'name': 'Levi\'s Men\'s 511 Slim Fit Jeans',
        'category': 'Fashion',
        'imageUrl': 'https://images.unsplash.com/photo-1542272604-787c3835535d?q=80&w=400',
        'platforms': {
            'Amazon': {'price': 1899.0, 'originalPrice': 3299.0, 'rating': 4.1, 'deliveryCharge': 40.0, 'buyLink': 'https://www.amazon.in/levis-511'},
            'Flipkart': {'price': 1799.0, 'originalPrice': 3299.0, 'rating': 4.0, 'deliveryCharge': 40.0, 'buyLink': 'https://www.flipkart.com/levis-511'},
            'Myntra': {'price': 1649.0, 'originalPrice': 3299.0, 'rating': 4.2, 'deliveryCharge': 0.0, 'buyLink': 'https://www.myntra.com/levis-511'},
            'Meesho': {'price': 1499.0, 'originalPrice': 3299.0, 'rating': 3.8, 'deliveryCharge': 0.0, 'buyLink': 'https://www.meesho.com/levis-511'},
        }
    },
    {
        'id': 'boat_smartwatch',
        'name': 'boAt Xtend Smartwatch with Alexa Built-in',
        'category': 'Electronics',
        'imageUrl': 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?q=80&w=400',
        'platforms': {
            'Amazon': {'price': 1999.0, 'originalPrice': 7990.0, 'rating': 4.1, 'deliveryCharge': 40.0, 'buyLink': 'https://www.amazon.in/dp/boat-smartwatch'},
            'Flipkart': {'price': 1899.0, 'originalPrice': 7990.0, 'rating': 4.2, 'deliveryCharge': 40.0, 'buyLink': 'https://www.flipkart.com/boat-smartwatch'},
            'Croma': {'price': 2199.0, 'originalPrice': 7990.0, 'rating': 4.0, 'deliveryCharge': 0.0, 'buyLink': 'https://www.croma.com/boat-smartwatch'},
            'Reliance Digital': {'price': 1999.0, 'originalPrice': 7990.0, 'rating': 4.1, 'deliveryCharge': 0.0, 'buyLink': 'https://www.reliancedigital.in/boat-smartwatch'},
            'Meesho': {'price': 1799.0, 'originalPrice': 7990.0, 'rating': 3.7, 'deliveryCharge': 0.0, 'buyLink': 'https://www.meesho.com/boat-smartwatch'},
        }
    }
]

# Helper to construct product instances from dataset
def get_representative_products():
    reps = []
    for item in BASE_PRODUCTS:
        # Find store with lowest price
        best_platform = list(item['platforms'].keys())[0]
        min_price = item['platforms'][best_platform]['price']
        for p, details in item['platforms'].items():
            if details['price'] < min_price:
                min_price = details['price']
                best_platform = p
        
        details = item['platforms'][best_platform]
        disc = ((details['originalPrice'] - details['price']) / details['originalPrice']) * 100
        
        reps.append({
            'base_id': item['id'],
            'name': item['name'],
            'category': item['category'],
            'imageUrl': item['imageUrl'],
            'platform': best_platform,
            'price': details['price'],
            'originalPrice': details['originalPrice'],
            'discount': round(disc, 1),
            'rating': details['rating'],
            'deliveryCharge': details['deliveryCharge'],
            'buyLink': details['buyLink'],
            'all_platforms': list(item['platforms'].keys())
        })
    return reps

def search_products(query):
    reps = get_representative_products()
    if not query:
        return reps
    q = query.lower()
    return [p for p in reps if q in p['name'].lower() or q in p['category'].lower()]

def get_comparisons(base_id):
    item = next((x for x in BASE_PRODUCTS if x['id'] == base_id), None)
    if not item:
        return []
    
    comparisons = []
    for platform, details in item['platforms'].items():
        disc = ((details['originalPrice'] - details['price']) / details['originalPrice']) * 100
        comparisons.append({
            'name': item['name'],
            'imageUrl': item['imageUrl'],
            'category': item['category'],
            'platform': platform,
            'price': details['price'],
            'originalPrice': details['originalPrice'],
            'discount': round(disc, 1),
            'rating': details['rating'],
            'deliveryCharge': details['deliveryCharge'],
            'buyLink': details['buyLink']
        })
    # Sort ascending by price
    comparisons.sort(key=lambda x: x['price'])
    return comparisons

# --- Session State Initializer ---
if 'authenticated' not in st.session_state:
    st.session_state.authenticated = False
if 'user' not in st.session_state:
    st.session_state.user = None
if 'current_page' not in st.session_state:
    st.session_state.current_page = 'Home'
if 'wishlist' not in st.session_state:
    st.session_state.wishlist = []
if 'compare_queue' not in st.session_state:
    st.session_state.compare_queue = []
if 'alerts' not in st.session_state:
    st.session_state.alerts = []
if 'search_val' not in st.session_state:
    st.session_state.search_val = ""
if 'selected_base_id' not in st.session_state:
    st.session_state.selected_base_id = None

# --- Helper Navigation Functions ---
def navigate_to(page):
    st.session_state.current_page = page
    st.session_state.selected_base_id = None
    st.rerun()

def get_badge_html(platform):
    classes = {
        'Amazon': 'badge-amazon',
        'Flipkart': 'badge-flipkart',
        'Meesho': 'badge-meesho',
        'Myntra': 'badge-myntra',
        'Croma': 'badge-croma',
        'Reliance Digital': 'badge-reliance'
    }
    cls = classes.get(platform, 'badge-amazon')
    return f'<span class="{cls}">{platform}</span>'

# --- 1. Login / Sign Up Page ---
if not st.session_state.authenticated:
    st.markdown("""
    <style>
    .stApp {
        background: linear-gradient(135deg, #F5F3FF 0%, #FDF2F8 50%, #EFF6FF 100%) !important;
    }
    div[data-testid="stForm"] {
        background-color: #FFFFFF !important;
        border-radius: 30px !important;
        border: none !important;
        box-shadow: 0 20px 40px rgba(139, 92, 246, 0.08) !important;
        padding: 32px !important;
        max-width: 400px !important;
        margin: 20px auto 0 auto !important;
    }
    div[data-testid="stForm"]::before {
        display: none !important;
    }
    div[data-testid="stTextField"] input {
        border-radius: 25px !important;
        background-color: #F8FAFC !important;
        border: 1px solid #E2E8F0 !important;
        padding: 12px 20px !important;
        font-size: 14px !important;
        height: auto !important;
    }
    /* Style form submit button as pink-purple gradient */
    div[data-testid="stForm"] button {
        background: linear-gradient(135deg, #EC4899 0%, #8B5CF6 100%) !important;
        color: #FFFFFF !important;
        border: none !important;
        border-radius: 25px !important;
        font-weight: 700 !important;
        padding: 12px 24px !important;
        font-size: 15px !important;
        width: 100% !important;
        box-shadow: 0 4px 15px rgba(236, 72, 153, 0.3) !important;
        transition: all 0.2s !important;
    }
    div[data-testid="stForm"] button:hover {
        transform: translateY(-1px) !important;
        box-shadow: 0 6px 20px rgba(236, 72, 153, 0.4) !important;
        color: #FFFFFF !important;
    }
    /* Style columns and round social buttons */
    div[data-testid="stHorizontalBlock"] div[data-testid="stColumn"] button {
        border-radius: 50% !important;
        width: 46px !important;
        height: 46px !important;
        min-width: 46px !important;
        margin: 0 auto !important;
        display: flex !important;
        align-items: center !important;
        justify-content: center !important;
        background-color: #FFFFFF !important;
        border: 1px solid #E2E8F0 !important;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.03) !important;
        color: #475569 !important;
        font-size: 16px !important;
        font-weight: bold !important;
        padding: 0 !important;
        line-height: 46px !important;
        transition: all 0.2s !important;
    }
    div[data-testid="stHorizontalBlock"] div[data-testid="stColumn"] button:hover {
        border-color: #8B5CF6 !important;
        color: #8B5CF6 !important;
        transform: scale(1.05) !important;
    }
    </style>
    """, unsafe_allow_html=True)
    
    col1, col2, col3 = st.columns([1, 1.8, 1])
    with col2:
        st.image("login_char.png", use_container_width=True)
        
        with st.form("login_form", clear_on_submit=False):
            st.markdown("<h2 style='text-align: center; color: #1E1B4B; margin-bottom: 2px; font-weight: 800; font-family: Outfit, sans-serif;'>Welcome Back!</h2>", unsafe_allow_html=True)
            st.markdown("<p style='text-align: center; color: #6B7280; font-size: 13px; margin-bottom: 20px;'>Login to continue</p>", unsafe_allow_html=True)
            
            email = st.text_input("Username / Email", placeholder="Username / Email", label_visibility="collapsed")
            password = st.text_input("Password", type="password", placeholder="Password", label_visibility="collapsed")
            
            st.markdown("<div style='text-align: right; margin-top: -8px; margin-bottom: 16px;'><a href='#' style='color: #8B5CF6; font-size: 11px; text-decoration: none; font-weight: 600;'>Forgot Password?</a></div>", unsafe_allow_html=True)
            
            submitted = st.form_submit_button("Login")
            if submitted:
                if "@" in email and len(password) >= 6:
                    name = email.split('@')[0].capitalize()
                    st.session_state.authenticated = True
                    st.session_state.user = {
                        'name': name,
                        'email': email,
                        'photoUrl': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150',
                        'loginMethod': 'email'
                    }
                    st.success("Successfully Logged In!")
                    time.sleep(0.5)
                    st.rerun()
                else:
                    st.error("Invalid email or password (min 6 characters)")
                    
        st.markdown("<div style='text-align: center; color: #94A3B8; font-size: 11px; margin: 16px 0;'>or continue with</div>", unsafe_allow_html=True)
        
        col_g, col_a, col_f = st.columns([1, 1, 1])
        with col_g:
            if st.button("G", key="google_login", use_container_width=True):
                st.session_state.authenticated = True
                st.session_state.user = {
                    'name': 'Alex Carter',
                    'email': 'alex.carter@gmail.com',
                    'photoUrl': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150',
                    'loginMethod': 'google'
                }
                st.success("Successfully Authenticated via Google!")
                time.sleep(0.5)
                st.rerun()
        with col_a:
            if st.button("", key="apple_login", use_container_width=True):
                st.session_state.authenticated = True
                st.session_state.user = {
                    'name': 'Alex Carter',
                    'email': 'alex.carter@gmail.com',
                    'photoUrl': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150',
                    'loginMethod': 'apple'
                }
                st.success("Successfully Authenticated via Apple!")
                time.sleep(0.5)
                st.rerun()
        with col_f:
            if st.button("f", key="facebook_login", use_container_width=True):
                st.session_state.authenticated = True
                st.session_state.user = {
                    'name': 'Alex Carter',
                    'email': 'alex.carter@gmail.com',
                    'photoUrl': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150',
                    'loginMethod': 'facebook'
                }
                st.success("Successfully Authenticated via Facebook!")
                time.sleep(0.5)
                st.rerun()
                
        st.markdown("<div style='text-align: center; margin-top: 20px; font-size: 12px; color: #6B7280;'>Don't have an account? <a href='#' style='color: #8B5CF6; font-weight: 700; text-decoration: none;'>Sign Up</a></div>", unsafe_allow_html=True)

# --- App Content (Authenticated) ---
else:
    # --- Sidebar Mobile Layout Navigation ---
    with st.sidebar:
        st.markdown(f"""
        <div style='text-align: center; margin-bottom: 24px;'>
            <img src='{st.session_state.user["photoUrl"]}' style='border-radius: 50%; width: 70px; height: 70px;'/>
            <h4 style='margin-top: 8px; color: #0D47A1; margin-bottom: 0;'>{st.session_state.user["name"]}</h4>
            <span style='font-size: 11px; color: grey;'>({st.session_state.user["loginMethod"].upper()} Login)</span>
        </div>
        """, unsafe_allow_html=True)
        
        st.markdown("<hr style='margin-top: 0;'>", unsafe_allow_html=True)
        
        # Navigation Options
        pages = ["Home 🏠", "Compare Queue 🔄", "Wishlist ❤️", "Price Alerts 🔔", "Profile 👤"]
        for p in pages:
            label = p.split(" ")[0]
            if st.button(p, use_container_width=True, type="secondary" if st.session_state.current_page != label else "primary"):
                navigate_to(label)
                
        st.markdown("<br><br><br><br>", unsafe_allow_html=True)
        if st.button("Log Out 🚪", use_container_width=True):
            st.session_state.authenticated = False
            st.session_state.user = None
            st.rerun()

    # --- Screen 2: Single Product Platforms Comparison Mode ---
    if st.session_state.selected_base_id is not None:
        comparisons = get_comparisons(st.session_state.selected_base_id)
        if comparisons:
            product = comparisons[0]
            col_back, col_title = st.columns([1, 10])
            with col_back:
                if st.button("← Back"):
                    st.session_state.selected_base_id = None
                    st.rerun()
            
            st.markdown(f"## {product['name']}")
            
            col_img, col_act = st.columns([1, 2])
            with col_img:
                st.image(product['imageUrl'], use_container_width=True)
            with col_act:
                st.markdown(f"**Category**: {product['category']}")
                st.markdown(f"**Rating**: ⭐ {product['rating']}")
                st.markdown("---")
                
                # Alerts & Wishlist Quick Buttons
                col_al, col_wi = st.columns([1, 1])
                with col_al:
                    # Price Alert setup
                    st.subheader("Set Price Alert 🔔")
                    target = st.number_input("Target Price (₹)", min_value=1.0, max_value=product['price']-1.0, value=product['price'] * 0.90, step=100.0)
                    if st.button("Set Alert threshold", use_container_width=True):
                        # Avoid duplicate
                        st.session_state.alerts = [a for a in st.session_state.alerts if a['name'] != product['name']]
                        st.session_state.alerts.append({
                            'id': f"alert_{int(time.time())}",
                            'name': product['name'],
                            'imageUrl': product['imageUrl'],
                            'platform': product['platform'],
                            'target_price': target,
                            'initial_price': product['price'],
                            'current_price': product['price'],
                            'triggered': False
                        })
                        st.success(f"Alert set at ₹{target:.0f}!")
                
                with col_wi:
                    st.subheader("Wishlist Options ❤️")
                    is_liked = product['name'] in st.session_state.wishlist
                    if st.button("Remove from Wishlist" if is_liked else "Add to Wishlist", use_container_width=True):
                        if is_liked:
                            st.session_state.wishlist.remove(product['name'])
                            st.info("Removed from wishlist.")
                        else:
                            st.session_state.wishlist.append(product['name'])
                            st.success("Added to wishlist!")
                        time.sleep(0.3)
                        st.rerun()
                        
            st.markdown("### Compare Platform Offers")
            for idx, comp in enumerate(comparisons):
                is_best = idx == 0
                bg_color = "#E8F5E9" if is_best else "#FFFFFF"
                border_style = "2px solid #4CAF50" if is_best else "1px solid #E0E0E0"
                
                col_row_1, col_row_2, col_row_3 = st.columns([2, 5, 2])
                with col_row_1:
                    st.markdown(f"<div style='margin-top: 15px;'>{get_badge_html(comp['platform'])}</div>", unsafe_allow_html=True)
                with col_row_2:
                    st.markdown(f"""
                    <div style='padding: 8px; background-color: {bg_color}; border: {border_style}; border-radius: 8px;'>
                        <strong style='font-size: 16px; color: #0D47A1;'>₹{comp['price']:.0f}</strong> 
                        <span style='text-decoration: lineThrough; color: grey; font-size: 12px;'>₹{comp['originalPrice']:.0f}</span> 
                        <span style='color: green; font-weight: bold; font-size: 12px;'>{comp['discount']}% OFF</span><br>
                        <span style='font-size: 11px; color: grey;'>Delivery: {"Free" if comp['deliveryCharge']==0 else f"₹{comp['deliveryCharge']:.0f}"} | Rating: ⭐ {comp['rating']}</span>
                    </div>
                    """, unsafe_allow_html=True)
                with col_row_3:
                    st.markdown("<div style='height:12px;'></div>", unsafe_allow_html=True)
                    if is_best:
                        st.markdown("<span style='color:green; font-weight:bold; font-size:10px;'>BEST DEAL ⭐</span>", unsafe_allow_html=True)
                    st.link_button("Buy Now 🚀", comp['buyLink'], type="primary" if is_best else "secondary")

    # --- Screen 3: Home View ---
    elif st.session_state.current_page == 'Home':
        st.markdown("<h2 style='color: #0D47A1; margin-bottom: 2px;'>CompareKart Dashboard</h2>", unsafe_allow_html=True)
        st.markdown("<p style='color: grey; font-size: 13px;'>Real-time price index search comparison tool</p>", unsafe_allow_html=True)
        
        # Search Box
        search_query = st.text_input("🔎 Search products across stores...", value=st.session_state.search_val, placeholder="e.g. iPhone, Nike, MacBook...")
        
        # Category Tags Row
        st.markdown("**Shop Categories:**")
        cols_cat = st.columns(4)
        cats = [("Electronics 📱", "Electronics"), ("Fashion 👕", "Fashion"), ("Footwear 👟", "Footwear"), ("Appliances 🍳", "Appliances")]
        for idx, (label, val) in enumerate(cats):
            if cols_cat[idx].button(label, use_container_width=True):
                st.session_state.search_val = val
                st.rerun()
                
        if st.session_state.search_val:
            if st.button("Clear Category Filters"):
                st.session_state.search_val = ""
                st.rerun()
                
        # Handle Search Results Rendering
        query_to_run = search_query if search_query else st.session_state.search_val
        if query_to_run:
            results = search_products(query_to_run)
            st.markdown(f"### Results for '{query_to_run}' ({len(results)} matches)")
            
            # Sort filters
            sort_opt = st.selectbox("Sort By:", ["Lowest Price 💸", "Highest Rating ⭐", "Best Discount 🏷️"])
            if "Lowest Price" in sort_opt:
                results.sort(key=lambda x: x['price'])
            elif "Highest Rating" in sort_opt:
                results.sort(key=lambda x: x['rating'], reverse=True)
            elif "Best Discount" in sort_opt:
                results.sort(key=lambda x: x['discount'], reverse=True)
                
            if not results:
                st.warning("No products matched your search. Try looking up 'iphone' or 'nike'.")
            else:
                for res in results:
                    # Find base product to pass on
                    col_p1, col_p2, col_p3 = st.columns([1, 3, 1])
                    with col_p1:
                        st.image(res['imageUrl'], width=100)
                    with col_p2:
                        st.markdown(f"#### {res['name']}")
                        st.markdown(f"Lowest Price: **₹{res['price']:.0f}** at {get_badge_html(res['platform'])} (Original: ~₹{res['originalPrice']:.0f})", unsafe_allow_html=True)
                        st.markdown(f"⭐ {res['rating']} | {res['discount']}% off | Available at {len(res['all_platforms'])} platforms.")
                    with col_p3:
                        st.markdown("<div style='height: 15px;'></div>", unsafe_allow_html=True)
                        if st.button("Compare Prices 🔍", key=f"cmp_{res['base_id']}"):
                            st.session_state.selected_base_id = res['base_id']
                            st.rerun()
                            
                        # Compare Queue toggler
                        in_q = any(x['name'] == res['name'] for x in st.session_state.compare_queue)
                        if st.button("Remove Compare" if in_q else "Add to Compare", key=f"q_{res['base_id']}"):
                            if in_q:
                                st.session_state.compare_queue = [x for x in st.session_state.compare_queue if x['name'] != res['name']]
                                st.info("Removed from Compare Queue")
                            else:
                                if len(st.session_state.compare_queue) >= 3:
                                    st.session_state.compare_queue.pop(0) # circular
                                st.session_state.compare_queue.append(res)
                                st.success("Added to Compare Queue!")
                            time.sleep(0.3)
                            st.rerun()
        else:
            # Promo Banner
            st.markdown("""
            <div style='background: linear-gradient(135deg, #0D47A1 0%, #1976D2 100%); padding: 24px; border-radius: 12px; color: white; margin-bottom: 24px;'>
                <span style='background-color:rgba(255,255,255,0.2); padding: 4px 8px; border-radius: 4px; font-size:10px; font-weight:bold;'>PROMOTED VALUE</span>
                <h3 style='color: white; margin-top:10px; margin-bottom: 2px;'>Compare Prices. Save up to 45% Instantly</h3>
                <p style='font-size: 13px; margin-bottom: 0;'>Look up tech products, apparel and get indexed prices across 6 major Indian shopping platforms.</p>
            </div>
            """, unsafe_allow_html=True)
            
            # Trending & Hot Deals
            st.markdown("### Trending Offers (Highly Rated)")
            trends = get_representative_products()
            trends.sort(key=lambda x: x['rating'], reverse=True)
            cols_t = st.columns(4)
            for i, p in enumerate(trends[:4]):
                with cols_t[i]:
                    st.image(p['imageUrl'], use_container_width=True)
                    st.markdown(f"**{p['name'][:22]}...**")
                    st.markdown(f"₹{p['price']:.0f} at {p['platform']}")
                    if st.button("View Options 🔍", key=f"trend_{p['base_id']}"):
                        st.session_state.selected_base_id = p['base_id']
                        st.rerun()

    # --- Screen 4: Compare Queue Dashboard ---
    elif st.session_state.current_page == 'Compare':
        st.markdown("## Compare Queue Dashboard 🔄")
        queue = st.session_state.compare_queue
        
        if not queue:
            st.info("Your Compare Queue is empty. Search products on the Home screen and add them to compare.")
        else:
            st.warning(f"Comparing {len(queue)} items side-by-side (Max 3).")
            if st.button("Clear Queue"):
                st.session_state.compare_queue = []
                st.rerun()
                
            cols_cmp = st.columns(len(queue) + 1)
            # Row labels
            with cols_cmp[0]:
                st.markdown("<div style='height:120px;'></div>", unsafe_allow_html=True)
                st.markdown("**Product**")
                st.markdown("**Best Platform**")
                st.markdown("**Price**")
                st.markdown("**Discount**")
                st.markdown("**Rating**")
                st.markdown("**Delivery charge**")
                st.markdown("**Action**")
                
            for idx, prod in enumerate(queue):
                with cols_cmp[idx + 1]:
                    st.image(prod['imageUrl'], height=100)
                    st.markdown(f"**{prod['name'][:28]}**")
                    st.markdown(get_badge_html(prod['platform']), unsafe_allow_html=True)
                    st.markdown(f"₹{prod['price']:.0f}")
                    st.markdown(f"{prod['discount']}% OFF")
                    st.markdown(f"⭐ {prod['rating']}")
                    st.markdown("Free" if prod['deliveryCharge']==0 else f"₹{prod['deliveryCharge']:.0f}")
                    if st.button("Remove ❌", key=f"del_q_{prod['base_id']}"):
                        st.session_state.compare_queue.remove(prod)
                        st.rerun()

    # --- Screen 5: Wishlist View ---
    elif st.session_state.current_page == 'Wishlist':
        st.markdown("## My Wishlist ❤️")
        wish = st.session_state.wishlist
        
        if not wish:
            st.info("Your Wishlist is empty. Click the heart buttons on product pages to save them.")
        else:
            reps = get_representative_products()
            wish_items = [p for p in reps if p['name'] in wish]
            
            for item in wish_items:
                col_w1, col_w2, col_w3 = st.columns([1, 4, 1])
                with col_w1:
                    st.image(item['imageUrl'], width=80)
                with col_w2:
                    st.markdown(f"#### {item['name']}")
                    st.markdown(f"Available from: **₹{item['price']:.0f}** | Store: {get_badge_html(item['platform'])}", unsafe_allow_html=True)
                with col_w3:
                    st.markdown("<div style='height: 12px;'></div>", unsafe_allow_html=True)
                    if st.button("Compare 🔍", key=f"wish_cmp_{item['base_id']}"):
                        st.session_state.selected_base_id = item['base_id']
                        st.rerun()
                    if st.button("Remove ❌", key=f"wish_rem_{item['base_id']}"):
                        st.session_state.wishlist.remove(item['name'])
                        st.rerun()

    # --- Screen 6: Price Drop Alerts View ---
    elif st.session_state.current_page == 'Alerts':
        st.markdown("## Active Price Alerts 🔔")
        alerts = st.session_state.alerts
        
        if not alerts:
            st.info("No active price alerts set. Visit a product's compare page to register target drop indicators.")
        else:
            st.info("💡 Interactivity: Click the 'Simulate Drop' button on any alert card to test drop notification signals!")
            for al in alerts:
                bg_col = "#E8F5E9" if al['triggered'] else "#FFFFFF"
                border_st = "1.5px solid #4CAF50" if al['triggered'] else "1px solid #E0E0E0"
                
                st.markdown(f"""
                <div style='background-color:{bg_col}; border:{border_st}; padding:14px; border-radius:12px; margin-bottom:12px;'>
                    <span style='float:right; font-weight:bold; font-size:10px; padding:4px 6px; border-radius:4px; background-color:{"#4CAF50" if al["triggered"] else "#FFC107"}; color:{"white" if al["triggered"] else "#5D4037"};'>
                        {"ALERT TRIGGERED 🔔" if al["triggered"] else "MONITORING"}
                    </span>
                    <strong style='font-size:14px;'>{al['name']}</strong><br>
                    <span style='font-size:12px; color:grey;'>Store: {al['platform']}</span><br>
                    <div style='display:flex; gap:20px; margin-top:8px;'>
                        <div><span style='font-size:10px; color:grey;'>Initial Price</span><br><strong>₹{al['initial_price']:.0f}</strong></div>
                        <div><span style='font-size:10px; color:grey;'>Target Threshold</span><br><strong style='color:#0D47A1;'>₹{al['target_price']:.0f}</strong></div>
                        <div><span style='font-size:10px; color:grey;'>Current Price</span><br><strong style='color:{"green" if al["triggered"] else "amber"};'>₹{al['current_price']:.0f}</strong></div>
                    </div>
                </div>
                """, unsafe_allow_html=True)
                
                col_sim1, col_sim2 = st.columns([1, 5])
                with col_sim1:
                    if al['triggered']:
                        if st.button("Reset Alert Price 🔄", key=f"rst_{al['id']}"):
                            al['current_price'] = al['initial_price']
                            al['triggered'] = False
                            st.rerun()
                    else:
                        if st.button("Simulate Drop 💸", key=f"sim_{al['id']}"):
                            # Drop below target price by 3%
                            al['current_price'] = al['target_price'] - 150.0
                            al['triggered'] = True
                            st.toast(f"🔔 Price drop triggered for {al['name'][:20]}...!", icon="🎉")
                            st.rerun()
                with col_sim2:
                    if st.button("Delete Alert ❌", key=f"del_al_{al['id']}"):
                        st.session_state.alerts.remove(al)
                        st.rerun()

    # --- Screen 7: Profile Screen ---
    elif st.session_state.current_page == 'Profile':
        st.markdown("## My Profile 👤")
        u = st.session_state.user
        
        col_avatar, col_uinfo = st.columns([1, 4])
        with col_avatar:
            st.image(u['photoUrl'], width=120)
        with col_uinfo:
            st.markdown(f"### {u['name']}")
            st.markdown(f"**Email**: {u['email']}")
            st.markdown(f"**Provider**: {u['loginMethod'].upper()}")
            
        st.markdown("---")
        st.subheader("Preferences")
        st.toggle("Price Drop Notifications", value=True)
        st.toggle("Dark Theme (Simulation)", value=False)
        
        st.markdown("---")
        st.subheader("Stats Counters")
        col_s1, col_s2, col_s3 = st.columns(3)
        col_s1.metric("Favorites", len(st.session_state.wishlist))
        col_s2.metric("Active Alerts", len(st.session_state.alerts))
        col_s3.metric("Compare Queue Size", len(st.session_state.compare_queue))
        
        st.markdown("<br>", unsafe_allow_html=True)
        if st.button("Log Out 🚪", type="primary"):
            st.session_state.authenticated = False
            st.session_state.user = None
            st.rerun()
