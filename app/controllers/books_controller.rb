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
end
