class StrategiesController < ApplicationController
  # GET /strategies/1
  # GET /strategies/1.json
  def show
    @etude = Etude.find(params[:id])
    @strategy = @etude.lit_strategie

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @strategy }
    end
  end

  # GET /strategies/1/edit
  def edit
    @etude = Etude.find(params[:id])
    @strategy = @etude.lit_strategie
  end

  # PUT /strategies/1
  # PUT /strategies/1.json
  def update
    @etude = Etude.find(params[:id])
    @strategy = @etude.lit_strategie

    respond_to do |format|
      if @strategy.update_attributes(params[:strategy])
        format.html { redirect_to @strategy, notice: 'Strategie was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @strategy.errors, status: :unprocessable_entity }
      end
    end
  end
end
