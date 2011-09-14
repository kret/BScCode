class BooksController < ApplicationController

  def new
    @book = Book.new
  end

  def create
    @book = Book.new params[:book]
    if @book.save
      if request.xhr?
        render :json => { :status => :ok, :redirect_to => book_path(@book) }
      else
        redirect_to @book, :notice => t('book.flash.created_successfully')
      end
    else
      if request.xhr?
        render :json => { :status => :invalid, :errors => @book.errors }
      else
        respond_to do |format|
          format.html { render :new }
          format.json { render :json => { :status => :invalid, :errors => @book.errors } }
        end
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
      prefs = prefs.empty? ? Preference.new : prefs.first
      render :json => { :status => :ok, :preferences => strip_preference(prefs) }
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
        render :json => { :status => :ok, :preferences => strip_preference(prefs) }
      else
        render :json => { :status => :invalid, :errors => prefs.errors }
      end
    else
      render :json => { :status => :invalid }
    end
  end

  private

    def strip_preference(pref)
      stripped = {}
      stripped = pref.attributes.except("id", "created_at", "updated_at", "book_id", "user_id") unless pref.nil?
    end

end
