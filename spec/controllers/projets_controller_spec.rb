# encoding: utf-8
require 'spec_helper'

describe ProjetsController do

  # This should return the minimal set of attributes required to create a valid
  # Projet. As you add validations to Projet, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "code" => "Code",
    "nom" => "Nom",
    "description" => "Description",
    "entites_concernees" => "Entités concernées",
    "ministere" => "Finances",
    "quotation_disic" => 5}
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ProjetsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

#  describe "GET index" do
#    it "assigns all projets as @projets" do
#      projet = Projet.create! valid_attributes
#      get :index, {}, valid_session
#      assigns(:projets).should eq([projet])
#    end
#  end

  describe "GET show" do
    it "assigns the requested projet as @projet" do
      projet = Projet.create! valid_attributes
      get :show, {:id => projet.to_param}, valid_session
      assigns(:projet).should eq(projet)
    end
  end

  describe "GET new" do
    it "assigns a new projet as @projet" do
      get :new, {}, valid_session
      assigns(:projet).should be_a_new(Projet)
    end
  end

  describe "GET edit" do
    it "assigns the requested projet as @projet" do
      projet = Projet.create! valid_attributes
      get :edit, {:id => projet.to_param}, valid_session
      assigns(:projet).should eq(projet)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Projet" do
        expect {
          post :create, {:projet => valid_attributes}, valid_session
        }.to change(Projet, :count).by(1)
      end

      it "assigns a newly created projet as @projet" do
        post :create, {:projet => valid_attributes}, valid_session
        assigns(:projet).should be_a(Projet)
        assigns(:projet).should be_persisted
      end

      it "redirects to the created projet" do
        post :create, {:projet => valid_attributes}, valid_session
        response.should redirect_to(Projet.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved projet as @projet" do
        # Trigger the behavior that occurs when invalid params are submitted
        Projet.any_instance.stub(:save).and_return(false)
        post :create, {:projet => {  }}, valid_session
        assigns(:projet).should be_a_new(Projet)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Projet.any_instance.stub(:save).and_return(false)
        post :create, {:projet => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested projet" do
        projet = Projet.create! valid_attributes
        # Assuming there are no other projets in the database, this
        # specifies that the Projet created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Projet.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => projet.to_param, :projet => { "these" => "params" }}, valid_session
      end

      it "assigns the requested projet as @projet" do
        projet = Projet.create! valid_attributes
        put :update, {:id => projet.to_param, :projet => valid_attributes}, valid_session
        assigns(:projet).should eq(projet)
      end

      it "redirects to the projet" do
        projet = Projet.create! valid_attributes
        put :update, {:id => projet.to_param, :projet => valid_attributes}, valid_session
        response.should redirect_to(projet)
      end
    end

    describe "with invalid params" do
      it "assigns the projet as @projet" do
        projet = Projet.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Projet.any_instance.stub(:save).and_return(false)
        put :update, {:id => projet.to_param, :projet => {  }}, valid_session
        assigns(:projet).should eq(projet)
      end

      it "re-renders the 'edit' template" do
        projet = Projet.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Projet.any_instance.stub(:save).and_return(false)
        put :update, {:id => projet.to_param, :projet => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested projet" do
      projet = Projet.create! valid_attributes
      expect {
        delete :destroy, {:id => projet.to_param}, valid_session
      }.to change(Projet, :count).by(-1)
    end

    it "redirects to the projets list" do
      projet = Projet.create! valid_attributes
      delete :destroy, {:id => projet.to_param}, valid_session
      response.should redirect_to(projets_url)
    end
  end
end
