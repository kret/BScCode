class BooksController < ApplicationController

  def new
    @book = Book.new
  end

  def create
    @book = Book.new params[:book]
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
      to_send = {}
      to_send = prefs.first.attributes.except("id", "created_at", "updated_at", "book_id", "user_id") unless prefs.nil? || prefs.first.nil?
      render :json => { :status => :ok, :preferences => to_send }
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
