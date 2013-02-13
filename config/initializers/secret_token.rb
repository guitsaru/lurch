# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
Lurch::Application.config.secret_token = ENV['SECRET_TOKEN'] || '27002d54cf3964eef276330e968102a32b1cbe077bf4f3762af642223a5fc33d97ada47f8677ed698e00eb868e6c7944c8c10332750623a0e16b9a41ad0d5b92'
