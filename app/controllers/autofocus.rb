module Autofocus

  def autofocus(params,lignes1,lignes2)
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
        if m[2] == 'actuelle' || m[2] == "" then
          if ligne.to_i == lignes1 then
            ligne = (ligne.to_i - 1).to_s
          end
        elsif ligne.to_i == lignes2 then
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
