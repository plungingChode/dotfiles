function envsource
  # Ignore empty lines and comments
  for line in (cat $argv | sd '^\s*#.*\n' '' | sd '^\s*\n' '')
    set item (string split -m 1 '=' $line)
    set value (printf $item[2] | sd '^"' '' | sd '"$' '')
    echo $item[1] $value
    set --export $item[1] $value
    echo "Exported key $item[1]"
  end
end

