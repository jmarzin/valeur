# encoding: utf-8

Alors(/^je vois la question (.+)$/) do |question|
  page.should have_content question
end
