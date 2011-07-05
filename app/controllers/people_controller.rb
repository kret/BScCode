class PeopleController < ApplicationController
  autocomplete :person, :last_name, :full => true, :scope => :full_name_containing, :display_value => :display_name

  def new
    @person = Person.new
  end

  def create
    @person = Person.new params[:person]
    if @person.save
      respond_to do |format|
        format.html { redirect_to @person, :notice => t('person.flash.created_successfully') }
        format.json { render :json => @person }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render :json => { :status => 'error' } }
      end
    end
  end

  def show
    @person = Person.find params[:id]
  end
end
