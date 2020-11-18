# -*- coding: utf-8 -*- 
from flask import render_template, flash, redirect, url_for, request
from flask_login import login_user, logout_user, current_user, login_required
from werkzeug.urls import url_parse
from app import app, db
from app.forms import LoginForm, RegistrationForm, EditProfileForm
from app.models import User, Post, SumMntSale
from datetime import datetime

@login_required
@app.route('/')
@app.route('/index')
def index():
    posts = [
        {
            'author': {'username': 'John'},
            'body': 'Beautiful day in Portland!'
        }
    ]
    top_sales = get_top_sales()
    return render_template('index.html', title='Home', posts=posts, top_sales = top_sales)

@app.route('/login', methods=['GET', 'POST'])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        if user is None or not user.check_password(form.password.data):
            flash('Неправильное имя пользователя или пароль')
            return redirect(url_for('login'))
        login_user(user, remember=form.remember_me.data)
        next_page = request.args.get('next')
        if not next_page or url_parse(next_page).netloc != '':
            next_page = url_for('index')
        return redirect(next_page)
    return render_template('login.html', title='Вход', form=form)

@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('index'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    if current_user.is_authenticated:
        return redirect(url_for('index'))
    form = RegistrationForm()
    if form.validate_on_submit():
        user = User(username=form.username.data, email=form.email.data)
        user.set_password(form.password.data)
        db.session.add(user)
        db.session.commit()
        flash('Поздравляем, теперь вы зарегистрированный пользователь!')
        return redirect(url_for('login'))
    return render_template('register.html', title='Регистрация', form=form)

@app.route('/user/<username>')
@login_required
def user(username):
    user = User.query.filter_by(username=username).first_or_404()
    return render_template('user.html', user=user, posts=user.posts)

@app.before_request
def before_request():
    if current_user.is_authenticated:
        current_user.last_seen = datetime.utcnow()
        db.session.commit()

@app.route('/edit_profile', methods=['GET', 'POST'])
@login_required
def edit_profile():
    form = EditProfileForm(current_user.username)
    if form.validate_on_submit():
        current_user.username = form.username.data
        current_user.about_me = form.about_me.data
        db.session.commit()
        flash('Ваши изменения были сохранены.')
        return redirect(url_for('edit_profile'))
    elif request.method == 'GET':
        form.username.data = current_user.username
        form.username.data = current_user.about_me
    return render_template('edit_profile.html', title='Изменить профиль', form=form)


@app.route('/user/<int:uid>')
def get_userinfo(uid):
    user = User.query.get(uid)
    print ('render with user_id = ', uid)
    return render_template('my_template.html', user=user)


@app.route('/pie')
def pie():
    labels = ['Большая часть', 'что-то незначительное', 'меньшая часть']
    values = [100, 15, 39]
    colors = [ "#F7464A", "#46BFBD", "#ABCDEF" ]
    return render_template('pie.html', title='Bitcoin Monthly Price in USD', max=17000, set=zip(values, labels, colors))

@app.route('/bar')
def bar():
    labels = ['Большая часть', 'что-то незначительное']
    values = [10000, 140000]
    return render_template('bar.html', title='Bitcoin Monthly Price in USD', max=150000, labels=labels, values=values)


@app.route('/top_sales')
@login_required
def top_sales():
    top_sales = get_top_sales()
    return render_template('top_sales.html', title='Топ продаж по типам магазинов', top_sales = top_sales)

def get_top_sales():
    return SumMntSale.query.all()