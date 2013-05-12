require 'spec_helper'
require 'pry'

describe Parametrage do
  it "charge un fichier xml" do
    @reduit = Parametrage.charge_xml('/home/jacques/Bureau/S.xml')
    Parametrage.transforme(@reduit)
    binding.pry
    pending
  end
end
