Alcms::Engine.setup do |config|
  # this condition should be true to open editor

  # config.editor_mode_condition do
  #   params[:edit]
  # end

  # this condition should be true to open editor
  # also it is checked when user saves cms changes

  # config.can_save_condition do
  #   current_user.admin?
  # end

  # path to alcms admin page
  # button is hidden if nil
  # config.admin_path = '/admin/cms'
end
