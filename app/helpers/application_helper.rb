module ApplicationHelper
  def my_title
    if @title.nil?
      @title = "Dkrss"
    else
      @title = "DK - "+@title
    end
    return @title
  end
end
