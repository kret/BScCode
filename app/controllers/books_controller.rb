class BooksController < ApplicationController

  def new
    @book = Book.new
  end

  def create
    book_hash = {}
    if params[:book][:book_json]
      bj = params[:book].delete :book_json
      book_hash = ActiveSupport::JSON.decode bj unless bj.blank?
    end
    book_hash.merge! params[:book]

    @book = Book.new book_hash
    if @book.save
      redirect_to @book, :notice => t('book.flash.created_successfully')
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render :json => { :status => :invalid, :errors => @book.errors } }
      end
    end
  end

  def show
    @book = Book.find params[:id]
  end

  def get_preferences
    book = Book.find params[:id]
    # for demo hardcoding is good enough; normally this would be taken from session
    user = User.find 1
    if user.id == 1
      prefs = Preference.find_for_book_and_user book, user
      render :json => { :status => :ok, :preferences => prefs }
    else
      render :json => { :status => :invalid }
    end
  end

  def set_preferences
    book = Book.find params[:id]
    # for demo hardcoding is good enough; normally this would be taken from session
    user = User.find 1
    if user.id == 1
      pv = ActiveSupport::JSON.decode params[:preferences] || ""
      prefs = Preference.find_for_book_and_user book, user
      if prefs.empty?
        prefs = Preference.new pv
        prefs.user = user
        prefs.book = book
      else
        prefs = prefs.first
        prefs.update_attributes pv
      end
      if prefs.save
        render :json => { :status => :ok, :preferences => prefs }
      else
        render :json => { :status => :invalid, :errors => prefs.errors }
      end
    else
      render :json => { :status => :invalid }
    end
  end
end
