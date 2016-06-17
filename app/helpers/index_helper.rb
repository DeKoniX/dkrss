module IndexHelper
  def description_l(description)
    if description.length > 2000
      description[0..2000] 
    else
      description
    end
  end
end
