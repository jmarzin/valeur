class EtudesController < ApplicationController
  # GET /etudes
  # GET /etudes.json
  def index
    @etudes = Etude.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @etudes }
    end
  end

  # GET /etudes/1
  # GET /etudes/1.json
  def show
    @etude = Etude.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @etude }
    end
  end

  # GET /etudes/new
  # GET /etudes/new.json
  def new
    @etude = Etude.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @etude }
    end
  end

  # GET /etudes/1/edit
  def edit
    @etude = Etude.find(params[:id])
  end

  # POST /etudes
  # POST /etudes.json
  def create
    @etude = Etude.new(params[:etude])

    respond_to do |format|
      if @etude.save
        format.html { redirect_to @etude, notice: 'Etude was successfully created.' }
        format.json { render json: @etude, status: :created, location: @etude }
      else
        format.html { render action: "new" }
        format.json { render json: @etude.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /etudes/1
  # PUT /etudes/1.json
  def update
    @etude = Etude.find(params[:id])

    respond_to do |format|
      if @etude.update_attributes(params[:etude])
        format.html { redirect_to @etude, notice: 'Etude was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @etude.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /etudes/1
  # DELETE /etudes/1.json
  def destroy
    @etude = Etude.find(params[:id])
    @etude.destroy

    respond_to do |format|
      format.html { redirect_to etudes_url }
      format.json { head :no_content }
    end
  end
end
