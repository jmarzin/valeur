class ParametragesController < ApplicationController
  # GET /parametrages
  # GET /parametrages.json
  def index
    @parametrages = Parametrage.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @parametrages }
    end
  end

  # GET /parametrages/1
  # GET /parametrages/1.json
  def show
    @parametrage = Parametrage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @parametrage }
    end
  end

  # GET /parametrages/new
  # GET /parametrages/new.json
  def new
    @parametrage = Parametrage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @parametrage }
    end
  end

  # GET /parametrages/1/edit
  def edit
    @parametrage = Parametrage.find(params[:id])
  end

  # POST /parametrages
  # POST /parametrages.json
  def create
    @parametrage = Parametrage.new(params[:parametrage])

    respond_to do |format|
      if @parametrage.save
        format.html { redirect_to @parametrage, notice: 'Parametrage was successfully created.' }
        format.json { render json: @parametrage, status: :created, location: @parametrage }
      else
        format.html { render action: "new" }
        format.json { render json: @parametrage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /parametrages/1
  # PUT /parametrages/1.json
  def update
    @parametrage = Parametrage.find(params[:id])

    respond_to do |format|
      if @parametrage.update_attributes(params[:parametrage])
        format.html { redirect_to @parametrage, notice: 'Parametrage was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @parametrage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parametrages/1
  # DELETE /parametrages/1.json
  def destroy
    @parametrage = Parametrage.find(params[:id])
    @parametrage.destroy

    respond_to do |format|
      format.html { redirect_to parametrages_url }
      format.json { head :no_content }
    end
  end
end
