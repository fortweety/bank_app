# README

run steps

- cp database.yml.example database.yml
- rake db:create
- rake db:migrate
- rails s

Functional:

- User.create_user(email, pass) for create user and account

- User.add_deposite(id, amount) for invest money to account *amount has bigdecimal format u could use 2 symbols after . for example '155.55'
  without condition who deposite to user , he deposite himself :)

transfer operations allow in application non console mode from ui

