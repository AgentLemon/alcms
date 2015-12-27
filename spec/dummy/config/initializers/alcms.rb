Alcms::Engine.setup do |config|
  config.can_save_condition do
    !params[:i_am_hacker]
  end
end
