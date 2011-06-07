# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

secret = ENV['SECRET_TOKEN']
secret ||= 'd8d65b60d2538b4bde0eba2080aa08a06f6d74433012cf641d5eda2f99315f1eb17e33d4a3bbe86947656b21fab4090c226029157944b3415417cda184e3ff79'

Oddit::Application.config.secret_token = secret
