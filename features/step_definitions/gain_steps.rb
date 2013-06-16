# encoding: utf-8

Quand(/^je saisis (\d+) pour les cadres A et (\d+) pour les cadres B pour ETP(\d+)$/) do |arg1, arg2, arg3|
  fill_in 'gain_etp_reparts_attributes_0_repartitions_attributes_1_pourcent', :with => arg1
  fill_in 'gain_etp_reparts_attributes_0_repartitions_attributes_2_pourcent', :with => arg2
end

Quand(/^je saisis (\d+) pour les cadres A\+ pour ETP(\d+)$/) do |arg1, arg2|
  fill_in 'gain_etp_reparts_attributes_4_repartitions_attributes_0_pourcent', :with => arg1
end
