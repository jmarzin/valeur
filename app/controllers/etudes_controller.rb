# -*- coding: utf-8 -*-
class EtudesController < ApplicationController

  before_filter :charge_projet

  # GET /etudes
  # GET /etudes.json
  def index
    @etudes = @projet.etudes.all
    @modif_supp = Etude.modif_supp_apparents(@etudes)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @etudes }
    end
  end

  # GET /etudes/1
  # GET /etudes/1.json
  def show
    @etude = @projet.etudes.find(params[:id])
    @modif_supp = Etude.modif_supp_apparents([@etude])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @etude }
    end
  end

  # GET /etudes/new
  # GET /etudes/new.json
  def new
    @etude = @projet.etudes.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @etude }
    end
  end

  # GET /etudes/1/edit
  def edit
    @etude = @projet.etudes.find(params[:id])
    @inactif = @etude.inactif

  end

  # POST /etudes
  # POST /etudes.json
  def create
    @etude = @projet.etudes.new(params[:etude])

    respond_to do |format|
      if @etude.save
        format.html { redirect_to [@projet, @etude], notice: "L'étude a été créée." }
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
    @etude = @projet.etudes.find(params[:id])

    respond_to do |format|
      if @etude.update_attributes(params[:etude])
        @etude.gere_resumes
        format.html { redirect_to [@projet, @etude], notice: "L'étude a bien été mise à jour." }
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
    @etude = @projet.etudes.find(params[:id])
    @etude.destroy

    respond_to do |format|
      format.html { redirect_to projet_etudes_path(@projet) }
      format.json { head :no_content }
    end
  end
  private
    def charge_projet
      @projet = Projet.find(params[:projet_id])
    end
end
