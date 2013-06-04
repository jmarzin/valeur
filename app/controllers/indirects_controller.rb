# -*- coding: utf-8 -*-
require 'mareva'

class IndirectsController < ApplicationController
  # GET /indirects/1
  # GET /indirects/1.json
  def show
    @etude = Etude.find(params[:id])
    binding.pry
    @etude.lit_rentabilite
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @etude }
    end
  end

  # GET /indirects/1/edit
  def edit
    @etude = Etude.find(params[:id])
    @indirect = @etude.lit_indirect
  end

  # PUT /directs/1
  # PUT /directs/1.json
  def update
    @etude = Etude.find(params[:id])
    respond_to do |format|
      if @etude.etude_rentabilite.indirect.update_attributes(params[:direct])
        if params[:commit] then
          @etude.simplifie_indirect
          flash[:notice] = "Les coûts indirects ont bien été mis à jour."
          if params[:commit] == 'Actualiser' then
            @direct = @etude.lit_indirect
            format.html { render action: "edit"}
            format.json { head :no_content }
          else
            format.html { render action: "show"}
            format.json { head :no_content }
          end
        else
          @direct = @etude.traite_touche(params)
          format.html { render action: "edit" }
          format.json { head :no_content }
        end
      else
        flash[:notice] = "Problème de mise à jour des coûts indirects."
        format.html { render action: "edit", notice: '' }
        format.json { render json: @projet.errors }
      end
    end
  end
end
