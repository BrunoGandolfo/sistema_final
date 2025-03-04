module SelectorHelpers
  def find_by_testid(testid)
    find("[data-testid='#{testid}']")
  end

  def click_testid(testid)
    find_by_testid(testid).click
  end

  def has_testid?(testid)
    has_css?("[data-testid='#{testid}']")
  end

  def has_no_testid?(testid)
    has_no_css?("[data-testid='#{testid}']")
  end
end

RSpec.configure do |config|
  config.include SelectorHelpers, type: :system
end
