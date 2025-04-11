from flask import Flask, redirect, url_for, session
from authlib.integrations.flask_client import OAuth
from dotenv import load_dotenv
import os

_ = load_dotenv()

app = Flask(__name__)
app.secret_key = os.urandom(24)
oauth = OAuth(app)

oauth.register(
    name='oidc',
    # Points identity provider (Cognito)
    authority='https://cognito-idp.eu-central-1.amazonaws.com/eu-central-1_qpQXeCBsA',
    # client_id :: unique identifier assigned to the app by the identity provider during the OAuth/OIDC flow
    client_id=os.getenv("AWS_COGNITO_CLIENT_IS"),
    # By default, some Cognito App Clients are set up as public (web or mobile apps that can’t securely store secrets)
    # that's why does not require client_secret
    client_secret='<client secret>',
    # This URL allows your OAuth client to dynamically retrieve configuration details from Cognito
    server_metadata_url=os.getenv("AWS_COGNITO_SERVER_METADATA_URL"),
    # 'scope' defines which permissions of user info the app is requesting from the identity provider.
    # openid: tells the identity provider that your application wants to authenticate the user and receive an ID token.
    # email: requests access to the user's email address.
    # phone: requests access to the user's phone number.
    client_kwargs={'scope': 'phone openid email'}
)


@app.route('/')
def index():
    user = session.get('user')
    if user:
        return f'Hello, {user["email"]}. <a href="/logout">Logout</a>'
    else:
        return f'Welcome! Please <a href="/login">Login</a>.'


@app.route('/login')
def login():
    # Alternate option to redirect to /authorize
    # redirect_uri = url_for('authorize', _external=True)
    # return oauth.oidc.authorize_redirect(redirect_uri)
    return oauth.oidc.authorize_redirect('https://d84l1y8p4kdic.cloudfront.net')


@app.route('/authorize')
def authorize():
    token = oauth.oidc.authorize_access_token()
    user = token['userinfo']
    session['user'] = user
    return redirect(url_for('index'))


@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('index'))


if __name__ == '__main__':
    app.run(debug=True)
