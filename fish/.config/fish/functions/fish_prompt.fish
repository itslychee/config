
function fish_prompt --description "The prompt"
	# My custom fish prompt
  
  set -l PROMPT
  set -a PROMPT (set_color 1aad5c)$USER(set_color 30a0f0)@(set_color e32d67)$hostname
  set -a PROMPT (set_color 28e7ed)(prompt_pwd)
  set -a PROMPT (set_color de3ed3)\$(set_color normal)

  # if contains (tty) /dev/tty(seq 0 9)
  # end
  echo "$PROMPT "

end   
	    
