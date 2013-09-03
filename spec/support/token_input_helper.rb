module TokenInputHelper
  def fill_token_input(locator, options)
    raise "Must pass a hash containing 'with'" unless options.is_a?(Hash) && options.has_key?(:with)
    page.execute_script %Q{$('#token-input-#{locator}').val('#{options[:with]}').keydown()}
    sleep(1)
    find(:xpath, "//div[@class='token-input-dropdown']/ul/li[contains(string(),'#{options[:with]}')]").click
  end
end