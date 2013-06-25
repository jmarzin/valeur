module Autofocus
  def autofocus(params,lignes)
    valeur = ""
    if params[:commit] then
      valeur = params[:commit]
    else
      code = params.key('Insv')
      code = params.key('Ins^') if not code
      code = params.key('Sup') if not code
      m = /^(.)(\D*)(\d+)/.match(code)
      ligne = m[3]
      if m[1] == 's' then
        if ligne.to_i == lignes then
          ligne =  (ligne.to_i - 1).to_s
        end
      elsif m[1] == 'b' then
        ligne = ligne.succ
      end
      valeur = m[2]+ligne
    end
  end
  private :autofocus
end
