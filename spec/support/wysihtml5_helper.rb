module Wysihtml5Helper
  def fill_in_wysihtml5(text)
    #js must be enabled
    page.execute_script("editor.setValue('#{text}')")
  end
end